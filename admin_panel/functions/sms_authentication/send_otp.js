const admin = require("firebase-admin");
const axios = require("axios");
const { onCall } = require("firebase-functions/v2/https");


// Configuration - Replace with your actual credentials
const INFOBIP_API_KEY = "Add API KEY Here";
const INFOBIP_BASE_URL = "Add Base URL Here";
const SENDER_ID = "TSTore";

const MAX_RESEND_ATTEMPTS = 3;
const RESEND_COOLDOWN = 60; // Seconds

// Export the Cloud Function using the v2 onRequest handler
exports.sendOtpHandler = onCall( async (request) => {
    try {
        const {phoneNumber, msg} = request.data;

        console.log("Received phone from phoneNumber: " + phoneNumber);
        console.log("Received phone from req.data: " + request.data.phoneNumber);

        // Check if the phone number is provided
        if (!phoneNumber) {
            throw new functions.https.HttpsError('invalid-argument', 'Phone number is required.');
        }


        // Basic phone number validation
        if (!phoneNumber.startsWith('+') || phoneNumber.length < 8) {
            throw new functions.https.HttpsError('invalid-argument', 'Invalid phone number format. Use E.164 format (e.g., +923329121290)');
        }

        // 3. Firestore document path validation
        if (typeof phoneNumber !== 'string' || phoneNumber.trim() === '') {
            console.error('Invalid document path:', { phoneNumber });
            throw new functions.https.HttpsError('invalid-argument', 'Invalid phone number - cannot be empty');
        }


        // 5. Firestore document operations
        const otpDocRef = admin.firestore().collection("OtpRequests").doc(phoneNumber);



        // 4. Generate OTP
        const otp = Math.floor(100000 + Math.random() * 900000).toString();


        await otpDocRef.set({
            code: otp,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            expiresAt: Date.now() + 600000 // 10 minutes expiration
        });

        let message = `Your verification code for H-24 is ${otp}. Do not share this code with anyone.`;

        if (msg) {
            message = msg;
        }

        // 6. Send SMS via InfoBip API
        const response = await axios.post(
            `${INFOBIP_BASE_URL}/sms/2/text/advanced`,
            {
                messages: [{
                    destinations: [{ to: phoneNumber }],
                    from: SENDER_ID,
                    text: message
                }]
            },
            {
                headers: {
                    "Authorization": `App ${INFOBIP_API_KEY}`,
                    "Content-Type": "application/json"
                },
                timeout: 10000  // 10-second timeout
            }
        );

        // 7. Handle successful response
        return {
            status: 200,
            success: true,
            message: "OTP sent successfully",
        };

    } catch (error) {
        // 8. Enhanced error handling
        console.error("Full Error Details:", {
            error: error.message,
            stack: error.stack,
            requestBody: req.body
        });

        let errorMessage = "Failed to send OTP";
        let statusCode = 500;

        // Handle Firestore document path errors
        if (error.message.includes("valid resource path")) {
            errorMessage = "Invalid phone number format - contains illegal characters";
            statusCode = 400;
        }
        // Handle Axios errors
        else if (error.response) {
            errorMessage = `SMS service error: ${error.response.status}`;
            console.error("InfoBip API Response:", error.response.data);
        }

        return {
            status: statusCode,
            success: false,
            message: errorMessage
        };
    }
});