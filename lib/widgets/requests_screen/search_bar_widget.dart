import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RequestsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onFilterTap;

  const RequestsSearchBar({
    super.key,
    required this.controller,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Search hospital or area',
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.tune, color: AppColors.primaryRed, size: 20),
          ),
        ),
      ],
    );
  }
}