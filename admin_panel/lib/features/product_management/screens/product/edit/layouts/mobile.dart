import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/tags_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: TSizes().defaultSpace,
            left: TSizes().defaultSpace,
            right: TSizes().defaultSpace,
            bottom: TSizes().defaultSpace * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: TTexts.updateProduct.tr,
                breadcrumbItems: [TRoutes.products, TTexts.updateProduct.tr],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Update Product
              const ProductTitleAndDescription(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Stock & Pricing
              TContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    TTextWithIcon(text: TTexts.productConfiguration.tr, icon: Iconsax.setting),
                    Divider(color: TColors().grey),
                    SizedBox(height: TSizes().spaceBtwItems),

                    // Product Type
                    const ProductTypeWidget(),
                    SizedBox(height: TSizes().spaceBtwInputFields),

                    // Stock
                    const ProductStockAndPricing(),
                    SizedBox(height: TSizes().spaceBtwSections),

                    // Attributes
                    ProductAttributes(),
                    SizedBox(height: TSizes().spaceBtwSections),
                  ],
                ),
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Variations
              const ProductVariations(),
              SizedBox(height: TSizes().defaultSpace),

              // Sidebar
              const ProductVisibilityWidget(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Product Thumbnail
              const ProductThumbnailImage(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Product Images
              const ProductAdditionalImages(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Product Brand
              const ProductBrand(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Product Categories
              const ProductCategories(),
              SizedBox(height: TSizes().spaceBtwSections),

              // Product Brand
              const ProductTag(),
              SizedBox(height: TSizes().spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
