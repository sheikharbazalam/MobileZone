import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/templates/login_template.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          ///  Header
          TLoginHeader(),

          /// Form
          TLoginForm(),
        ],
      ),
    );
  }
}
