import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notice_scraper/notice.dart';
import 'package:notice_scraper/notice_list.dart';
import 'package:notice_scraper/notice_manager.dart';
import 'package:notice_scraper/button_dropdown.dart';

import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  String newURL='';
  bool _overlay=false;
  OverlayEntry? overlayEntry;
 // final LayerLink _layerLink = LayerLink();

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
        title: Text('Notice Scraper', textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Qwitcher Grypen',
              fontSize: 36,
              letterSpacing: -0.01,
              fontWeight: FontWeight.normal,
              height: 1
          ),
        ),
      ),
      body: currentOrigin == null
          ? const Text('등록된 사이트가 없습니다.')
          : Column(children: [
            Flexible(
              flex: 1,
                child: upperList()
            ),
            Expanded(
              flex: 9,
              child: IndexedStack(index: selectedIndex, children: lists),
            )
        ]),
      /*
      floatingActionButton: currentOrigin == null
          ? null
          : FloatingActionButton(
              onPressed: () => _buildOriginDialog(context, currentOrigin!),
              child: const Icon(Icons.arrow_forward),
            ),

       */
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            if(index==2 && _overlay==false){
              _overlay=true;
             createHighlightOverlay();
            }else if(index==2 && _overlay==true){
              _overlay=false;
             removeHighlightOverlay();
            }
          });
        },
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.arrow_back),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_sharp),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),

            label: '',
          ),
        ],
      ),
    );
  }

  void createHighlightOverlay() {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);
    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        return Positioned(
          top: 400,
          left: 400,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: (() {

                }),
                child: Text(":"),
              ),
               FloatingActionButton(
                  child: Text(":"),
                  onPressed: (() {

                })
              ),
              FloatingActionButton(
                  child: Text(":"),
                  onPressed: (() {

                  })
              ),
              FloatingActionButton(
                   child: Text(":"),
                 onPressed: (() {

                 })
              ),
            ],
        )
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    super.dispose();
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
    List<String> strlist=["공대", "사캠"];


    return ListView.separated(
      padding: const EdgeInsets.all(5),
      itemCount: strlist.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
              width: 66,
              height: 66,

              child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color : Color.fromRGBO(217, 217, 217, 0),
                              border : Border.all(
                                color: Color.fromRGBO(161, 161, 161, 1),
                                width: 2,
                              ),
                              borderRadius : BorderRadius.all(Radius.elliptical(66, 66)),
                            )
                        )
                    ),
                    Positioned(
                        top: 8,
                        left: 0,
                        child: TextButton(
                            child: Text(strlist.elementAt(index)),
                            onPressed: (){
                              setState(() {
                                selectedIndex=index;
                              });
                            },
                          ),
                    )
              ]
              )



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
