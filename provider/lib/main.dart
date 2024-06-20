import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:worker/firebase_options.dart';
import 'package:worker/network/local/cach_helper.dart';
import 'package:worker/new/home.dart';
import 'package:worker/noconnection.dart';
import 'package:worker/view/auth/letsin/letsyou.dart';
import 'package:worker/view/home_screen/home.dart';
import 'package:worker/view/splashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     String? token = CacheHelper.getData(key: "token");
     print(token);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      locale: Locale('ar', 'AE'), // Set default locale to Arabic
      fallbackLocale: Locale('ar', 'AE'), // Fallback to Arabic
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'),
      ],

      home: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          return snapshot.data==ConnectivityResult.none?
          const NoConnectionWidget()
          :
          SplashPage();
        }
      ),
    );
  }
}
//