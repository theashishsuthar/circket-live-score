import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constraints.dart';

import 'dart:io' show Platform;
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:one_dice_game/utils/GlobalVaribales.dart';
// import 'package:one_dice_game/utils/appVersion.dart';
// import 'package:one_dice_game/utils/getUpdateUrl.dart';

import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

import 'package:file_utils/file_utils.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

bool downloading = false;
var progress = "0";
var path = "No Data";
var platformVersion = "Unknown";
Permission permission1 = Permission.manageExternalStorage;
var _onPressed;
Random random = Random();
Directory? externalDir;

var advertisementAppName;
var advertisementAppUrl;
var advertisementAppDescription;
var advertisementAppImage;
var advertisementAppColorCode;

showAdvertisement(BuildContext context) {
  var snapShot =
      FirebaseFirestore.instance.collection("admin").doc("advertisement").get();

  snapShot.then((v) {
    getAdvertisementDetails();
    if (v["advertisement"] == "yes") {
      getAdvertisementDetails();

      showUpdateDialogueBox(context);
    }
  });
}

showUpdateDialogueBox(
  BuildContext context,
) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double sizedheight = MediaQuery.of(context).size.height / 10;
  double sizedwidth = MediaQuery.of(context).size.width / 5;

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('admin')
                .doc("advertisement")
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                DocumentSnapshot value = snapshot.data;

                advertisementAppName = value["appname"];
                advertisementAppUrl = value["appurl"];
                advertisementAppDescription = value["appdescription"];
                advertisementAppImage = value["appimage"];
                advertisementAppColorCode = value["colorcode"];

                return StatefulBuilder(builder: (context, setState) {
                  return Center(
                      child: GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg:
                                    "Click On Update Button To Update The App!");
//
//_launchURL();
                            print("yesy");
//                    OpenFile.open("/storage/emulated/0/KD PLAY APP/KD Play App - Play N Earn.apk").catchError((e){
//                      print(e);
//                    });
                          },
                          child: Container(
                              // decoration: Box,
                              child: AlertDialog(
                            actions: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                      startingColor,
                                      endingColor
                                    ])),
                                // color: Colors.white,
                                width: width * .9,
                                height: height * .60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )),
                                    Center(
                                      child: Text(
                                        advertisementAppName.toString(),
                                        style: TextStyle(
                                            fontSize: sizedwidth / 3,
                                            color: HexColor(
                                                advertisementAppColorCode
                                                    .toString()),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: sizedheight / 8,
                                    ),
                                    Center(
                                      // decoration: ,
                                      //   child: Card(
                                      // // shape: ,
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10)),
                                      // elevation: 4,
                                      // child: Container(
                                      //   decoration:BoxDecoration(
                                      //     borderRadius:BorderRadius.circular(10),
                                      //   ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/Images/loader.gif',
                                            height: sizedheight * 2.5,
                                            width: sizedwidth * 2.5,
                                        
                                            // imageScale:0.7,
                                            fit: BoxFit.fill,
                                            image: advertisementAppImage.toString(),
                                          ),
                                        ),
                                      // ),
                                    ),
                                    // ),
                                    SizedBox(
                                      height: sizedheight / 8,
                                    ),
                                    Center(
                                        child: Container(
                                      width: width * .7,
                                      alignment: Alignment.center,
                                      child: Text(
                                        advertisementAppDescription.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sizedwidth / 4,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                    SizedBox(
                                      height: sizedheight / 6,
                                    ),
                                    progress == "0"
                                        ? ButtonTheme(
                                            buttonColor: HexColor(
                                                advertisementAppColorCode
                                                    .toString()),
                                            height: sizedheight * .8,
                                            minWidth: sizedwidth * 2,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              onPressed: () async {
                                                Dio dio = Dio();
                                                var checkPermission1 =
                                                    await Permission
                                                        .manageExternalStorage
                                                        .status;
                                                var checkPermission2 =
                                                    await Permission
                                                        .storage.status;

                                                if (checkPermission1.isDenied ||
                                                    checkPermission2.isDenied) {
                                                  await Permission
                                                      .manageExternalStorage
                                                      .request();
                                                  await Permission.storage
                                                      .request();

                                                  checkPermission1 =
                                                      await Permission
                                                          .manageExternalStorage
                                                          .status;
                                                  checkPermission2 =
                                                      await Permission
                                                          .storage.status;
//    debugPrint(checkPermission1.isGranted.toString()+ "sddsdfdfssdfsdfsfesf");
                                                }

                                                if (checkPermission1
                                                        .isGranted ||
                                                    checkPermission2
                                                        .isGranted) {
//    debugPrint(checkPermission1.isGranted.toString()+ " sddsdfdfssdfsdfsfesf");
                                                  String dirloc = "";

                                                  final pathi = Directory(
                                                      "/storage/emulated/0/$advertisementAppName");
                                                  if ((!await pathi.exists())) {
                                                    FileUtils.mkdir([
                                                      "/storage/emulated/0/$advertisementAppName/"
                                                    ]);

                                                    dirloc =
                                                        "/storage/emulated/0/$advertisementAppName/$advertisementAppName";
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Downloading Started ...");
//      pathi.create().then((value) {
//        dirloc = "/storage/emulated/0/KD PLAY APP/KD PLAY APP";
//      });

                                                    print("not exist");
                                                  } else {
                                                    print("exist");
                                                    dirloc =
                                                        "/storage/emulated/0/$advertisementAppName/$advertisementAppName";
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Downloading Started ...");
                                                  }
//    final Directory extDir = await getExternalStorageDirectory();
//      dirloc = (await  getExternalStorageDirectory()).path;
//    dirloc= "/storage/emulated/0/KD PLAY APP";
                                                  debugPrint(dirloc);

                                                  try {
//      FileUtils.mkdir([dirloc]);
                                                    await dio.download(
                                                        advertisementAppUrl,
                                                        dirloc + "" + ".apk",
                                                        onReceiveProgress:
                                                            (receivedBytes,
                                                                totalBytes) {
//              downloading = true;
                                                      setState(() {
                                                        progress = ((receivedBytes /
                                                                    totalBytes) *
                                                                100)
                                                            .toStringAsFixed(0);
                                                        debugPrint(progress);
                                                      });
                                                    }).whenComplete(() {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Downloading Completed. Please Install The App Now!");
                                                      OpenFile.open(
                                                              "/storage/emulated/0/$advertisementAppName/$advertisementAppName.apk")
                                                          .catchError((e) {
                                                        print(e);
                                                      });
                                                    });

//      Fluttertoast.showToast(msg: "Downloading Completed !");
//      downloading =false;
//      progress = "Download Completed.";
//      path = dirloc + "" + ".apk";

                                                  } catch (e) {
                                                    downloading = false;
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Downloading Failed Please Try Again ...");

                                                    print(e);
                                                  }
                                                } else {
                                                  openAppSettings();
//                                                    progress =
//                                                    "Permission Denied!";
                                                  downloading = false;
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Permission Denied Please Try Again ...");
//      _onPressed = () {
//
//        downloadFile();
//      };

                                                }
                                              },
                                              child: Text(
                                                "Download Now",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: sizedwidth / 4,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: sizedheight / 6,
                                              ),
                                              Center(
                                                  child: LinearPercentIndicator(
                                                width: width * .71,
                                                lineHeight: sizedheight / 7,
                                                percent:
                                                    double.parse(progress) /
                                                        100,
                                                backgroundColor: Colors.black12,
                                                progressColor: HexColor(
                                                    advertisementAppColorCode
                                                        .toString()),
                                              )),
                                              SizedBox(
                                                height: sizedheight / 8,
                                              ),
                                              Center(
                                                  child: Text(
                                                "Downloading : " +
                                                    progress +
                                                    "%",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              )),
                                            ],
                                          ),
                                    SizedBox(
                                      height: sizedheight / 6,
                                    ),
                                    progress == "100"
                                        ? ButtonTheme(
                                            buttonColor: HexColor(
                                                advertisementAppColorCode),
                                            height: sizedheight * .8,
                                            minWidth: sizedwidth * 2,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              onPressed: () {
                                                OpenFile.open(
                                                        "/storage/emulated/0/$advertisementAppName/$advertisementAppName.apk")
                                                    .catchError((e) {
                                                  print(e);
                                                });
                                              },
                                              child: Text(
                                                "OPEN NOW",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: sizedwidth / 4,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            ],
                          ))));
                });
              }
            });
      });
}

_launchURL() async {
  var url = "/storage/emulated/0/One Dice Game/";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> getAdvertisementDetails() async {
  var data =
      FirebaseFirestore.instance.collection("admin").doc("advertisement").get();

  data.then((value) {
    advertisementAppName = value["appname"];
    advertisementAppUrl = value["appurl"];
    advertisementAppDescription = value["appdescription"];
    advertisementAppImage = value["appimage"];
  });
}
