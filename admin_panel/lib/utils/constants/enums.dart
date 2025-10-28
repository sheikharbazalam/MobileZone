/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

enum StorageType { firebase, supabase }

enum AppRole { superAdmin, demo, user, admin , unknown }

enum TransactionType { buy, sell }

enum ChatType { support }

enum MessageType { text, audio, image }

enum ChatMessageStatus { sending, sent, delivered, read, failed }

enum DiscountType { percentage, flat }

enum TextSizes { small, medium, large }

enum ProductVisibility { published, hidden }

enum ProductType { simple, digital, variable }

enum ShippingMethod { standard, express, overnight }

enum PaymentMethods { cash, card, paypal }

enum ShippingStatus { pending, inTransit, delivered, canceled }

enum MediaCategory { none, banners, brands, categories, products, personalized }

enum BannerTargetType {
  none,
  productScreen,
  categoryScreen,
  brandScreen,
  customUrl,
  homeScreen,
  shopScreen,
  favouriteScreen,
  settingScreen,
  cart,
  orders,
  profile
}

enum UnitType {
  unitLess,
  length, // e.g., meters, kilometers, miles
  weight, // e.g., grams, kilograms, pounds
  volume, // e.g., liters, milliliters, cubic meters
  temperature, // e.g., Celsius, Fahrenheit, Kelvin
  time, // e.g., seconds, minutes, hours
  area, // e.g., square meters, acres, hectares
  speed, // e.g., meters per second, kilometers per hour, miles per hour
  pressure, // e.g., pascal, bar, psi
  energy, // e.g., joules, kilojoules, calories, kilocalories
  power, // e.g., watts, kilowatts, horsepower
  frequency, // e.g., hertz, kilohertz, gigahertz
  fuelEfficiency, // e.g., liters per 100 kilometers, miles per gallon
  angle, // e.g., degrees, radians, gradians
  currency, // e.g., USD, EUR, GBP
  density, // e.g., kilograms per cubic meter, grams per cubic centimeter
  force, // e.g., newtons, pounds-force
  luminosity, // e.g., lumens, candelas
  dataStorage, // e.g., bytes, kilobytes, megabytes, gigabytes
  electricCurrent, // e.g., amperes, milliamperes
  voltage, // e.g., volts, millivolts
  capacitance, // e.g., farads, microfarads
  resistance, // e.g., ohms, milliohms
  inductance, // e.g., henries, millihenries
  magneticField, // e.g., teslas, gauss
  radioactivity, // e.g., becquerels, curies
  concentration, // e.g., moles per liter, parts per million (ppm)
  acidity, // pH level
  illumination, // e.g., lux, foot-candles
  torque, // e.g., newton-meters, pound-feet
}


enum Permission {
  unknown,

  // Dashboard
  viewDashboard,
  createDashboard,
  updateDashboard,
  deleteDashboard,

  // Media
  viewMedia,
  createMedia,
  editMedia,
  deleteMedia,

  // Attribute
  viewAttribute,
  createAttribute,
  updateAttribute,
  deleteAttribute,

  // Brand
  viewBrand,
  createBrand,
  updateBrand,
  deleteBrand,

  // Category
  viewCategory,
  createCategory,
  updateCategory,
  deleteCategory,

  // Sub Category
  viewSubCategory,
  createSubCategory,
  updateSubCategory,
  deleteSubCategory,

  // Unit
  viewUnit,
  createUnit,
  updateUnit,
  deleteUnit,

  // Products
  viewProducts,
  createProducts,
  updateProducts,
  deleteProducts,

  // Orders
  viewOrders,
  createOrders,
  updateOrders,
  deleteOrders,

  // Recommended Product
  viewRecommendedProduct,
  createRecommendedProduct,
  updateRecommendedProduct,
  deleteRecommendedProduct,

  // Review
  viewReview,
  createReview,
  updateReview,
  deleteReview,

  // Banner
  viewBanner,
  createBanner,
  updateBanner,
  deleteBanner,

  // Coupon
  viewCoupon,
  createCoupon,
  updateCoupon,
  deleteCoupon,

  // Notifications
  viewNotifications,
  createNotifications,
  updateNotifications,
  deleteNotifications,

  // Retailer
  viewRetailer,
  createRetailer,
  updateRetailer,
  deleteRetailer,

  // Users
  viewUsers,
  createUsers,
  updateUsers,
  deleteUsers,

  // Roles & Permissions
  viewRoles,
  createRoles,
  updateRoles,
  deleteRoles,

  // Settings
  viewSettings,
  updateSettings,
  createSettings,
  deleteSettings,
}
