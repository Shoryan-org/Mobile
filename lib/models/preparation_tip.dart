import 'package:flutter/material.dart';

/// One "before you donate" tip shown on the Eligibility screen.
class PreparationTip {
  final IconData icon;
  final String title;
  final String description;

  const PreparationTip({
    required this.icon,
    required this.title,
    required this.description,
  });
}