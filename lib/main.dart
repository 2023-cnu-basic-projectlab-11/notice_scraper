import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
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
  TextEditingController id = TextEditingController(); //id
  TextEditingController pw = TextEditingController(); //password

  late Scraper scraper_1;
  Future<List<Notice>> notices = Future.value([]);

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
              controller: id,
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: pw,
            ),
            OutlinedButton(
              //실제 id, pw 입력받아 로그인하도록 하는 부분(이렇게 입력받은 정보를 어떻게 실제로 활용할 것인가?)
              onPressed: () => setState(() {
                scraper_1 = CNUCyberCampusScraper(id.text, pw.text);
                notices = scraper_1.scrap().toList().catchError((e) {
                  log("error");
                  return [Notice("알수없음", DateTime.now())];
                });
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Button'),
            ),
            // FutureBuilder 예시 코드

            FutureBuilder(
                future: notices,
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
