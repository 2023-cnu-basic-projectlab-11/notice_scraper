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

Widget noticeToWidget(Notice notice) {
  //origin 반영
  // Figma Flutter Generator Elevation6Widget - FRAME
  return Container(
      width: 344,
      height: 80,
      decoration: BoxDecoration(
        color : Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                    width: 344,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius : BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow : [BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          offset: Offset(0,2),
                          blurRadius: 6
                      )],
                      color : Color.fromRGBO(243, 237, 247, 1),
                    )
                )
            ),Positioned(
                top: 58,
                left: 240,
                child: Text(notice.datetime.toString(), textAlign: TextAlign.center, style: TextStyle(
                    color: Color.fromRGBO(88, 62, 91, 1),
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.33
                ),)
            ),Positioned(
                top: 7,
                left: 35,
                child: Text('사이버캠퍼스', textAlign: TextAlign.center, style: TextStyle(
                    color: Color.fromRGBO(43, 92, 174, 1),
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.33
                ),)
            ),Positioned(
                top: 30,
                left: 16,
                child: Text(notice.title, textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(88, 62, 91, 1),
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.5
                ),)
            ),Positioned(
                top: 57,
                left: 11,
                child: Container(
                    width: 61,
                    height: 19,
                    decoration: BoxDecoration(

                    ),
                    child: Stack(
                        children: <Widget>[Positioned(
                              top: 2,
                              left: 16,
                              child: Text('충남대학교', textAlign: TextAlign.center, style: TextStyle(
                                  color: Color.fromRGBO(255, 132, 132, 1),
                                  fontFamily: 'Roboto',
                                  fontSize: 11,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1.45
                              ),)
                          ),
                        ]
                    )
                )
            )
          ]
      )
  );
  //notice 불러오기,위젯 변환, 리스트로 구성
}

Iterable<Widget> noticesToWidgets(List<Notice> notices) sync* {
  for(int i = 0; i < notices.length; i++) {
    yield noticeToWidget(notices[i]);
  }
}