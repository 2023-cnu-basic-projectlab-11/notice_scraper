import 'dart:async';
//import 'dart:ffi';

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
    await _storage.ready;
    final iter = StreamIterator(scrapers
        .firstWhere((s) => s.origin.endpointUrl == origin.endpointUrl)
        .scrap());

    if (await iter.moveNext()) {
      // 가장 최근 공지(첫번쨰로 나오는 공지)를 가져옴
      final item = iter.current;
      yield item;

      // 해당 공지가 연속으로 얼마나 나오는지 체크
      int count = 1;
      while (await iter.moveNext()) {
        yield iter.current;
        if (item != iter.current) break;
        count++;
      }

      // 얻은 공지를 중복 횟수와 함께 저장
      await _storage.setItem(
          origin.endpointUrl, item.toJson()..addAll({'count': count}));

      // 나머지는 그대로 출력
      while (await iter.moveNext()) {
        yield iter.current;
      }
    }
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
