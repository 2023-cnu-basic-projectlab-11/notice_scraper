import 'package:flutter/cupertino.dart';

import 'notice.dart';

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