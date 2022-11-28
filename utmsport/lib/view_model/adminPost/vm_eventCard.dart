import 'package:flutter/material.dart';
import 'package:utmsport/model/m_Event.dart';

Widget EventCard(BuildContext context, int index, events) {
  String getId(index) => events[index]?["id"];
  String getName(index) => events[index]?["name"];
  String getDate(index) => events[index]?["date"];
  String getImage(index) =>
      events[index]?["image"] ??
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  String getPlatform(index) => events[index]?["platform"];
  String getVenue(index) => events[index]?["venue"];

  return InkWell(
      child: Card(
    elevation: 4.0,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(getName(index)),
                subtitle: Text(getDate(index)),
              ),
            ),
            ElevatedButton(
              onPressed: () => editEvents(context, events[index]),
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.black87),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.yellow),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () => deleteEvents(getId(index)),
              child: Text("Delete"),
              style: TextButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
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
