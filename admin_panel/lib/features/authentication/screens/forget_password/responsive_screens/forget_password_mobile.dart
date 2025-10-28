import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';
import 'package:t_utils/utils/helpers/helper_functions.dart';

import '../widgets/forget_password_form.dart';

class ForgetPasswordScreenMobile extends StatelessWidget {
  const ForgetPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context) ? TColors().darkBackground : Colors.white,
      body: Container(
        padding: EdgeInsets.all(TSizes().defaultSpace),
        child: const ForgetPasswordForm(),
      ),
    );
  }
}
