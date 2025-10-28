import 'package:flutter/material.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';

class EmptyChatView extends StatelessWidget {
  const EmptyChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TImage(imageType: ImageType.asset, image: TImages.supportIllustration, width: 400, height: 400),
    );
  }
}
