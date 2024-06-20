import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:worker/network/local/cach_helper.dart';
import 'package:worker/new/home.dart';
import 'package:worker/view/auth/letsin/letsyou.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _initialized = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await CacheHelper.init();
    String? token = await CacheHelper.getData(key: 'token');
    print("before if token= $token");

    //Future.delayed(Duration(seconds: 5),
    Timer(const Duration(seconds: 3), () async {
      if (token != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BaseScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Letsyou()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EasySplashScreen(
      logoWidth: 100,
      logo: Image.asset(
        "assets/images/3.png",
        width: 1000,
        height: 700,
        fit: BoxFit.cover,
      ),
      title: const Text(
        "",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: const Text("...تحميل"),
    ));
  }
}
