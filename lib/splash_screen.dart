import 'package:flutter/material.dart';
import 'package:shoryan/core/network/token_storage.dart';
import 'package:shoryan/onboarding_screen.dart';
import 'package:shoryan/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:shoryan/navigation/main_navigation_screen.dart';
import 'package:shoryan/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final TokenStorage tokenStorage;

  const SplashScreen({super.key, required this.tokenStorage});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Wait for the splash delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final hasToken = widget.tokenStorage.hasToken;
    final hasSeenOnboarding = widget.tokenStorage.hasSeenOnboarding;

    Widget nextScreen;

    if (hasToken) {
      // Returning authenticated user -> Home
      nextScreen = const MainNavigationScreen();
    } else if (hasSeenOnboarding) {
      // Returning unauthenticated user -> Auth
      nextScreen = const SignInScreen();
    } else {
      // First-time user -> Onboarding
      nextScreen = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/logo.png',
            width: 200, 
          ),
        ),
      ),
    );
  }
}
