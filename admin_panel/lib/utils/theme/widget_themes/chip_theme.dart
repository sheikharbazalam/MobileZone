import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    checkmarkColor: TColors().white,
    selectedColor: TColors().primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    backgroundColor: Colors.transparent,
    disabledColor: TColors().grey.withValues(alpha: 0.4),
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
    labelStyle: TextStyle(color: TColors().black, fontFamily: 'Urbanist'),
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    checkmarkColor: TColors().white,
    selectedColor: TColors().primary,
    disabledColor: TColors().darkerGrey,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
    labelStyle: TextStyle(color: TColors().white, fontFamily: 'Urbanist'),
  );
}
