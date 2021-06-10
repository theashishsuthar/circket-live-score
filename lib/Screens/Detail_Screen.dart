import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final String? uid;
  DetailScreen({this.uid});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late StreamController<DetailsModel> streamController = StreamController();
  @override
  void initState() {
    Timer.periodic(Duration(microseconds: 300), (timer) {
      fetchAlbum();
    });
    super.initState();
  }

  Future fetchAlbum() async {
    // print(widget.uid);
    //http://13.235.241.13/getgames/cricket
    //http://139.59.82.99:3000/api/match/getMatchScore?eventId=30589258

    try {
      final response = await http.get(
        Uri.parse(
            'http://139.59.82.99:3000/api/match/getMatchScore?eventId=${widget.uid}'),
      );
      // print(response.body);
      // print(response.statusCode.toString());

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        // print(jsonDecode(response.body)['result']);
        streamController
            .add(DetailsModel.fromJson(jsonDecode(response.body)['result']));
      } else {
        throw Exception('Failed to load the Data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // DetailsModel model = DetailsModel.fromJson(snapshot.data);
              DetailsModel model = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text("p1 : - ${model.p1!}"),
                    Text("p1 : - ${model.p2!}"),
                    Text("ao : - ${model.home.ao!}"),
                    Text("b1s : - ${model.home.b1s!}"),
                    Text("b2s : - ${model.home.b2s!}"),
                    Text("bw : - ${model.home.bw!}"),
                    Text("cd : - ${model.home.cd!}"),
                    Text("con : - ${model.home.con}"),
                    Text("cs : - ${model.home.cs}"),
                    Text("hms : - ${model.home.hms!}"),
                    Text("i : - ${model.home.i!}"),
                    Text("i1 : - ${model.home.i1}"),
                    Text("i1b : - ${model.home.i1b!}"),
                    Text("i2 : - ${model.home.i2}"),
                    Text("iov : - ${model.home.iov!}"),
                    Text("lw : - ${model.home.lw!}"),
                    Text("md : - ${model.home.md!}"),
                    Text("mit : - ${model.home.mit!}"),
                    Text("mk : - ${model.home.mk!}"),
                    Text("oh : - ${model.home.oh}"),
                    Text("os : - ${model.home.os!}"),
                    Text("home p1 : - ${model.home.p1!}"),
                    Text("home p2 : - ${model.home.p2!}"),
                    Text("pb : - ${model.home.pb!}"),
                    Text("pt : - ${model.home.pt!}"),
                    Text("rt : - ${model.home.rt!}"),
                    Text("sk : - ${model.home.sk!}"),
                    Text("sn : - ${model.home.sn}"),
                    Text("ssns : - ${model.home.ssns!}"),
                    Text("t1  - ${model.home.t1}"),
                    Text("t2 : - ${model.home.t2}"),
                    Text("tt : - ${model.home.tt!}"),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class DetailsModel {
  String? p1;
  String? p2;
  DetailsofHome home;
  DetailsModel({
    this.p1,
    this.p2,
    required this.home,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      home: DetailsofHome.fromJson(jsonDecode(json['home'])),
      p1: json['p1'].toString(),
      p2: json['p2'].toString(),
    );
  }
}

class DetailsofHome {
  String? ao;
  String? b1s;
  String? b2s;
  String? bw;
  String? cd;
  late Map<String, dynamic> con;
  late Map<String, dynamic> cs;
  String? hms;
  String? i;
  late Map<String, dynamic> i1;
  late Map<String, dynamic> i2;
  String? i1b;
  String? iov;
  String? lw;
  String? md;
  String? mit;
  String? mk;
  String? oh;
  String? os;
  String? p1;
  String? p2;
  String? pb;
  String? pt;
  String? rt;
  String? sk;
  String? sn;
  String? ssns;
  late Map<String, dynamic> t1;
  late Map<String, dynamic> t2;
  String? tt;

  DetailsofHome({
    this.ao,
    this.b1s,
    this.b2s,
    this.bw,
    this.cd,
    required this.con,
    required this.cs,
    this.hms,
    this.i,
    required this.i1,
    this.i1b,
    required this.i2,
    this.iov,
    this.lw,
    this.md,
    this.mit,
    this.mk,
    this.oh,
    this.os,
    this.p1,
    this.p2,
    this.pb,
    this.pt,
    this.rt,
    this.sk,
    this.sn,
    this.ssns,
    required this.t1,
    required this.t2,
    this.tt,
  });

  factory DetailsofHome.fromJson(Map<String, dynamic> json) {
    return DetailsofHome(
      con: json['con'],
      cs: json['cs'],
      i1: json['i1'],
      i2: json['i2'],
      t1: json['t1'],
      t2: json['t2'],
      ao: json['ao'],
      b1s: json['b1s'],
      b2s: json['b2s'],
      bw: json['bw'],
      cd: json['cd'],
      hms: json['hms'],
      i1b: json['i1b'],
      i: json['i'],
      iov: json['iov'],
      lw: json['lw'],
      md: json['md'],
      mit: json['mit'],
      mk: json['mk'],
      oh: json['oh'],
      os: json['os'],
      p1: json['p1'],
      p2: json['p2'],
      pb: json['pb'],
      pt: json['pt'],
      rt: json['rt'],
      sk: json['sk'],
      sn: json['sn'],
      ssns: json['ssns'],
      tt: json['tt'],
    );
  }
}
