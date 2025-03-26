import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ads/ad_provider.dart';
import 'my_app.dart';
import 'providers/theme_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/two_player_game_provider.dart';
import 'providers/score_provider.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ["27F289DA0EED2C3628B923F9D0A2DA6C"]),
  );

  // Initialize the database
  await DatabaseHelper().database;

  // Initialize Providers
  final adProvider = AdProvider();
  await adProvider
      .initializeAds(); // This is already async, but ensure ad is loaded
  await Future.delayed(Duration.zero); // Allow ad loading to start
  final themeProvider = await ThemeProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
        ChangeNotifierProvider(create: (_) => TwoPlayerGameProvider()),
        ChangeNotifierProvider.value(value: adProvider),
      ],
      child: const MyApp(),
    ),
  );
}
