import * as functions from 'firebase-functions';

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  // Handle new user creation
  console.log('New user created:', user.uid);
});
