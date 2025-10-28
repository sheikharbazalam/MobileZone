import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CouponsDesktopScreen(), mobile: CouponsMobileScreen());
  }
}
