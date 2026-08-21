import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

/// A generic rounded pill/tag: colored background, colored text, and an
/// optional leading icon or dot. Used for "Donor" / "Requester" /
/// "Verified" on Profile.
class TagPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final bool showDot;

  const TagPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.badgeText.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}