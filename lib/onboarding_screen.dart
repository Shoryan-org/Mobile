import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';
import 'package:shoryan/features/auth/presentation/screens/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Find a compatible\ndonor quickly',
      'subtitle':
          'Our advanced network instantly\nmatches you with verified donors in\nyour immediate area when every\nsecond counts.',
      'buttonText': 'Next',
      'illustration': const _Illustration1(),
    },
    {
      'title': 'Help people nearby',
      'subtitle':
          'Your donation can save up to 3 lives. Find local\nhospitals and blood drives in need of your\nblood type.',
      'buttonText': 'Continue',
      'illustration': const _Illustration2(),
    },
    {
      'title': 'Smart Matching',
      'subtitle':
          "Our AI connects you with urgent\nneeds based on your profile, and\nsends timely reminders when it's\nsafe to donate again.",
      'buttonText': 'Get Started',
      'illustration': const _Illustration3(),
    },
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.navLabel.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: page['illustration'] as Widget,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Text(
                                page['title']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.screenTitle.copyWith(
                                  fontSize: 28,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page['subtitle']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.screenSubtitle.copyWith(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicators and Bottom Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: _currentIndex == index ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primaryRed
                              : AppColors.routineBackground,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _pages[_currentIndex]['buttonText']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Image 2 - Find a compatible donor quickly
class _Illustration1 extends StatelessWidget {
  const _Illustration1();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/onboarding.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Image 3 - Help people nearby
class _Illustration2 extends StatelessWidget {
  const _Illustration2();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Center(
        child: Image.asset(
          'assets/images/on_boarding.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Image 1 - Smart Matching
class _Illustration3 extends StatelessWidget {
  const _Illustration3();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center circle with pulse
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryRed, width: 2),
            ),
            child: const Icon(
              Icons.monitor_heart_outlined,
              color: AppColors.primaryRed,
              size: 50,
            ),
          ),
          // Top circle with user
          Positioned(
            top: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightPink, width: 1.5),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.primaryRed,
                size: 24,
              ),
            ),
          ),
          // Bottom left circle with O-
          Positioned(
            bottom: 40,
            left: 50,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Center(
                child: Text(
                  'O-',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primaryRed,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          // Bottom right circle with bell
          Positioned(
            bottom: 40,
            right: 50,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
