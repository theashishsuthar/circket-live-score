import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_live_score/advertisement/ad_helper.dart';
import 'package:cricket_live_score/constraints.dart';
import 'package:cricket_live_score/main.dart';
import 'package:cricket_live_score/screens/DetailScreen.dart';
import 'package:cricket_live_score/screens/subscription.dart';
import 'package:cricket_live_score/screens/subscriptionHistory.dart';
import 'package:cricket_live_score/widgets/matchcard.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;

import 'package:cricket_live_score/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  late BannerAd _bannerAd;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@drawable/ic_launcher');
    // const IOSInitializationSettings b = IOSInitializationSettings();
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(initializationSettingsAndroid, b);

    // notifications.initialize(
    //   initializationSettings,
    // );

    // addORupdateData();
    changePremiumuserStatus();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    setup();
    handle();

    _bannerAd.load();
    print(premiumStatus);
    super.initState();
  }

  Future setup() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future handle() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: "@drawable/ic_launcher",

                importance: Importance.high,

                // icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data);
      if (message.data['gameId'] != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ScoreDetailScreen(
            uid: message.data['gameId'],
          );
        }));
      }
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
    });
  }

  // Future? handle() async {
  //   _firebaseMessaging!.configure(
  //     onResume: (Map<String, dynamic> message) async {},
  //     // onBackgroundMessage: showNotification,
  //     onMessage: (Map<String, dynamic> message) async {
  //       print(message);
  //       return showNotification(message);
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {},
  //   );
  // }

  // Future<dynamic> showNotification(Map<String, dynamic> message) async {
  //   AndroidNotificationDetails androidChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'CHANNEL ID 2',
  //     'CHANNEL NAME 2',
  //     'CHANNEL DESCRIPTION 2',
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     playSound: true,
  //     color: Colors.black,
  //     // largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
  //     styleInformation: BigTextStyleInformation(
  //       '${message['data']['body']}',
  //       contentTitle: '<b>${message['data']['title']}</b>',
  //       htmlFormatContentTitle: true,
  //     ),
  //   );
  //   var b = IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(androidChannelSpecifics, b);
  //   await notifications.show(
  //     0,
  //     message['notification']['title'],
  //     message['notification']['body'],
  //     platformChannelSpecifics,
  //     payload: 'Custom_Sound',
  //   );
  // }

  changePremiumuserStatus() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();

    if (doc.exists) {
      if (DateTime.parse(Timestamp.now().toDate().toString())
          .isAfter(DateTime.parse(doc['PremiumEnd'].toDate().toString()))) {
        doc.reference.update({
          'premium': false,
        });
      }
    }
  }

//  'premiumStart': Timestamp.now(),
//             'premiumEnd': Timestamp.fromDate(DateTime(DateTime.now().year,
//                 DateTime.now().month + 1, DateTime.now().day))

  Future androidId() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId;
  }

  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Widget homescreen() {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Are you sure?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  content: const Text('Do you want to exit from app?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Crickscore',
              style: appBarTitleTextStyle,
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[startingColor, endingColor]))),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.sports_cricket),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.015,
                      ),
                      Text(
                        'Live',
                        style: tabBarTitleTextStyle,
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(EvaIcons.clockOutline),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.015,
                      ),
                      Text(
                        'Upcoming',
                        style: tabBarTitleTextStyle,
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(Icons.wallet_membership),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.015,
                      ),
                      Text(
                        'Subscription',
                        style: tabBarTitleTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LiveScore(),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[startingColor, endingColor])),
                child: UpcomingMatches(),
              ),
              premiumStatus ? SubscriptionHistory() : Subscription()
            ],
          ),
        ),
      ),
    );
  }

  Future checkpremium() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();
    return doc;
  }

  Widget adwidget() {
    return FutureBuilder(
        future: checkpremium(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot doc = snapshot.data;
            // print(doc['premium']);
            return _isBannerAdReady && doc['premium'] == false
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        homescreen(),
        adwidget(),
      ],
    );
  }
}

class LiveScore extends StatefulWidget {
  const LiveScore({Key? key}) : super(key: key);

  @override
  _LiveScoreState createState() => _LiveScoreState();
}

class _LiveScoreState extends State<LiveScore> {
  Future fetchMatches() async {
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258
    //30594391
    try {
      final response =
          await http.get(Uri.http('13.235.241.13', '/getgames/cricket'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];

        // return DataGet.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('failed to load the data');
      }
    } catch (e) {
      print(e);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('OOps! Something went wrong.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[startingColor, endingColor])),
      child: StreamBuilder(
          stream: Stream.fromFuture(fetchMatches()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<DataGet> _list = [];
            if (snapshot.hasData) {
              snapshot.data!.forEach((element) {
                DataGet d = DataGet.fromJson(element);
                if (d.vir == "1" && d.inplay == "True") {
                  _list.add(d);
                }
              });
              return _list.isEmpty
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.height * 0.08,
                              right: MediaQuery.of(context).size.width * 0.05,
                            ),
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/Images/logo2.png',
                              scale: 1,
                            ),
                          ),
                          Text(
                            "No live matches available",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      // shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // print(_list[index].title);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ScoreDetailScreen(
                                uid: _list[index].uid,
                              );
                            }));
                          },
                          child: MatchCard(
                            uid: _list[index].uid,
                            title: _list[index].title,
                          ),
                        );
                      });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            }
          }),
    );
  }
}

class DataGet {
  String? title;
  String? uid;
  String? vir;
  String? inplay;
  String? back1;
  String? back11;
  String? back12;
  String? f;
  String? lay1;
  String? lay11;
  String? lay12;
  String? m1;
  String? tv;
  DataGet({
    this.title,
    this.uid,
    this.inplay,
    this.vir,
    this.back1,
    this.back11,
    this.back12,
    this.f,
    this.lay1,
    this.lay11,
    this.lay12,
    this.m1,
    this.tv,
  });
  factory DataGet.fromJson(Map<String, dynamic> json) {
    return DataGet(
      uid: json['gameId'],
      title: json['eventName'],
      inplay: json['inPlay'] as String,
      vir: json["vir"].toString(),
      back11: json['back11'].toString(),
      back12: json['back12'].toString(),
      back1: json['back1'].toString(),
      f: json['f'].toString(),
      lay11: json['lay11'].toString(),
      lay12: json['lay12'].toString(),
      lay1: json['lay1'].toString(),
      m1: json['m1'].toString(),
      tv: json['tv'].toString(),
    );
  }
}
// import 'dart:convert';

// import 'package:cricket_live_score/Screens/Detail_Screen.dart';
// import 'package:cricket_live_score/Screens/Live_Score.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class UpcomingMatches extends StatefulWidget {
  const UpcomingMatches({Key? key}) : super(key: key);

  @override
  _UpcomingMatchesState createState() => _UpcomingMatchesState();
}

class _UpcomingMatchesState extends State<UpcomingMatches> {
  Future<List<dynamic>> fetchMatches() async {
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258

    final response =
        await http.get(Uri.http('13.235.241.13', '/getgames/cricket'));

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['data']);
      return jsonDecode(response.body)['data'];

      // return DataGet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.fromFuture(fetchMatches()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<DataGet> _list = [];
          if (snapshot.hasData) {
            snapshot.data!.forEach((element) {
              DataGet d = DataGet.fromJson(element);
              if (d.vir == "1" && d.inplay == "False") {
                _list.add(d);
              }
            });
            _list.removeAt(0);

            return ListView.builder(

                // shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ScoreDetailScreen(
                            uid: _list[index].uid,
                          );
                          // DetailScreen(
                          //   uid: _list[index].uid,
                          // );
                        }));
                      },
                      child: UpComingMatchCard(
                        uid: _list[index].uid,
                        time: _list[index].title!.split("/")[1],
                        title: _list[index].title!.split("/")[0],
                      )
                      //  Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: ListTile(
                      //     title: Text(_list[index].title!.split("/")[0]),
                      //     subtitle: Text(_list[index].title!.split("/")[1]),
                      //   ),
                      // ),
                      );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final String? uid;
  DetailScreen({this.uid});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late StreamController<DetailsModel> streamController;
  @override
  void initState() {
    streamController = StreamController();

    Timer.periodic(Duration(microseconds: 300), (timer) {
      fetchAlbum();
    });

    super.initState();
  }

  Future fetchAlbum() async {
    // print(widget.uid);
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258
    //30595134
    try {
      final response = await http.get(
        Uri.parse(
            'http://139.59.82.99:3000/api/match/getMatchScore?eventId=${widget.uid}'),
      );
      // print(response.body);
      // print(response.statusCode.toString());

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        // print(jsonDecode(response.body)['result']);

        streamController
            .add(DetailsModel.fromJson(jsonDecode(response.body)['result']));
      } else if (response.statusCode == 202) {
        streamController.addError(
          new Exception("Failed to load the data"),
        );
      } else {
        throw Exception('Failed to load the data');
      }
    } catch (e) {
      return e;
    }
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // DetailsModel model = DetailsModel.fromJson(snapshot.data);
              DetailsModel model = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text("p1 : - ${model.p1!}"),
                    Text("p1 : - ${model.p2!}"),
                    Text("ao : - ${model.home.ao!}"),
                    Text("b1s : - ${model.home.b1s!}"),
                    Text("b2s : - ${model.home.b2s!}"),
                    Text("bw : - ${model.home.bw!}"),
                    Text("cd : - ${model.home.cd!}"),
                    Text("con : - ${model.home.con}"),
                    Text("cs : - ${model.home.cs}"),
                    Text("hms : - ${model.home.hms!}"),
                    Text("i : - ${model.home.i!}"),
                    Text("i1 : - ${model.home.i1}"),
                    Text("i1b : - ${model.home.i1b!}"),
                    Text("i2 : - ${model.home.i2}"),
                    Text("iov : - ${model.home.iov!}"),
                    Text("lw : - ${model.home.lw!}"),
                    Text("md : - ${model.home.md!}"),
                    Text("mit : - ${model.home.mit!}"),
                    Text("mk : - ${model.home.mk!}"),
                    Text("oh : - ${model.home.oh}"),
                    Text("os : - ${model.home.os!}"),
                    Text("home p1 : - ${model.home.p1!}"),
                    Text("home p2 : - ${model.home.p2!}"),
                    Text("pb : - ${model.home.pb!}"),
                    Text("pt : - ${model.home.pt!}"),
                    Text("rt : - ${model.home.rt!}"),
                    Text("sk : - ${model.home.sk!}"),
                    Text("sn : - ${model.home.sn}"),
                    Text("ssns : - ${model.home.ssns!}"),
                    Text("t1  - ${model.home.t1}"),
                    Text("t2 : - ${model.home.t2}"),
                    Text("tt : - ${model.home.tt!}"),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong!'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class DetailsModel {
  String? p1;
  String? p2;
  DetailsofHome home;
  DetailsModel({
    this.p1,
    this.p2,
    required this.home,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      home: DetailsofHome.fromJson(jsonDecode(json['home'])),
      p1: json['p1'].toString(),
      p2: json['p2'].toString(),
    );
  }
}

class DetailsofHome {
  String? ao;
  String? b1s;
  String? b2s;
  String? bw;
  String? cd;
  late Map<String, dynamic> con;
  late Map<String, dynamic> cs;
  String? hms;
  String? i;
  late Map<String, dynamic> i1;
  late Map<String, dynamic> i2;
  String? i1b;
  String? iov;
  String? lw;
  String? md;
  String? mit;
  String? mk;
  String? oh;
  String? os;
  String? p1;
  String? p2;
  String? pb;
  String? pt;
  String? rt;
  String? sk;
  String? sn;
  String? ssns;
  late Map<String, dynamic> t1;
  late Map<String, dynamic> t2;
  String? tt;

  DetailsofHome({
    this.ao,
    this.b1s,
    this.b2s,
    this.bw,
    this.cd,
    required this.con,
    required this.cs,
    this.hms,
    this.i,
    required this.i1,
    this.i1b,
    required this.i2,
    this.iov,
    this.lw,
    this.md,
    this.mit,
    this.mk,
    this.oh,
    this.os,
    this.p1,
    this.p2,
    this.pb,
    this.pt,
    this.rt,
    this.sk,
    this.sn,
    this.ssns,
    required this.t1,
    required this.t2,
    this.tt,
  });

  factory DetailsofHome.fromJson(Map<String, dynamic> json) {
    return DetailsofHome(
      con: json['con'],
      cs: json['cs'],
      i1: json['i1'],
      i2: json['i2'],
      t1: json['t1'],
      t2: json['t2'],
      ao: json['ao'],
      b1s: json['b1s'],
      b2s: json['b2s'],
      bw: json['bw'],
      cd: json['cd'],
      hms: json['hms'],
      i1b: json['i1b'],
      i: json['i'],
      iov: json['iov'],
      lw: json['lw'],
      md: json['md'],
      mit: json['mit'],
      mk: json['mk'],
      oh: json['oh'],
      os: json['os'],
      p1: json['p1'],
      p2: json['p2'],
      pb: json['pb'],
      pt: json['pt'],
      rt: json['rt'],
      sk: json['sk'],
      sn: json['sn'],
      ssns: json['ssns'],
      tt: json['tt'],
    );
  }
}
