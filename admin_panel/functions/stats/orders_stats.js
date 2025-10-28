const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const moment = require('moment');

// Handle order creation
exports.handleOrderCreated = onDocumentCreated('Orders/{orderId}', async (event) => {
    const orderData = event.data.data();

    if (!orderData) {
        console.log('No order data available, skipping...');
        return;
    }

    try {
        // Update order stats
        await updateOrderStats(orderData, 'increment');

        // Update retailer stats
//        await updateRetailerStats(orderData, 'increment');

        // Adjust order status stats for global and retailer-specific
        await adjustOrderStatusStats(null, orderData.orderStatus); // New status on creation
//        await adjustOrderStatusStatsForRetailer(null, orderData); // New status for retailer

        console.log('Order stats updated successfully on creation.');
    } catch (error) {
        console.error('Error updating order stats on creation:', error);
    }
});

// Handle order updates
exports.handleOrderUpdated = onDocumentUpdated('Orders/{orderId}', async (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    if (!afterData) {
        console.log('No data available after update, skipping...');
        return;
    }

    try {
        // Adjust status stats for both global and retailer-specific
        if (beforeData.orderStatus !== afterData.orderStatus) {
            // Adjust global order status stats
            await adjustOrderStatusStats(beforeData.orderStatus, afterData.orderStatus);

            // Adjust retailer-specific order status stats
//            await adjustOrderStatusStatsForRetailer(beforeData, afterData);
        }

        // Update order stats
        await updateOrderStats(afterData, 'increment', beforeData);

        // Update retailer stats
//        await updateRetailerStats(afterData, 'increment', beforeData);


        console.log('Order stats updated successfully on order update.');
    } catch (error) {
        console.error('Error updating order stats on update:', error);
    }
});

// Handle order deletion
exports.handleOrderDeleted = onDocumentDeleted('Orders/{orderId}', async (event) => {
    const orderData = event.data.data();

    if (!orderData) {
        console.log('No order data available for deletion, skipping...');
        return;
    }

    try {
        // Update order stats
        await updateOrderStats(orderData, 'decrement');

        // Update retailer stats
//        await updateRetailerStats(orderData, 'decrement');

        // Update order status stats for retailer
        await adjustOrderStatusStats(orderData.orderStatus, null); // No current status on deletion
//        await adjustOrderStatusStatsForRetailer(orderData, null); // Handle retailer-specific status


        console.log('Order stats updated successfully on deletion.');
    } catch (error) {
        console.error('Error updating order stats on deletion:', error);
    }
});

// Update order stats for total orders, revenue, tax, shipping, discounts, points, etc. on daily, weekly, monthly, and yearly basis
async function updateOrderStats(orderData, action, beforeData = null) {
    const orderDate = moment(orderData.orderDate.toDate());
    const year = orderDate.year();
    const month = orderDate.month() + 1; // Month is zero-based
    const day = orderDate.date();
    const weekNumber = orderDate.isoWeek(); // ISO week number

    const statsRef = admin.firestore().collection('StatsOrders');

    // Calculate the difference between before and after for update scenarios
    let amountDifference = orderData.totalAmount - (beforeData ? beforeData.totalAmount : 0);
    let taxDifference = orderData.taxAmount - (beforeData ? beforeData.taxAmount : 0);
    let shippingDifference = orderData.shippingAmount - (beforeData ? beforeData.shippingAmount : 0);
    let itemCountDifference = orderData.itemCount - (beforeData ? beforeData.itemCount : 0);

    // New fields: Total discounts and points usage
    let discountDifference = orderData.totalDiscountAmount - (beforeData ? beforeData.totalDiscountAmount : 0);
    let pointsUsedDifference = orderData.pointsUsed - (beforeData ? beforeData.pointsUsed : 0);
    let couponDiscountDifference = orderData.couponDiscountAmount - (beforeData ? beforeData.couponDiscountAmount : 0);

    const incrementValue = action === 'increment'
        ? (beforeData ? 0 : 1)  // Set to 1 for new orders, 0 for updates
        : -1;                    // Set to -1 for deletions


    // Set differences to negative if action is 'decrement' (i.e., during deletion)
    if (action === 'decrement') {
        amountDifference = -amountDifference;
        taxDifference = -taxDifference;
        shippingDifference = -shippingDifference;
        itemCountDifference = -itemCountDifference;
        discountDifference = -discountDifference;
        pointsUsedDifference = -pointsUsedDifference;
        couponDiscountDifference = -couponDiscountDifference;
    }

    const batch = admin.firestore().batch();

    // Prepare stats fields for daily, weekly, monthly, and yearly aggregation
    const statsData = {
        totalOrders: admin.firestore.FieldValue.increment(incrementValue),
        totalRevenue: admin.firestore.FieldValue.increment(amountDifference),
        totalTax: admin.firestore.FieldValue.increment(taxDifference),
        totalShipping: admin.firestore.FieldValue.increment(shippingDifference),
        totalItemsSold: admin.firestore.FieldValue.increment(itemCountDifference),
        totalDiscounts: admin.firestore.FieldValue.increment(discountDifference),
        totalPointsUsed: admin.firestore.FieldValue.increment(pointsUsedDifference),
        totalCouponDiscounts: admin.firestore.FieldValue.increment(couponDiscountDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    // Update daily stats
    const dailyDoc = statsRef.doc(`daily_${year}_${month}_${day}`);
    batch.set(dailyDoc, statsData, { merge: true });

    // Update weekly stats
    const weeklyDoc = statsRef.doc(`weekly_${year}_${weekNumber}`);
    batch.set(weeklyDoc, statsData, { merge: true });

    // Update monthly stats
    const monthlyDoc = statsRef.doc(`monthly_${year}_${month}`);
    batch.set(monthlyDoc, statsData, { merge: true });

    // Update yearly stats
    const yearlyDoc = statsRef.doc(`yearly_${year}`);
    batch.set(yearlyDoc, statsData, { merge: true });

    await batch.commit();
}


// Function to update stats (daily, weekly, monthly, yearly)
async function updateRetailerStats(orderData, action, beforeData = null) {
    const orderDate = moment(orderData.orderDate.toDate());
    const year = orderDate.year();
    const month = orderDate.month() + 1; // Month is zero-based
    const day = orderDate.date();
    const weekNumber = orderDate.isoWeek(); // ISO week number

    const statsRef = admin.firestore().collection('StatsRetailers').doc(orderData.retailerId);

    let amountDifference = orderData.totalAmount - (beforeData ? beforeData.totalAmount : 0);
    let taxDifference = orderData.taxAmount - (beforeData ? beforeData.taxAmount : 0);
    let shippingDifference = orderData.shippingAmount - (beforeData ? beforeData.shippingAmount : 0);
    let discountDifference = orderData.totalDiscountAmount - (beforeData ? beforeData.totalDiscountAmount : 0);
    let pointsDifference = orderData.pointsUsed - (beforeData ? beforeData.pointsUsed : 0);
    let couponDiscountDifference = orderData.couponDiscountAmount - (beforeData ? beforeData.couponDiscountAmount : 0);
    let itemCountDifference = orderData.itemCount - (beforeData ? beforeData.itemCount : 0);

    const incrementValue = action === 'increment'
            ? (beforeData ? 0 : 1)  // Set to 1 for new orders, 0 for updates
            : -1;                    // Set to -1 for deletions


    // Set differences to negative if action is 'decrement' (i.e., during deletion)
    if (action === 'decrement') {
        amountDifference = -amountDifference;
        taxDifference = -taxDifference;
        shippingDifference = -shippingDifference;
        itemCountDifference = -itemCountDifference;
        discountDifference = -discountDifference;
        pointsUsedDifference = -pointsUsedDifference;
        couponDiscountDifference = -couponDiscountDifference;
    }


    const batch = admin.firestore().batch();

    // Update daily stats
    const dailyDoc = statsRef.collection('daily').doc(`${year}_${month}_${day}`);
    batch.set(dailyDoc, {
        totalOrders: admin.firestore.FieldValue.increment(incrementValue),
        totalRevenue: admin.firestore.FieldValue.increment(amountDifference),
        totalTax: admin.firestore.FieldValue.increment(taxDifference),
        totalShipping: admin.firestore.FieldValue.increment(shippingDifference),
        totalDiscount: admin.firestore.FieldValue.increment(discountDifference),
        totalPointsUsed: admin.firestore.FieldValue.increment(pointsDifference),
        totalCouponDiscount: admin.firestore.FieldValue.increment(couponDiscountDifference),
        totalItemsSold: admin.firestore.FieldValue.increment(itemCountDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    // Update weekly stats
    const weeklyDoc = statsRef.collection('weekly').doc(`${year}_week_${weekNumber}`);
    batch.set(weeklyDoc, {
        totalOrders: admin.firestore.FieldValue.increment(incrementValue),
        totalRevenue: admin.firestore.FieldValue.increment(amountDifference),
        totalTax: admin.firestore.FieldValue.increment(taxDifference),
        totalShipping: admin.firestore.FieldValue.increment(shippingDifference),
        totalDiscount: admin.firestore.FieldValue.increment(discountDifference),
        totalPointsUsed: admin.firestore.FieldValue.increment(pointsDifference),
        totalCouponDiscount: admin.firestore.FieldValue.increment(couponDiscountDifference),
        totalItemsSold: admin.firestore.FieldValue.increment(itemCountDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    // Update monthly stats
    const monthlyDoc = statsRef.collection('monthly').doc(`${year}_${month}`);
    batch.set(monthlyDoc, {
        totalOrders: admin.firestore.FieldValue.increment(incrementValue),
        totalRevenue: admin.firestore.FieldValue.increment(amountDifference),
        totalTax: admin.firestore.FieldValue.increment(taxDifference),
        totalShipping: admin.firestore.FieldValue.increment(shippingDifference),
        totalDiscount: admin.firestore.FieldValue.increment(discountDifference),
        totalPointsUsed: admin.firestore.FieldValue.increment(pointsDifference),
        totalCouponDiscount: admin.firestore.FieldValue.increment(couponDiscountDifference),
        totalItemsSold: admin.firestore.FieldValue.increment(itemCountDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    // Update yearly stats
    const yearlyDoc = statsRef.collection('yearly').doc(`${year}`);
    batch.set(yearlyDoc, {
        totalOrders: admin.firestore.FieldValue.increment(incrementValue),
        totalRevenue: admin.firestore.FieldValue.increment(amountDifference),
        totalTax: admin.firestore.FieldValue.increment(taxDifference),
        totalShipping: admin.firestore.FieldValue.increment(shippingDifference),
        totalDiscount: admin.firestore.FieldValue.increment(discountDifference),
        totalPointsUsed: admin.firestore.FieldValue.increment(pointsDifference),
        totalCouponDiscount: admin.firestore.FieldValue.increment(couponDiscountDifference),
        totalItemsSold: admin.firestore.FieldValue.increment(itemCountDifference),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });

    await batch.commit();
}


// Adjust order status stats if the status changes (null for old status on creation, null for new status on deletion)
async function adjustOrderStatusStats(oldStatus, newStatus) {
    const statusStatsRef = admin.firestore().collection('StatsOrderByStatus').doc('status');

    const batch = admin.firestore().batch();

    if (oldStatus) {
        batch.set(statusStatsRef, {
            [oldStatus]: admin.firestore.FieldValue.increment(-1)
        }, { merge: true });
    }

    if (newStatus) {
        batch.set(statusStatsRef, {
            [newStatus]: admin.firestore.FieldValue.increment(1)
        }, { merge: true });
    }

    await batch.commit();
}

// Adjust stats if order status changes (pending, shipped, etc.)
async function adjustOrderStatusStatsForRetailer(beforeData, afterData) {
    const retailerStatsRef = admin.firestore().collection('StatsOrderByStatus').doc(afterData.retailerId);
    const batch = admin.firestore().batch();

    // Check if the retailer stats document exists
    const docSnapshot = await retailerStatsRef.get();
    if (!docSnapshot.exists) {
        // If it doesn’t exist, create it with the new status
        batch.set(retailerStatsRef, {
            [afterData.orderStatus]: 1  // Set the initial count to 1 for the new order's status
        });
    } else {
        // If it exists, proceed with increment/decrement as usual
        if (beforeData && beforeData.orderStatus) {
            batch.set(retailerStatsRef, {
                [beforeData.orderStatus]: admin.firestore.FieldValue.increment(-1)
            }, { merge: true });
        }
        if (afterData.orderStatus) {
            batch.set(retailerStatsRef, {
                [afterData.orderStatus]: admin.firestore.FieldValue.increment(1)
            }, { merge: true });
        }
    }

    await batch.commit();
}

