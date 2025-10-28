const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');

// Handle brand creation
exports.handleBrandCreated = onDocumentCreated('Brands/{brandId}', async (event) => {
    const brandData = event.data.data();

    if (!brandData) {
        console.log('No brand data available, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(brandData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsBrands').doc(createdAt);

        console.log(`Brand created on ${createdAt}. Incrementing totalBrands and relevant fields.`);

        // Increment brand stats
        await statsDocRef.set({
            totalBrands: admin.firestore.FieldValue.increment(1),
            totalProducts: admin.firestore.FieldValue.increment(brandData.productsCount || 0),
            totalViews: admin.firestore.FieldValue.increment(brandData.viewCount || 0),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        console.log('Brand stats updated successfully.');
    } catch (error) {
        console.error('Error updating brand stats on creation:', error);
    }
});


// Handle brand updates
exports.handleBrandUpdated = onDocumentUpdated('Brands/{brandId}', async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(afterData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsBrands').doc(createdAt);

        console.log(`Brand created on ${createdAt} updated. Checking for changes...`);

        // Variables to track changes
        let updates = {};
        let updated = false;

        // Check for changes in productsCount
        if (beforeData.productsCount !== afterData.productsCount) {
            const productsDifference = (afterData.productsCount || 0) - (beforeData.productsCount || 0);
            updates.totalProducts = admin.firestore.FieldValue.increment(productsDifference);
            console.log(`Products count changed by ${productsDifference}`);
            updated = true;
        }

        // Check for changes in viewCount
        if (beforeData.viewCount !== afterData.viewCount) {
            const viewsDifference = (afterData.viewCount || 0) - (beforeData.viewCount || 0);
            updates.totalViews = admin.firestore.FieldValue.increment(viewsDifference);
            console.log(`View count changed by ${viewsDifference}`);
            updated = true;
        }

        // Update if any changes were detected
        if (updated) {
            updates.updatedAt = admin.firestore.FieldValue.serverTimestamp();
            await statsDocRef.set(updates, { merge: true });
            console.log('Brand stats updated successfully on brand update.');
        } else {
            console.log('No relevant changes detected, skipping stats update.');
        }
    } catch (error) {
        console.error('Error updating brand stats on update:', error);
    }
});


// Handle brand deletion
exports.handleBrandDeleted = onDocumentDeleted('Brands/{brandId}', async (event) => {
    const brandData = event.data.data();

    if (!brandData) {
        console.log('No brand data available for deletion, skipping...');
        return;
    }

    try {
        // Convert the Firestore Timestamp 'createdAt' to a readable date format
        const createdAt = moment(brandData.createdAt.toDate()).format('YYYY-MM-DD');
        const statsDocRef = admin.firestore().collection('StatsBrands').doc(createdAt);

        console.log(`Brand created on ${createdAt} deleted. Decrementing totalBrands and relevant fields.`);

        // Decrement brand stats
        await statsDocRef.set({
            totalBrands: admin.firestore.FieldValue.increment(-1),
            totalProducts: admin.firestore.FieldValue.increment(-(brandData.productsCount || 0)),
            totalViews: admin.firestore.FieldValue.increment(-(brandData.viewCount || 0)),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        console.log('Brand stats updated successfully on deletion.');
    } catch (error) {
        console.error('Error updating brand stats on deletion:', error);
    }
});
