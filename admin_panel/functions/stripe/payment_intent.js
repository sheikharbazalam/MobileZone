const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const stripe = require('stripe')('sk_test_51RLTXcINpmiYACrDjj7eKAyIDfNeUBVy5jlnx1u7OmcjDMMnz424XkC0XQR9DsJ10kvOIUmb8SIML028s9ZmSxRZ00a3bxr1dh');

exports.createStripePaymentIntent = onCall(
    { region: "us-central1", memory: "256MiB" },
    async (request) => {
        console.log("Function triggered", { uid: request.auth?.uid, data: request.data });
        try {
            // 1. Authentication check
            if (!request.auth) {
                console.log("Unauthenticated request");
                throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
            }

            // 2. Input validation
            const { amount, currency, orderId } = request.data;
            if (typeof amount !== "number" || !currency) {
                console.log("Invalid input", { amount, currency });
                throw new functions.https.HttpsError("invalid-argument", "Missing or invalid amount/currency");
            }

            // 3. Create PaymentIntent
            console.log("Creating payment intent", { amount, currency });
            const paymentIntent = await stripe.paymentIntents.create({
                amount: Math.round(amount * 100),
                currency: currency.toLowerCase(),
                automatic_payment_methods: { enabled: true },
                metadata: {
                    userId: request.auth.uid,
                    orderId: orderId || "",
                    environment: "development"
                }
            });
            console.log("PaymentIntent created", { id: paymentIntent.id });

            // 4. Update Firestore (Optional)

            // 5. Return client secret
            return { clientSecret: paymentIntent.client_secret };
        } catch (error) {
            // Structured error logging
            console.log("Error in createStripePaymentIntent", {
                message: error.message,
                stack: error.stack
            });
            // Rethrow as HttpsError for client-side clarity
            const code = (error instanceof functions.https.HttpsError) ? error.code : "internal";
            throw new functions.https.HttpsError(code, error.message);
        }
    }
);