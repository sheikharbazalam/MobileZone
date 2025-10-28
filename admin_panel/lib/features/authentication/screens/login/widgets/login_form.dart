import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/utils/constants/sizes.dart';
import 'package:t_utils/utils/validators/validation.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../controllers/login_controller.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TSizes().spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email.tr,
              ),
              onFieldSubmitted: (value) => controller.emailAndPasswordSignIn(),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) =>
                    TValidator.validateEmptyText(TTexts.password.tr, value),
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
                onFieldSubmitted: (value) =>
                    controller.emailAndPasswordSignIn(),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) =>
                            controller.rememberMe.value = value!,
                      ),
                    ),
                    Text(TTexts.rememberMe.tr),
                  ],
                ),

                /// Forget Password
                TextButton(
                  onPressed: () => Get.toNamed(TRoutes.forgetPassword),
                  child: Text(TTexts.forgetPassword.tr),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,

              /// Un Comment this line to register admin
              //child: ElevatedButton(
              //onPressed: () => controller.registerAdmin(),
              //child: const Text('Register Admin'),
              //),
              child: ElevatedButton(
                  onPressed: () => controller.emailAndPasswordSignIn(),
                  //onPressed: () {
                  // print("hello");
                  //controller.emailAndPasswordSignIn();
                  //},
                  child: Text(TTexts.signIn.tr)),
            ),
          ],
        ),
      ),
    );
  }
}
