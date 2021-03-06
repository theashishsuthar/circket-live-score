// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_live_score/screens/DetailScreen.dart';
import 'package:cricket_live_score/screens/Homescreen.dart';
import 'package:device_info/device_info.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:splashscreen/splashscreen.dart';

bool premiumStatus = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration = RequestConfiguration(
  //   testDeviceIds: [
  //   "ECE8592E40EC36DA1900EBE92963BB3C",
  // ]
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    addORupdateData();
    checkpremium();

    super.initState();
  }

  Future checkpremium() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();
    if (doc.exists) {
      setState(() {
        premiumStatus = doc['premium'];
      });
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future addORupdateData() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();
    String token = await _firebaseMessaging.getToken().then((token) {
      return token;
    });
    if (doc.exists) {
      _firebaseMessaging.getToken().then((tokens) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(androidInfo.androidId)
            .update({'androidNotificationToken': tokens});
      });
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(androidInfo.androidId)
          .set({
        "uid": androidInfo.androidId,
        "premium": false,
        "PremiumEnd": Timestamp.now(),
        "time": Timestamp.now(),
        'androidNotificationToken': token,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Cricket line master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SourceSansPro-Regular',
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => SplashScreen(
              title: Text(
                'Cricket Line Master',
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
