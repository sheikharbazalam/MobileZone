import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/exports.dart';
import '../../../controllers/media_controller.dart';

class MediaFolderDropdown extends StatelessWidget {
  const MediaFolderDropdown({super.key, this.onChanged, this.width});

  final double? width;
  final void Function(MediaCategory?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () => SizedBox(
        width: width ?? (TDeviceUtils.isMobileScreen(context) ? double.infinity : 140),
        child: DropdownButtonFormField<MediaCategory>(
          isExpanded: false,
          onChanged: onChanged,
          value: controller.selectedPath.value,
          items: MediaCategory.values.map(
            (category) {
              return DropdownMenuItem<MediaCategory>(
                value: category,
                child: Text(category.name.capitalize.toString()),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
