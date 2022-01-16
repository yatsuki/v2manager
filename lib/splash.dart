// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart';
import 'package:v2manager/pages/home/home.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    var d = const Duration(seconds: splashDuration);
    Future.delayed(d, () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const HomePage();
      }), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: SizedBox()));

}
