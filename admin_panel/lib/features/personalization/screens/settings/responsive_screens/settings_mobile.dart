// import 'package:flutter/material.dart';
//
//
// import 'package:t_utils/t_utils.dart';
//
// import '../widgets/image_meta.dart';
// import '../widgets/settings_form.dart';
//
// class SettingsMobileScreen extends StatelessWidget {
//   const SettingsMobileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(TSizes().defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Breadcrumbs
//               TBreadcrumbsWithHeading(heading: 'Settings', breadcrumbItems: ['Settings']),
//               SizedBox(height: TSizes().spaceBtwSections),
//
//               Column(
//                 children: [
//                   ImageAndMeta(),
//                   SizedBox(height: TSizes().spaceBtwSections),
//
//                   // Form
//                   SettingsForm(),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
