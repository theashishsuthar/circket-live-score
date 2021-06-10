import 'dart:convert';

import 'package:cricket_live_score/Screens/Detail_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveScore extends StatefulWidget {
  const LiveScore({Key? key}) : super(key: key);

  @override
  _LiveScoreState createState() => _LiveScoreState();
}

class _LiveScoreState extends State<LiveScore> {
  Future fetchMatches() async {
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258

    try {
      final response =
          await http.get(Uri.http('13.235.241.13', '/getgames/cricket'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];

        // return DataGet.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
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
    return StreamBuilder(
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
            return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DetailScreen(
                          uid: _list[index].uid,
                        );
                      }));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(_list[index].title!.split("/")[0]),
                        subtitle: Text(_list[index].title!.split("/")[1]),
                      ),
                    ),
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
