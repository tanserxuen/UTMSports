import 'package:flutter/material.dart';
import 'package:utmsport/model/m_Event.dart';

Widget EventCard(BuildContext context, int index, event) {
  String getId() => event?["id"];
  String getName() => event?["name"]??"";
  String getDate() => event?["date"]??"";
  String getImage() =>
      event?["image"] ??
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  String getPlatform() => event?["platform"]??"";
  String getVenue() => event?["venue"]??"";

  return InkWell(
      child: Card(
    elevation: 4.0,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(getName()),
                subtitle: Text(getDate()),
              ),
            ),
            ElevatedButton(
              onPressed: () => editEvents(context, event.data()),
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
              onPressed: () => deleteEvents(getId()),
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
                  child: Image.network(getImage()),
                )),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Venue: ${getVenue()}"),
                Text("Platform: ${getPlatform()}"),
              ],
            )),
          ],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Expanded(
            child: new Text(
              event?["description"],
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
      //         SecondRoute(id: event.getId(), name: event.getName())),
      );
}
