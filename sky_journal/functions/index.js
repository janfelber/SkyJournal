const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const { DateTime } = require('luxon');

exports.sendNotificationBeforeAppointment = functions.pubsub.schedule('0 0 * * *').timeZone('Europe/Bratislava').onRun(async (context) => {
  // Get all appointments from Firestore
  const appointmentsRef = admin.firestore().collection('doctor-appointment');
  // Get current date and format it to day month year (12 January 2024)
  const now = DateTime.now().setZone('Europe/Bratislava').toFormat('dd LLLL yyyy');

  try {
    const appointmentsSnapshot = await appointmentsRef.get();

    appointmentsSnapshot.forEach(async (doc) => {
      // Get appointment data
      const appointmentData = doc.data();
      // Get appointment date and format it to day month year (12 January 2024)
      const appointmentDate = appointmentData.Date;
      const appointmentStatus = appointmentData.Status;
      const appointmentDateTime = DateTime.fromMillis(appointmentDate.seconds * 1000).setZone('Europe/Bratislava').toFormat('dd LLLL yyyy');

      // Check if appointment date is today 
      if (appointmentDateTime === now && appointmentStatus === 'Upcoming') {
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
              title: `Today's Appointment: Dr. ${DoctorName}`,
              body: `Appointment at ${Time}`,
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
      //if appointment is not upcoming - its status is not 'Upcoming' or no appointment is today - do nothing
      if (appointmentStatus !== 'Upcoming' || appointmentDateTime !== now) {
        console.log('No appointment today.');
        return;
      }
    });
  } catch (error) {
    console.error('Error in getting data from Firestore: ', error);
  }
});

exports.sendNotificationBeforeExpiry = functions.pubsub.schedule('0 0 * * *').timeZone('Europe/Bratislava').onRun(async (context) => {
  // Get all licecense cards from Firestore
  const licenseCardRef = admin.firestore().collection('license-card');
  // Get current date and format it to day month year (12 January 2024)
  const now = DateTime.now();

  try {
    const licenseCardSnapshot = await licenseCardRef.get();

    licenseCardSnapshot.forEach(async (doc) => {
      // Get license card data
      const licenseCardData = doc.data();
      // Get license card and format it to day month year (12 January 2024)
      const licenseCardDate = DateTime.fromFormat(licenseCardData.DateOfExpiry, 'dd.MM.yyyy', { zone: 'Europe/Bratislava' });
      const licenseCardDateFormat = licenseCardDate.toFormat('dd LLLL yyyy');
      
      const diffInDays = licenseCardDate.diff(now, 'days').days;
      console.log('Difference in days:', diffInDays);

      // Check if license card is less than 7 days
      if (diffInDays < 7) {
          console.log('less than 7 days.');
          // Get FCM token, notification status
          const { FcmToken, notificationSent, CertificateNumber} = licenseCardData;

          if(notificationSent){
            console.log('Notification already sent.');
            return;
          }

          // Prepare notification payload
          const payload = {
            notification: {
              title: 'License Card Expiring Soon: ' + CertificateNumber ,
              body: 'Card will expire in 7 days - ' + licenseCardDateFormat,
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
        };
      }
    );
  } catch (error) {
    console.error('Error in getting data from Firestore: ', error);
  }
}
);