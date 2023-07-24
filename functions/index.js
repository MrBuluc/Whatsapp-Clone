// firebase deploy --only functions:sendNotification
// firebase functions:delete sendNotification

/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();
const db = admin.firestore();

exports.sendNotification = functions.firestore
    .document("Conversations/{conversationId}/Messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      const {message, senderId} = snapshot.data();

      const conversationId = context.params.conversationId;

      (await db.collection("Conversations").doc(conversationId).get())
          .data()
          .members.filter((memberId) => memberId !== senderId)
          .map(async (otherMemberId) => {
            const token = (
              await db.collection("Users").doc(otherMemberId).get()
            ).data().token;

            if (!token) {
              return;
            }

            await admin.messaging().send({
              token,
              data: {conversationId, userId: senderId, memberId: otherMemberId},
              notification: {
                title: "You have a message",
                body: message,
              },
              android: {
                notification: {clickAction: "FLUTTER_NOTIFICATION_CLICK"},
              },
            });
          });
    });
