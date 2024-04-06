// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, prefer_final_fields

import 'package:intl/intl.dart';
import 'package:sky_journal/imports/flight_module_imports/flight_imports.dart';

class Flights extends StatefulWidget {
  final String? userName;
  const Flights({
    Key? key,
    this.userName,
  }) : super(key: key);

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  final FirestoreDatabase database = FirestoreDatabase();

  TextEditingController _searchController = TextEditingController();

  // Focus state for search bar
  bool isFocused = false;

  // Calculate length of flight
  String calculateLengthOfFlight(String departureTime, String arrivalTime) {
    var format = DateFormat("HH:mm");
    var one = format.parse(departureTime);
    var two = format.parse(arrivalTime);

    var differenceBetweenTimes = two.difference(one);
    var hoursOfFlight = differenceBetweenTimes.inHours;
    var minutesOfFlight = differenceBetweenTimes.inMinutes.remainder(60);

    return '$hoursOfFlight h $minutesOfFlight min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Column(
            children: [
              // Greetings Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${widget.userName}!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        getCurrentDate('MMMM dd, yyyy'),
                        style: TextStyle(color: Colors.blue[200]),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contex) {
                              return AddFlightPage();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 25,
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: isFocused ? Colors.blue : Colors.grey,
                    ),
                    label: Text(
                      'Search Flights',
                      style: TextStyle(
                        color: isFocused ? Colors.grey : Colors.grey,
                      ),
                    ),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    setState(() {
                      isFocused = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isFocused = false;
                    });
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              StreamBuilder(
                stream: database.getFlightsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final flights = snapshot.data!.docs;
                  final List<QueryDocumentSnapshot> userFlights = [];

                  // Get current user
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser != null) {
                    // Get flights for the current user
                    for (var flight in flights) {
                      String userEmailAddress = flight['UserEmail'];

                      if (userEmailAddress == currentUser.email) {
                        userFlights.add(flight);
                      }
                    }
                  }

                  if (_searchController.text.isNotEmpty) {
                    userFlights.removeWhere((flight) {
                      String flightNumber =
                          flight['FlightNumber'].toString().toLowerCase();
                      String startDestination =
                          flight['StartDestination'].toString().toLowerCase();
                      String endDestination =
                          flight['EndDestination'].toString().toLowerCase();
                      String startDate =
                          flight['StartDate'].toString().toLowerCase();
                      String endDate =
                          flight['EndDate'].toString().toLowerCase();
                      String timeOfTakeOff =
                          flight['TimeOfTakeOff'].toString().toLowerCase();
                      String timeOfLanding =
                          flight['TimeOfLanding'].toString().toLowerCase();
                      String airline =
                          flight['Airline'].toString().toLowerCase();
                      String numOfPassengers =
                          flight['NumberOfPassangers'].toString().toLowerCase();
                      String avgSpeed =
                          flight['AvarageSpeed'].toString().toLowerCase();
                      String searchQuery = _searchController.text.toLowerCase();
                      String typeOfAircraft =
                          flight['TypeOfAircraft'].toString().toLowerCase();
                      String pilotFunction =
                          flight['PilotFunction'].toString().toLowerCase();
                      return !flightNumber.contains(searchQuery) &&
                          !startDestination.contains(searchQuery) &&
                          !endDestination.contains(searchQuery) &&
                          !startDate.contains(searchQuery) &&
                          !endDate.contains(searchQuery) &&
                          !timeOfTakeOff.contains(searchQuery) &&
                          !timeOfLanding.contains(searchQuery) &&
                          !airline.contains(searchQuery) &&
                          !numOfPassengers.contains(searchQuery) &&
                          !avgSpeed.contains(searchQuery) &&
                          !typeOfAircraft.contains(searchQuery) &&
                          !pilotFunction.contains(searchQuery);
                    });
                  }
                  // If there are no flights for the current user
                  if (userFlights.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          'No flights for the current user',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: userFlights.length,
                      itemBuilder: (context, index) {
                        final flight = userFlights[index];

                        String flightNumber = flight['FlightNumber'];
                        String startDate = flight['StartDate'];
                        String endDate = flight['EndDate'];
                        String startDestination = flight['StartDestination'];
                        String endDestination = flight['EndDestination'];
                        String timeOfTakeOff = flight['TimeOfTakeOff'];
                        String timeOfLanding = flight['TimeOfLanding'];
                        String airline = flight['Airline'];
                        String numOfPassengers = flight['NumberOfPassangers'];
                        String avgSpeed = flight['AvarageSpeed'];
                        String typeOfAircraft = flight['TypeOfAircraft'];
                        String pilotFunction = flight['PilotFunction'];

                        return MyListTile(
                            flightNumber: flightNumber,
                            startDate: startDate,
                            endDate: endDate,
                            startDestination: startDestination.toUpperCase(),
                            endDestination: endDestination.toUpperCase(),
                            timeOfTakeOff: timeOfTakeOff,
                            timeOfLanding: timeOfLanding,
                            lengthOfFlight: calculateLengthOfFlight(
                                timeOfTakeOff, timeOfLanding),
                            onTap: () {
                              pushToNewPage(
                                  context,
                                  FlightDetailsPage(
                                    flightNumber: flightNumber,
                                    startDate: startDate,
                                    endDate: endDate,
                                    startDestination: startDestination,
                                    endDestination: endDestination,
                                    timeOfTakeOff: timeOfTakeOff,
                                    timeOfLanding: timeOfLanding,
                                    airline: airline,
                                    numbersOfPassengers: numOfPassengers,
                                    avgSpeed: avgSpeed,
                                    typeOfAircraft: typeOfAircraft,
                                    pilotFunction: pilotFunction,
                                  ));
                            });
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
