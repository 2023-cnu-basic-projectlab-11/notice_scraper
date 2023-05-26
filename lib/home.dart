import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/notice_list.dart';
import 'package:notice_scraper/notice_manager.dart';
import 'package:notice_scraper/site_add.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  String newURL='';
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
      appBar: AppBar(
        elevation: 10,
        title: Text(currentOrigin?.name ?? ''),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: onPressedPerson,
        ),
      ),
      endDrawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => setState(() {
          selectedIndex = i;
          if (currentOrigin != null) {
            log('Origin changed to ${currentOrigin!.name}');
          }
        }),
        children: [
          navItem(
            Text('탐색',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
          const Divider(),
          ...lists
              .map((e) => e.origin)
              .map((origin) => NavigationDrawerDestination(
                    label: Text(origin.name),
                    icon: const Icon(Icons.circle, size: 8),
                  )),
          const Divider(),
          FloatingActionButton(
            onPressed: () => {
              siteAdd(),
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: currentOrigin == null
          ? const Text('등록된 사이트가 없습니다.')
          : Column(children: [
            Flexible(
              flex: 1,
                child: upperList()
            ),
            Expanded(
              flex: 10,
              child: IndexedStack(index: selectedIndex, children: lists),
            )
        ]),
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
            Text(
              origin.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              origin.description ?? "설명 없음",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.right,
            ),
            const Divider(
              height: 30,
            ),
            Row(children: [
              Expanded(
                  child: Text(
                origin.baseUri,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              FilledButton(
                  onPressed: () => _launchUrl(origin.baseUri),
                  child: const Text("사이트 접속"))
            ]),
          ],
        );
      },
    );
  }

  Widget navItem(Widget inner) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        constraints: const BoxConstraints.expand(height: 56),
        child: inner,
      );

  Widget bulletElement(String text) => Row(children: [
        const Text(
          "\u2022",
          style: TextStyle(fontSize: 30),
        ), //bullet text
        const SizedBox(
          width: 10,
        ), //space between bullet and text
        Expanded(
          child: Text(
            text,
          ), //text
        )
      ]);

  Widget upperList(){
    List<String> strlist=["공대", "사캠", "-", "-", "-", "-", "-", "-", "-", "-"];

    return ListView.separated(
      padding: const EdgeInsets.all(5),
      itemCount: strlist.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: [
              FloatingActionButton(
                  child: Text(strlist.elementAt(index)),
                  onPressed: (){
                    setState(() {
                      selectedIndex=index;
                    });
                  }
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Future<void> _launchUrl(String source) async {
    if (!await launchUrl(Uri.https(source))) {
      throw Exception('Could not launch $source');
    }
  }
}
