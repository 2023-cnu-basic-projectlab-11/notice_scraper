import 'dart:io';

import 'package:http/http.dart';
import 'package:notice_scraper/notice.dart';

/// 고수준 scraper 추상 클래스
abstract class Scraper {
  /// 스크랩된 원본이 있는 사이트
  final Origin origin;
  Scraper(this.origin);

  /// 공지를 스크랩해서 List로 돌려주는 함수 (비동기)
  Future<List<Notice>> scrap();
}

/// 다트 코드를 이용하여 직접 스크랩하는 scraper.\
/// HTTP 요청의 편의를 위해, get, post와 같은 메서드와 자동으로 쿠키 ,세션을 관리해주는 기능이 포함되어있다.
abstract class NativeScraper implements Scraper {
  /// 요청 시 기본적으로 붙는 헤더
  static const defaultHeader = {
    "Accept": "*/*",
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language':
        'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7,ja;q=0.6,zh-CN;q=0.5,zh;q=0.4',
    'Connection': 'keep-alive',
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36",
    "X-Requested-With": "XMLHttpRequest",
    'sec-ch-ua':
        '"Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
  };

  /// 현재 세션의 쿠키
  final List<Cookie> _cookies = List.empty(growable: true);

  /// http 클라이언트
  Client? _client;

  /// HTTP GET request
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    final rsp = await (_client ?? (_client = Client())).get(url,
        headers: headers == null
            ? _headerWithCookies()
            : (_headerWithCookies()..addAll(headers)));
    _addCookies(rsp);
    return rsp;
  }

  /// HTTP POST request
  Future<Response> post(Uri url,
      {Object? body, Map<String, String>? headers}) async {
    final rsp = await (_client ?? (_client = Client())).post(url,
        body: body,
        headers: headers == null
            ? _headerWithCookies()
            : (_headerWithCookies()..addAll(headers)));
    _addCookies(rsp);
    return rsp;
  }

  Map<String, String> _headerWithCookies() =>
      Map.from(defaultHeader)..addAll({'Cookie': _cookies.join('; ')});

  List<Cookie> _addCookies(Response response) => _cookies
    ..addAll(
        _getCookies(response)?.map((e) => Cookie.fromSetCookieValue(e)) ?? []);

  Iterable<String>? _getCookies(Response response) =>
      response.headers["set-cookie"]
          ?.replaceAll(', ', r'\\')
          .split(',')
          .map((e) => e.replaceAll(r'\\', ', '));

  void startSession() => _client = Client();
  void closeSession() => _client?.close();
}

/// 외부 자바스크립트 코드를 이용하는 scraper (아직 미구현)
class JavascriptScraper implements Scraper {
  @override
  final Origin origin;

  JavascriptScraper(this.origin);

  @override
  Future<List<Notice>> scrap() => throw UnimplementedError();
}
