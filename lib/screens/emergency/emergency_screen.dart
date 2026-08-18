import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/blood_request_repository.dart';
import '../../data/repositories/mock_blood_request_repository.dart';
import '../../models/blood_request.dart';
import '../../widgets/emergency/emergency_banner.dart';
import '../../widgets/requests/request_card.dart';


class EmergencyScreen extends StatefulWidget {
  final BloodRequestRepository repository;

  EmergencyScreen({super.key, BloodRequestRepository? repository})
      : repository = repository ?? MockBloodRequestRepository();

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<BloodRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final requests = await widget.repository.getUrgentRequests();
    if (!mounted) return;
    setState(() {
      _requests = requests;
      _isLoading = false;
    });
  }

  void _dismiss(String id) {
    setState(() => _requests.removeWhere((r) => r.id == id));
  }

  /// Turns "6 min ago" into "6 min" — good enough for the mock data's
  /// "N min/hr ago" format without adding a real time-parsing utility.
  String _fastestResponseLabel() {
    if (_requests.isEmpty) return '—';
    return _requests.first.postedAgo.replaceAll(' ago', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Emergency',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed))
          : ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text(
            'Critical requests within 10 km',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          EmergencyBanner(
            criticalCount: _requests.length,
            fastestResponseLabel: _fastestResponseLabel(),
            onCallHotline: () {},
          ),
          const SizedBox(height: 22),
          const Text(
            'Critical now',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (_requests.isEmpty)
            const Text(
              'No critical requests right now.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ..._requests.map(
                  (request) => RequestCard(
                request: request,
                onAccept: () {},
                onDismiss: () => _dismiss(request.id),
              ),
            ),
        ],
      ),
    );
  }
}