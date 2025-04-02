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
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();

  // Initialize the database
  await DatabaseHelper().database;

  // Initialize Providers
  final adProvider = AdProvider();
  await adProvider.initializeAds(); // Ensure ads load properly

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
