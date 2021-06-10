import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class PricingCard extends StatelessWidget {
  // const PricingCard({ Key key }) : super(key: key);

  String ? imagePath;
  String ? duration;
  String  ? price;
  bool ? isMonthly;

  PricingCard({this.imagePath,this.duration,this.price,this.isMonthly});

  Widget listOfFeature(String title) {
    return ListTile(
      leading: MyBullet(),
      title: Transform(
        transform: Matrix4.translationValues(-16, 0.0, 0.0),
        child: Text(title, style: TextStyle(fontSize: 14, color: Colors.black)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height ,
      // margin: EdgeInsets.only(
      //   top: MediaQuery.of(context).size.height * 0.05,
      //   left: MediaQuery.of(context).size.height * 0.05,
      //   right: MediaQuery.of(context).size.height * 0.05,
      //   bottom: MediaQuery.of(context).size.height * 0.25,
      // ),
      // width: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          isMonthly! ? Container(
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
          ) : SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          // Image.asset('assets/Images/1.png'),

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
                          imagePath!,
                        ))),
              ),
              // Size
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duration!,
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
                            //superscript is usually smaller in size
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontFamily: 'SourceSansPro-Regular'),
                          ),
                        ),
                      ),
                      TextSpan(
                          text: price,
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
                    // textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15,color: Colors.black)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.blue)),
                    )),
                onPressed: () {},
                child: Text(
                  'Choose Plan',
                  style: TextStyle(color: Colors.black),
                )),
          ),

          // Text('This subscription will be \n valid for current device',textAlign: TextAlign.center,style: TextStyle(
          //   fontSize: 12
          // ),)
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
