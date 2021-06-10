import 'package:cricket_live_score/constraints.dart';
import 'package:cricket_live_score/widgets/matchcard.dart';
import 'package:cricket_live_score/widgets/upcoming_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';

class ScoreDetailScreen extends StatefulWidget {
  @override
  _ScoreDetailScreenState createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Derby vs Lanc',
          style: appBarTitleTextStyle,
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[startingColor, endingColor]))),
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
                        right: MediaQuery.of(context).size.height * 0.01,
                        top: MediaQuery.of(context).size.height * 0.01
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5.0),
                          color: Colors.grey[850]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Icon(
                                    //   EvaIcons.volumeMuteOutline,
                                    //   color: Colors.white,
                                    // ),
                                    Container(

                                        // alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: SpriteDemo()),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.80,
                          //   child:
                          // ),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'SourceSansPro-Regular',
                            ),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                ScaleAnimatedText('Bowling'),
                                ScaleAnimatedText('Batting'),
                                ScaleAnimatedText('Fielding'),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'NW 55/4',
                                        style: TextStyle(
                                            fontFamily: "SourceSansPro-Regular",
                                            letterSpacing: 0.8,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        children: <TextSpan>[
                                      TextSpan(
                                        text: '(7.0)',
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
                                        text: 'NW 55/4',
                                        style: TextStyle(
                                            fontFamily: "SourceSansPro-Regular",
                                            letterSpacing: 0.8,
                                            color: Colors.black,
                                            fontSize: 18),
                                        children: <TextSpan>[
                                      TextSpan(
                                        text: '(7.0)',
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
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textWidget('Run needed', ' 168'),
                        textWidget('Ball Rem', ' 120')
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
                        textWidget('R.R.R', ' 8.45'),
                        textWidget('C.R.R', ' 0.0'),
                        textWidget('Target', ' 169')
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textWidget('Fav Team', ' Eng'),
                        textWithBox('LANC:', '', '43', '42')
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
                        textWithBox('6', 'Over Runs', '52', '52'),
                        textWithBox('RXB', '', '52', '52')
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
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
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Jos Butler')),
                            DataCell(Text('23')),
                            DataCell(Text('10')),
                            DataCell(Text('2')),
                            DataCell(Text('1')),
                            DataCell(Text('0')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                                'Jonny Bairstow')), //Current strike batsman
                            DataCell(Text('50')),
                            DataCell(Text('30')),
                            DataCell(Text('2')),
                            DataCell(Text('1')),
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
                          left: MediaQuery.of(context).size.height * 0.03),
                      child: Text(
                        'Partnership',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Last 24 Balls'),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.red[300],
                        child: Text('W', style: subtitleTextStyle2),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: Text('1', style: subtitleTextStyle2),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: Text('1', style: subtitleTextStyle2),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.purple[300],
                        child: Text('6', style: subtitleTextStyle2),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[600],
                        child: Text(
                          '0',
                          style: subtitleTextStyle2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
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
              Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columnSpacing: 20.0,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Over',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Session',
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Pass/Wkt',
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ODDS',
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('0')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('LANC 28-31')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('6')),
                            DataCell(Text('44-85')),
                            DataCell(Text('84/1')),
                            DataCell(Text('LANC 28-31')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('6')),
                            DataCell(Text('44-85')),
                            DataCell(Text('84/1')),
                            DataCell(Text('LANC 28-31')),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                      endIndent: 1,
                      indent: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.03),
                      child: Text(
                        'Partnership',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
