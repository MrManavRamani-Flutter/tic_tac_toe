import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/tic_tac_toe/ttt_home_screen.dart';
import 'screens/auth_screens/no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _handleInitialNavigation();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF06B1C8),
      end: const Color(0xFFFF4081),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleInitialNavigation() {
    log('Starting navigation handling...');
    // Navigate directly without checking or showing ads
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    _controller.stop();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final connectivity = context.read<ConnectivityProvider>();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => connectivity.isConnected
              ? const TttHomeScreen()
              : const NoInternetScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: theme.currentTheme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tic Tac Toe",
                          style: theme.currentTheme.textTheme.displayLarge
                              ?.copyWith(
                            fontSize: 40,
                            color: _colorAnimation.value,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Fun Time!",
                          style:
                              theme.currentTheme.textTheme.bodyLarge?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
