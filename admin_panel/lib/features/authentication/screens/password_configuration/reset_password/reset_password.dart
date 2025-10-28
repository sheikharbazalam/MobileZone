import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'reset_password_desktop.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments;
    return TSiteTemplate(useLayout: false, desktop: ResetPasswordDesktopScreen(email: email));
  }
}
