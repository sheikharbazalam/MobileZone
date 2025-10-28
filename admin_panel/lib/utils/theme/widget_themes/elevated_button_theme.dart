import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      iconColor: Colors.white,
      foregroundColor: TColors().lightBackground,
      backgroundColor: TColors().primary,
      disabledForegroundColor: TColors().darkGrey,
      disabledBackgroundColor: TColors().buttonDisabled,
      side: BorderSide(color: TColors().primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes().buttonRadius)),
      padding: EdgeInsets.symmetric(vertical: TSizes().buttonHeight, horizontal: TSizes().buttonHeight),
      textStyle: TextStyle(fontSize: 16, color: TColors().textWhite, fontWeight: FontWeight.w500, fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      iconColor: Colors.white,
      foregroundColor: TColors().lightBackground,
      backgroundColor: TColors().primary,
      disabledForegroundColor: TColors().darkGrey,
      disabledBackgroundColor: TColors().darkerGrey,
      side: BorderSide(color: TColors().primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes().buttonRadius)),
      padding: EdgeInsets.symmetric(vertical: TSizes().buttonHeight, horizontal: TSizes().buttonHeight),
      textStyle: TextStyle(fontSize: 16, color: TColors().textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}
