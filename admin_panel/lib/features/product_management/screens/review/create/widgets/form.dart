import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/review/create_review_controller.dart';
import 'product_widget.dart';

class CreateReviewForm extends StatelessWidget {
  const CreateReviewForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateReviewController());
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
            TTextWithIcon(text: TTexts.createNewReview.tr, icon: Iconsax.activity),
            SizedBox(height: TSizes().spaceBtwSections),

            /// Products Search
            const ProductsWidget(),
            SizedBox(height: TSizes().spaceBtwInputFields),



            Text(TTexts.chooseYourRating.tr, style: Theme.of(context).textTheme.titleMedium),
            Obx(
              () => RatingBar.builder(
                minRating: 1,
                itemCount: 5,
                allowHalfRating: true,
                direction: Axis.horizontal,
                initialRating: controller.rating.value,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(CupertinoIcons.star_fill, color: Colors.amber),
                onRatingUpdate: (rating) => controller.rating.value = rating,
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),

            /// Review
            Text(TTexts.addReview.tr, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: TSizes().spaceBtwInputFields / 2),
            SizedBox(
              height: 80,
              child: TextFormField(
                expands: true,
                maxLines: null,
                textAlign: TextAlign.start,
                controller: controller.review,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(labelText:TTexts.review.tr, hintText: 'Add your review here...', alignLabelWithHint: true),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields),


            // Checkbox
            Obx(
              () => CheckboxMenuButton(
                value: controller.isApproved.value,
                onChanged: (value) => controller.isApproved.value = value ?? false,
                child: Text(TTexts.approved.tr),
              ),
            ),

            SizedBox(height: TSizes().spaceBtwInputFields * 2),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createReview(), child: Text(TTexts.createReview.tr)),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
