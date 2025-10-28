import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TIconButtonTheme {
  TIconButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightIconButtonTheme = IconButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      iconColor: TColors().primary,
      foregroundColor: TColors().primary,
      backgroundColor: TColors().lightBackground,
      disabledForegroundColor: TColors().darkGrey,
      disabledBackgroundColor: TColors().buttonDisabled,
      side: BorderSide(color: TColors().lightBackground),
    ),
  );

  /* -- Dark Theme -- */
  static final darkIconButtonTheme = IconButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      iconColor: TColors().primary,
      foregroundColor: TColors().primary,
      backgroundColor: TColors().lightBackground,
      disabledForegroundColor: TColors().darkGrey,
      disabledBackgroundColor: TColors().buttonDisabled,
      side: BorderSide(color: TColors().lightBackground),
    ),
  );
}
