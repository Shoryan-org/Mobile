import 'package:flutter/material.dart';
import '../../models/preparation_tip.dart';
import 'eligibility_repository.dart';

class MockEligibilityRepository implements EligibilityRepository {
  @override
  Future<List<PreparationTip>> getPreparationTips() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      PreparationTip(
        icon: Icons.restaurant,
        title: 'Eat iron-rich food',
        description: 'Have a full meal 3 hours before donating.',
      ),
      PreparationTip(
        icon: Icons.water_drop_outlined,
        title: 'Hydrate well',
        description: 'Drink 500 ml of water before your appointment.',
      ),
      PreparationTip(
        icon: Icons.nightlight_round,
        title: 'Sleep 7+ hours',
        description: 'Avoid donating after a sleepless night.',
      ),
      // Not in the mockup screenshot (it's cut off after 3 tips), but
      // listed in the proposal's chatbot knowledge base under "Before
      // donation" — added so this list and the AI chatbot's answers
      // stay consistent.
      PreparationTip(
        icon: Icons.badge_outlined,
        title: 'Bring your national ID',
        description: "You won't be able to donate without it.",
      ),
    ];
  }
}