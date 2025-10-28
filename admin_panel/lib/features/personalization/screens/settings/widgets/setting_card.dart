import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/common/widgets/chips/animated_icon_switch.dart';
import 'package:t_utils/common/widgets/containers/t_container.dart';
import 'package:t_utils/common/widgets/texts/text_with_icon.dart';
import 'package:t_utils/utils/constants/sizes.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsCard({super.key, required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: TTextWithIcon(text: title, icon: icon)),
              TIconToggleSwitch(current: true, options: [true, false], icons: [Iconsax.add, Iconsax.aquarius3]),
            ],
          ),
          SizedBox(height: TSizes().spaceBtwSections),
          child,
        ],
      ),
    );
  }
}
