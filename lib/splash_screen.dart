import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this dependency for cool spinners
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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<int> _countdownAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _handleInitialNavigation();
  }

  void _setupAnimations() {
    // Main controller for countdown
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Pulse controller for subtle effects
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _countdownAnimation = IntTween(begin: 3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showTitle = true);
      }
    });

    _controller.forward();
  }

  void _handleInitialNavigation() {
    log('Starting navigation handling...');
    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) return;
      final connectivity = context.read<ConnectivityProvider>();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => connectivity.isConnected
              ? const TttHomeScreen()
              : const NoInternetScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.black, // Cinematic black background
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  theme.currentTheme.colorScheme.primary.withOpacity(0.1),
                  Colors.black,
                ],
                radius: 1.5,
                center: Alignment.center,
              ),
            ),
          ),
          // Animated countdown circle
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _showTitle ? 0.0 : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Film reel effect circle
                    Container(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.currentTheme.colorScheme.secondary
                              .withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          '${_countdownAnimation.value}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.25,
                            fontWeight: FontWeight.bold,
                            color: theme.currentTheme.colorScheme.secondary,
                            shadows: [
                              Shadow(
                                color: theme.currentTheme.colorScheme.secondary
                                    .withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Title animation
          AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Tic Tac Toe",
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: theme.currentTheme.colorScheme.primary,
                      shadows: [
                        Shadow(
                          color: theme.currentTheme.colorScheme.primary
                              .withOpacity(0.7),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Ready to Play?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: theme.currentTheme.colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading indicator
          Positioned(
            bottom: screenHeight * 0.1,
            child: SpinKitFadingCircle(
              color: theme.currentTheme.colorScheme.secondary,
              size: screenWidth * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
