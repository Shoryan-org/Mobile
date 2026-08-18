import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/blood_bank_repository.dart';
import '../../data/repositories/mock_blood_bank_repository.dart';
import '../../models/blood_bank.dart';
import '../../widgets/home/blood_bank_tile.dart';

/// reusing the "Nearby blood banks" data  BloodBankTile

class SavedCentersScreen extends StatefulWidget {
  final BloodBankRepository repository;

  SavedCentersScreen({super.key, BloodBankRepository? repository})
      : repository = repository ?? MockBloodBankRepository();

  @override
  State<SavedCentersScreen> createState() => _SavedCentersScreenState();
}

class _SavedCentersScreenState extends State<SavedCentersScreen> {
  List<BloodBank> _banks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final banks = await widget.repository.getNearbyBanks();
    if (!mounted) return;
    setState(() {
      _banks = banks;
      _isLoading = false;
    });
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
          'Saved centers',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed))
          : ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: _banks.map((bank) => BloodBankTile(bank: bank)).toList(),
      ),
    );
  }
}