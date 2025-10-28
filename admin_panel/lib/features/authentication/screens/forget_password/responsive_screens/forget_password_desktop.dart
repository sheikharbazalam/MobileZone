import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/templates/login_template.dart';
import '../widgets/forget_password_form.dart';

class ForgetPasswordScreenDesktop extends StatelessWidget {
  const ForgetPasswordScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(child: ForgetPasswordForm());
  }
}
