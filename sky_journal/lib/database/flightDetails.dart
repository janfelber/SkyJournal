import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlightDetails {
  User? user = FirebaseAuth.instance.currentUser;
  // get collection of flights from firebase
  final CollectionReference flights =
      FirebaseFirestore.instance.collection('flights');

  Future<void> addFlight(
      String startDestination, String endDestination, String airLine) {
    return flights.add({
      'UserEmail': user!.email,
      'StartDestination': startDestination,
      'EndDestination': endDestination,
      'Airline': airLine,
      'TimeStamp': Timestamp.now(),
    });
  }
}
