import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EmergencyBanner extends StatelessWidget {
  final int criticalCount;
  final String fastestResponseLabel;
  final VoidCallback? onCallHotline;

  const EmergencyBanner({
    super.key,
    required this.criticalCount,
    required this.fastestResponseLabel,
    this.onCallHotline,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: AppColors.primaryRed,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_outlined,
                        color: AppColors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$criticalCount critical request${criticalCount == 1 ? '' : 's'} live now',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Patients need blood within the next few hours.',
                          style: TextStyle(color: AppColors.softPink, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF6E0F0B),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.bolt, size: 15, color: AppColors.softPink),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Fastest response: $fastestResponseLabel',
                      style: const TextStyle(color: AppColors.softPink, fontSize: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onCallHotline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.call, size: 15),
                    label: const Text('Call hotline'),
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