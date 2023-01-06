import 'package:flutter/material.dart';
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
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            getImage(),
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.contain,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              direction: Axis.vertical,
                              spacing: 8,
                              children: [

                                  Text(
                                    getName(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                SizedBox(height: 10,),
                                Wrap(spacing:5,children: [
                                  Icon(Icons.perm_device_information),
                                  Text(getDescription(), style: TextStyle(fontSize: 15),)
                                ]),
                                Wrap(spacing:5,children: [
                                  Icon(Icons.calendar_today),
                                  Text(getDate(), style: TextStyle(fontSize: 15),)
                                ]),
                                Wrap(spacing: 5,
                                  children: [
                                    Icon(Icons.meeting_room_outlined),
                                    Text(getPlatform(), style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                                Wrap(spacing: 5,
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(getVenue(), style: TextStyle(fontSize: 15),),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
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
    ),
  );
}
