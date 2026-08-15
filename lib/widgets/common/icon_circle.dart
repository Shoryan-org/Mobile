import 'package:flutter/material.dart';

class IconCircle extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;

  const IconCircle({
    super.key,
    required this.icon,
    required this.background,
    required this.iconColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}