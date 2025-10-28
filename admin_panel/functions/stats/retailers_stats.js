const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');

// Handle retailer creation
exports.handleRetailerCreated = onDocumentCreated('Retailers/{retailerId}', async (event) => {
    const retailerData = event.data.data();

    if (!retailerData) {
        console.log('No retailer data available, skipping...');
        return;
    }

    try {
        // Update retailer stats on creation
        await updateRetailerStats(retailerData, 'increment');
        console.log('Retailer stats updated successfully on creation.');
    } catch (error) {
        console.error('Error updating retailer stats on creation:', error);
    }
});

// Handle retailer updates
exports.handleRetailerUpdated = onDocumentUpdated('Retailers/{retailerId}', async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // Adjust stats based on changes in retailer data
        await updateRetailerStats(afterData, 'increment', beforeData);
        console.log('Retailer stats updated successfully on update.');
    } catch (error) {
        console.error('Error updating retailer stats on update:', error);
    }
});

// Handle retailer deletion
exports.handleRetailerDeleted = onDocumentDeleted('Retailers/{retailerId}', async (event) => {
    const retailerData = event.data.data();

    if (!retailerData) {
        console.log('No retailer data available for deletion, skipping...');
        return;
    }

    try {
        // Decrement stats on retailer deletion
        await updateRetailerStats(retailerData, 'decrement');
        console.log('Retailer stats updated successfully on deletion.');
    } catch (error) {
        console.error('Error updating retailer stats on deletion:', error);
    }
});

// Update retailer stats for total retailers, products, orders, and revenue
async function updateRetailerStats(retailerData, action, beforeData = null) {
    const createdAt = moment(retailerData.createdAt.toDate()).format('YYYY-MM-DD');
    const statsDocRef = admin.firestore().collection('StatsRetailers').doc(createdAt);

    const totalProductsDifference = retailerData.totalProducts - (beforeData ? beforeData.totalProducts : 0);
    const totalOrdersDifference = retailerData.totalOrders - (beforeData ? beforeData.totalOrders : 0);
    const totalRevenueDifference = retailerData.totalRevenue - (beforeData ? beforeData.totalRevenue : 0);

    const incrementValue = action === 'increment' ? 1 : -1;

    await statsDocRef.set({
        totalRetailers: admin.firestore.FieldValue.increment(incrementValue),
        totalProducts: admin.firestore.FieldValue.increment(totalProductsDifference),
        totalOrders: admin.firestore.FieldValue.increment(totalOrdersDifference),
        totalRevenue: admin.firestore.FieldValue.increment(totalRevenueDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
}
