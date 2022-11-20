import 'package:flutter/material.dart';

Widget EventCard(BuildContext context, int index, events) {
  String getName(index) => events[index]?["name"];
  String getDate(index) => events[index]?["name"];
  String getImage(index) =>
      events[index]?["image"] ??
      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg';
  String getPlatform(index) => events[index]?["platform"];
  String getVenue(index) => events[index]?["venue"];

  return InkWell(
      child: Card(
    elevation: 4.0,
    child: Column(
      children: [
        ListTile(
          title: Text(getName(index)),
          subtitle: Text(getDate(index)),
        ),
        Row(
          children: <Widget>[
            Container(
                height: 150.0,
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image.network(getImage(index)),
                )),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Venue: ${getVenue(index)}"),
                Text("Platform: ${getPlatform(index)}"),
              ],
            )),
          ],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Expanded(
            child: new Text(
              events[index]?["description"],
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ),
        ButtonBar(
          children: [
            TextButton(
              child: const Text('View Details'),
              onPressed: () {
                /* ... */
              },
            )
          ],
        )
      ],
    ),
  )
      // onTap: () => MaterialPageRoute(
      //     builder: (context) =>
      //         SecondRoute(id: events.getId(index), name: events.getName(index))),
      );
}
