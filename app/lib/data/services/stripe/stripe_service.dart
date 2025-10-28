import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

/// Service for processing Stripe payments via Firebase Cloud Functions.
///
/// This class encapsulates the full payment lifecycle:
/// 1. Request a PaymentIntent from your Cloud Function backend.
/// 2. Initialize and display Stripe’s PaymentSheet UI.
///
/// All secret-key logic and card handling remain server-side. Your Flutter
/// client only orchestrates calls and displays UI.
class TStripePaymentService extends GetxController {
  /// Singleton instance accessible via `TStripePaymentService.instance`.
  static TStripePaymentService get instance => Get.isRegistered() ? Get.find() : Get.put(TStripePaymentService());

  /// Reactive loading flag for UI binding.
  final RxBool isLoading = false.obs;

  /// Firebase Functions instance for calling HTTPS endpoints.
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Initiates the full payment flow for a given order.
  Future<Map<String, dynamic>> processPayment({required double amount, required String currency, required String orderId}) async {
    try {
      // STEP 1: Obtain client secret from Cloud Function
      final String clientSecret = await _getPaymentIntent(amount: amount, currency: currency, orderId: orderId);

      // STEP 2: Display Stripe’s native PaymentSheet UI
      final response = await _handleCardPayment(clientSecret);
      return response;
    } on StripeException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Calls the `createStripePaymentIntent` Cloud Function.
  Future<String> _getPaymentIntent({required double amount, required String currency, required String orderId}) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('createStripePaymentIntent');
      final result = await callable.call(<String, dynamic>{'amount': amount, 'currency': currency});
      return result.data['clientSecret'] as String;
    } catch (e) {
      rethrow;
    }
  }

  /// Initializes and presents Stripe’s PaymentSheet.
  Future<Map<String, dynamic>> _handleCardPayment(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(paymentIntentClientSecret: clientSecret, merchantDisplayName: 'Coding with T'),
    );
    await Stripe.instance.presentPaymentSheet();

    // Capture payment confirmation data
    final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);

    return {
      'paymentIntentId': paymentIntent.id,
      'paymentMethodId': paymentIntent.paymentMethodId,
      'amountCaptured': (paymentIntent.amount) / 100, // Convert cents to dollars
      'currency': paymentIntent.currency,
      'paymentMethod': paymentIntent.captureMethod.name,
      'paymentStatus': paymentIntent.status.name,
    };
  }
}
