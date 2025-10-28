const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');

// Handle category creation
exports.handleCategoryCreated = onDocumentCreated('Categories/{categoryId}', async (event) => {
    const categoryData = event.data.data(); // Correctly access the document data

    if (!categoryData) {
        console.log('No category data available, skipping...');
        return;
    }

    // Log the raw createdAt value to inspect it
    console.log('Raw createdAt value:', categoryData.createdAt);

    // Ensure 'createdAt' field exists and is a valid Firestore Timestamp
    let createdAt = categoryData.createdAt;

    if (!createdAt) {
        console.error('createdAt field is missing or invalid, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp to a readable date format
        createdAt = createdAt.toDate();
        const formattedCreatedAt = moment(createdAt).format('YYYY-MM-DD');

        console.log('Formatted createdAt:', formattedCreatedAt);

        // Get reference to the stats document for the date
        const statsDocRef = admin.firestore().collection('StatsCategories').doc(formattedCreatedAt);

        // Log category creation and stats update
        console.log(`Category created on ${formattedCreatedAt}. Incrementing totalCategories and totalProducts.`);

        // Increment category count and total products (if any)
        await statsDocRef.set({
            totalCategories: admin.firestore.FieldValue.increment(1),
            totalProducts: admin.firestore.FieldValue.increment(categoryData.numberOfProducts || 0),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        console.log('Category stats updated successfully.');
    } catch (error) {
        console.error('Error updating category stats on creation:', error);
    }
});


// Handle category updates
exports.handleCategoryUpdated = onDocumentUpdated('Categories/{categoryId}', async (event) => {
    const beforeData = event.data.before.data(); // Data before the update
    const afterData = event.data.after.data();   // Data after the update

    // Log the before and after data for debugging
    console.log('Before update:', beforeData);
    console.log('After update:', afterData);

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // If numberOfProducts has changed, update product stats
        if (beforeData.numberOfProducts !== afterData.numberOfProducts) {
            const createdAt = afterData.createdAt ? moment(afterData.createdAt.toDate()).format('YYYY-MM-DD') : null;

            if (!createdAt) {
                console.error('createdAt field is missing or invalid');
                return;
            }

            const statsDocRef = admin.firestore().collection('StatsCategories').doc(createdAt);

            // Calculate the difference in product count between before and after
            const productsDifference = (afterData.numberOfProducts || 0) - (beforeData.numberOfProducts || 0);

            console.log(`Updating stats for category created at ${createdAt}. Product difference: ${productsDifference}`);

            // Update the product count based on the difference
            await statsDocRef.set({
                totalProducts: admin.firestore.FieldValue.increment(productsDifference),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            }, { merge: true });

            console.log('Category stats updated successfully.');
        }
    } catch (error) {
        console.error('Error updating category stats:', error);
    }
});


// Handle category deletion
exports.handleCategoryDeleted = onDocumentDeleted('Categories/{categoryId}', async (event) => {
    const categoryData = event.data.data(); // Correctly access the document data

    if (!categoryData) return;

    const createdAt = categoryData.createdAt ? moment(categoryData.createdAt.toDate()).format('YYYY-MM-DD') : null;

    if (!createdAt) {
        console.error('createdAt field is missing or invalid');
        return;
    }

    const statsDocRef = admin.firestore().collection('StatsCategories').doc(createdAt);

    // Decrement category count and total products
    await statsDocRef.set({
        totalCategories: admin.firestore.FieldValue.increment(-1),
        totalProducts: admin.firestore.FieldValue.increment(-categoryData.numberOfProducts || 0),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
});