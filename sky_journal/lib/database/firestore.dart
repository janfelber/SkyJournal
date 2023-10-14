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

  // get collection of flights from firebase
  final CollectionReference flights =
      FirebaseFirestore.instance.collection('flights');

  //add flight to firestore
  Future<void> addFlight(
      String flightNumber,
      String startDate,
      String endDate,
      String startDestination,
      String endDestination,
      String timeOfTakeOff,
      String timeOfLanding,
      String airLine) {
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
}
