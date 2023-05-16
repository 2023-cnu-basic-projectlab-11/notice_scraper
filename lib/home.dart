import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/notice_manager.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key}) {}

  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  Origin? origin = NoticeManager().origins.firstOrNull;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(origin?.name ?? '등록된 사이트가 없습니다.'),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: onPressedPerson,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onPressedMenu,
          )
        ],
      ),
      //body: NoticeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedRefresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void onPressedMenu() {
    log('Menu button pressed');
  }

  void onPressedRefresh() {
    log('Refresh button pressed');
  }

  void onPressedPerson() {
    log('Person button pressed');
  }
}
