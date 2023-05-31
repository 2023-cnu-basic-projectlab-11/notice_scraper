import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'notice.dart';
import 'notice_list.dart';
import 'notice_manager.dart';

class siteAdd extends StatefulWidget {
  const siteAdd({super.key});

  @override
  State<StatefulWidget> createState() => _siteAdd();
}

class _siteAdd extends State<siteAdd> {
  int selectedIndex = 0;
  String newURL='';
  TextEditingController tx=TextEditingController();
  Origin? get currentOrigin => lists.elementAtOrNull(selectedIndex)?.origin;
  final List<NoticeList> lists = NoticeManager()
      .origins
      .map((e) => NoticeList(
    origin: e,
    perPage: NoticeManager().perPage,
  ))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => setState(() {
          selectedIndex = i;
          if (currentOrigin != null) {
            log('Origin changed to ${currentOrigin!.name}');
          }
        }),
        children: [
          Text('탐색',
              style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)
          ),
          FloatingActionButton(
            onPressed: () => {
              siteAdd(),
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: currentOrigin == null
          ? null
          : FloatingActionButton(
        onPressed: () => _buildOriginDialog(context, currentOrigin!),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  void onPressedPerson() {
    log('Person button pressed');
  }


  Future<void> _buildOriginDialog(BuildContext context, Origin origin) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Text(newURL),
            const Divider(
              height: 30,
            ),
            Row(children: [
              Expanded(
                  child: TextField(
                    controller: tx,
                  )),
              FilledButton(
                  onPressed: () => {},
                  child: const Text("f")
              )
            ]),
          ],
        );
      },
    );
  }

  Widget siteAdd() => AlertDialog(
      shape: RoundedRectangleBorder(
        //팝업창에 radius를 주기위한 옵션
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0),
      //default 패딩값을 없앨 수 있다.
      content:Container()
  );

}