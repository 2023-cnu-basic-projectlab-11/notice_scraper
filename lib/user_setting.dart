import 'package:flutter/material.dart';
import 'package:notice_scraper/notice_manager.dart';

import 'notice.dart';
import 'notice_list.dart';

class UserSetting extends StatelessWidget{
  UserSetting({super.key});

  List<NoticeList> lists = NoticeManager()
      .origins
      .map((e) => NoticeList(
    origin: e,
    perPage: NoticeManager().perPage,
  ))
      .toList();
  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text('dddd'),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: ()=>{},
        ),
      ),
      body: Column(children: [
        Text("data"),
        Expanded(
          flex: 1,
            child:
            ListView.separated(
              padding: const EdgeInsets.all(5),
              itemCount: NoticeManager().scrapers.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      Text(NoticeManager().scrapers.elementAt(index).toString()),
                      Row(
                        children: [
                          FloatingActionButton(
                              onPressed: () {  },
                              child: Text("+"),
                          ),
                          FloatingActionButton(
                              child: Text("-"),
                              onPressed: (){}
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
        ),
        FloatingActionButton(
        onPressed: () => {
          Navigator.pop(context),
        },
        child: const Icon(Icons.arrow_back),
      ),
    ]
    )
    );
  }



}

