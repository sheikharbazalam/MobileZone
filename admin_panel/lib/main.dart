import 'package:cwt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';
import 'utils/constants/colors.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  await GetStorage.init();

  // Remove # sign from url
  usePathUrlStrategy();

  // Initialize Colors and Sizes
  TAdminColors.override();
  TAdminSizes.override();

  // YOUR SUPABASE KEY ID HERE
  await Supabase.initialize(
    url: 'https://igwsqklioeufpbiljnqh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlnd3Nxa2xpb2V1ZnBiaWxqbnFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MDIwNjcsImV4cCI6MjA2MjI3ODA2N30.a-f7-UvlnlQn752CHAHwUciWOl38aC__AqrWsZ1ph7Q',
  );

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Main App Starts here...
  runApp(const App());
}
