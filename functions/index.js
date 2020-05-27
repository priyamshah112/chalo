const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.chatNotification = functions.firestore
    .document('group_chat/{chatDoc}/chat/{message}')
    .onCreate((snapshot, context) => {
        console.log(snapshot.data());
        return admin.messaging().sendToTopic('chat', {
            notification: {
                title: 'Message from '+snapshot.data().name,
                body: snapshot.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        });
    });
