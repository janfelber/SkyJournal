import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geodesy/geodesy.dart';

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

  final CollectionReference doctorAppointment =
      FirebaseFirestore.instance.collection('docotor-applications');

  //add doctors apoointment to firestore
  Future<void> addDoctorAppointment(
    String doctorName,
    DateTime date,
    String time,
    String doctorSpeciality,
    String status,
  ) {
    return doctorAppointment.add({
      'UserEmail': user!.email,
      'Date': date,
      'Time': time,
      'DoctorName': doctorName,
      'DoctorSpeciality': doctorSpeciality,
      'Status': status,
    });
  }

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

  Stream<QuerySnapshot> getDoctorAppointmentStream() {
    final doctorAppointmentStream = FirebaseFirestore.instance
        .collection('docotor-applications')
        .orderBy('Date', descending: true)
        .snapshots();
    return doctorAppointmentStream;
  }

  updateDoctorAppointmentStatus(String appointmentId, String status) {
    doctorAppointment.doc(appointmentId).update({'Status': status});
  }

  //get numbers of flight for current user
  Future<int> getNumberOfFlights() async {
    final snapshot =
        await flights.where('UserEmail', isEqualTo: user!.email).get();
    return snapshot.docs.length;
  }

  //get total flight hour with minutes for current user
  Future<Map<String, dynamic>> calculateTotalHours() async {
    final snapshot =
        await flights.where('UserEmail', isEqualTo: user!.email).get();
    int totalHour = 0;
    int totalMinutes = 0;

    for (var doc in snapshot.docs) {
      var format = DateFormat("HH:mm");

      final startDate = (doc['TimeOfTakeOff']);
      final endDate = (doc['TimeOfLanding']);
      var one = format.parse(startDate);
      var two = format.parse(endDate);
      var differenceBetweenTimes = two.difference(one);
      var minutesOfFlight = differenceBetweenTimes.inMinutes.remainder(60);
      var hoursOfFlight = differenceBetweenTimes.inHours;

      totalHour += hoursOfFlight;
      totalMinutes += minutesOfFlight;
    }

    return {'hours': totalHour, 'minutes': totalMinutes};
  }

  //get most visited destination for current user

  Future<String> getMostVisitedDestination() async {
    // Získání snapshotu všech letů pro aktuálního uživatele
    final snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    // Mapa pro ukládání počtu výskytů každé destinace
    final Map<String, int> destinationCounts = {};

    // Projití každého dokumentu ve snapshotu
    for (var doc in snapshot.docs) {
      // Získání EndDestination z dokumentu
      final endDestination = doc['EndDestination'];

      // Inkrementace počtu výskytů dané destinace
      destinationCounts[endDestination] =
          (destinationCounts[endDestination] ?? 0) + 1;
    }

    // Nalezení destinace s největším počtem výskytů
    String mostVisitedDestination = '';
    int max = 0;
    destinationCounts.forEach((destination, count) {
      if (count > max) {
        max = count;
        mostVisitedDestination = destination;
      }
    });

    return mostVisitedDestination;
  }

  //get number of longest flight for current user
  Future<Map<String, dynamic>> getLongestFlight() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    int longestFlightInMinutes = 0;
    String longestFlightId = '';

    // Výpočet dĺžky letu pre každý let
    for (var doc in snapshot.docs) {
      var format = DateFormat("HH:mm");

      final startDate = doc['TimeOfTakeOff'];
      final endDate = doc['TimeOfLanding'];
      var takeOffTime = format.parse(startDate);
      var landingTime = format.parse(endDate);

      // Rozdiel v čase v minútach
      var differenceInMinutes = landingTime.difference(takeOffTime).inMinutes;

      // Ak je aktuálny let dlhší, aktualizujte najdlhší let
      if (differenceInMinutes > longestFlightInMinutes) {
        longestFlightInMinutes = differenceInMinutes;
        longestFlightId = doc['FlightNumber'];
      }
    }

    // Prevod na hodiny a minúty
    int hours = longestFlightInMinutes ~/ 60;
    int minutes = longestFlightInMinutes % 60;

    // Návratová hodnota: najdlhší let a jeho ID vo formáte hodín a minút
    return {'hours': hours, 'minutes': minutes, 'id': longestFlightId};
  }

  //get average of flghts for current user
  Future<Map<String, dynamic>> getAverageOfFlights() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    int totalFlights = snapshot.docs.length;
    int totalHours = 0;
    int totalMinutes = 0;

    for (var doc in snapshot.docs) {
      var format = DateFormat("HH:mm");

      final startDate = (doc['TimeOfTakeOff']);
      final endDate = (doc['TimeOfLanding']);
      var one = format.parse(startDate);
      var two = format.parse(endDate);
      var differenceBetweenTimes = two.difference(one);
      var minutesOfFlight = differenceBetweenTimes.inMinutes.remainder(60);
      var hoursOfFlight = differenceBetweenTimes.inHours;

      totalHours += hoursOfFlight;
      totalMinutes += minutesOfFlight;
    }

    int averageHours = totalHours ~/ totalFlights;
    int averageMinutes = totalMinutes ~/ totalFlights;

    return {'hours': averageHours, 'minutes': averageMinutes};
  }

  //update flight in firestore by flight number
  Future<void> updateFlight(
    String flightNumber,
    String startDate,
    String endDate,
    String startDestination,
    String endDestination,
    String timeOfTakeOff,
    String timeOfLanding,
    String airLine,
  ) {
    return flights
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('FlightNumber', isEqualTo: flightNumber)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Flight not found');
      } else {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'StartDate': startDate,
            'EndDate': endDate,
            'StartDestination': startDestination,
            'EndDestination': endDestination,
            'TimeOfTakeOff': timeOfTakeOff,
            'TimeOfLanding': timeOfLanding,
            'Airline': airLine,
          });
        });
      }
    });
  }

  //get location from city name
  Future<LatLng> getLocationFromCityName(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      } else {
        throw Exception('No location found for the city name: $cityName');
      }
    } catch (e) {
      print('Error while getting location: $e');
      rethrow; // rethrow the exception for handling it at a higher level
    }
  }

  //calculate total distance of all flights for current user
  Future<double> calculateTotalDistance() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    double totalDistance = 0;

    for (var doc in snapshot.docs) {
      final startDestination = doc['StartDestination'];
      final endDestination = doc['EndDestination'];

      final startCoordinates = await getLocationFromCityName(startDestination);
      final endCoordinates = await getLocationFromCityName(endDestination);

      final distance = Geodesy().distanceBetweenTwoGeoPoints(
        LatLng(startCoordinates.latitude, startCoordinates.longitude),
        LatLng(endCoordinates.latitude, endCoordinates.longitude),
      );

      totalDistance += distance;
    }

    double totalDistanceInKm = totalDistance / 1000;
    totalDistanceInKm = double.parse(totalDistanceInKm.toStringAsFixed(0));

    return totalDistanceInKm;
  }
}
