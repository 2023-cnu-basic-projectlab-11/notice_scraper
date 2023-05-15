import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'package:notice_scraper/notice_manager.dart';
import 'notice.dart';
import 'scraper.dart';

import 'dart:developer';

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
      home: const MyCalcPage(),
    );
  }
}

class MyCalcPage extends StatefulWidget {
  const MyCalcPage({super.key});

  @override
  State<MyCalcPage> createState() => _MyCalcPage();
}

class _MyCalcPage extends State<MyCalcPage> {
  TextEditingController id_value = TextEditingController(); //id
  TextEditingController pw_value = TextEditingController(); //password
  String dynamic = "";
  List<Origin> origins = NoticeManager().origins.toList();

  @override
  void initState() {
    super.initState();
  }

  //비동기 테스트
  Future<String> reportUserRole() async {
    return Future.delayed(const Duration(seconds: 4), () => 'test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              controller: id_value,
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: pw_value,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    //사용자에게서 id, 비밀번호 입력받는 부분
                  });
                },
                child: const Text("_buttonText")),
            // FutureBuilder 예시 코드

            FutureBuilder(
                //이 부분에서 불러온 데이터를 출력할 예정이었으나, 공지를 불러오는 중간 과정을 볼 수 없어 성공/실패 여부를 알 수 없음
                future: NoticeManager().scrap(origins.first).toList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                  if (snapshot.hasData == false) {
                    return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
                  }

                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }

                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                  else {
                    // 정상적으로 업데이트 시간이 갱신되었는지 확인
                    NoticeManager()
                        .getLastUploadedAt(origins.first)
                        .then((value) => log(value.toString()));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        jsonEncode(
                            snapshot.data), // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class Iphone14pro2Widget extends StatefulWidget {
  const Iphone14pro2Widget({super.key});

  @override
  _Iphone14pro2WidgetState createState() => _Iphone14pro2WidgetState();
}

class _Iphone14pro2WidgetState extends State<Iphone14pro2Widget> {
  late Scraper scraper_1;
  late Future<List<Notice>> info_list;

  //Notice notices = info_list.elementAt(0);
  //static String id_show=notices.elementAt(0).title;
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Iphone14pro2Widget - FRAME

    return Container(
      width: 393,
      height: 852,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Stack(children: <Widget>[
        Positioned(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: value1,
          ),
        ),
        Positioned(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: value2,
          ),
        ),
        Positioned(
          child: OutlinedButton(
            onPressed: () {
              scraper_1 =
                  CNUCyberCampusScraper(value1.toString(), value2.toString());
              info_list = scraper_1.scrap().toList();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Button'),
          ),
        ),
        /*
              Positioned(
                child: FutureBuilder<List<Notice>>(
                  future: info_list,
                  builder: (BuildContext context, AsyncSnapshot<List<Notice>> list){
                    if (list.hasData) {
                      return Text('스냅샷 데이터: ${list.data.toString()}');
                    } else if (list.hasData == false) {
                      return CircularProgressIndicator();
                    } else if (list.hasError) {
                      return Text('스냅샷 에러');
                    } else {
                      return Text('혹시 몰라서 else문 추가');
                    }
                  },
                )
              )
              */
      ]),
    );
  }
}
