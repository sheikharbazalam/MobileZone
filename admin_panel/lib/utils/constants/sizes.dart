import 'package:t_utils/t_utils.dart';

/// Add or update any sizes of your choice.
/// There are three ways to use sizes in your code.
///
/// 1. TSizes().sm
/// 2. TAdminSizes.base.sm
/// 3. TAdminSizes.myCustomSize
class TAdminSizes {
  static final myCustomSize = 16.0;

  /// Method to update already defined colors.
  static TSizes base = TSizes();

  /// Method to update already defined colors.
  static void override() {
    // Update the base colors with new values
    base = base.init();
  }
}
