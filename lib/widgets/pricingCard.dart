import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_live_score/screens/subscriptionHistory.dart';
import 'package:device_info/device_info.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PricingCard extends StatefulWidget {
  final String? imagePath;
  final String? duration;
  final String? price;
  final bool? isMonthly;

  PricingCard({this.imagePath, this.duration, this.price, this.isMonthly});

  @override
  _PricingCardState createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }';

    var res = await http.post(Uri.parse("https://api.razorpay.com/v1/orders"),
        headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    print('ORDER ID response => ${res.body}');

    return json.decode(res.body)['id'].toString();
  }

  void openCheckout() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Apikey")
          .doc("+919557920831")
          .get();
      // String key = 'rzp_test_XF0TQwHrsnczbj';
      // String key = 'rzp_live_5slR1LkCEaloJ3';
      // String secret = 'esjnaE5MH9pjHhbsOC8oomyq';
      String key = doc['key'];
      String secret = doc['secretKey'];

      var amount = 100 * 100;
      //json.decode(res.body)['id'].toString();
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

      var headers = {
        'content-type': 'application/json',
        'Authorization': authn,
      };

      var data =
          '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }';

      var res = await http.post(Uri.parse("https://api.razorpay.com/v1/orders"),
          headers: headers, body: data);
      if (res.statusCode == 200) {
        var options = {
          // 'key': 'rzp_test_XF0TQwHrsnczbj',
          // 'key': 'rzp_live_5slR1LkCEaloJ3',
          'key': key,
          'amount': 100 * 100,
          'order_id': json.decode(res.body)['id'].toString(),
          'name': 'Subscription',
          'description': 'Subscription',
          // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
          // 'external': {
          //   'wallets': ['paytm','phonepay']
          // }
        };
        try {
          _razorpay.open(options);
        } catch (e) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Oops! something went wrong!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Okay',
                      ),
                    )
                  ],
                );
              });
        }
      } else
        throw Exception('http.post error: statusCode= ${res.statusCode}');
      // print('ORDER ID response => ${res.body}');

      // var options = {
      //   // 'key': 'rzp_test_XF0TQwHrsnczbj',
      //   'key': 'rzp_live_5slR1LkCEaloJ3',
      //   'amount': 100 * 100,
      //   'order_id': generateOrderId(key, secret, 100),
      //   'name': 'Subscription',
      //   'description': 'Subscription',
      //   // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      //   // 'external': {
      //   //   'wallets': ['paytm','phonepay']
      //   // }
      // };

      // try {
      //   _razorpay.open(options);
      // } catch (e) {
      //   return showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: Text(
      //             'Oops! something went wrong!',
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               child: Text(
      //                 'Okay',
      //               ),
      //             )
      //           ],
      //         );
      //       });
      // }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Oops! something went wrong!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Okay',
                  ),
                )
              ],
            );
          });
    }
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // print(response.orderId);
    // print(response.paymentId);
    // print(response.signature);
    //pay_HMq1GE0a9PtN2B
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    await FirebaseFirestore.instance
        .collection("PaymentHistory")
        .doc(androidInfo.androidId)
        .collection("historyList")
        .add({
          "payment": "Success",
          "paymentId": response.paymentId,
          "time": Timestamp.now(),
        })
        .then((value) async => await FirebaseFirestore.instance
                .collection("Users")
                .doc(androidInfo.androidId)
                .update({
              "premium": true,
              "premiumStart": Timestamp.now(),
              'PremiumEnd': Timestamp.fromDate(DateTime(
                  DateTime.parse(Timestamp.now().toDate().toString()).year,
                  DateTime.parse(Timestamp.now().toDate().toString()).month + 1,
                  DateTime.parse(Timestamp.now().toDate().toString()).day)),
            }))
        .then((value) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Payment was successful!',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Okay',
                    ),
                  )
                ],
              );
            }));

    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  _handlePaymentError(PaymentFailureResponse response) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    await FirebaseFirestore.instance
        .collection("PaymentHistory")
        .doc(androidInfo.androidId)
        .collection("historyList")
        .add({
      "payment": "Failed",
      "paymentId": "xxxxx",
      "time": Timestamp.now(),
    });
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Payment was failed!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Okay',
                ),
              )
            ],
          );
        });
    // print('failure ---- ${response.code.toString()}----${response.message}');
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Payment through wallet!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Okay',
                ),
              )
            ],
          );
        });
    // print("wallet: ---- ${response.walletName}");
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  Widget listOfFeature(String title) {
    return ListTile(
      leading: MyBullet(),
      title: Transform(
        transform: Matrix4.translationValues(-16, 0.0, 0.0),
        child: Text(title, style: TextStyle(fontSize: 14, color: Colors.black)),
      ),
    );
  }

  Future payment() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(androidInfo.androidId)
        .get();
    if (doc['premium'] == false) {
      openCheckout();
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'You had already subscription.',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Okay',
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.1,
        left: MediaQuery.of(context).size.height * 0.05,
        right: MediaQuery.of(context).size.height * 0.05,
        bottom: MediaQuery.of(context).size.height * 0.11,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          widget.isMonthly!
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.50),
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(61, 55, 243, 15),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'POPULAR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.09,
                    right: MediaQuery.of(context).size.width * 0.04),
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          widget.imagePath!,
                        ))),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.duration!,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(-2, -2),
                          child: Text(
                            '₹',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontFamily: 'SourceSansPro-Regular'),
                          ),
                        ),
                      ),
                      TextSpan(
                          text: widget.price,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'SourceSansPro-Regular',
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' / Month',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'SourceSansPro-Regular',
                              fontWeight: FontWeight.bold)),
                    ]),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Divider(
            indent: 34.0,
            endIndent: 34.0,
            thickness: 1.0,
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              children: <Widget>[
                listOfFeature('Ads free solution'),
                listOfFeature('Live prediction'),
                listOfFeature('Real time score update')
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.40,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.blue)),
                    )),
                onPressed: payment,
                child: Text(
                  'Let\'s Get Started',
                  style: TextStyle(color: Colors.black),
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Text(
              'Note :- This subscription will be allowed on only one device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 20.0,
      width: 20.0,
      child: Icon(EvaIcons.checkmark),
    );
  }
}
