const { onCall } = require("firebase-functions/v2/https");
const { getAuth } = require("firebase-admin/auth");

// Add Admin Role Function
exports.addAdminRole = onCall(async (request) => {
  const { email } = request.data;

  if (!email || typeof email !== "string") {
    throw new Error("Invalid request. 'email' must be provided and should be a valid string.");
  }

  try {
    // Fetch user by email
    const user = await getAuth().getUserByEmail(email);

    // Check if user already has the admin role
    if (user.customClaims?.admin) {
      return { message: `${email} is already an admin.` };
    }

    // Set custom claims for admin role
    await getAuth().setCustomUserClaims(user.uid, { admin: true });

    return { message: `Success! ${email} has been made an admin.` };
  } catch (error) {
    console.error("Error adding admin role:", error.message);
    throw new Error(`Adding admin role failed: ${error.message}`);
  }
});
