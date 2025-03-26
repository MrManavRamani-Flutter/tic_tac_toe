import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/connectivity_provider.dart';
import 'splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, ConnectivityProvider>(
      builder: (context, theme, connectivity, _) {
        return MaterialApp(
          title: 'Tic Tac Toe',
          debugShowCheckedModeBanner: false,
          theme: theme.currentTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
