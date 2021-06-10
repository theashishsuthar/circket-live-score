import 'dart:convert';

import 'package:cricket_live_score/Screens/Detail_Screen.dart';
import 'package:cricket_live_score/Screens/Live_Score.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
