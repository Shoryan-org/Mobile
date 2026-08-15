import '../../models/blood_bank.dart';

/// Abstract data source for nearby blood banks
abstract class BloodBankRepository {
  Future<List<BloodBank>> getNearbyBanks();
}