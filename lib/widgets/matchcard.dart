import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cricket_live_score/screens/Homescreen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../constraints.dart';

class MatchCard extends StatefulWidget {
  final String? title;
  final String? uid;

  MatchCard({this.title, this.uid});

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  // ignore: close_sinks
  StreamController<DetailsModel>? streamController;

  @override
  void initState() {
    streamController = StreamController();
    fetchAlbum(widget.uid!).then((value) => timerFunction());

    super.initState();
  }

  @override
  void dispose() {
    streamController!.close();
    super.dispose();
  }

  timerFunction() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchAlbum(widget.uid!);
    });
  }

  Future fetchAlbum(String uid) async {
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258
    //30595134
    try {
      final response = await http.get(
        Uri.parse(
            'http://139.59.82.99:3000/api/match/getMatchScore?eventId=$uid'),
      );

      if (response.statusCode == 200) {
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

  Widget team(String circleTitle, String title, String score, bool isBatting,
      String over, BuildContext context) {
    //Changes maded
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          isBatting
              ? Row(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 15,
                          child: Text(
                            circleTitle.substring(0, 2),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.14,
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.016),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Column(
                      children: [
                        Text(
                          score,
                          style: runTextStyle,
                        ),
                        Text(
                          over,
                          style: subtitleTextStyle,
                        )
                      ],
                    ),
                  )
                ])
              : Row(
                  children: [
                    over == '0 over'
                        ? Container(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.08,
                                right:
                                    MediaQuery.of(context).size.width * 0.08),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02,
                                right:
                                    MediaQuery.of(context).size.width * 0.03),
                            child: Column(
                              children: [
                                Text(
                                  score,
                                  style: runTextStyle,
                                ),
                                Text(
                                  over,
                                  style: subtitleTextStyle,
                                )
                              ],
                            ),
                          ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 15,
                            child: Text(
                              circleTitle.substring(0, 2),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Text(
                              title,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.016,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
            DetailsModel model = snapshot.data;
            String value = model.home.con['mf'].toString() == "Test"
                ? " (${model.home.con['mf'].toString()})"
                : "";
            return Container(
                height: MediaQuery.of(context).size.height * 0.26,
                width: double.infinity,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      model.home.con['sr'].toString() + value,
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      widget.title!.split('/')[1],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          letterSpacing: 0.8),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.043,
                      ),
                      child: Row(
                        children: [
                          team(
                              model.home.t1['n']!.toString(),
                              model.home.t1['f']!.toString(),
                              model.home.i1['sc'].toString() +
                                  '/' +
                                  model.home.i1['wk'].toString(),
                              true,
                              model.home.i1['ov'].toString() + "over",
                              context),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                decoration: BoxDecoration(
                                    // color: Colors.grey,
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          startingColor,
                                          endingColor
                                        ]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: CircleAvatar(
                                  child: Text(
                                    'VS',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  radius: 15,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                          team(
                              model.home.t2['n']!.toString(),
                              model.home.t2['f']!.toString(),
                              model.home.i2['sc'].toString() +
                                  '/' +
                                  model.home.i2['wk'].toString(),
                              false,
                              model.home.i2['ov'].toString() + ' ' + "over",
                              context),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.width * 0.10,
                            margin: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            color: Colors.pink,
                            child: Text(
                              double.tryParse(model.home.rt!
                                          .split(',')[0]
                                          .toString()) !=
                                      null
                                  ? model.home.rt!.split(',')[0]
                                  : model.home.rt!.split(',')[1],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.width * 0.10,
                            alignment: Alignment.center,
                            color: Colors.pink,
                            child: Text(
                              int.tryParse(model.home.rt!
                                          .split(',')[0]
                                          .toString()) !=
                                      null
                                  ? model.home.rt!.split(',')[1]
                                  : model.home.rt!.split(',')[2],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.08),
                      child: model.home.con['lt'].toString().isNotEmpty
                          ? Text(
                              model.home.con['lt'].toString(),
                              style: TextStyle(
                                color: endingColor,
                                fontSize: 13,
                                letterSpacing: 0.8,
                              ),
                            )
                          : Text(
                              'Live',
                              style: TextStyle(color: Colors.red),
                            ),
                    ),
                  ],
                ));
          } else if (snapshot.hasError) {
            // return Container();
            return Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: Text(
                      widget.title!
                          .split("/")[0]
                          .split("v")[0]
                          .trim()
                          .substring(0, 1),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          widget.title!.split("/")[0],
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        child: Text(widget.title!.split("/")[1]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'Live',
                        style: TextStyle(color: Colors.red),
                      )
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.02,
                      // ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: MediaQuery.of(context).size.width * 0.08),
                      //   child: Text(
                      //     "Oops! something went wrong.",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 13,
                      //       letterSpacing: 0.8,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: Text(
                      widget.title!
                          .split("/")[0]
                          .split("v")[1]
                          .trim()
                          .substring(0, 1),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = new Color.fromRGBO(203, 33, 39, opacity);

    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 2; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}

class SpriteDemo extends StatefulWidget {
  @override
  SpriteDemoState createState() => new SpriteDemoState();
}

class SpriteDemoState extends State<SpriteDemo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller!.stop();
    _controller!.reset();
    _controller!.repeat(
      period: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: new AppBar(title: const Text('Pulse')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            painter: new SpritePainter(_controller!),
            child: new SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.height * 0.006,
            ),
          ),
          Text('LIVE', style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
