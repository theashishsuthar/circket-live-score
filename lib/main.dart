// @dart=2.9
import 'package:cricket_live_score/Authentications/signin.dart';

import 'package:cricket_live_score/screens/Homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: SplashScreen(
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
        seconds:3,
        navigateAfterSeconds: HomeScreen(),
        backgroundColor: Colors.white,
        useLoader: true,
        loaderColor: Colors.pink[900],
      ),
    );
  }
}

User user;
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
