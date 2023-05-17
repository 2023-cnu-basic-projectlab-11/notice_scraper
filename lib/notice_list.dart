import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notice_scraper/notice_manager.dart';

import 'notice.dart';

class NoticeList extends StatefulWidget {
  final Origin origin;
  final int perPage;
  const NoticeList({super.key, required this.origin, required this.perPage});

  @override
  State<NoticeList> createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
  int page = 0;
  bool _isEnd = false;
  List<Notice> notices = [];
  _NoticeListState();

  Origin get origin => widget.origin;
  final Container _sep = Container(height: 1);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
        onRefresh: onPressedRefresh,
        child: ListView.separated(
          itemBuilder: (ctx, i) {
            if (i == notices.length) {
              if (_isEnd) return const Text('마지막 공지사항입니다.');
              // list의 끝에 도달했을 시, 새로 로딩을 한다.
              log('Scroll end. load more notices...');
              // 새로고침과 동시에 일어날 경우 꼬이는 것을 방지하기 위해 현재 notice 리스트의 참조를 캐싱
              final noticeRef = notices;
              NoticeManager().scrap(origin, page++).then(
                    (list) => setState(() {
                      if (notices != noticeRef) return;
                      if (list.isEmpty) {
                        _isEnd = true;
                        return;
                      }
                      noticeRef.addAll(list);
                      log('${list.length} notices loaded');
                    }),
                  );
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (i < notices.length) {
              return NoticeView(notice: notices[i]);
            } else {
              return null;
            }
          },
          separatorBuilder: (ctx, i) => _sep,
          itemCount: notices.length + 1,
        ));
  }

  Future<void> onPressedRefresh() async {
    final list = await NoticeManager().scrap(origin, 0);
    setState(() {
      _isEnd = false;
      page = 1;
      notices = list;
    });
  }
}

class NoticeView extends StatelessWidget {
  final Notice notice;

  const NoticeView({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notice.title, overflow: TextOverflow.ellipsis),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                DateFormat.yMMMd().format(notice.datetime),
                textAlign: TextAlign.right,
              )
            ]),
          ],
        ),
      ),
    );
  }
}
