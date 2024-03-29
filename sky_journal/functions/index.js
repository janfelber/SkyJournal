const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationBeforeAppointment = functions.pubsub.schedule('0 0 * * *').timeZone('Europe/Bratislava').onRun(async (context) => {
  const appointmentsRef = admin.firestore().collection('docotor-applications');
  const now = admin.firestore.Timestamp.now();

  try {
    const appointmentsSnapshot = await appointmentsRef.where('Date', '>', now).get();

    appointmentsSnapshot.forEach(async (doc) => {
      const appointmentData = doc.data();

      
      const {FcmToken, notificationSent, DoctorName, Time } = appointmentData;

      console.log('FCM token:', FcmToken);
      console.log('Stav notifikácie:', notificationSent);

      if (notificationSent) {
        console.log('Notification already sent.');
        return;
      }

      const payload = {
        
        notification: {
          //title for the notification
          title: 'Doctor Appointment Reminder',
          //body of the notification
          body: 'Dr. ' + DoctorName + ' at ' + Time,
        },
      };

      try {
        // Send notification to the user
        await admin.messaging().sendToDevice(FcmToken, payload);
        await doc.ref.update({ notificationSent: true });
        console.log('Notification was successfully sent.');
      } catch (error) {
        console.error('Error in sending: ', error);
      }
    });
  } catch (error) {
    console.error('Error in getting data from Firestore: ', error);
  }
});
