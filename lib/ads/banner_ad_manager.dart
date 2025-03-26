import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  static BannerAd? _splashBannerAd;
  static BannerAd? _homeBottomBannerAd;
  static BannerAd? _gameSettingsBottomBannerAd;
  static BannerAd? _scoreBottomBannerAd;
  static BannerAd? _resultsBottomBannerAd;
  static BannerAd? _twoPlayerSetupBottomBannerAd;
  static BannerAd? _twoPlayerResultsBottomBannerAd;
  static BannerAd? _twoPlayerScoreBottomBannerAd;

  static bool _isSplashLoaded = false;
  static bool _isHomeBottomLoaded = false;
  static bool _isGameSettingsBottomLoaded = false;
  static bool _isScoreBottomLoaded = false;
  static bool _isResultsBottomLoaded = false;
  static bool _isTwoPlayerSetupBottomLoaded = false;
  static bool _isTwoPlayerResultsBottomLoaded = false;
  static bool _isTwoPlayerScoreBottomLoaded = false;

  static void loadSplashBannerAd() {
    _loadBannerAd('_splashBannerAd', 'Splash', () => _isSplashLoaded = true);
  }


  static void loadHomeBottomBannerAd() {
    _loadBannerAd('_homeBottomBannerAd', 'Home Bottom', () => _isHomeBottomLoaded = true);
  }


  static void loadGameSettingsBottomBannerAd() {
    _loadBannerAd('_gameSettingsBottomBannerAd', 'GameSettings Bottom', () => _isGameSettingsBottomLoaded = true);
  }


  static void loadScoreBottomBannerAdWidget() {
    _loadBannerAd('_scoreBottomBannerAd', 'Score Bottom', () => _isScoreBottomLoaded = true);
  }


  static void loadResultsBottomBannerAdWidget() {
    _loadBannerAd('_resultsBottomBannerAd', 'Results Bottom', () => _isResultsBottomLoaded = true);
  }


  static void loadTwoPlayerSetupBottomBannerAdWidget() {
    _loadBannerAd('_twoPlayerSetupBottomBannerAd', 'TwoPlayerSetup Bottom', () => _isTwoPlayerSetupBottomLoaded = true);
  }


  static void loadTwoPlayerResultsBottomBannerAdWidget() {
    _loadBannerAd('_twoPlayerResultsBottomBannerAd', 'TwoPlayerResults Bottom', () => _isTwoPlayerResultsBottomLoaded = true);
  }


  static void loadTwoPlayerScoreBottomBannerAdWidget() {
    _loadBannerAd('_twoPlayerScoreBottomBannerAd', 'TwoPlayerScore Bottom', () => _isTwoPlayerScoreBottomLoaded = true);
  }

  static void _loadBannerAd(String fieldName, String logName, VoidCallback onLoaded) {
    BannerAd banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('$logName Banner ad loaded.');
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          log('$logName Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();

    // Dynamically assign to the correct field
    switch (fieldName) {
      case '_splashBannerAd': _splashBannerAd = banner; break;
      case '_homeBottomBannerAd': _homeBottomBannerAd = banner; break;
      case '_gameSettingsBottomBannerAd': _gameSettingsBottomBannerAd = banner; break;
      case '_scoreBottomBannerAd': _scoreBottomBannerAd = banner; break;
      case '_resultsBottomBannerAd': _resultsBottomBannerAd = banner; break;
      case '_twoPlayerSetupBottomBannerAd': _twoPlayerSetupBottomBannerAd = banner; break;
      case '_twoPlayerResultsBottomBannerAd': _twoPlayerResultsBottomBannerAd = banner; break;
      case '_twoPlayerScoreBottomBannerAd': _twoPlayerScoreBottomBannerAd = banner; break;
    }
  }

  static Widget getSplashBannerAdWidget() => _buildBannerWidget(_splashBannerAd, _isSplashLoaded);
  static Widget getHomeBottomBannerAdWidget() => _buildBannerWidget(_homeBottomBannerAd, _isHomeBottomLoaded);
  static Widget getGameSettingsBottomBannerAdWidget() => _buildBannerWidget(_gameSettingsBottomBannerAd, _isGameSettingsBottomLoaded);
  static Widget getScoreBottomBannerAdWidget() => _buildBannerWidget(_scoreBottomBannerAd, _isScoreBottomLoaded);
  static Widget getResultsBottomBannerAdWidget() => _buildBannerWidget(_resultsBottomBannerAd, _isResultsBottomLoaded);
  static Widget getTwoPlayerSetupBottomBannerAdWidget() => _buildBannerWidget(_twoPlayerSetupBottomBannerAd, _isTwoPlayerSetupBottomLoaded);
  static Widget getTwoPlayerResultsBottomBannerAdWidget() => _buildBannerWidget(_twoPlayerResultsBottomBannerAd, _isTwoPlayerResultsBottomLoaded);
  static Widget getTwoPlayerScoreBottomBannerAdWidget() => _buildBannerWidget(_twoPlayerScoreBottomBannerAd, _isTwoPlayerScoreBottomLoaded);

  static Widget _buildBannerWidget(BannerAd? ad, bool isLoaded) {
    return ad != null && isLoaded
        ? SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    )
        : const SizedBox();
  }

  static void disposeBannerAds() {
    _splashBannerAd?.dispose();
    _homeBottomBannerAd?.dispose();
    _gameSettingsBottomBannerAd?.dispose();
    _scoreBottomBannerAd?.dispose();
    _resultsBottomBannerAd?.dispose();
    _twoPlayerSetupBottomBannerAd?.dispose();
    _twoPlayerResultsBottomBannerAd?.dispose();
    _twoPlayerScoreBottomBannerAd?.dispose();

    _isSplashLoaded = false;
    _isHomeBottomLoaded = false;
    _isGameSettingsBottomLoaded = false;
    _isScoreBottomLoaded = false;
    _isResultsBottomLoaded = false;
    _isTwoPlayerSetupBottomLoaded = false;
    _isTwoPlayerResultsBottomLoaded = false;
    _isTwoPlayerScoreBottomLoaded = false;
  }
}