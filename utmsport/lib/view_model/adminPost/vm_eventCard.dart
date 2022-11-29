import 'package:flutter/material.dart';

import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/globalVariable.dart' as global;

Widget EventCard(BuildContext context, int index, event) {
  String getId() => event?["id"];
  String getName() => event?["name"] ?? "";
  String getDate() => event?["date"] ?? "";
  String getImage() =>
      event?["image"] ??
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  String getPlatform() => event?["platform"] ?? "";
  String getVenue() => event?["venue"] ?? "";
  List<Widget> actionButtons = global.getUserRole() == 'admin'
      ? [
          IconButton(
            onPressed: () => editEvents(context, event.data()),
            icon: Icon(
              Icons.edit,
              color: Colors.orange[200],
            ),
          ),
          IconButton(
            onPressed: () => deleteEvents(context, getId()),
            icon: Icon(
              Icons.delete,
              color: Colors.red[200],
            ),
          ),
        ]
      : [];

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
            IconButton(
              onPressed: () => print("View details"),
              icon: Icon(
                Icons.info,
                color: Colors.blue[200],
              ),
            ),
            ...actionButtons,
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            event?["description"],
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
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
      ],
    ),
  )
      // onTap: () => MaterialPageRoute(
      //     builder: (context) =>
      //         SecondRoute(id: event.getId(), name: event.getName())),
      );
}
