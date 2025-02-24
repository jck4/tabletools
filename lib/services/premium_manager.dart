import 'package:flutter/material.dart';

class PremiumManager extends ChangeNotifier {
  bool _isPremiumUser = false;

  bool get isPremiumUser => _isPremiumUser;

  void unlockPremium() {
    _isPremiumUser = true;
    notifyListeners();
  }
}
