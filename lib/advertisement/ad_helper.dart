import 'dart:io';
class AdHelper{
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-9796891464075357/7781613792';
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-9796891464075357/8920323697';
      //ca-app-pub-3940256099942544/1033173712
       return 'ca-app-pub-3940256099942544/1033173712';
    }
  }
}