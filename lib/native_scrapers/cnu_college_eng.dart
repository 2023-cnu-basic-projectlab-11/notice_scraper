import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';
import 'package:html/parser.dart' as parser;

class CNUCollegeEngScraper extends NativeScraper {
  static const _homeUri = "eng.cnu.ac.kr";

  static const _noticePath = "/eng/information/notice.do";

  @override
  Origin get origin => const Origin('충남대 공과대학 공지', '충남대 공과대학 공지사항입니다.',
      _homeUri, 'https://$_homeUri$_noticePath');

  @override
  Future<List<Notice>> scrap([int offset = 0, int limit = 50]) async {
    startSession();
    final notices = await _scrap(offset, limit);
    return notices ?? [];
  }

  DateTime _dateFormat(String? date) => date == null
      ? DateTime.now()
      : DateTime.parse("20$date".replaceAll('.', '-'));

  Future<List<Notice>?> _scrap(int offset, int limit) async {
    // 공지가 있는 사이트 접속
    final response = await get(Uri.https(_homeUri, _noticePath, {
      'mode': 'list',
      'articleLimit': limit.toString(),
      'article.offset': offset.toString(),
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
    final notices = noticeElements
        .map((e) => Notice(
              e.querySelector('.b-title-box a')?.text.trim() ?? "제목없음",
              _dateFormat(e.querySelector('.b-date')?.text.trim()),
            ))
        .toList();
    return notices;
  }
}
