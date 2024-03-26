const functions = require('firebase-functions');
const admin = require('firebase-admin');


admin.initializeApp();
const database = admin.firestore();


exports.sendNotification = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const querySnapshot = await database.collection('docotor-applications').where("Date", '<=' , admin.firestore.Timestamp.now()).where('Status', '==', 'Upcoming').where("notificationSent", "==" , false).get();

    function sendNotification(token) {
        let title = 'Upcoming Appointment';
        let body = 'You have an upcoming appointment';

        querySnapshot.forEach(async (doc) => {
            sendNotification(doc.data().token);
            await database.collection('docotor-applications/' + snapshot.data().token).update({ "notificationSent": true });
        });

        const message = {
            notification: { title: title, body: body },
            token: token,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        admin.messaging().send(message).then(response => {
            console.log('Successfully sent message:', response);
        }).catch(error => {
            console.log('Error sending message:', error);
        });
    }
});