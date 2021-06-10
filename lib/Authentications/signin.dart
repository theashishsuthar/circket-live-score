import 'package:cricket_live_score/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @required
  final FirebaseAuth? auth;
  @required
  final GoogleSignIn? signIn;
  SignIn({this.auth, this.signIn});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isloading = false;
  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        isloading = true;
      });
      GoogleSignInAccount? googleSignInAccount = await widget.signIn!.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult =
          await widget.auth!.signInWithCredential(credential);
      user = authResult.user;

      // print("User Name: ${user.displayName}");
      // print("User Email ${user.email}");
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MyApp();
        }));
      }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                'Oops! Something went wrong.',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Okay'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          });
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Widget signUpButton(String title, String imageUrl, Function fun) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      height: MediaQuery.of(context).size.height * 0.06,
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.65,
          maxWidth: MediaQuery.of(context).size.width * 0.75),
      child: RaisedButton(
        elevation: 1,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(
            60,
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.08,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.fill,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.6),
            ),
            isloading == true
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  )
                : Container(),
            isloading == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.03,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Stack(
      children: [
        Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1607081692245-419edffb5462?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
              fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.25), BlendMode.dstATop),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you love trends ? Want to be Part of Trend ? Then, sign up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.4,
                      fontFamily: 'BadScript',
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                      // decoration: InputDecoration
                      ),
                ),
              ),
              signUpButton('Sign in with Google',
                  'assets/images/google_logo.png', signInWithGoogle),
            ],
          ),
        ),
        isloading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
