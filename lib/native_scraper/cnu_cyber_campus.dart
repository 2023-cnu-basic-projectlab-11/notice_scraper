import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:html_unescape/html_unescape.dart';
import 'package:pointycastle/export.dart';
import 'package:html/parser.dart' as parser;
import 'package:encrypt/encrypt.dart';

class CNUCyberCampusScraper extends NativeScraper {
  /// 로그인 base uri
  static const _loginUri = "dcs-lcms.cnu.ac.kr";

  /// 로그인된 사캠 홈 base uri
  static const _homeUri = "dcs-learning.cnu.ac.kr";

  /// 사캠 서버에서 내부적으로 사용하는 api path prefix
  static const _apiPath = "/api/v1";

  /// 사캠 서버에서 내부적으로 사용하는 공개 암호화 키
  static const _encryptKey = "dJoviA4NUgrSM73R5uIrNaJtPCd1zA78";
  static const _iv = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  CNUCyberCampusScraper(String id, String password)
      : _id = id,
        _password = password;

  @override
  Origin get origin =>
      const Origin("cnu_cyber_campus", "충남대 사이버캠퍼스", "충남대 사캠 공지입니다.", _homeUri);

  final String _id;
  final String _password;

  @override
  Future<List<Notice>> scrap() async {
    // HTTP 요청을 위해 세션 시작
    startSession();

    // 로그인 페이지 접속 & 로그인 폼 데이터 추출
    var response = await get(Uri.https(_loginUri, "/login"));
    final inputs = getLoginFormInput(response.body);

    // 로그인 요청을 위한 input 채우기
    inputs["user_id"] = _id;
    inputs["user_password"] = encryptPassword(inputs['key']!, _password);
    inputs["univ_no"] = "CNU";

    // 로그인 요청
    response = await post(Uri.https(_loginUri, "$_apiPath/user/login"),
        body: {'e': encryptData(inputs)});

    // 로그인된 세션을 이용해 공지 불러오기
    // 먼저 학기 목록 불러오기
    response =
        await post(Uri.https(_homeUri, "$_apiPath/term/getYearTermList"));

    // 불러온 목록에서 현재 학기 찾기
    final currentYearTerm = jsonDecode(response.body)["body"]['list']
        .firstWhere((element) => element['current_term_yn'] == "Y");

    // 공지 불러오는 요청 작성
    final noticeRequestBody = {
      'type': 'notice',
      'term_cd': currentYearTerm['term_cd']!.toString(),
      'term_year': currentYearTerm['term_year']!.toString(),
      'limit': '100'
    };

    // 공지 목록 요청
    response = await post(
        Uri.https(_homeUri, "$_apiPath/board/std/notice/list"),
        body: {'e': encryptData(noticeRequestBody)});

    // 요청이 완료되었으니 세션 닫기
    closeSession();

    // 응답된 공지 목록 파싱(Notice클래스로 변환)
    return parseNotices(HtmlUnescape()
        .convert(const Utf8Decoder().convert(response.bodyBytes)));
  }

  // json 응답을 Notice로 변환
  List<Notice> parseNotices(String json) => jsonDecode(json)['body']["list"]
      .map<Notice>((e) => Notice("${e['course_nm']}: ${e['boarditem_title']}",
          DateTime.parse(e['insert_dt']), origin))
      .toList();

  // 데이터를 공개 암호화 키로 암호화
  String encryptData(Map<String, String> data) =>
      Encrypter(AES(Key.fromUtf8(_encryptKey), mode: AESMode.cbc))
          .encrypt(jsonEncode(data), iv: IV(Uint8List.fromList(_iv)))
          .base64
          .replaceAll(RegExp(r'[\r|\n]'), '');

  // 비밀번호를 암호화
  String encryptPassword(String key, String password) {
    final parsed = RSAKeyParser()
        .parse("-----BEGIN PUBLIC KEY-----\n$key\n-----END PUBLIC KEY-----");
    return Encrypter(
            RSA(publicKey: RSAPublicKey(parsed.modulus!, parsed.exponent!)))
        .encrypt(password, iv: IV(Uint8List.fromList(_iv)))
        .base64;
  }

  // html에서 로그인 폼 정보 가져오기
  Map<String, String> getLoginFormInput(String html) =>
      parser.parse(html).querySelectorAll('form[name=loginForm] input').fold(
          <String, String>{},
          (m, e) =>
              m..addAll({e.attributes["name"]!: e.attributes["value"] ?? ""}))
        ..removeWhere((key, value) => value == "");
}
