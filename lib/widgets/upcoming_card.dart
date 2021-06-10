import 'package:cricket_live_score/constraints.dart';
import 'package:flutter/material.dart';

class UpComingMatchCard extends StatelessWidget {
  const UpComingMatchCard({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.03),
             child: Text('09 June 2021,Wednesday',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8
             ),),
           ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01),
            width: double.infinity,
            decoration: BoxDecoration(
              color: upcomingCardColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: Column(
                children: [
                  Text('Indian Premiere League',style: specialTitleTextStyle,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 16,
                                                  backgroundColor: Colors.black,

                            child: Text(
                              'AU',
                              style: TextStyle(fontSize: 12,color: Colors.white),
                            ),
                          ),
                          Text(
                            'Australia',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8),
                          )
                        ],
                      ),

                      Column(
                        children: [
                           SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text('09:30 PM,15th Match',style: TextStyle(
                            letterSpacing: 0.8,
                            // fontFamily: 'SourceSansPro-Light',
                            // fontWeight: FontWeight.w600
                          ),),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text('Abu Dhabi UAE',style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 16,
                            child: Text(
                              'EN',
                              style: TextStyle(fontSize: 12,color: Colors.white),
                            ),
                          ),
                          Text(
                            'England',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8),
                          ),

                        ],
                        
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
