import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static List<ProductDetails> _products = [];

  static Future<void> init() async {
    _subscription = _iap.purchaseStream.listen((purchases) {
      _handlePurchase(purchases);
    });
  }

  static Future<void> fetchProducts() async {
    final response = await _iap.queryProductDetails({'tabletools_pro'});

    if (response.notFoundIDs.isNotEmpty) {
      print("⚠️ Subscription not found: ${response.notFoundIDs}");
    }

    _products = response.productDetails;
  }

  static Future<void> purchaseSubscription() async {
    if (_products.isEmpty) {
      print("⚠️ No subscriptions available.");
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: _products.first);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static void _handlePurchase(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        print("✅ Purchase successful! Sending to backend...");
        _verifyPurchase(purchase.transactionDate ?? "", purchase.verificationData.serverVerificationData);
      }
    }
  }

  static Future<void> _verifyPurchase(String transactionId, String receipt) async {
    print("🔍 Sending purchase verification to backend...");
    // TODO: Send to Rails API (Step 4)
  }
}
