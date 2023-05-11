import 'package:notice_scraper/notice.dart';

abstract class NoticeStorage {
  Iterable<Notice> get notices;
  void refresh();
}

class TestNoticeStorage implements NoticeStorage {
  @override
  Iterable<Notice> get notices => [
        Notice('공지1', DateTime.now().subtract(const Duration(days: 1)),
            const Origin('테스트 사이트', '테스트용 사이트입니다', 'example1.com')),
        Notice('공지2', DateTime.now().subtract(const Duration(days: 2)),
            const Origin('테스트 사이트', '테스트용 사이트입니다', 'example2.com')),
        Notice('공지3', DateTime.now().subtract(const Duration(days: 3)),
            const Origin('테스트 사이트', '테스트용 사이트입니다', 'example3.com'))
      ];

  @override
  void refresh() {}
}
