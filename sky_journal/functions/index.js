const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const { DateTime } = require('luxon');

exports.sendNotificationBeforeAppointment = functions.pubsub.schedule('0 0 * * *').timeZone('Europe/Bratislava').onRun(async (context) => {
  // Get all appointments from Firestore
  const appointmentsRef = admin.firestore().collection('doctor-applications');
  // Get current date and format it to day month year (12 January 2024)
  const now = DateTime.now().setZone('Europe/Bratislava').toFormat('dd LLLL yyyy');

  try {
    const appointmentsSnapshot = await appointmentsRef.get();

    appointmentsSnapshot.forEach(async (doc) => {
      // Get appointment data
      const appointmentData = doc.data();
      // Get appointment date and format it to day month year (12 January 2024)
      const appointmentDate = appointmentData.Date;
      const appointmentDateTime = DateTime.fromMillis(appointmentDate.seconds * 1000).setZone('Europe/Bratislava').toFormat('dd LLLL yyyy');

      // Check if appointment date is today
      if (appointmentDateTime === now) {
        // Get FCM token, notification status, doctor name and time of the appointment
        const { FcmToken, notificationSent, DoctorName, Time } = appointmentData;

        console.log('FCM token:', FcmToken);
        console.log('Stav notifikácie:', notificationSent);

        // Check if notification was already sent
        if (notificationSent) {
          console.log('Notification already sent.');
          return;
        }

        // Prepare notification payload
        const payload = {
          notification: {
            title: 'Doctor Appointment Reminder',
            body: 'Dr. ' + DoctorName + ' at ' + Time,
          },
        };

        try {
          // Send notification to the user - FCM token is used to identify the device
          await admin.messaging().sendToDevice(FcmToken, payload);
          await doc.ref.update({ notificationSent: true });
          console.log('Notification was successfully sent.');
        } catch (error) {
          console.error('Error in sending: ', error);
        }
      }
    });
  } catch (error) {
    console.error('Error in getting data from Firestore: ', error);
  }
});
