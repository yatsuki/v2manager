import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart';
import 'package:v2manager/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 隐藏底部按钮栏
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    // // 隐藏状态栏
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // // 隐藏状态栏和底部按钮栏
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "V2ray Manager",
      theme: ThemeData(
        // fontFamily: 'Georgia',
        primarySwatch: Colors.green,
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary, buttonColor: Colors.green)
      ),
      routes: routePath,
      initialRoute: rHome,
    );
  }
}