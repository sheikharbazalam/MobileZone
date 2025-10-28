const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');

// Handle user creation
exports.handleUserCreated = onDocumentCreated('Users/{userId}', async (event) => {
    const userData = event.data.data();

    if (!userData) {
        console.log('No user data available, skipping...');
        return;
    }

    try {
        // Update user stats on creation
        await updateUserStats(userData, 'increment');
        console.log('User stats updated successfully on creation.');
    } catch (error) {
        console.error('Error updating user stats on creation:', error);
    }
});

// Handle user updates
exports.handleUserUpdated = onDocumentUpdated('Users/{userId}', async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // Adjust stats based on changes in user data
        await updateUserStats(afterData, 'increment', beforeData);
        console.log('User stats updated successfully on update.');
    } catch (error) {
        console.error('Error updating user stats on update:', error);
    }
});

// Handle user deletion
exports.handleUserDeleted = onDocumentDeleted('Users/{userId}', async (event) => {
    const userData = event.data.data();

    if (!userData) {
        console.log('No user data available for deletion, skipping...');
        return;
    }

    try {
        // Decrement stats on user deletion
        await updateUserStats(userData, 'decrement');
        console.log('User stats updated successfully on deletion.');
    } catch (error) {
        console.error('Error updating user stats on deletion:', error);
    }
});

// Update user stats for total users, orders, and revenue
async function updateUserStats(userData, action, beforeData = null) {
    const createdAt = moment(userData.createdAt.toDate()).format('YYYY-MM-DD');
    const statsDocRef = admin.firestore().collection('StatsUsers').doc(createdAt);

    const totalOrdersDifference = userData.totalOrders - (beforeData ? beforeData.totalOrders : 0);
    const totalRevenueDifference = userData.totalRevenue - (beforeData ? beforeData.totalRevenue : 0);

    const incrementValue = action === 'increment' ? 1 : -1;

    await statsDocRef.set({
        totalUsers: admin.firestore.FieldValue.increment(incrementValue),
        totalOrders: admin.firestore.FieldValue.increment(totalOrdersDifference),
        totalRevenue: admin.firestore.FieldValue.increment(totalRevenueDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
}
