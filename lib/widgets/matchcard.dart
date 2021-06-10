// import 'dart:html';
import 'dart:math';

import 'package:cricket_live_score/screens/DetailScreen.dart';
import 'package:flutter/material.dart';

import '../constraints.dart';

class MatchCard extends StatelessWidget {
  Widget team(String circleTitle, String title, String score, bool isBatting,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.sta,
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
                            circleTitle,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01),
                    child: Column(
                      children: [
                        Text(
                          '350/7',
                          style: runTextStyle,
                        ),
                        Text(
                          '20.0 Over',
                          style: subtitleTextStyle,
                        )
                      ],
                    ),
                  )
                ])
              : Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.01),
                      child: Column(
                        children: [
                          Text(
                            '350/7',
                            style: runTextStyle,
                          ),
                          Text(
                            '20.0 Over',
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
                              circleTitle,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
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
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
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
              'T20 Blast,North Group',
              style: TextStyle(color: Colors.deepPurple),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              '07:00 PM 09-Jun',
              style: TextStyle(
                  color: Colors.black, fontSize: 12, letterSpacing: 0.8),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.025,
                //   width:MediaQuery.of(context).size.width * 0.20,
                //   margin: EdgeInsets.all(
                //     MediaQuery.of(context).size.height * 0.01
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.orangeAccent,
                //     borderRadius: BorderRadius.circular(12)
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Container(
                //         // decoration: BoxDecoration(
                //         //   color: Colors.red
                //         // ),
                //         color: Colors.orangeAccent,
                //         height: MediaQuery.of(context).size.height * 0.5,
                //         width: MediaQuery.of(context).size.width * 0.05,
                //         margin: EdgeInsets.only(
                //           top:  MediaQuery.of(context).size.height * 0.009,
                //           left:  MediaQuery.of(context).size.height * 0.006,
                //           bottom:  MediaQuery.of(context).size.height * 0.006
                //         ),
                //         child: SpriteDemo(),
                //       ),
                //       Text('Live',style: TextStyle(color: Colors.white),)
                //     ],
                //   ),
                // ),

                team('AU', 'Australia', '655', true, context),
                Column(
                  children: [
                    Container(
                        // height: MediaQuery.of(context).size.height * 0.03,
                        // width: MediaQuery.of(context).size.width * 0.05,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.015),
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[startingColor, endingColor]),
                            borderRadius: BorderRadius.circular(20)),
                        child: 
                            CircleAvatar(
                              child: Text(
                                'VS',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              radius: 15,
                              backgroundColor: Colors.transparent,
                            ),

                            
                          
                        ),
                        
                  ],
                ),
                team('EN', 'England', '655', false, context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.10,
                              margin: EdgeInsets.all(2),
                              alignment: Alignment.center,
                              color: Colors.pink,
                              child: Text('40',style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.10,
                              alignment: Alignment.center,
                              color: Colors.pink,
                              child: Text('40',style: TextStyle(
                                color: Colors.white
                              ),),
                            )
                          ],
                        ),
                        SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
                        Text('Australia needs 30 runs in 116 balls',style: TextStyle(
                          color: endingColor,
                          fontSize: 13,
                          letterSpacing: 0.8
                        ),)
          ],
        ),
      
    );
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
  AnimationController ? _controller;

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
           Text('LIVE',style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
