import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notice_scraper/native_scrapers/cnu_college_eng.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'package:notice_scraper/notice_manager.dart';
import 'notice.dart';
import 'scraper.dart';
import 'dart:math' as math;
import 'dart:developer';
import 'noticeList.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TabBar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeWidget(),
    );
  }
}

/*
class Iphone14pro4defaultWidget extends StatefulWidget {
  @override
  _Iphone14pro4defaultWidgetState createState() => _Iphone14pro4defaultWidgetState();
}

class _Iphone14pro4defaultWidgetState extends State<Iphone14pro4defaultWidget> {
  TextEditingController id = TextEditingController(); //id
  TextEditingController pw = TextEditingController(); //password

  late Scraper scraper_1;
  Future<List<Notice>> notices = Future.value([Notice('test', DateTime.now())]);
  NoticeManager manager=NoticeManager();
  
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Iphone14pro4defaultWidget - COMPONENT
    noticesToWidgets(notices as List<Notice>);
  }
}

 */

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidget();
}

class _HomeWidget extends State<HomeWidget> {
  TextEditingController id = TextEditingController(); //id
  TextEditingController pw = TextEditingController(); //password

  Scraper scraper_1 = CNUCollegeEngScraper();
  Future<List<Notice>> notices = Future.value([]);

  _HomeWidget() {
    notices = scraper_1.scrap().take(30).toList().catchError((e) {
      log("error");
      return [Notice("알수없음", DateTime.now())];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("widget.title"),
      ),
      body: FutureBuilder(future: notices, builder: (ctx, snapshot) {
        return snapshot.data == null ? Text('없음') : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                controller: id,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: pw,
              ),
              OutlinedButton(
                //실제 id, pw 입력받아 로그인하도록 하는 부분(이렇게 입력받은 정보를 어떻게 실제로 활용할 것인가?)
                onPressed: () => setState(() {
                  //scraper_1 = CNUCyberCampusScraper(id.text, pw.text);
                  scraper_1 = CNUCollegeEngScraper();
                  notices = scraper_1.scrap().take(30).toList().catchError((e) {
                    log("error");
                    return [Notice("알수없음", DateTime.now())];
                  });
                }),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                child: const Text('Button'),
              ),
            ]..addAll(noticesToWidgets(snapshot.data ?? [])),
          ),
        );

      },)
    );
  }
}


Iterable<Widget> noticesToWidgets(List<Notice> notices) sync* {
  for(int i = 0; i < notices.length; i++) {
    yield noticeToWidget(notices[i]);
  }
}