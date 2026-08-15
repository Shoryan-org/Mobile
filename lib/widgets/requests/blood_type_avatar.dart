import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/blood_type.dart';

/// Circular avatar showing a blood type label "O-".
class BloodTypeAvatar extends StatelessWidget {
  final BloodType bloodType;
  final double size;
  final bool filled;

  const BloodTypeAvatar({super.key, required this.bloodType, this.size = 44,this.filled = true});

  @override
  Widget build(BuildContext context) {
    final bool highlight = bloodType.isUniversalDonor;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryRed : AppColors.lightPink,
        shape: BoxShape.circle,
      ),
      child: Text(
        bloodType.label,
        style: TextStyle(
          fontSize: size * 0.32,
          fontWeight: FontWeight.w700,
          color: highlight ? AppColors.white : AppColors.primaryRed,
        ),
      ),
    );
  }
}