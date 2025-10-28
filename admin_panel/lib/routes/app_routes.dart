import 'package:cwt_ecommerce_admin_panel/features/admin_managment/screens/admin/create/create_admin.dart';
import 'package:cwt_ecommerce_admin_panel/features/admin_managment/screens/admin/view/admin.dart';
import 'package:cwt_ecommerce_admin_panel/features/role_management/screens/roles_and_permissions/view/role.dart';
import 'package:get/get.dart';

import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/chat/screens/all_chats/all _chats.dart';
import '../features/chat/screens/chat_details/chat_detail.dart';
import '../features/dashboard/screens/dashboard.dart';
import '../features/data_management/screens/attribute/create/create_attribute.dart';
import '../features/data_management/screens/attribute/edit/edit_attribute.dart';
import '../features/data_management/screens/attribute/view/attributes.dart';
import '../features/data_management/screens/brand/create/create_brand.dart';
import '../features/data_management/screens/brand/edit/edit_brand.dart';
import '../features/data_management/screens/brand/view/brands.dart';
import '../features/data_management/screens/category/create/create_category.dart';
import '../features/data_management/screens/category/create_subcategory/create_category.dart';
import '../features/data_management/screens/category/edit/edit_category.dart';
import '../features/data_management/screens/category/edit_subcategory/edit_subcategory.dart';
import '../features/data_management/screens/category/view/categories.dart';
import '../features/data_management/screens/category/view_subcategories/sub_categories.dart';
import '../features/data_management/screens/unit/create/create_unit.dart';
import '../features/data_management/screens/unit/edit/edit_attribute.dart';
import '../features/data_management/screens/unit/view/units.dart';
import '../features/media/screens/media/media.dart';
import '../features/personalization/screens/customers/details/customer.dart';
import '../features/personalization/screens/customers/view/customers.dart';
import '../features/personalization/screens/profile/profile.dart';
import '../features/personalization/screens/settings/settings.dart';
import '../features/product_management/screens/order/details/order_details.dart';
import '../features/product_management/screens/order/view/orders.dart';
import '../features/product_management/screens/product/create/create_product.dart';
import '../features/product_management/screens/product/edit/edit_product.dart';
import '../features/product_management/screens/product/view/products.dart';
import '../features/product_management/screens/recommended_product/view/recommended_products.dart';
import '../features/product_management/screens/review/create/create_review.dart';
import '../features/product_management/screens/review/view/reviews.dart';
import '../features/promotion_management/screens/banner/create/create_banner.dart';
import '../features/promotion_management/screens/banner/edit/edit_banner.dart';
import '../features/promotion_management/screens/banner/view/banner.dart';
import '../features/promotion_management/screens/coupon/create/create_coupon.dart';
import '../features/promotion_management/screens/coupon/edit/edit_coupon.dart';
import '../features/promotion_management/screens/coupon/view/coupons.dart';
import '../features/promotion_management/screens/notification/create/create_notification.dart';
import '../features/promotion_management/screens/notification/view/notifications.dart';
import 'routes.dart';
import 'routes_middleware.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => const ForgetPasswordScreen()),

    GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.media, page: () => const MediaScreen(), middlewares: [TRouteMiddleware()]),

    // Categories
    GetPage(name: TRoutes.categories, page: () => const CategoriesScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.subCategories, page: () => const SubCategoriesScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createCategory, page: () => const CreateCategoryScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createSubCategory, page: () => const CreateSubCategoryScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editCategory, page: () => const EditCategoryScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editSubCategory, page: () => const EditSubCategoryScreen(), middlewares: [TRouteMiddleware()]),

    // Brands
    GetPage(name: TRoutes.brands, page: () => const BrandsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createBrand, page: () => const CreateBrandScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editBrand, page: () => const EditBrandScreen(), middlewares: [TRouteMiddleware()]),

    // Attributes
    GetPage(name: TRoutes.attributes, page: () => const AttributesScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createAttribute, page: () => const CreateAttributeScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editAttribute, page: () => const EditAttributeScreen(), middlewares: [TRouteMiddleware()]),

    // Units
    GetPage(name: TRoutes.units, page: () => const UnitsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createUnit, page: () => const CreateUnitScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editUnit, page: () => const EditUnitScreen(), middlewares: [TRouteMiddleware()]),

    // Products
    GetPage(name: TRoutes.products, page: () => const ProductsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.recommendedProducts, page: () => const RecommendedProductsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createProduct, page: () => const CreateProductScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editProduct, page: () => const EditProductScreen(), middlewares: [TRouteMiddleware()]),

    GetPage(name: TRoutes.reviews, page: () => const ReviewsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createReview, page: () => const CreateReviewScreen(), middlewares: [TRouteMiddleware()]),


    // Coupon
    GetPage(name: TRoutes.coupons, page: () => const CouponsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createCoupon, page: () => const CreateCouponScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editCoupon, page: () => const EditCouponScreen(), middlewares: [TRouteMiddleware()]),

    // Support
    GetPage(name: TRoutes.chats, page: () => const AllChatsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.chatDetails, page: () => const ChatDetail(), middlewares: [TRouteMiddleware()]),

    // Coupon
    // GetPage(name: TRoutes.campaigns, page: () => const CampaignsScreen(), middlewares: [TRouteMiddleware()]),
    // GetPage(name: TRoutes.createCampaign, page: () => const CreateCampaignScreen(), middlewares: [TRouteMiddleware()]),
    // GetPage(name: TRoutes.editCampaign, page: () => const EditCampaignScreen(), middlewares: [TRouteMiddleware()]),

    // Coupon
    GetPage(name: TRoutes.banners, page: () => const BannersScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createBanner, page: () => const CreateBannerScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editBanner, page: () => const EditBannerScreen(), middlewares: [TRouteMiddleware()]),

    // Notification
    GetPage(name: TRoutes.notifications, page: () => const NotificationsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createNotification, page: () => const CreateNotificationScreen(), middlewares: [TRouteMiddleware()]),

    // Customers
    GetPage(name: TRoutes.customers, page: () => const CustomersScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.customerDetails, page: () => const CustomerDetailScreen(), middlewares: [TRouteMiddleware()]),

    // Order
    GetPage(name: TRoutes.orders, page: () => const OrdersScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.orderDetails, page: () => const OrderDetailsScreen(), middlewares: [TRouteMiddleware()]),

    // Role
    GetPage(name: TRoutes.roles, page: () => const RoleScreen(), middlewares: [TRouteMiddleware()]),

    // Admin
    GetPage(name: TRoutes.admin, page: () => const AdminScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.adminCreate, page: () => const CreateAdminScreen(), middlewares: [TRouteMiddleware()]),

    // Settings
    GetPage(name: TRoutes.settings, page: () => const SettingsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.profile, page: () => const ProfileScreen(), middlewares: [TRouteMiddleware()]),
  ];
}
