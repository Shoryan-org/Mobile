import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/blood_type.dart';

class BloodTypeChipGrid extends StatelessWidget {
  final BloodType selected;
  final ValueChanged<BloodType> onSelected;

  const BloodTypeChipGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: BloodType.values.map((type) {
        final bool isActive = type == selected;
        return InkWell(
          onTap: () => onSelected(type),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 62,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryRed : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? AppColors.primaryRed : AppColors.border,
              ),
            ),
            child: Text(
              type.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isActive ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}