import 'dart:async';
import 'dart:convert';

import 'package:cricket_live_score/constraints.dart';
import 'package:cricket_live_score/screens/Homescreen.dart';
import 'package:cricket_live_score/widgets/matchcard.dart';
import 'package:cricket_live_score/widgets/upcoming_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';

class ScoreDetailScreen extends StatefulWidget {
  final String? uid;
  ScoreDetailScreen({this.uid});

  @override
  _ScoreDetailScreenState createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
  // ignore: close_sinks
  StreamController<DetailsModel>? streamController;
  ScrollController? scrollController;
  @override
  void initState() {
    scrollController = ScrollController();

    streamController = StreamController();
    Timer.periodic(Duration(microseconds: 300), (timer) {
      fetchAlbum(widget.uid!);
    });
    super.initState();
  }

  void dispose() {
    streamController!.close();
    scrollController!.dispose();
    super.dispose();
  }

  Future fetchAlbum(String uid) async {
    // print(widget.uid);
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258
    //30595134
    try {
      final response = await http.get(
        Uri.parse(
            'http://139.59.82.99:3000/api/match/getMatchScore?eventId=$uid'),
      );
      // print(response.body);
      // print(response.statusCode.toString());

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        // print(jsonDecode(response.body)['result']);

        streamController!
            .add(DetailsModel.fromJson(jsonDecode(response.body)['result']));
      } else if (response.statusCode == 202) {
        streamController!.addError(
          new Exception("Failed to load the data"),
        );
      } else {
        throw Exception('Failed to load the data');
      }
    } catch (e) {
      return e;
    }
  }

  Widget redcard(String data) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.035,
      width: MediaQuery.of(context).size.width * 0.07,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.red[300], borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(data, style: TextStyle(color: Colors.white))),
    );
  }

  Widget greencard(String data) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.035,
      width: MediaQuery.of(context).size.width * 0.07,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text(
        data,
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Widget textWidget(String title1, String title2) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: RichText(
          text: TextSpan(
              text: title1,
              style: TextStyle(
                  fontFamily: "SourceSansPro-Regular",
                  letterSpacing: 0.8,
                  color: Colors.black,
                  fontSize: 14),
              children: <TextSpan>[
            TextSpan(
              text: title2,
              style: TextStyle(
                  color: Colors.blueAccent, letterSpacing: 0.8, fontSize: 14),
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () {
              //     // navigate to desired screen
              //   }
            )
          ])),
    );
  }

  Widget textWithBox(
      String title1, String title2, String title3, String title4) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: Row(
        children: [
          RichText(
              text: TextSpan(
                  text: title1,
                  style: TextStyle(
                      fontFamily: 'SourceSansPro-Regular',
                      color: Colors.blueAccent,
                      letterSpacing: 0.8,
                      fontSize: 14),
                  children: <TextSpan>[
                TextSpan(
                  text: title2,
                  style: TextStyle(
                      fontFamily: "SourceSansPro-Regular",
                      letterSpacing: 0.8,
                      color: Colors.black,
                      fontSize: 14),
                  // recognizer: TapGestureRecognizer()
                  //   ..onTap = () {
                  //     // navigate to desired screen
                  //   }
                )
              ])),
          Container(
            height: MediaQuery.of(context).size.height * 0.035,
            width: MediaQuery.of(context).size.width * 0.07,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.red[300], borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(title3, style: TextStyle(color: Colors.white))),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.035,
            width: MediaQuery.of(context).size.width * 0.07,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(
              title4,
              style: TextStyle(color: Colors.white),
            )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamController!.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              if (scrollController!.hasClients) {
                scrollController!.animateTo(
                    scrollController!.position.maxScrollExtent,
                    duration: Duration(microseconds: 300),
                    curve: Curves.easeInOut);
              }
            });
            DetailsModel model = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: Text(
                  model.home.t1['n'] + ' vs ' + model.home.t2['n'],
                  style: appBarTitleTextStyle,
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        startingColor,
                        endingColor,
                      ],
                    ),
                  ),
                ),
                // bottom: TabBar(
                //   isScrollable: true,
                //   indicatorColor: Colors.white,
                //   tabs: [
                //     Tab(
                //       child: Row(
                //         children: [
                //           Icon(Icons.sports_cricket),
                //           SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.015,
                //           ),
                //           Text(
                //             'Live',
                //             style: tabBarTitleTextStyle,
                //           ),
                //         ],
                //       ),
                //     ),

                //   ],
                // ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[startingColor, endingColor])),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height * 0.01,
                                right:
                                    MediaQuery.of(context).size.height * 0.01,
                                top: MediaQuery.of(context).size.height * 0.01,
                              ),
                              height: MediaQuery.of(context).size.height * 0.18,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 5.0),
                                  color: Colors.grey[850]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Icon(
                                            //   EvaIcons.volumeMuteOutline,
                                            //   color: Colors.white,
                                            // ),
                                            Container(

                                                // alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: SpriteDemo()),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  DefaultTextStyle(
                                    style: const TextStyle(
                                      fontSize: 19.0,
                                      fontFamily: 'SourceSansPro-Regular',
                                    ),
                                    child: AnimatedTextKit(
                                      isRepeatingAnimation: true,
                                      repeatForever: true,
                                      animatedTexts: [
                                        ScaleAnimatedText(
                                          model.home.cs['msg'] == 'OC'
                                              ? "Over complete"
                                              : model.home.cs['msg'] == 'B'
                                                  ? "Balling"
                                                  : model.home.cs['msg'] == 'wk'
                                                      ? "Wicket"
                                                      : model.home.cs['msg'],
                                        ),
                                        // ScaleAnimatedText('Batting'),
                                        // ScaleAnimatedText('Fielding'),
                                      ],
                                      onTap: () {
                                        print("Tap Event");
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: model.home.t1['n'] +
                                                    " " +
                                                    model.home.i1['sc'] +
                                                    '/' +
                                                    model.home.i1['wk'],
                                                // 'NW 55/4',
                                                style: TextStyle(
                                                    fontFamily:
                                                        "SourceSansPro-Regular",
                                                    letterSpacing: 0.8,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                children: <TextSpan>[
                                              TextSpan(
                                                text: model.home.i1['ov'] +
                                                    " " +
                                                    "overs",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    letterSpacing: 0.8,
                                                    fontSize: 14),
                                                // recognizer: TapGestureRecognizer()
                                                //   ..onTap = () {
                                                //     // navigate to desired screen
                                                //   }
                                              )
                                            ])),
                                        RichText(
                                            text: TextSpan(
                                                text: model.home.i2['ov'] ==
                                                            "0" ||
                                                        model.home.i2['ov'] ==
                                                            ""
                                                    ? ""
                                                    : model.home.t2['n'] +
                                                        " " +
                                                        model.home.i2['sc'] +
                                                        '/' +
                                                        model.home.i2['wk'],
                                                style: TextStyle(
                                                    fontFamily:
                                                        "SourceSansPro-Regular",
                                                    letterSpacing: 0.8,
                                                    color: Colors.black,
                                                    fontSize: 18),
                                                children: <TextSpan>[
                                              TextSpan(
                                                text: model.home.i2['ov'] ==
                                                            "0" ||
                                                        model.home.i2['ov'] ==
                                                            ""
                                                    ? ""
                                                    : model.home.i2['ov'] +
                                                        " " +
                                                        "overs",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    letterSpacing: 0.8,
                                                    fontSize: 14),
                                                // recognizer: TapGestureRecognizer()
                                                //   ..onTap = () {
                                                //     // navigate to desired screen
                                                //   }
                                              )
                                            ]))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   height: MediaQuery.of(context).size.height * 0.02,
                            //   width: MediaQuery.of(context).size.width * 0.10,
                            //   color: Colors.black,
                            // )
                          ],
                        ),
                      ),
                      model.home.i == "i2" && model.home.con['mf'] != "Test"
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: double.infinity,
                              margin: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.01),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  model.home.i == "i2" &&
                                          model.home.con['mf'] != "Test"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            textWidget(
                                              'Run needed',
                                              ' ${(int.parse(model.home.i2['tr']) - int.parse(model.home.i2['sc'])).toString()}',
                                            ),
                                            textWidget('Overs Rem',
                                                ' ${(double.parse(model.home.iov!) - double.parse(model.home.i2['ov'])).toString()}'),
                                          ],
                                        )
                                      : Container(),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.grey,
                                    endIndent: 1,
                                    indent: 1,
                                  ),
                                  model.home.i == "i2"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            textWidget('R.R.R', ' 8.45'),
                                            textWidget('C.R.R', ' 0.0'),
                                            textWidget('Target',
                                                ' ${model.home.i2['tr']}')
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: double.infinity,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            model.home.con['mf'] == "Test"
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(model.home.t1['n']),
                                            Row(
                                              children: [
                                                redcard(model.home.rt!
                                                    .split(",")[0]),
                                                greencard(model.home.rt!
                                                    .split(",")[1]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(model.home.t2['n']),
                                            Row(
                                              children: [
                                                redcard(model.home.rt!
                                                    .split(",")[2]),
                                                greencard(model.home.rt!
                                                    .split(",")[3]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Text("Draw"),
                                            Row(
                                              children: [
                                                redcard(model.home.rt!
                                                    .split(",")[4]),
                                                greencard(model.home.rt!
                                                    .split(",")[5]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textWidget('Fav Team',
                                          ' ${model.home.rt!.split(",")[0]}'),
                                      textWithBox(
                                          '${model.home.rt!.split(",")[0]}:',
                                          ' ',
                                          '${model.home.rt!.split(",")[1]}',
                                          '${model.home.rt!.split(",")[2]}')
                                    ],
                                  ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                              endIndent: 1,
                              indent: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                model.home.sn == ""
                                    ? textWithBox('6 ', 'Over Runs', '-', '-')
                                    : textWithBox(
                                        '${model.home.sn!.split(",")[0]}',
                                        'Over Runs',
                                        '${model.home.sn!.split(",")[1]}',
                                        '${model.home.sn!.split(",")[2]}'),
                                textWithBox('R X B', '', '-', '-')
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataTable(
                              columnSpacing: 30.0,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Batsman',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'R',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'B',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    '4s',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    '6s',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'SR',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                model.home.b1s == ""
                                    ? DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text(' 0 ')),
                                        ],
                                      )
                                    : DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(model.home.os == "p1"
                                              ? '${model.home.p1}*'
                                              : '${model.home.p1}')),
                                          DataCell(Text(
                                              '${model.home.b1s!.split(",")[0]}')),
                                          DataCell(Text(
                                              '${model.home.b1s!.split(",")[1]}')),
                                          DataCell(Text(
                                              '${model.home.b1s!.split(",")[2]}')),
                                          DataCell(Text(
                                              '${model.home.b1s!.split(",")[3]}')),
                                          DataCell(Text('0')),
                                        ],
                                      ),
                                model.home.b2s == ""
                                    ? DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text("    -  ")),
                                          DataCell(Text(' 0 ')),
                                        ],
                                      )
                                    : DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(model.home.os == "p2"
                                              ? '${model.home.p2}*'
                                              : '${model.home.p2}')),
                                          DataCell(Text(
                                              '${model.home.b2s!.split(",")[0]}')),
                                          DataCell(Text(
                                              '${model.home.b2s!.split(",")[1]}')),
                                          DataCell(Text(
                                              '${model.home.b2s!.split(",")[2]}')),
                                          DataCell(Text(
                                              '${model.home.b2s!.split(",")[3]}')),
                                          DataCell(Text('0')),
                                        ],
                                      ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('Joe Root')), //Current strike batsman
                                //     DataCell(Text('500')),
                                //     DataCell(Text('100')),
                                //     DataCell(Text('20')),
                                //     DataCell(Text('30')),
                                //     DataCell(Text('0')),
                                //   ],
                                // ),
                              ],
                            ),
                            // Divider(
                            //   thickness: 0.5,
                            //   color: Colors.grey,
                            //   endIndent: 1,
                            //   indent: 1,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right: MediaQuery.of(context).size.height *
                                      0.01),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Partnership' +
                                        ":- " +
                                        (model.home.pt! == ""
                                            ? ""
                                            : (model.home.pt!.split(",")[0] +
                                                '(${model.home.pt!.split(",")[1]})')),
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                  Text(
                                    "Last wicket:-  " +
                                        model.home.lw.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: double.infinity,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Last 24 Balls'),
                              // model.home.pb != ""
                              //     ? Expanded(
                              //         child: Container(
                              //           child: ListView.builder(
                              //               controller: scrollController,
                              //               scrollDirection: Axis.horizontal,
                              //               // shrinkWrap: true,
                              //               // physics: NeverScrollableScrollPhysics(),
                              //               itemCount: model.home.pb!
                              //                   .split(",")
                              //                   .length,
                              //               itemBuilder:
                              //                   (BuildContext context, int i) {
                              //                 return model.home.pb!
                              //                             .split(",")
                              //                             .length ==
                              //                         0
                              //                     ? Container()
                              //                     : CircleAvatar(
                              //                         radius: 18,
                              //                         backgroundColor: model
                              //                                     .home.pb!
                              //                                     .split(
                              //                                         ",")[i] ==
                              //                                 "W"
                              //                             ? Colors.red[300]
                              //                             : model.home.pb!.split(
                              //                                         ",")[i] ==
                              //                                     '6'
                              //                                 ? Colors
                              //                                     .purple[300]
                              //                                 : model.home.pb!.split(
                              //                                                 ",")[
                              //                                             i] ==
                              //                                         '4'
                              //                                     ? Colors.green
                              //                                     : Colors
                              //                                         .green,
                              //                         child: Text(
                              //                             model.home.pb!
                              //                                 .split(",")[i],
                              //                             style:
                              //                                 subtitleTextStyle2),
                              //                       );
                              //               }),
                              //         ),
                              //       )
                              //     : Container(),

                              // CircleAvatar(
                              //   radius: 18,
                              //   backgroundColor: Colors.red[300],
                              //   child: Text('W', style: subtitleTextStyle2),
                              // ),
                              // CircleAvatar(
                              //   radius: 18,
                              //   backgroundColor: Colors.green,
                              //   child: Text('1', style: subtitleTextStyle2),
                              // ),
                              // CircleAvatar(
                              //   radius: 18,
                              //   backgroundColor: Colors.green,
                              //   child: Text('1', style: subtitleTextStyle2),
                              // ),
                              // CircleAvatar(
                              //   radius: 18,
                              //   backgroundColor: Colors.purple[300],
                              //   child: Text('6', style: subtitleTextStyle2),
                              // ),
                              // CircleAvatar(
                              //   radius: 18,
                              //   backgroundColor: Colors.grey[600],
                              //   child: Text(
                              //     '0',
                              //     style: subtitleTextStyle2,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: double.infinity,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Prediction'),
                              DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontFamily: 'SourceSansPro-Regular',
                                  ),
                                  child: AnimatedTextKit(
                                      isRepeatingAnimation: true,
                                      animatedTexts: [
                                        RotateAnimatedText('England will'),
                                        RotateAnimatedText('win by'),
                                        RotateAnimatedText('24 runs'),
                                      ])),
                            ],
                          ),
                        ),
                      ),
                      model.home.md == ""
                          ? Container()
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.33,
                              width: double.infinity,
                              margin: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.01),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: model.home.md == ""
                                  ? Text("")
                                  : Text("${model.home.md}"),
                              //  Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     DataTable(
                              //       columnSpacing: 20.0,
                              //       columns: const <DataColumn>[
                              //         DataColumn(
                              //           label: Text(
                              //             'Over',
                              //             style: TextStyle(color: Colors.deepPurple),
                              //           ),
                              //         ),
                              //         DataColumn(
                              //           label: Text(
                              //             'Session',
                              //             style: TextStyle(
                              //               color: Colors.deepPurple,
                              //             ),
                              //           ),
                              //         ),
                              //         DataColumn(
                              //           label: Text(
                              //             'Pass/Wkt',
                              //             style: TextStyle(
                              //               color: Colors.deepPurple,
                              //             ),
                              //           ),
                              //         ),
                              //         DataColumn(
                              //           label: Text(
                              //             'ODDS',
                              //             style: TextStyle(
                              //               color: Colors.deepPurple,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //       rows: const <DataRow>[
                              //         DataRow(
                              //           cells: <DataCell>[
                              //             DataCell(Text('0')),
                              //             DataCell(Text('')),
                              //             DataCell(Text('')),
                              //             DataCell(Text('LANC 28-31')),
                              //           ],
                              //         ),
                              //         DataRow(
                              //           cells: <DataCell>[
                              //             DataCell(Text('6')),
                              //             DataCell(Text('44-85')),
                              //             DataCell(Text('84/1')),
                              //             DataCell(Text('LANC 28-31')),
                              //           ],
                              //         ),
                              //         DataRow(
                              //           cells: <DataCell>[
                              //             DataCell(Text('6')),
                              //             DataCell(Text('44-85')),
                              //             DataCell(Text('84/1')),
                              //             DataCell(Text('LANC 28-31')),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //     Divider(
                              //       thickness: 0.5,
                              //       color: Colors.grey,
                              //       endIndent: 1,
                              //       indent: 1,
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.only(
                              //           left: MediaQuery.of(context).size.height *
                              //               0.03),
                              //       child: Text(
                              //         'Partnership',
                              //         style: TextStyle(color: Colors.deepPurple),
                              //       ),
                              //     )
                              //   ],
                              // ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
