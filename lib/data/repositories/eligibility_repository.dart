import '../../models/preparation_tip.dart';

abstract class EligibilityRepository {
  Future<List<PreparationTip>> getPreparationTips();
}