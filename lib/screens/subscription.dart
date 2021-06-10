import 'package:cricket_live_score/constraints.dart';
import 'package:cricket_live_score/widgets/pricingCard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'assets/Images/0.png',
  'assets/Images/1.png',
  'assets/Images/2.png',
];

final List<String> duration = [
  'Forever',
  'Monthly',
  'Annually',
];

class Subscription extends StatefulWidget {
  // const Subscription({ Key? key }) : super(key: key);

  // final List<PricingCard> pricingCard = PricingCard();

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  // final List<Widget> imageSliders = imgList
  //     .map(
  //       (item) => PricingCard(
  //         imagePath: imgList[imgList.indexOf(item)],
  //         duration:duration[duration.indexOf(item)],
  //       ),
  //     )
  //     .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,

      // height: ,

      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[startingColor, endingColor])),
      // margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      child:  PricingCard(
              imagePath: 'assets/Images/1.png',
              isMonthly: true,
              duration: 'Monthly',
              price: '100',
            ),
      
      // CarouselSlider(
      //     options: CarouselOptions(
      //       autoPlay: false,
      //       aspectRatio: 0.85,
      //       enlargeCenterPage: true,
      //     ),
      //     items: [
      //       PricingCard(
      //         imagePath: 'assets/Images/1.png',
      //         isMonthly: true,
      //         duration: 'Monthly',
      //         price: '100',
      //       ),
      //       // PricingCard(
      //       //   imagePath: 'assets/Images/2.png',
      //       //   isMonthly: false,
      //       //   duration: 'Anually',
      //       //   price: '500',
      //       // ),
      //       // PricingCard(
      //       //   imagePath: 'assets/Images/0.png',
      //       //   isMonthly: false,
      //       //   duration: 'Forever',
      //       //   price: '0',
      //       // ),
      //     ]),
    );
  }
}
