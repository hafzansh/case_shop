import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poggers/streams/landingpage.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueGrey, // navigation bar color
        statusBarColor: Colors.transparent, // status bar color
        statusBarBrightness: Brightness.dark, //status bar brigtness
        statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
        systemNavigationBarDividerColor:
            Colors.black, //Navigation bar divider color
        systemNavigationBarIconBrightness: Brightness.dark));
    return MaterialApp(
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            accentColor: Colors.blueGrey),
        home: LandingPage());
  }
}
