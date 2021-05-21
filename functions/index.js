const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { firestore } = require('firebase-admin');
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
exports.activityNotification = functions.firestore
    .document('plan/{planDoc}')
    .onUpdate(async (snapshot, context) => {
        const emails = await db.collection('group_chat').doc(context.params.planDoc).get()
            .then(doc => {
                return doc.data().messenger_id;
            }).catch(err => {
                console.log('Error getting document', err);
            });

            const newValue = snapshot.after.data();

            const previousValue = snapshot.before.data();

        try {
            for (const [key, value] of Object.entries(emails)) {
                if ((value !== null) && (newValue.activity_status !== previousValue.activity_status)) {
                    admin.messaging().sendToDevice(value, {
                        notification: {
                            title: newValue.activity_type + " is "+ newValue.activity_status,
                            body: "Have Fun..!",
                            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                        }
                    });
                }
            }
        } catch (e) {
            console.log('Error:', e);
        }
    });


    exports.broadcastNotification = functions.firestore
    .document('user_plans/{planDoc}')
    .onUpdate(async (snapshot, context) => {

        var msg, msg1;
        const newValue = snapshot.after.data();
        var planid = newValue.current_plans[newValue.current_plans.length];

        const doc = await db.collection("plan").document(planid).get().then(
            
        );
        const doc1 = await db.collection("users").document(doc.data().admin_id).get();

        if(newValue.admin_plans.contains(planid))
         msg1 = doc.data().admin_name+" has Created a new "+ doc.data().activity_type; 
        else
         msg = "You have been added to "+doc.data().admin_name+"'s activity";

        var value = doc1.data().token;
        try {
                if (value !== null) {
                    admin.messaging().sendToDevice(value, {
                        notification: {
                            title: msg,
                            body: "Enjoy..!",
                            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                        }
                    });
                }
        } catch (e) {
            console.log('Error:', e);
        }
    });

//final doc = await database.collection('users').document(CurrentUser.userEmail).get();

function checkDate(d, d1){
    var dates = d.getDate().toString()+" "+d.getMonth().toString()+" "+d.getFullYear().toString();
    var dates1 = d1.getDate().toString()+" "+d1.getMonth().toString()+" "+d1.getFullYear().toString();
    return (dates === dates1);
}