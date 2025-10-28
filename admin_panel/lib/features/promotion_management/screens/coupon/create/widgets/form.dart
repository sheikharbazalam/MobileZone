import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/coupon/create_coupon_controller.dart';

class CreateCouponForm extends StatelessWidget {
  const CreateCouponForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateCouponController());
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
            TTextWithIcon(text: TTexts.createNewCoupon.tr, icon: Iconsax.activity),
            SizedBox(height: TSizes().spaceBtwSections),

            // Text Field
            TextFormField(
              controller: controller.code,
              validator: (value) => TValidator.validateEmptyText(TTexts.couponCode.tr, value),
              decoration: InputDecoration(labelText: TTexts.couponCode.tr, prefixIcon: Icon(Iconsax.code)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            DropdownButtonFormField<DiscountType>(
              value: controller.discountType.value,
              hint:  Text(TTexts.selectDiscountType.tr),
              decoration: InputDecoration(labelText: TTexts.discountType.tr, prefixIcon: Icon(Iconsax.discount_shape)),
              onChanged: (DiscountType? newValue) => controller.discountType.value = newValue ?? DiscountType.percentage,
              items: DiscountType.values.map((DiscountType discountType) {
                return DropdownMenuItem<DiscountType>(
                  value: discountType,
                  child: Text(discountType.name.toUpperCase()), // Display the name
                );
              }).toList(),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Text Field
            TextFormField(
              keyboardType: TextInputType.number,
              controller: controller.discountValue,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              validator: (value) => TValidator.validateEmptyText(TTexts.discountValue.tr, value),
              decoration:  InputDecoration(labelText: TTexts.discountValue.tr, prefixIcon: Icon(Iconsax.add),
                  hintText: TTexts.discountValue.tr),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Text Field
            TextFormField(
              controller: controller.description,
              decoration: InputDecoration(labelText: TTexts.description.tr, prefixIcon: Icon(Iconsax.text)),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            TextFormField(
              controller: controller.usageLimit,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: TTexts.usageLimit.tr,
                prefixIcon: Icon(Iconsax.stop_circle),
                hintText: TTexts.usageLimitHint.tr,
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            // Date range picker button
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: controller.startDateTextField,
                    onTap: () async => await _startDateTimeRangePicker(context, controller),
                    decoration: InputDecoration(labelText: TTexts.startDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                  ),
                ),
                SizedBox(width: TSizes().spaceBtwItems),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async => await _endDateTimeRangePicker(context, controller),
                    controller: controller.endDateTextField,
                    decoration: InputDecoration(labelText: TTexts.endDate.tr, prefixIcon: Icon(Iconsax.calendar)),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes().spaceBtwItems / 2),
            Text(
              TTexts.couponNote.tr,
              style: Theme
                  .of(context)
                  .textTheme
                  .labelMedium,
            ),

            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            // Checkbox
            Obx(
                  () =>
                  CheckboxMenuButton(
                    value: controller.isActive.value,
                    onChanged: (value) => controller.isActive.value = value ?? false,
                    child: const Text('Is Active'),
                  ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            Obx(
                  () =>
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () => controller.createCoupon(), child: Text(TTexts.create.tr)),
                    ),
                  ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }

  Future<void> _startDateTimeRangePicker(BuildContext context, CreateCouponController controller) async {
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

  Future<void> _endDateTimeRangePicker(BuildContext context, CreateCouponController controller) async {
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
