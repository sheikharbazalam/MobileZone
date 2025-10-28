const { onCall } = require('firebase-functions/v2/https');
const { getAuth } = require('firebase-admin/auth');
const logger = require('firebase-functions/logger');

exports.deleteUserByEmail = onCall(async (request) => {
  const { email } = request.data; // Extract email from request data
  const authContext = request.auth; // Authentication context of the caller

  // Authentication check
  if (!authContext || !authContext.token) {
    logger.error('Unauthenticated request attempted to delete a user.');
    throw new Error('The request is unauthenticated.');
  }

  // Authorization check (ensure the caller has admin privileges)
  if (!authContext.token.admin) {
    logger.error('Unauthorized request attempted to delete a user.');
    throw new Error('You do not have permission to perform this action.');
  }

  // Input validation
  if (!email || typeof email !== 'string' || !email.includes('@')) {
    logger.error('Invalid email provided for user deletion.');
    throw new Error("Invalid request: 'email' must be a valid email address.");
  }

  try {
    // Fetch the user by email
    const userRecord = await getAuth().getUserByEmail(email);

    // Extract UID from the user record
    const uid = userRecord.uid;

    // Log user information before deletion
    logger.info(`Deleting user: UID = ${uid}, Email = ${email}`);

    // Delete the user using UID
    await getAuth().deleteUser(uid);

    logger.info(`User with email ${email} successfully deleted.`);
    return { message: `User with email ${email} deleted successfully.` };
  } catch (error) {
    // Log and handle errors
    logger.error('Error deleting user:', error);

    if (error.code === 'auth/user-not-found') {
      throw new Error('The user with the provided email does not exist.');
    } else if (error.code === 'auth/invalid-email') {
      throw new Error('The provided email address is badly formatted.');
    } else {
      throw new Error(`Deletion failed: ${error.message}`);
    }
  }
});
