import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_provider.dart'; // Import to access AdProvider's global IDs

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;

  static bool isAdLoaded() {
    return _interstitialAd != null;
  }

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdProvider.interstitialAdUnitId, // Use global ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('Interstitial ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          log('Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd(Function onComplete) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          log('Interstitial ad dismissed.');
          ad.dispose();
          _interstitialAd = null;
          onComplete();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          log('Failed to show interstitial ad: $error');
          ad.dispose();
          _interstitialAd = null;
          onComplete();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      log('No interstitial ad loaded.');
      onComplete();
    }
  }

  static void disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
