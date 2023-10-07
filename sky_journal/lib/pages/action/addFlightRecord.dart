import 'package:flutter/material.dart';

void addFlightRecord(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.0),
      ),
    ),
    builder: (BuildContext bc) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.93,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              // Horná časť s šedou farbou
              decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 30, 32, 100),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Flight',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Ďalší obsah modálneho okna
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Start Destination',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextButton(
                    onPressed: null,
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
