import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Simple stand-in for tabs whose feature branches haven't been built
/// yet (Map, AI, Profile), so the bottom nav is fully clickable
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hourglass_empty,
                  color: AppColors.primaryRed, size: 40),
              const SizedBox(height: 12),
              Text(title, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.cardSubtitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}