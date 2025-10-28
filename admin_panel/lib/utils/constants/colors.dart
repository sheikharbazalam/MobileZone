import 'package:flutter/material.dart';
import 'package:t_utils/utils/constants/colors.dart';

/// Add or update any colors of your choice.
/// There are three ways to use colors in your code.
///
/// 1. TColors().primary
/// 2. TAdminColors.base.primary
/// 3. TAdminColors.myCustomColor
class TAdminColors {
  /// Example of Custom Color
  /// Use it like TAdminColors.myColor
  static final myCustomColor = Color(0xFF000000);

  /// Helper - Call All colors using
  /// TAdminColors.base.primary
  static TColors base = TColors();

  /// Method to update already defined colors.
  static void override() {
    // Update the base colors with new values
    base = base.init();
  }
}

