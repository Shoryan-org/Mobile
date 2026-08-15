import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/blood_request.dart';
import 'blood_type_avatar.dart';
import 'urgency_badge.dart';

class RequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onDismiss;

  const RequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BloodTypeAvatar(bloodType: request.bloodType),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.hospitalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${request.area} · Requested by ${request.requesterName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              UrgencyBadge(urgency: request.urgency),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaItem(
                icon: Icons.location_on_outlined,
                label: '${request.distanceKm} km',
              ),
              const SizedBox(width: 14),
              _MetaItem(icon: Icons.access_time, label: request.postedAgo),
              const SizedBox(width: 14),
              _MetaItem(
                icon: Icons.water_drop_outlined,
                label: '${request.unitsCollected}/${request.unitsNeeded} units',
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: request.progress,
              minHeight: 5,
              backgroundColor: AppColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryRed),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept request'),
                ),
              ),
              const SizedBox(width: 10),
              _DismissButton(onTap: onDismiss),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.metaText),
      ],
    );
  }
}

class _DismissButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DismissButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}