import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/text_strings.dart';

class TDashboardCard extends StatelessWidget {
  const TDashboardCard({
    super.key,
    required this.context,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color,
    this.onTap,
    required this.headingIcon,
    required this.headingIconColor,
    required this.headingIconBgColor,
    this.comparedTo = "Dec 2023",
  });

  final BuildContext context;
  final String title, subTitle, comparedTo;
  final IconData icon, headingIcon;
  final Color? color, headingIconColor, headingIconBgColor;
  final String stats;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TContainer(
      onTap: onTap,
      padding: EdgeInsets.all(TSizes().md),
      child: Column(
        children: [
          /// Heading
          TTextWithIcon(
            text: title,
            icon: headingIcon,
            color: headingIconColor,
            backgroundColor: headingIconBgColor,
            textStyle: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: TSizes().spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subTitle, style: Theme.of(context).textTheme.headlineMedium),

              /// Right Side Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Indicator
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: TSizes().iconSm),
                        Text(
                          '$stats%',
                          style: Theme.of(context).textTheme.titleLarge!.apply(color: color, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 135,
                    child: Text(
                      '${TTexts.comparedTo.tr} $comparedTo',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
