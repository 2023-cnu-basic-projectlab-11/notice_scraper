import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notice_scraper/home.dart';
import 'package:notice_scraper/native_scrapers/cnu_college_eng.dart';
import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'package:notice_scraper/notice_manager.dart';
//import 'package:notice_scraper/native_scrapers/cnu_cyber_campus.dart';
import 'private.dart';

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.nanumGothicTextTheme(baseTheme.textTheme),
  );
}

void main() {
  NoticeManager().scrapers = [
    CNUCollegeEngScraper(),
    CNUCyberCampusScraper(id, pw)
  ];
  NoticeManager().perPage = 10;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notice Scraper',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
