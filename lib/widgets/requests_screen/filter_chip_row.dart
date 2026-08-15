import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/request_filter.dart';

class FilterChipRow extends StatelessWidget {
  final RequestFilter selected;
  final ValueChanged<RequestFilter> onSelected;

  const FilterChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RequestFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = RequestFilter.values[index];
          final bool isActive = filter == selected;
          return ChoiceChip(
            label: Text(filter.label),
            selected: isActive,
            onSelected: (_) => onSelected(filter),
            showCheckmark: false,
            selectedColor: AppColors.primaryRed,
            backgroundColor: AppColors.white,
            side: BorderSide(
              color: isActive ? AppColors.primaryRed : AppColors.border,
            ),
            labelStyle: TextStyle(
              color: isActive ? AppColors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}