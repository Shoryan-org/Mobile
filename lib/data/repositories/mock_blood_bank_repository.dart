import '../../models/blood_bank.dart';
import 'blood_bank_repository.dart';

class MockBloodBankRepository implements BloodBankRepository {
  @override
  Future<List<BloodBank>> getNearbyBanks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      BloodBank(
        name: 'Central Blood Bank — Nasr City',
        type: 'Blood bank',
        distanceKm: 1.1,
        isOpenNow: true,
      ),
      BloodBank(
        name: 'Al Nahda General Hospital',
        type: 'Hospital',
        distanceKm: 1.2,
        isOpenNow: true,
        closesAt: '11 PM',
      ),
      BloodBank(
        name: 'Dar El Shefa Donation Unit',
        type: 'Blood bank',
        distanceKm: 2.8,
        isOpenNow: true,
        closesAt: '9 PM',
      ),
    ];
  }
}