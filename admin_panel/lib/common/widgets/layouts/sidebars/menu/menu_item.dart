import 'package:cwt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/colors.dart';
import 'package:t_utils/utils/constants/sizes.dart';
import 'package:url_launcher/link.dart';

import '../sidebar_controller.dart';

class TMenuItem extends StatelessWidget {
  const TMenuItem({super.key, required this.route, required this.itemName, required this.icon});

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.put(SidebarController());
    return Link(
      uri: route != 'logout' ? Uri.parse(route) : null,
      builder: (_, __) => InkWell(
        onTap: () {
          if (route == 'logout') {
            AuthenticationRepository.instance.logout();
          } else {
            sidebarController.menuOnTap(route);
          }
        },
        onHover: (value) => value ? sidebarController.changeHoverItem(route) : sidebarController.changeHoverItem(''),
        child: Obx(() {
          // Decoration Box
          return Padding(
            padding: EdgeInsets.symmetric(vertical: TSizes().xs),
            child: Container(
              decoration: BoxDecoration(
                color: sidebarController.isHovering(route) || sidebarController.isActive(route) ? TColors().primary : Colors.transparent,
                borderRadius: BorderRadius.circular(TSizes().sm),
              ),

              // Icon and Text Row
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: TSizes().md, vertical: TSizes().sm),
                    child: sidebarController.isActive(route)
                        ? Icon(icon, size: 22, color: TColors().white)
                        : Icon(icon, size: 22, color: sidebarController.isHovering(route) ? TColors().white : TColors().grey),
                  ),
                  // Text
                  if (sidebarController.isHovering(route) || sidebarController.isActive(route))
                    Flexible(
                      child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors().white)),
                    )
                  else
                    Flexible(
                      child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors().grey)),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
