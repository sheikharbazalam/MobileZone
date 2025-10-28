import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/banner/create_banner_controller.dart';
import 'brand_widget.dart';
import 'category_widget.dart';
import 'product_widget.dart';

class CreateBannerForm extends StatelessWidget {
  const CreateBannerForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBannerController());
    return TFormContainer(
      isLoading: controller.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            SizedBox(height: TSizes().sm),
            TTextWithIcon(text: TTexts.createNewBanner.tr, icon: Iconsax.activity),
            SizedBox(height: TSizes().spaceBtwSections),

            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Obx(
                () => InkWell(
                  onTap: controller.pickImage,
                  child: TImage(
                    padding: 0,
                    backgroundColor: TColors().lightBackground,
                    imageType: controller.imageUrl.value.isNotEmpty ? ImageType.network : ImageType.asset,
                    image: controller.imageUrl.value.isNotEmpty ? controller.imageUrl.value : TImages.aspectRation16_9Colored,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwSections),

            // Text Field
            TextFormField(
              controller: controller.title,
              validator: (value) => TValidator.validateEmptyText(TTexts.bannerTitle.tr, value),
              decoration:  InputDecoration(labelText: TTexts.bannerTitle.tr, prefixIcon: Icon(Iconsax.code)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Text Field
            TextFormField(
              controller: controller.description,
              decoration: InputDecoration(labelText: TTexts.bannerDescription.tr, prefixIcon: Icon(Iconsax.text)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Date range picker button
            TDeviceUtils.isDesktopScreen(context)
                ? Row(
                    spacing: TSizes().spaceBtwItems,
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: controller.startDateTextField,
                          onTap: () async => await _startDateTimeRangePicker(context, controller),
                          decoration: InputDecoration(labelText: TTexts.startDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async => await _endDateTimeRangePicker(context, controller),
                          controller: controller.endDateTextField,
                          decoration: InputDecoration(labelText: TTexts.endDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                        ),
                      ),
                    ],
                  )
                : Column(
                    spacing: TSizes().spaceBtwItems,
                    children: [
                      TextFormField(
                        readOnly: true,
                        controller: controller.startDateTextField,
                        onTap: () async => await _startDateTimeRangePicker(context, controller),
                        decoration:  InputDecoration(labelText: TTexts.startDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                      ),
                      TextFormField(
                        readOnly: true,
                        onTap: () async => await _endDateTimeRangePicker(context, controller),
                        controller: controller.endDateTextField,
                        decoration: InputDecoration(labelText: TTexts.endDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                      ),
                    ],
                  ),
            SizedBox(height: TSizes().spaceBtwItems / 2),
            Text(
              TTexts.bannerNote.tr,
              style: Theme.of(context).textTheme.labelMedium,
            ),

            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            /// Banner Target Type
            TContainer(
              showShadow: true,
              child: Column(
                children: [
                  TTextWithIcon(text: TTexts.bannerTargetScreen.tr, icon: Iconsax.filter),
                  SizedBox(height: TSizes().spaceBtwItems),
                  TDropdown<BannerTargetType>(
                    labelText: TTexts.bannerTargetType.tr,
                    hintText: TTexts.selectBannerTargetType.tr,
                    prefixIcon: Icon(Iconsax.filter),
                    selectedItem: controller.bannerTargetType.value,
                    itemAsString: (suggestion) => suggestion.name[0].toUpperCase() + suggestion.name.substring(1),
                    onChanged: (suggestion) {
                      if (suggestion == null || suggestion == BannerTargetType.none) {
                        // Handle "Unselect" option
                        controller.bannerTargetType.value = BannerTargetType.none;
                        // controller.targetTypeController.clear();
                      } else {
                        controller.bannerTargetType.value = suggestion;
                        // controller.targetTypeController.text = suggestion.name[0].toUpperCase() + suggestion.name.substring(1);
                      }
                    },
                    showSearchBox: false,
                    items: (query, __) => BannerTargetType.values.toList(),
                  ),
                  SizedBox(height: TSizes().spaceBtwSections),
                  Obx(() {
                    if (controller.bannerTargetType.value == BannerTargetType.productScreen) {
                      return const BannerProductsWidget();
                    } else if (controller.bannerTargetType.value == BannerTargetType.categoryScreen) {
                      return const BannerCategoryWidget();
                    } else if (controller.bannerTargetType.value == BannerTargetType.brandScreen) {
                      return const BannerBrandWidget();
                    } else if (controller.bannerTargetType.value == BannerTargetType.customUrl) {
                      return TextFormField(
                        controller: controller.customUrlTextField,
                        decoration: InputDecoration(
                            labelText: TTexts.customUrl.tr, prefixIcon: Icon(Iconsax.add), hintText: TTexts.shareUrl.tr),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),

            SizedBox(height: TSizes().spaceBtwInputFields * 2),
            const Divider(),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            // Checkbox
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CheckboxMenuButton(
                      value: controller.isActive.value,
                      onChanged: (value) => controller.isActive.value = value ?? false,
                      child: Text(TTexts.isActive.tr),
                    ),
                  ),
                ),
                SizedBox(width: TSizes().spaceBtwInputFields),
                Expanded(
                  child: Obx(
                    () => CheckboxMenuButton(
                      value: controller.isFeatured.value,
                      onChanged: (value) => controller.isFeatured.value = value ?? false,
                      child: Text(TTexts.isFeatured.tr),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createBanner(), child: const Text('Create')),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }

  Future<void> _startDateTimeRangePicker(BuildContext context, CreateBannerController controller) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
      padding: EdgeInsets.all(TSizes().defaultSpace),
      is24HourMode: false,
      selectableDayPredicate: (dateTime) {
        // Disable dates before today for startDate
        if (dateTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
          return false;
        }
        return true;
      },
    );

    if (dateTime != null) {
      controller.startDate.value = dateTime;
      controller.startDateTextField.text = TFormatter.formatDate(controller.startDate.value);

      if (controller.endDate.value.isBefore(dateTime)) {
        controller.endDate.value = dateTime;
        controller.endDateTextField.text = TFormatter.formatDate(dateTime);
      }
    }
  }

  Future<void> _endDateTimeRangePicker(BuildContext context, CreateBannerController controller) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
      padding: EdgeInsets.all(TSizes().defaultSpace),
      initialDate: controller.endDate.value.isAfter(controller.startDate.value)
          ? controller.endDate.value
          : controller.startDate.value.add(const Duration(days: 1)),
      firstDate: controller.startDate.value,
      is24HourMode: false,
      selectableDayPredicate: (dateTime) {
        // Disable dates before today for startDate
        if (dateTime.isBefore(controller.startDate.value)) {
          return false;
        }
        return true;
      },
    );

    if (dateTime != null) {
      controller.endDate.value = dateTime;
      controller.endDateTextField.text = TFormatter.formatDate(controller.endDate.value);
    }
  }
}
