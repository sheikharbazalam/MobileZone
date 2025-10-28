const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');


// Handle product creation
exports.handleProductCreated = onDocumentCreated('Products/{productId}', async (event) => {
    const productData = event.data.data();

    if (!productData) {
        console.log('No product data available, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(productData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsProducts').doc(createdAt);

        console.log(`Product created on ${createdAt}. Incrementing totalProducts.`);

        // Increment product stats: products, views, likes, soldQuantity
        await statsDocRef.set({
            totalProducts: admin.firestore.FieldValue.increment(1),
            totalViews: admin.firestore.FieldValue.increment(productData.views || 0),
            totalLikes: admin.firestore.FieldValue.increment(productData.likes || 0),
            totalSold: admin.firestore.FieldValue.increment(productData.soldQuantity || 0),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        console.log('Product stats updated successfully.');
    } catch (error) {
        console.error('Error updating product stats on creation:', error);
    }
});


// Handle product updates
exports.handleProductUpdated = onDocumentUpdated('Products/{productId}', async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(afterData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsProducts').doc(createdAt);

        console.log(`Product created on ${createdAt} updated. Checking for changes...`);

        // Variables to track changes
        let updates = {};
        let updated = false;

        // Check for changes in views
        if (beforeData.views !== afterData.views) {
            const viewsDifference = (afterData.views || 0) - (beforeData.views || 0);
            updates.totalViews = admin.firestore.FieldValue.increment(viewsDifference);
            console.log(`Views changed by ${viewsDifference}`);
            updated = true;
        }

        // Check for changes in likes
        if (beforeData.likes !== afterData.likes) {
            const likesDifference = (afterData.likes || 0) - (beforeData.likes || 0);
            updates.totalLikes = admin.firestore.FieldValue.increment(likesDifference);
            console.log(`Likes changed by ${likesDifference}`);
            updated = true;
        }

        // Check for changes in sold quantity
        if (beforeData.soldQuantity !== afterData.soldQuantity) {
            const soldDifference = (afterData.soldQuantity || 0) - (beforeData.soldQuantity || 0);
            updates.totalSold = admin.firestore.FieldValue.increment(soldDifference);
            console.log(`Sold quantity changed by ${soldDifference}`);
            updated = true;
        }

        // If any changes were detected, update the stats document
        if (updated) {
            updates.updatedAt = admin.firestore.FieldValue.serverTimestamp();
            await statsDocRef.set(updates, { merge: true });
            console.log('Product stats updated successfully on product update.');
        } else {
            console.log('No relevant changes detected, skipping stats update.');
        }
    } catch (error) {
        console.error('Error updating product stats on update:', error);
    }
});

// Handle product deletion
exports.handleProductDeleted = onDocumentDeleted('Products/{productId}', async (event) => {
    const productData = event.data.data();

    if (!productData) {
        console.log('No product data available for deletion, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(productData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsProducts').doc(createdAt);

        console.log(`Product created on ${createdAt} deleted. Decrementing totalProducts.`);

        // Decrement product stats: products, views, likes, soldQuantity
        await statsDocRef.set({
            totalProducts: admin.firestore.FieldValue.increment(-1),
            totalViews: admin.firestore.FieldValue.increment(-(productData.views || 0)),
            totalLikes: admin.firestore.FieldValue.increment(-(productData.likes || 0)),
            totalSold: admin.firestore.FieldValue.increment(-(productData.soldQuantity || 0)),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        console.log('Product stats updated successfully on deletion.');
    } catch (error) {
        console.error('Error updating product stats on deletion:', error);
    }
});
