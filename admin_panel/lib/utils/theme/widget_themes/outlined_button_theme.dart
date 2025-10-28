import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

/* -- Light & Dark Outlined Button Themes -- */
class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors().darkBackground,
      side: BorderSide(color: TColors().borderPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes().buttonRadius)),
      padding: EdgeInsets.symmetric(vertical: TSizes().buttonHeight, horizontal: TSizes().buttonHeight),
      textStyle: TextStyle(fontSize: 16, color: TColors().black, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors().lightBackground,
      side: BorderSide(color: TColors().borderPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes().buttonRadius)),
      padding: EdgeInsets.symmetric(vertical: TSizes().buttonHeight, horizontal: TSizes().buttonHeight),
      textStyle: TextStyle(fontSize: 16, color: TColors().textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}
