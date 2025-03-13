import 'package:ai_text_extracter_app/stripe/stripe_storage.dart';
import 'package:flutter/material.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> checkPremiumStatus() async {
    _isPremium = await StripeStorage().checkIfPremium();
    notifyListeners();
  }

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }
}
