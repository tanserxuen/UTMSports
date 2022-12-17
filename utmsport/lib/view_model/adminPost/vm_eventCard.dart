import 'package:flutter/material.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/utils.dart';

Widget EventCard(BuildContext context, int index, event) {
  String getId() => event?.id ?? "";
  String getName() => event?.name ?? "";
  String getDescription() => event?.description ?? "";
  String getDate() => Utils.parseDateTimeToFormatDate(event?.date) ?? "";
  String getImage() =>
      event?.image ??
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  String getPlatform() => event?.platform ?? "";
  String getVenue() => event?.venue ?? "";

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
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            getDescription(),
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
