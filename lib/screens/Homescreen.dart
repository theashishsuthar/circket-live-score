import 'package:cricket_live_score/constraints.dart';
import 'package:cricket_live_score/screens/DetailScreen.dart';
import 'package:cricket_live_score/screens/subscription.dart';
import 'package:cricket_live_score/widgets/matchcard.dart';
import 'package:cricket_live_score/widgets/pricingCard.dart';
import 'package:cricket_live_score/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                    Icon(Icons.lock_clock),
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
            //       Container(

            //         margin: EdgeInsets.all(
            //           MediaQuery.of(context).size.height * 0.03
            //         ),
            //         child: StackCard.builder(

            // stackOffset:Offset(40, 25),
            // stackType:  StackType.middle,
            //   displayIndicator: true,
            //   displayIndicatorBuilder:
            //         IdicatorBuilder(displayIndicatorActiveColor: Colors.blue),
            //   itemCount: 5,
            //   dimension:StackDimension(
            //     height: MediaQuery.of(context).size.height * 0.80,
            //     width: double.infinity
            //   ),
            //   onSwap: (index) {
            //     print("Page change to $index");
            //   },
            //   itemBuilder: (context, index) {
            //     // Movie movie = _movieData[index];
            //     return MatchCard();
            //   }),
            //       ),

            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[startingColor, endingColor])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext conext) {
                            return DetailScreen();
                          }));
                        },
                        child: MatchCard()),
                    MatchCard(),
                    MatchCard(),
                    MatchCard(),
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[startingColor, endingColor])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    UpComingMatchCard(),
                    UpComingMatchCard(),
                    UpComingMatchCard(),
                    UpComingMatchCard(),
                    UpComingMatchCard()
                  ],
                ),
              ),
            ),

            Subscription()
            //   child: Column(
            //     children: [
            //       Card(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5.0),
            //         ),
            //         margin: EdgeInsets.all(
            //             MediaQuery.of(context).size.height * 0.01),
            //         child: ListTile(
            //           leading: Icon(Icons.shopping_bag),
            //           title: Text('Your Subscription'),
            //           trailing: Icon(
            //             EvaIcons.arrowIosForward,
            //             color: Colors.black,
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
