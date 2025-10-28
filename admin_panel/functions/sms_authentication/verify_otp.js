const admin = require("firebase-admin");
const { onCall } = require("firebase-functions/v2/https");
const functions = require("firebase-functions");

exports.verifyOtpHandler = onCall(async (request) => {
    try {
        const { phoneNumber, otp } = request.data;

        // Validate input parameters
        if (!phoneNumber || !otp) {
            throw new functions.https.HttpsError(
                'invalid-argument',
                'Both phone number and OTP code are required'
            );
        }

        // Validate phone format
        if (!phoneNumber.startsWith('+') || phoneNumber.length < 8) {
            throw new functions.https.HttpsError(
                'invalid-argument',
                'Invalid phone number format. Use E.164 format (e.g., +923329121290)'
            );
        }

        // Get OTP document reference
        const otpRef = admin.firestore().collection("OtpRequests").doc(phoneNumber);
        const otpDoc = await otpRef.get();

        if (!otpDoc.exists) {
            throw new functions.https.HttpsError(
                'not-found',
                'No OTP request found for this number'
            );
        }

        const otpData = otpDoc.data();

        // Check expiration
        if (Date.now() > otpData.expiresAt) {
            await otpRef.delete();
            throw new functions.https.HttpsError(
                'deadline-exceeded',
                'OTP has expired. Please request a new one'
            );
        }

        // Verify code match
        if (otpData.code !== otp) {
            throw new functions.https.HttpsError(
                'permission-denied',
                'Invalid verification code'
            );
        }


        // Generate custom token without creating user
        const uid = `phone_${phoneNumber}`;
        console.log("UID : " + uid);
        let userRecord;

        try {
            userRecord = await admin.auth().getUser(uid);
            console.log("Existing user found:", uid);
        } catch (error) {
            if (error.code === 'auth/user-not-found') {
                console.log("Creating new user for:", phoneNumber);
                userRecord = await admin.auth().createUser({
                    uid: uid,
                    phoneNumber: phoneNumber
                });
            } else {
                throw error;
            }
        }



        const token = await admin.auth().createCustomToken(uid);
        console.log("Token : " + token);


        // Cleanup OTP record
        await otpRef.delete();

        return {
            status: 200,
            success: true,
            message: "Verification successful",
            token: token,
            uid: uid
        };

    } catch (error) {
        console.error("Verification Error:", {
            errorCode: error.code,
            errorMessage: error.message,
            stack: error.stack,
            inputData: request.data
        });

        // Handle specific permission error
        if (error.code === 'auth/insufficient-permission') {
            throw new functions.https.HttpsError(
                'permission-denied',
                'Server configuration error. Please contact support.'
            );
        }

        // Re-throw properly formatted errors
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }

        throw new functions.https.HttpsError(
            error.code,
            error.message
        );
    }
});