// To parse required this JSON data, do
//
//     final geofenceModel = geofenceModelFromJson(jsonString);

import 'dart:convert';

List<GeofenceModel> geofenceModelFromJson(String str) =>
    List<GeofenceModel>.from(
        json.decode(str).map((x) => GeofenceModel.fromJson(x)));

String geofenceModelToJson(List<GeofenceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeofenceModel {
  GeofenceModel({
    required this.id,
    required this.attributes,
    required this.calendarId,
    required this.name,
    required this.description,
    required this.area,
    required this.parentId,
    required this.directAccess,
    required this.groupAccess,
  });

  int id;
  Attributes attributes;
  int calendarId;
  String name;
  String description;
  String area;
  int parentId;
  bool directAccess;
  bool groupAccess;

  factory GeofenceModel.fromJson(Map<String, dynamic> json) => GeofenceModel(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
        calendarId: json["calendarId"],
        name: json["name"],
        description: json["description"],
        area: json["area"],
        parentId: json["parentId"],
        directAccess: json["directAccess"],
        groupAccess: json["groupAccess"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "calendarId": calendarId,
        "name": name,
        "description": description,
        "area": area,
        "parentId": parentId,
        "directAccess": directAccess,
        "groupAccess": groupAccess,
      };
}

class Attributes {
  Attributes({
    required this.type,
    required this.radius,
    required this.color,
    required this.latlng,
  });

  String type;
  double radius;
  String color;
  List<double> latlng;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        type: json["type"],
        radius: 0.0,
        //  json['type'] == "circle"
        //     ? json["radius"].toDouble()
        //     : 0.0,
        color: json["color"],
        latlng: List<double>.from(json["latlng"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "radius": radius,
        "color": color,
        "latlng": List<dynamic>.from(latlng.map((x) => x)),
      };
}
