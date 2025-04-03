import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'app_open_ad_manager.dart';
import 'interstitial_ad_manager.dart';

class AdProvider with ChangeNotifier {
  // Global Ad Unit IDs using Live IDs
  static const String bannerAdUnitId = 'ca-app-pub-6919467491710773/7966688145';

  static const String interstitialAdUnitId =
      'ca-app-pub-6919467491710773/8641475566';

  // Global Ad Unit IDs using Test IDs

  // static const String appOpenAdUnitId =
  //     'ca-app-pub-3940256099942544/9257395921';

  // Banner Ad instances
  BannerAd? _homeBottomBannerAd;

  BannerAd? _gameSettingsBottomBannerAd;
  BannerAd? _scoreBottomBannerAd;
  BannerAd? _resultsBottomBannerAd;
  BannerAd? _twoPlayerSetupBottomBannerAd;
  BannerAd? _twoPlayerResultsBottomBannerAd;
  BannerAd? _twoPlayerScoreBottomBannerAd;

  // Load flags
  bool _isHomeBottomLoaded = false;
  bool _isGameSettingsBottomLoaded = false;
  bool _isScoreBottomLoaded = false;
  bool _isResultsBottomLoaded = false;
  bool _isTwoPlayerSetupBottomLoaded = false;
  bool _isTwoPlayerResultsBottomLoaded = false;
  bool _isTwoPlayerScoreBottomLoaded = false;

  final bool _hasAppOpenAd = false;
  final bool _hasInterstitialAd = false;

  // Getters
  bool get hasAppOpenAd => _hasAppOpenAd;

  bool get hasInterstitialAd => _hasInterstitialAd;

  AdProvider() {
    initializeAds();
  }

  // Initialize ads when the provider is created
  Future<void> initializeAds() async {
    // await AppOpenAdManager.loadAdWithAwait(); // New method to await ad loading
    InterstitialAdManager.loadInterstitialAd();
    _loadHomeBottomBannerAd(); // Load initial ads
    notifyListeners();
  }

  // Load a banner ad with specific settings
  void _loadBannerAd({
    required String adUnitId,
    required Function(BannerAd?) onAssign,
    required Function() onLoaded,
    required String logName,
  }) {
    BannerAd banner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('$logName Banner ad loaded.');
          onLoaded();
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          log('$logName Banner ad failed to load: $error');
          ad.dispose(); // Dispose ad on failure
          onAssign(null); // Clear the reference
          notifyListeners();
        },
      ),
    )..load();
    onAssign(banner);
  }

  // Individual methods to load specific banner ads
  void _loadHomeBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _homeBottomBannerAd = ad,
        onLoaded: () => _isHomeBottomLoaded = true,
        logName: 'Home Bottom');
  }

  void _loadGameSettingsBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _gameSettingsBottomBannerAd = ad,
        onLoaded: () => _isGameSettingsBottomLoaded = true,
        logName: 'GameSettings Bottom');
  }

  void _loadScoreBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _scoreBottomBannerAd = ad,
        onLoaded: () => _isScoreBottomLoaded = true,
        logName: 'Score Bottom');
  }

  void _loadResultsBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _resultsBottomBannerAd = ad,
        onLoaded: () => _isResultsBottomLoaded = true,
        logName: 'Results Bottom');
  }

  void _loadTwoPlayerSetupBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _twoPlayerSetupBottomBannerAd = ad,
        onLoaded: () => _isTwoPlayerSetupBottomLoaded = true,
        logName: 'TwoPlayerSetup Bottom');
  }

  void _loadTwoPlayerResultsBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _twoPlayerResultsBottomBannerAd = ad,
        onLoaded: () => _isTwoPlayerResultsBottomLoaded = true,
        logName: 'TwoPlayerResults Bottom');
  }

  void _loadTwoPlayerScoreBottomBannerAd() {
    _loadBannerAd(
        adUnitId: bannerAdUnitId,
        onAssign: (ad) => _twoPlayerScoreBottomBannerAd = ad,
        onLoaded: () => _isTwoPlayerScoreBottomLoaded = true,
        logName: 'TwoPlayerScore Bottom');
  }

  // Recreate a specific banner ad
  void recreateHomeBottomBannerAd() {
    _homeBottomBannerAd?.dispose();
    _isHomeBottomLoaded = false;
    _loadHomeBottomBannerAd();
    log('Home Bottom Banner Ad recreated.');
  }

  // Widget builder for banner ads
  Widget _buildBannerWidget(
      BannerAd? ad, bool isLoaded, VoidCallback recreateAd) {
    if (ad == null || !isLoaded) {
      recreateAd(); // Recreate ad if null or not loaded
      return const SizedBox(
        height: 50,
        child: Center(child: Text('Loading Ad...')),
      );
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }

  Widget getHomeBottomBannerAdWidget() {
    return _buildBannerWidget(
      _homeBottomBannerAd,
      _isHomeBottomLoaded,
      recreateHomeBottomBannerAd,
    );
  }

  Widget getGameSettingsBottomBannerAdWidget() {
    return _buildBannerWidget(
      _gameSettingsBottomBannerAd,
      _isGameSettingsBottomLoaded,
      () => _loadGameSettingsBottomBannerAd(),
    );
  }

  Widget getScoreBottomBannerAdWidget() {
    return _buildBannerWidget(
      _scoreBottomBannerAd,
      _isScoreBottomLoaded,
      () => _loadScoreBottomBannerAd(),
    );
  }

  Widget getResultsBottomBannerAdWidget() {
    return _buildBannerWidget(
      _resultsBottomBannerAd,
      _isResultsBottomLoaded,
      () => _loadResultsBottomBannerAd(),
    );
  }

  Widget getTwoPlayerSetupBottomBannerAdWidget() {
    return _buildBannerWidget(
      _twoPlayerSetupBottomBannerAd,
      _isTwoPlayerSetupBottomLoaded,
      () => _loadTwoPlayerSetupBottomBannerAd(),
    );
  }

  Widget getTwoPlayerResultsBottomBannerAdWidget() {
    return _buildBannerWidget(
      _twoPlayerResultsBottomBannerAd,
      _isTwoPlayerResultsBottomLoaded,
      () => _loadTwoPlayerResultsBottomBannerAd(),
    );
  }

  Widget getTwoPlayerScoreBottomBannerAdWidget() {
    return _buildBannerWidget(
      _twoPlayerScoreBottomBannerAd,
      _isTwoPlayerScoreBottomLoaded,
      () => _loadTwoPlayerScoreBottomBannerAd(),
    );
  }

  // Show App Open Ad
  // void showAppOpenAd(VoidCallback onAdDismissed) {
  //   if (AppOpenAdManager.isAdLoaded) {
  //     log('Showing app open ad...');
  //     AppOpenAdManager.showAd(onAdDismissed);
  //   } else {
  //     log('No App Open Ad available to show, preloading for next time.');
  //     AppOpenAdManager.loadAd();
  //     onAdDismissed();
  //   }
  // }

  // Show Interstitial Ad
  void showInterstitialAd(VoidCallback onAdDismissed) {
    InterstitialAdManager.showInterstitialAd(onAdDismissed);
  }

  // Dispose of all ads
  @override
  void dispose() {
    _homeBottomBannerAd?.dispose();
    _gameSettingsBottomBannerAd?.dispose();
    _scoreBottomBannerAd?.dispose();
    _resultsBottomBannerAd?.dispose();
    _twoPlayerSetupBottomBannerAd?.dispose();
    _twoPlayerResultsBottomBannerAd?.dispose();
    _twoPlayerScoreBottomBannerAd?.dispose();
    InterstitialAdManager.disposeInterstitialAd();
    // AppOpenAdManager.dispose();
    super.dispose();
    log('AdProvider disposed.');
  }

  // Reset ads to prepare for new instances
  void resetAds() {
    // Dispose current ad instances to avoid conflicts
    _homeBottomBannerAd?.dispose();
    _gameSettingsBottomBannerAd?.dispose();
    _scoreBottomBannerAd?.dispose();
    _resultsBottomBannerAd?.dispose();
    _twoPlayerSetupBottomBannerAd?.dispose();
    _twoPlayerResultsBottomBannerAd?.dispose();
    _twoPlayerScoreBottomBannerAd?.dispose();

    // Clear references
    _homeBottomBannerAd = null;
    _gameSettingsBottomBannerAd = null;
    _scoreBottomBannerAd = null;
    _resultsBottomBannerAd = null;
    _twoPlayerSetupBottomBannerAd = null;
    _twoPlayerResultsBottomBannerAd = null;
    _twoPlayerScoreBottomBannerAd = null;

    // Reload fresh ads for relevant screens
    _loadHomeBottomBannerAd();
    _loadGameSettingsBottomBannerAd();
    _loadScoreBottomBannerAd();
    _loadResultsBottomBannerAd();
    _loadTwoPlayerSetupBottomBannerAd();
    _loadTwoPlayerResultsBottomBannerAd();
    _loadTwoPlayerScoreBottomBannerAd();
    notifyListeners();
  }
}
