const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

// --------------- Import functions ---------------
const { addAdminRole } = require('./authentication/set_admin');
const { registerUser } = require('./authentication/register_auth_user');
const { deleteUserByEmail } = require('./authentication/delete_auth_user');
exports.uploadCategoryImage = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'You must be signed in to upload images.'
    );
  }

  // Fetch user role from Firestore
  const userDoc = await admin
    .firestore()
    .doc(`Users/${context.auth.uid}`)
    .get();
  if (!userDoc.exists || userDoc.data().role !== 'superAdmin') {
    throw new functions.https.HttpsError(
      'permission-denied',
      'You are not allowed to perform this action.'
    );
  }

  // Upload image to Storage
  const bucket = admin.storage().bucket();
  const file = bucket.file(`Categories/${data.fileName}`);

  await file.save(Buffer.from(data.base64, 'base64'), {
    contentType: data.contentType,
  });

  return { message: 'Upload successful' };
});

exports.authentication = { addAdminRole, registerUser, deleteUserByEmail };

//  --------------- Import notification functions ---------------
const { sendNotifications } = require('./notifications/order_notifications');

exports.sendNotification = sendNotifications;

// --------------- Import stats functions from different modules ---------------
const updateOrderStats = require('./stats/orders_stats');
//const updateProductStats = require('./stats/products_stats');
//const updateRetailerStats  = require('./stats/retailers_stats');
//const updateUserStats  = require('./stats/users_stats');
//const updateCategoryStats  = require('./stats/categories_stats');
//const updateBrandStats = require('./stats/brands_stats');

// Export all the functions
exports.updateOrderStats = updateOrderStats;
//exports.CategoryStats = updateCategoryStats;
//exports.updateProductStats = updateProductStats;
//exports.updateRetailerStats = updateRetailerStats;
//exports.updateUserStats = updateUserStats;
//exports.updateBrandStats = updateBrandStats;

// --------------- Import SMS handlers ---------------
const { sendOtpHandler } = require('./sms_authentication/send_otp');
const { verifyOtpHandler } = require('./sms_authentication/verify_otp');

exports.infoBip = { sendOtpHandler, verifyOtpHandler };

// --------------- Stripe ---------------
const { createStripePaymentIntent } = require('./stripe/payment_intent');
exports.createStripePaymentIntent = createStripePaymentIntent;
