// @dart=2.9

import 'package:cricket_live_score/screens/Homescreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Cricket live master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SourceSansPro-Regular',
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => SplashScreen(
              title: Text(
                'Crickscore',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple,
                ),
              ),
              image: Image.asset('assets/Images/logo2.png'),
              photoSize: 50.0,
              seconds: 3,
              navigateAfterSeconds: HomeScreen(),
              backgroundColor: Colors.white,
              useLoader: true,
              loaderColor: Colors.pink[900],
            ),
      },
    );
  }
}
