import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/scraper.dart';

class NoticeManager {
  static final NoticeManager _instance = NoticeManager._internal();
  factory NoticeManager() => _instance;
  NoticeManager._internal();

  Iterable<Origin> get origins => scrapers.map((e) => e.origin);
  final LocalStorage _storage = LocalStorage("latest_updated_times.json");
  List<Scraper> scrapers = [];

  Stream<Notice> scrap(Origin origin) async* {
    final iter = StreamIterator(scrapers
        .firstWhere((s) => s.origin.endpointUrl == origin.endpointUrl)
        .scrap());

    if (await iter.moveNext()) {
      // 가장 최근 공지(첫번쨰로 나오는 공지)의 시간으로 저장소 update
      await _storage.ready;
      await _storage.setItem(
          origin.endpointUrl, iter.current.datetime.toIso8601String());
      yield iter.current;

      // 나머지는 그대로 출력
      while (await iter.moveNext()) {
        yield iter.current;
      }
    }
  }

  Future<DateTime?> getLastUploadedAt(Origin origin) async {
    // 저장소에서 시간 가져오기
    await _storage.ready;
    return DateTime.tryParse(_storage.getItem(origin.endpointUrl) ?? "");
  }
}
