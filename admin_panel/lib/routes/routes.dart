// routes.dart

class TRoutes {
  static const login = '/login';
  static const forgetPassword = '/forget-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const media = '/media';

  /// Data Management
  static const categories = '/categories';
  static const subCategories = '/sub-categories';
  static const createCategory = '/categories/create';
  static const createSubCategory = '/sub-categories/create';
  static const editCategory = '/categories/edit';
  static const editSubCategory = '/sub-categories/edit';

  static const brands = '/brands';
  static const createBrand = '/brands/create';
  static const editBrand = '/brands/edit';

  static const attributes = '/attributes';
  static const createAttribute = '/attributes/create';
  static const editAttribute = '/attributes/edit';

  static const units = '/units';
  static const createUnit = '/units/create';
  static const editUnit = '/units/edit';

  static const banners = '/banners';
  static const createBanner = '/banners/create';
  static const editBanner = '/banners/edit';

  static const products = '/products';
  static const recommendedProducts = '/recommended-products';
  static const createProduct = '/products/create';
  static const editProduct = '/products/edit';

  static const reviews = '/reviews';
  static const createReview = '/reviews/create';
  static const editReview = '/reviews/edit';

  static const retailers = '/retailers';
  static const createRetailer = '/retailers/create';
  static const editRetailer = '/retailers/details';

  static const customers = '/customers';
  static const createCustomer = '/customers/create';
  static const customerDetails = '/customers/details';

  static const admin = '/admin';
  static const adminCreate = '/admin/create';

  static const orders = '/orders';
  static const orderDetails = '/orders/order-details';

  static const coupons = '/coupons';
  static const createCoupon = '/coupons/create';
  static const editCoupon = '/coupons/edit';

  static const campaigns = '/campaigns';
  static const createCampaign = '/campaigns/create';
  static const editCampaign = '/campaigns/edit';

  static const notifications = '/notifications';
  static const createNotification = '/notifications/create';
  static const notificationDetail = '/notifications/details';

  static const chats = '/support';
  static const chatDetails = '/chat-Details';


  static const settings = '/settings';
  static const profile = '/profile';

  static const roles = '/role';


  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    media,
    products,
    categories,
    brands,
    customers,
    orders,
    coupons,
    settings,
    profile
  ];
}

// All App Screens
class AppRoutes {
  static const initial = '/';
  static const onBoarding = '/on-boarding';
  static const logIn = '/log-in';
  static const signup = '/sign-up';
  static const forgetPassword = '/forget-password';
  static const home = '/home';
  static const categories = '/categories';
  static const category = '/category';
  static const categoryBrand = '/category-Brand';
  static const search = '/search';
  static const filter = '/filter';
  static const store = '/store';
  static const shop = '/shop';
  static const notification = '/notification';
  static const notificationDetails = '/notification-details';
  static const favourite = '/favourite';
  static const profile = '/profile';
  static const productDetail = '/product-detail';
  static const newArrival = '/new-Arrival';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const pay = '/pay';
  static const order = '/order';
  static const orderDetail = '/orderDetail';
  static const navigation = '/navigation';
}
