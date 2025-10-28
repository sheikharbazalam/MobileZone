import 'package:flutter/material.dart';


import 'package:t_utils/t_utils.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context) ? TColors().black : Colors.white,
      body: Container(
        padding: EdgeInsets.all(TSizes().defaultSpace),
        child: const SingleChildScrollView(
          child: Column(
            children: [

              ///  Header
              TLoginHeader(),

              /// Form
              TLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
