const { onRequest } = require("firebase-functions/v2/https");
const Stripe = require("stripe");
const stripe = new Stripe('sk_test_YourDirectStripeSecretKey');
const admin = require("firebase-admin");

exports.handleStripeWebhook = onRequest(
    { region: "us-central1", maxInstances: 3 },
    async (req, res) => {
        const sig = req.headers["stripe-signature"];
        const webhookSecret = "whsec_YourWebhookSigningSecret";

        try {
            const event = stripe.webhooks.constructEvent(
                req.rawBody,
                sig,
                webhookSecret
            );

            switch (event.type) {
                case "payment_intent.succeeded":
                    await handlePaymentSuccess(event.data.object);
                    break;

                case "payment_intent.payment_failed":
                    await handlePaymentFailure(event.data.object);
                    break;

                default:
                    console.log(`Unhandled event: ${event.type}`);
            }

            res.status(200).send();
        } catch (err) {
            console.error("Webhook Error:", err);
            res.status(400).send(`Webhook Error: ${err.message}`);
        }
    }
);

async function handlePaymentSuccess(paymentIntent) {
    const orderId = paymentIntent.metadata.orderId;
    const amount = paymentIntent.amount_received / 100;

    await admin.firestore().collection("orders").doc(orderId).update({
        paymentStatus: "paid",
        amountCaptured: amount,
        paymentMethod: paymentIntent.payment_method_types[0],
        receiptUrl: paymentIntent.charges.data[0].receipt_url,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
}

async function handlePaymentFailure(paymentIntent) {
    const orderId = paymentIntent.metadata.orderId;

    await admin.firestore().collection("orders").doc(orderId).update({
        paymentStatus: "failed",
        paymentError: paymentIntent.last_payment_error?.message || "Payment failed",
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
}