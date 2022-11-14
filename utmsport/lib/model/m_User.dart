// To parse this JSON data, do
//
//     final userDb = userDbFromJson(jsonString);

import 'dart:convert';

class UserDb {
  UserDb({
    required this.id,
    required this.name,
    required this.roles,
    required this.userId,
  });

  String id;
  String name;
  String roles;
  String userId;

  factory UserDb.fromRawJson(String str) => UserDb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDb.fromJson(Map<String, dynamic> json) => UserDb(
    id: json["id"],
    name: json["name"],
    roles: json["roles"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "roles": roles,
    "userId": userId,
  };

  displayName(){
    return this.name;
  }
}
