import 'dart:async';
import 'dart:developer';

import 'package:localstorage/localstorage.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';

class NoticeManager {
  static final NoticeManager _instance = NoticeManager._internal();
  factory NoticeManager() => _instance;
  NoticeManager._internal();

  Iterable<Origin> get origins => scrapers.map((e) => e.origin);
  final LocalStorage _storage = LocalStorage("latest_updated_times.json");
  int perPage = 50;
  List<Scraper> scrapers = [];

  Future<List<Notice>> scrap(Origin origin, [int page = 0]) async {
    await _storage.ready;
    log('Scrap notices from ${origin.name}');
    final scraper =
        scrapers.firstWhere((s) => s.origin.endpointUrl == origin.endpointUrl);
    final notices = await scraper.scrap(page * perPage, perPage);

    if (page == 0) {
      final item = notices.firstOrNull;
      if (item == null) return [];

      int count = 0;
      var searchNotices = notices;
      do {
        for (var notice in searchNotices) {
          if (notice != item) break;
          count++;
        }

        if (count < (++page) * perPage) break;

        searchNotices = await scraper.scrap(page * perPage, perPage);
      } while (true);
      log('latest notice "${item.title}" found($count) at ${item.datetime.toString()}.');
      _storage.setItem(
          origin.endpointUrl, item.toJson()..addAll({'count': count}));
    }

    return notices;
  }

  /// 해당 Origin에서 가장 최근에 scrap된 공지를 반환한다. 중복을 구분하기 위해 연속으로 몇번 나왔는지에 대한 정수값과 함께 제공된다.
  Future<(Notice, int)?> getLastUpdatedNotice(Origin origin) async {
    // 저장소에서 등록된 가장 최근 공지 반환
    await _storage.ready;
    final Map<String, dynamic>? json = _storage.getItem(origin.endpointUrl);

    if (json == null) return null;
    final int? count = json['count'];

    if (count == null) return null;
    return (Notice.fromJson(json), count);
  }
}
