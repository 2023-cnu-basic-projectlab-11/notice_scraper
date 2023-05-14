import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';

class NoticeManager {
  static final NoticeManager _instance = NoticeManager._internal();
  factory NoticeManager() => _instance;
  NoticeManager._internal();

  Iterable<Origin> get origins => scrapers.map((e) => e.origin);
  final LocalStorage _storage = LocalStorage("latest_updated_times.json");
  final List<Scraper> scrapers = [
    CNUCyberCampusScraper('id', 'password'),
  ];

  Stream<Notice> scrap(Origin origin) async* {
    await _storage.ready;
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

  Future<DateTime?> getLastUpdated(Origin origin) async {
    await _storage.ready;
    return DateTime.tryParse(_storage.getItem(origin.endpointUrl) ?? "");
  }
}
