import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'data/services/razorpay/razorpay_service.dart';
import 'features/personalization/controllers/language_controller.dart';
import 'firebase_options.dart';
import 'utils/constants/api_constants.dart';

/// Entry point of the Flutter App with robust initialization
Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Keep splash screen visible until initialization completes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    debugPrint('🔹 Initializing local storage...');
    await GetStorage.init();

    // Optional system UI setup
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // Initialize Firebase safely
    debugPrint('🔹 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');

    // Setup Stripe (non-blocking)
    debugPrint('🔹 Setting up Stripe...');
    Stripe.publishableKey = TAPIs.stripePublishableKey;
    await Stripe.instance.applySettings();
    debugPrint('✅ Stripe initialized');

    // Register dependencies lazily (loads only when used)
    debugPrint('🔹 Setting up GetX controllers...');
    Get.lazyPut(() => LanguageController(), fenix: true);
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.lazyPut(() => RazorpayService(), fenix: true);
    debugPrint('✅ Controllers registered');
  } catch (e, stackTrace) {
    debugPrint('❌ Error during app initialization: $e');
    debugPrintStack(stackTrace: stackTrace);
  } finally {
    // Always remove splash, even if initialization fails
    FlutterNativeSplash.remove();
  }

  runApp(const App());
}
