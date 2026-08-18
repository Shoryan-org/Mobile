import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/create_request_repository.dart';
import '../../data/repositories/mock_create_request_repository.dart';
import '../../models/blood_type.dart';
import '../../models/new_request_payload.dart';
import '../../models/urgency_level.dart';
import '../../widgets/create_request/blood_type_chip_grid.dart';
import '../../widgets/create_request/info_banner.dart';
import '../../widgets/create_request/units_stepper.dart';
import '../../widgets/create_request/urgency_option_card.dart';


class CreateRequestScreen extends StatefulWidget {
  final CreateRequestRepository repository;

  CreateRequestScreen({super.key, CreateRequestRepository? repository})
      : repository = repository ?? MockCreateRequestRepository();

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  BloodType _bloodType = BloodType.oNegative;
  UrgencyLevel _urgency = UrgencyLevel.critical;
  int _units = 2;
  bool _isSubmitting = false;

  final _hospitalController = TextEditingController(text: 'Al Nahda General Hospital');
  final _locationController = TextEditingController(text: 'Nasr City, Cairo');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _hospitalController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await widget.repository.submitRequest(
        NewRequestPayload(
          bloodType: _bloodType,
          urgency: _urgency,
          hospital: _hospitalController.text,
          locationArea: _locationController.text,
          unitsRequired: _units,
          notes: _notesController.text,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
          'Create request',
          style: TextStyle(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text(
            'Reach compatible donors nearby',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Blood type needed'),
          const SizedBox(height: 10),
          BloodTypeChipGrid(
            selected: _bloodType,
            onSelected: (type) => setState(() => _bloodType = type),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Urgency level'),
          const SizedBox(height: 10),
          ...UrgencyLevel.values.map(
                (level) => UrgencyOptionCard(
              level: level,
              isSelected: _urgency == level,
              onTap: () => setState(() => _urgency = level),
            ),
          ),
          const SizedBox(height: 12),
          const _FieldLabel('Hospital'),
          const SizedBox(height: 10),
          TextField(
            controller: _hospitalController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.local_hospital_outlined),
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Location / area'),
          const SizedBox(height: 10),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Donors within 10 km will be notified first',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Units required'),
          const SizedBox(height: 10),
          UnitsStepper(value: _units, onChanged: (v) => setState(() => _units = v)),
          const SizedBox(height: 22),
          const _FieldLabel('Notes (optional)'),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Patient condition, ward number, contact hours...',
            ),
          ),
          const SizedBox(height: 18),
          if (_urgency == UrgencyLevel.critical)
            const InfoBanner(
              message: 'Emergency requests are pushed instantly to every '
                  'compatible donor within 10 km and pinned to the top of '
                  'their feed.',
            ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
                : const Text('Submit request'),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}