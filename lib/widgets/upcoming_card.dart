import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cricket_live_score/Screens/HomeScreen.dart';
import 'package:cricket_live_score/constraints.dart';
import 'package:flutter/material.dart';

class UpComingMatchCard extends StatefulWidget {
  String? title;
  String? time;
  String? uid;
  UpComingMatchCard({
    this.time,
    this.title,
    this.uid,
  });

  @override
  _UpComingMatchCardState createState() => _UpComingMatchCardState();
}

class _UpComingMatchCardState extends State<UpComingMatchCard> {
  StreamController<DetailsModel>? streamController;
  @override
  void initState() {
    streamController = StreamController();
    Timer.periodic(Duration(microseconds: 300), (timer) {
      fetchAlbum(widget.uid!);
    });
    super.initState();
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
  @override
  void dispose() {
   streamController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Text(
              widget.time.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8),
            ),
          ),
          StreamBuilder(
            stream: streamController!.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DetailsModel model = snapshot.data;
                return Container(
                    height: model.home.con['lt'].toString() == ""
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height * 0.17,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: upcomingCardColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.02),
                      child: Column(
                        children: [
                          Text(
                            widget.title.toString(),
                            style: specialTitleTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black,
                                    child: Text(
                                      model.home.t1['n']
                                          .toString()
                                          .substring(0, 2),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  // Container(
                                  //   alignment: Alignment.center,
                                  //   width: MediaQuery.of(context).size.width*0.2,
                                  //   child: Text(
                                  //      model.home.t1['f'].toString(),
                                  //      overflow: TextOverflow.fade,
                                  //      textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.bold,
                                  //         letterSpacing: 0.8),
                                  //   ),
                                  // )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(
                                    widget.time.toString(),
                                    style: TextStyle(
                                      letterSpacing: 0.8,
                                      // fontFamily: 'SourceSansPro-Light',
                                      // fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(
                                    model.home.con['sr'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 16,
                                    child: Text(
                                      model.home.t2['n']
                                          .toString()
                                          .substring(0, 2),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  // Container(
                                  //   alignment: Alignment.center,
                                  //   width: MediaQuery.of(context).size.width*0.2,
                                  //   child: Text(
                                  //      model.home.t2['f'].toString(),
                                  //      overflow: TextOverflow.fade,
                                  //      textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.bold,
                                  //         letterSpacing: 0.8),
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          ),
                          model.home.con['lt'].toString() == ""
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  child: Text(
                                    model.home.con['lt'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ));
              } else {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: upcomingCardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('Coming soon'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
