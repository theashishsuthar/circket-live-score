import 'package:cricket_live_score/Screens/Live_Score.dart';
import 'package:cricket_live_score/Screens/Upcoming.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Cricket',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: "Live",
              ),
              Tab(
                text: "Upcoming",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LiveScore(),
            UpcomingMatches(),
          ],
        ),
      ),
    );
  }
}
