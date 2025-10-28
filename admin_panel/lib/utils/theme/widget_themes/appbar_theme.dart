
import 'package:flutter/material.dart';
import 'package:t_utils/t_utils.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    actionsIconTheme: IconThemeData(color: TColors().iconPrimary, size: TSizes().iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: TColors().black, fontFamily: 'Urbanist'),
  );
  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    actionsIconTheme: IconThemeData(color: TColors().white, size: TSizes().iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: TColors().white, fontFamily: 'Urbanist'),
  );
}
