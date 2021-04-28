const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

const db = admin.firestore();
exports.chatNotification = functions.firestore
    .document('group_chat/{chatDoc}/chat/{message}')
    .onCreate(async (snapshot, context) => {
        const emails = await db.collection('group_chat').doc(context.params.chatDoc).get()
            .then(doc => {
                return doc.data().messenger_id;
            }).catch(err => {
                console.log('Error getting document', err);
            });

        try {
            for (const [key, value] of Object.entries(emails)) {
                if (value !== null) {
                    admin.messaging().sendToDevice(value, {
                        notification: {
                            title: 'Message from ' + snapshot.data().sender_name,
                            body: snapshot.data().message_content,
                            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                        }
                    });
                }
            }
        } catch (e) {
            console.log('Error:', e);
        }
    });   
