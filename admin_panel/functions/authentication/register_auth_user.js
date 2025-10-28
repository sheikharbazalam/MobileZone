const { onCall } = require('firebase-functions/v2/https');
const { getAuth } = require('firebase-admin/auth');
const logger = require('firebase-functions/logger');

exports.registerUser = onCall(async (request) => {
  const { email, password } = request.data;

  // Input validation
  if (!email || typeof email !== 'string' || !email.includes('@')) {
    logger.error('Invalid email provided for registration.');
    throw new Error("Invalid request: 'email' must be a valid email address.");
  }

  if (!password || typeof password !== 'string' || password.length < 4) {
    logger.error('Invalid password provided for registration.');
    throw new Error(
      "Invalid request: 'password' must be a string with at least 4 characters."
    );
  }

  try {
    // Create user
    const user = await getAuth().createUser({
      email: email.trim(),
      password: password.trim(),
    });

    // Log success
    logger.info(`User registered successfully: ${user.uid}`);

    // Return user data
    return {
      message: 'User registered successfully.',
      user: {
        uid: user.uid,
        email: user.email,
      },
    };
  } catch (error) {
    // Log error
    logger.error('Error registering user:', error);

    // Provide user-friendly error messages
    if (error.code === 'auth/email-already-exists') {
      throw new Error('The email is already registered. Please use another email.');
    } else if (error.code === 'auth/invalid-password') {
      throw new Error('The password is invalid or does not meet security requirements.');
    } else if (error.code === 'auth/invalid-email') {
      throw new Error('The email address is badly formatted.');
    } else {
      throw new Error(`Registration failed: ${error.message}`);
    }
  }
});
