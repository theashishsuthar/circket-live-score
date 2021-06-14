import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constraints.dart';

class SubscriptionHistory extends StatefulWidget {
  @override
  _SubscriptionHistoryState createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Future checkpremium() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();
    return doc;
  }

  Future<QuerySnapshot> paymenthistory() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection("PaymentHistory")
        .doc(androidInfo.androidId)
        .collection("historyList")
        .get();
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder<QuerySnapshot>(
        future: paymenthistory(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<HistoryCard> _list = [];
          if (snapshot.hasData) {
            snapshot.data!.docs.forEach((element) {
              HistoryCard historyCard = HistoryCard.fromDocument(element);
              _list.add(historyCard);
            });
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[startingColor, endingColor])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: Stream.fromFuture(checkpremium()),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          DocumentSnapshot doc = snapshot.data;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.01),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: doc['premium'] == true
                                ? Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          'your current susbcription valid till'),
                                      Text(
                                        '  ${DateFormat("dd MMM yyyy").format(DateTime.parse(doc['PremiumEnd'].toDate().toString()))}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                : Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          'You don\'t have any current subscription.purchse it!'),
                                    ],
                                  ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: Text(
                      'Payment History',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                  _list.isEmpty
                      ? Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Still, you have not subscription history.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                          child: ListView(
                            children: _list,
                          ),
                        )),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class HistoryCard extends StatefulWidget {
  final String? payment;
  final Timestamp? time;
  final String? paymentid;
  HistoryCard({
    this.payment,
    this.paymentid,
    this.time,
  });

  factory HistoryCard.fromDocument(DocumentSnapshot doc) {
    return HistoryCard(
      payment: doc['payment'],
      paymentid: doc['paymentId'],
      time: doc['time'],
    );
  }
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.14,
          child: Icon(
            EvaIcons.creditCard,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
              color: widget.payment == 'Success'
                  ? Colors.green[300]
                  : Colors.red[300],
              borderRadius: BorderRadius.circular(5)),
        ),
        title: widget.payment == 'Success'
            ? Text('Payment Sucessful')
            : Text('Payment Failed'),
        subtitle: Text(
            '${DateFormat("dd MMM yyyy").format(DateTime.parse(widget.time!.toDate().toString()))} \n${widget.paymentid}'),
        isThreeLine: true,
        trailing: widget.payment == 'Success'
            ? Container(
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.20,
                child:
                    Text('Rs 100', style: TextStyle(color: Colors.green[900])),
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(15)),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text('Rs 100', style: TextStyle(color: Colors.red[900])),
                decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(15)),
              ),
      ),
    );
  }
}
