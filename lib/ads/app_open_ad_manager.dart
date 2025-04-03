// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import 'ad_provider.dart';
//
// class AppOpenAdManager {
//   static AppOpenAd? _appOpenAd;
//   static bool _isShowingAd = false;
//   static bool _hasShownAd = false;
//   static bool _isAdLoaded = false;
//
//   static Future<void> loadAdWithAwait() async {
//     Completer<void> completer = Completer();
//     AppOpenAd.load(
//       adUnitId: AdProvider.appOpenAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           log('App Open Ad loaded successfully.');
//           _appOpenAd = ad;
//           _isAdLoaded = true;
//           completer.complete();
//         },
//         onAdFailedToLoad: (error) {
//           log('App Open Ad failed to load: $error');
//           _isAdLoaded = false;
//           _appOpenAd = null;
//           completer.complete(); // Complete even on failure
//         },
//       ),
//     );
//     return completer.future;
//   }
//
//   static void loadAd() {
//     AppOpenAd.load(
//       adUnitId: AdProvider.appOpenAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           log('App Open Ad loaded successfully.');
//           _appOpenAd = ad;
//           _isAdLoaded = true;
//         },
//         onAdFailedToLoad: (error) {
//           log('App Open Ad failed to load: $error');
//           _isAdLoaded = false;
//           _appOpenAd = null;
//         },
//       ),
//     );
//   }
//
//   static bool get isAdLoaded => _isAdLoaded;
//
//   static void showAd(VoidCallback onAdDismissed) {
//     if (_appOpenAd != null && !_isShowingAd && !_hasShownAd && _isAdLoaded) {
//       log('Showing App Open Ad...');
//       _isShowingAd = true;
//       _hasShownAd = true;
//
//       _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           log('App Open Ad dismissed.');
//           _isShowingAd = false;
//           _isAdLoaded = false;
//           ad.dispose();
//           _appOpenAd = null;
//           loadAd();
//           onAdDismissed();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           log('App Open Ad failed to show: $error');
//           _isShowingAd = false;
//           _isAdLoaded = false;
//           ad.dispose();
//           _appOpenAd = null;
//           loadAd();
//           onAdDismissed();
//         },
//       );
//       _appOpenAd!.show();
//     } else {
//       log(
//         'App Open Ad not shown: '
//         'available: ${_appOpenAd != null}, '
//         'isShowing: $_isShowingAd, '
//         'hasShown: $_hasShownAd, '
//         'isLoaded: $_isAdLoaded',
//       );
//       onAdDismissed();
//     }
//   }
//
//
//   static void dispose() {
//     _appOpenAd?.dispose();
//     _appOpenAd = null;
//     _isShowingAd = false;
//     _isAdLoaded = false;
//     _hasShownAd = false;
//   }
// }
