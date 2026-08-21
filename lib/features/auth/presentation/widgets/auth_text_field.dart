import 'package:flutter/material.dart';
import 'package:shoryan/core/theme/app_colors.dart';
import 'package:shoryan/core/theme/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.cardSubtitle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.cardSubtitle.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            prefixIcon: prefixIcon,
            prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 0),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 0),
            filled: false,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed),
            ),
          ),
        ),
      ],
    );
  }
}
