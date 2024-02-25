// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DoctorAppointment extends StatefulWidget {
  final void Function() completedAppointment;
  final void Function() cancelAppointment;
  final String doctorName;
  final String date;
  final String time;
  final String doctorSpeciality;
  final String status;
  final String appointmentId;

  const DoctorAppointment({
    super.key,
    required this.completedAppointment,
    required this.cancelAppointment,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.doctorSpeciality,
    required this.status,
    required this.appointmentId,
  });

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  Icon getStatusIcon(String status) {
    switch (status) {
      case 'Upcoming':
        return Icon(Icons.schedule, color: Colors.blue);
      case 'Completed':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Canceled':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help_outline, color: Colors.grey); // Default case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ListTile(
              title: Text("Dr. ${widget.doctorName}"),
              subtitle: Text("Speciality: ${widget.doctorSpeciality}"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 5),
                    Text("${widget.date}")
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 5),
                    Text("${widget.time}")
                  ],
                ),
                Row(
                  children: [
                    getStatusIcon(widget.status), // Use getStatusIcon here
                    SizedBox(width: 5),
                    Text("${widget.status}")
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            if (widget.status == 'Upcoming')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: widget.cancelAppointment,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.completedAppointment,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Complete",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
