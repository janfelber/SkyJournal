import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*

This database stores added flights in the firestore database.
It is stored in collection called 'flights' in Firebase.

Each flight contains the following fields:

- start destination
- end destination
- date of departure
- date of arrival
- flight number
- airline
- time of flight
- 
*/

class FirestoreDatabase {
  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get colletion of health insurance cards from firebase
  final CollectionReference healthInsuranceCards =
      FirebaseFirestore.instance.collection('health-insurance-card');

  // get collection of licenseCards from firebase
  final CollectionReference licenseCards =
      FirebaseFirestore.instance.collection('license-card');

  // get collection of flights from firebase
  final CollectionReference flights =
      FirebaseFirestore.instance.collection('flights');

  //add health insurance card to firestore
  Future<void> addHealthCard(
    String dateOfBirth,
    String personalNumber,
    String numberOfInsuranceInstitution,
    String numberOfInsuranceCard,
    String dateOfIssue,
    String dateOfExpiry,
  ) {
    return healthInsuranceCards.add({
      'UserEmail': user!.email,
      'DateOfBirth': dateOfBirth,
      'PersonalNumber': personalNumber,
      'NumberOfInsuranceInstitution': numberOfInsuranceInstitution,
      'NumberOfInsuranceCard': numberOfInsuranceCard,
      'DateOfIssue': dateOfIssue,
      'DateOfExpiry': dateOfExpiry,
    });
  }

  //add license card to firestore
  Future<void> addLicenseCard(
    String nationality,
    String dateOfBirth,
    String certificateNumber,
    String dateOfIssue,
    String dateOfExpiry,
    String sex,
    String height,
    String weight,
    String hair,
    String eyes,
  ) {
    return licenseCards.add({
      'UserEmail': user!.email,
      'Nationality': nationality,
      'DateOfBirth': dateOfBirth,
      'CertificateNumber': certificateNumber,
      'DateOfIssue': dateOfIssue,
      'DateOfExpiry': dateOfExpiry,
      'Sex': sex,
      'Height': height,
      'Weight': weight,
      'Hair': hair,
      'Eyes': eyes
    });
  }

  //add flight to firestore
  Future<void> addFlight(
    String flightNumber,
    String startDate,
    String endDate,
    String startDestination,
    String endDestination,
    String timeOfTakeOff,
    String timeOfLanding,
    String airLine,
    String numbersOfPassengers,
    String avgSpeed,
  ) {
    return flights.add({
      'UserEmail': user!.email,
      'FlightNumber': flightNumber,
      'StartDate': startDate,
      'EndDate': endDate,
      'StartDestination': startDestination,
      'EndDestination': endDestination,
      'TimeOfTakeOff': timeOfTakeOff,
      'TimeOfLanding': timeOfLanding,
      'Airline': airLine,
      'NumberOfPassangers': numbersOfPassengers,
      'AvarageSpeed': avgSpeed,
      'TimeStamp': Timestamp.now(),
    });
  }

  //read flight from firebase
  Stream<QuerySnapshot> getFlightsStream() {
    final flightsStream = FirebaseFirestore.instance
        .collection('flights')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
    return flightsStream;
  }

  Stream<QuerySnapshot> getCardStream() {
    final cardStream =
        FirebaseFirestore.instance.collection('license-card').snapshots();
    return cardStream;
  }
}
