import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';

class NoticeManager {
  static final NoticeManager _instance = NoticeManager._internal();
  factory NoticeManager() => _instance;
  NoticeManager._internal();

  List<Origin> get origins => scrapers.map((e) => e.origin).toList();
  final LocalStorage _storage = LocalStorage("latest_updated_times.json");
  final List<Scraper> scrapers = [
    CNUCyberCampusScraper('id', 'password'),
  ];

  Stream<Notice> scrap(Origin origin) async* {
    final iter = StreamIterator(scrapers
        .firstWhere((s) => s.origin.endpointUrl == origin.endpointUrl)
        .scrap());

    if (await iter.moveNext()) {
      _storage.setItem(origin.endpointUrl, iter.current.datetime);
      yield iter.current;

      while (await iter.moveNext()) {
        yield iter.current;
      }
    }
  }

  DateTime? getLastUpdated(Origin origin) =>
      DateTime.tryParse(_storage.getItem(origin.endpointUrl) ?? "");
}



/*
[
  Notice('공지1', DateTime.now().subtract(const Duration(days: 1)),
      const Origin('테스트 사이트', '테스트용 사이트입니다', 'example1.com')),
  Notice('공지2', DateTime.now().subtract(const Duration(days: 2)),
      const Origin('테스트 사이트', '테스트용 사이트입니다', 'example2.com')),
  Notice('공지3', DateTime.now().subtract(const Duration(days: 3)),
      const Origin('테스트 사이트', '테스트용 사이트입니다', 'example3.com'))
]
*/