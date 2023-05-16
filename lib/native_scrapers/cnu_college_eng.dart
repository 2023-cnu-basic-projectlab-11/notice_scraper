import 'dart:convert';

import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';
import 'package:html/parser.dart' as parser;

class CNUCollegeEngScraper extends NativeScraper {
  static const _homeUri = "eng.cnu.ac.kr";

  static const _noticePath = "/eng/information/notice.do";

  static const int _offset = 0;
  static const int _limit = 50;

  @override
  Origin get origin => const Origin('충남대 공과대학 공지', '충남대 공과대학 공지사항입니다.',
      _homeUri, 'https://$_homeUri$_noticePath');

  @override
  Stream<Notice> scrap() async* {
    startSession();

    int page = 0;
    while (true) {
      final notices = await _scrap(page++);
      if (notices == null) break;
      yield* Stream.fromIterable(notices);
    }
    closeSession();
  }

  DateTime _dateFormat(String? date) => date == null
      ? DateTime.now()
      : DateTime.parse("20$date".replaceAll('.', '-'));

  Future<Iterable<Notice>?> _scrap(int page) async {
    // 공지가 있는 사이트 접속
    final response = await get(Uri.https(_homeUri, _noticePath, {
      'mode': 'list',
      'articleLimit': _limit.toString(),
      'article.offset': (_offset * page).toString(),
    }));

    // 공지가 들어있는 Element 추출
    final html = response.body;
    final noticeElements = parser
        .parse(html)
        .querySelector('.board-table')!
        .querySelector('tbody')!
        .children;

    // 만약 불러온 공지가 없다면 스크랩 중지
    if (noticeElements.first.querySelector('.b-no-post') != null) {
      return null;
    }

    // Element에서 공지로 파싱
    final notices = noticeElements.map((e) => Notice(
          e.querySelector('.b-title-box a')?.text.trim() ?? "제목없음",
          _dateFormat(e.querySelector('.b-date')?.text.trim()),
        ));
    return notices;
  }
}
