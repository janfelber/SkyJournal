import 'package:flutter/material.dart';

class InfoStatsList extends StatelessWidget {
  final List<String> stats;

  InfoStatsList(this.stats);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stats.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(stats[index]),
              // Čiara medzi položkami
              subtitle: Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
            ),
            // Medzera medzi čiarou a nasledujúcim záznamom (nepovinné)
            SizedBox(height: 10.0),
          ],
        );
      },
    );
  }
}
