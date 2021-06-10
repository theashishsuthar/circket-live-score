import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../constraints.dart';

class SubscriptionHistory extends StatefulWidget {
  // const SubscriptionHistory({ Key? key }) : super(key: key);

  @override
  _SubscriptionHistoryState createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Your Subscription'),
        elevation: 0,
          centerTitle: true,
          title: Text(
            'Your Subscription',
            style: appBarTitleTextStyle,
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[startingColor, endingColor]))),
      ),

      body: Container(
          decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[startingColor, endingColor])),
        // margin: EdgeInsets.all(
        //   MediaQuery.of(context).size.height * 0.10,
          
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.01
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Current Susbcription Valid till'),
                  Text(' 3-June-2021',style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02
              ),
              child: Text('Payment History',textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 19),),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Icon(EvaIcons.creditCard,color: Colors.white,),
                        decoration: BoxDecoration(
                           color: Colors.green[300],
                           borderRadius: BorderRadius.circular(5)
                        ),
                      ),

                      title: Text('Payment Sucessful'),
                      subtitle: Text('19 June 2021'),
                      trailing: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: Text('Rs 100',style: TextStyle(
                          color: Colors.green[900]
                        )),
                        decoration: BoxDecoration(
                           color: Colors.green[200],
                           borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Icon(EvaIcons.creditCard,color: Colors.white,),
                        decoration: BoxDecoration(
                           color: Colors.green[300],
                           borderRadius: BorderRadius.circular(5)
                        ),
                      ),

                      title: Text('Payment Sucessful'),
                      subtitle: Text('19 June 2021'),
                      trailing: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: Text('Rs 100',style: TextStyle(
                          color: Colors.green[900]
                        )),
                        decoration: BoxDecoration(
                           color: Colors.green[200],
                           borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Icon(EvaIcons.creditCard,color: Colors.white,),
                        decoration: BoxDecoration(
                           color: Colors.green[300],
                           borderRadius: BorderRadius.circular(5)
                        ),
                      ),

                      title: Text('Payment Sucessful'),
                      subtitle: Text('19 June 2021'),
                      trailing: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: Text('Rs 100',style: TextStyle(
                          color: Colors.green[900]
                        )),
                        decoration: BoxDecoration(
                           color: Colors.green[200],
                           borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}