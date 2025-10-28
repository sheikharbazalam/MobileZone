import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';
import 'responsive_screens/desktop.dart';
import 'responsive_screens/mobile.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: MediaDesktopScreen(), mobile: MediaMobileScreen());
  }
}
