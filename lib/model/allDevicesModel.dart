// To parse required this JSON data, do
//
//     final allDevicesModel = allDevicesModelFromJson(jsonString);

import 'dart:convert';

AllDevicesModel allDevicesModelFromJson(String str) =>
    AllDevicesModel.fromJson(json.decode(str));

String allDevicesModelToJson(AllDevicesModel data) =>
    json.encode(data.toJson());

class AllDevicesModel {
  AllDevicesModel({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasNext,
    required this.data,
  });

  int page;
  int pageSize;
  int total;
  bool hasNext;
  List<Datum> data;

  factory AllDevicesModel.fromJson(Map<String, dynamic> json) =>
      AllDevicesModel(
        page: json["page"],
        pageSize: json["pageSize"],
        total: json["total"],
        hasNext: json["hasNext"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "total": total,
        "hasNext": hasNext,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.entity,
    required this.parent,
    required this.extraInfo,
  });

  Entity entity;
  Parent parent;
  ExtraInfo extraInfo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        entity: Entity.fromJson(json["entity"]),
        parent: Parent.fromJson(json["parent"]),
        extraInfo: ExtraInfo.fromJson(json["extraInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "entity": entity.toJson(),
        "parent": parent.toJson(),
        "extraInfo": extraInfo.toJson(),
      };
}

class Entity {
  Entity({
    required this.id,
    required this.attributes,
    required this.groupId,
    required this.name,
    required this.uniqueId,
    required this.status,
    required this.positionId,
    required this.geofenceIds,
    required this.phone,
    required this.model,
    required this.contact,
    required this.category,
    required this.disabled,
    required this.parentId,
    required this.created,
    required this.directAccess,
    required this.groupAccess,
  });

  int id;
  Attributes attributes;
  int groupId;
  String name;
  String uniqueId;
  String status;
  int positionId;
  List<dynamic> geofenceIds;
  String phone;
  String model;
  String contact;
  String category;
  bool disabled;
  int parentId;
  DateTime created;
  bool directAccess;
  bool groupAccess;

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
        groupId: json["groupId"],
        name: json["name"],
        uniqueId: json["uniqueId"],
        status: json["status"],
        positionId: json["positionId"],
        geofenceIds: List<dynamic>.from(json["geofenceIds"].map((x) => x)),
        phone: json["phone"] == null ? null : json["phone"],
        model: json["model"],
        contact: json["contact"] == null ? null : json["contact"],
        category: json["category"] == null ? null : json["category"],
        disabled: json["disabled"],
        parentId: json["parentId"],
        created: DateTime.parse(json["created"]),
        directAccess: json["directAccess"],
        groupAccess: json["groupAccess"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "groupId": groupId,
        "name": name,
        "uniqueId": uniqueId,
        "status": status,
        "positionId": positionId,
        "geofenceIds": List<dynamic>.from(geofenceIds.map((x) => x)),
        "phone": phone == null ? null : phone,
        "model": model,
        "contact": contact == null ? null : contact,
        "category": category == null ? null : category,
        "disabled": disabled,
        "parentId": parentId,
        "created": created.toIso8601String(),
        "directAccess": directAccess,
        "groupAccess": groupAccess,
      };
}

class Attributes {
  Attributes({
    required this.minimalNoDataDuration,
    required this.minimalParkingDuration,
    required this.minimalTripDuration,
    required this.minimalTripDistance,
    required this.speedThreshold,
    required this.processInvalidPositions,
    required this.useIgnition,
    required this.storeTime,
    required this.port,
    required this.protocol,
    required this.parkingMaxIdleSpeed,
    required this.parkingMinIdleTime,
    required this.mileageAccuracy,
    required this.mileageCounter,
    required this.color,
    required this.eh,
    required this.td,
    required this.devicePassword,
  });

  int minimalNoDataDuration;
  int minimalParkingDuration;
  int minimalTripDuration;
  int minimalTripDistance;
  double speedThreshold;
  bool processInvalidPositions;
  int useIgnition;
  int storeTime;
  int port;
  String protocol;
  String parkingMaxIdleSpeed;
  String parkingMinIdleTime;
  double mileageAccuracy;
  String mileageCounter;
  String color;
  int eh;
  double td;
  String devicePassword;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        minimalNoDataDuration: json["minimalNoDataDuration"],
        minimalParkingDuration: json["minimalParkingDuration"],
        minimalTripDuration: json["minimalTripDuration"],
        minimalTripDistance: json["minimalTripDistance"],
        speedThreshold: json["speedThreshold"].toDouble(),
        processInvalidPositions: json["processInvalidPositions"],
        useIgnition: json["useIgnition"],
        storeTime: json["storeTime"],
        port: json["port"],
        protocol: json["protocol"],
        parkingMaxIdleSpeed: json["parking.maxIdleSpeed"],
        parkingMinIdleTime: json["parking.minIdleTime"],
        mileageAccuracy: json["mileageAccuracy"].toDouble(),
        mileageCounter: json["mileageCounter"],
        color: json["color"] == null ? null : json["color"],
        eh: json["EH"] == null ? null : json["EH"],
        td: json["TD"] == null ? null : json["TD"].toDouble(),
        devicePassword:
            json["devicePassword"] == null ? null : json["devicePassword"],
      );

  Map<String, dynamic> toJson() => {
        "minimalNoDataDuration": minimalNoDataDuration,
        "minimalParkingDuration": minimalParkingDuration,
        "minimalTripDuration": minimalTripDuration,
        "minimalTripDistance": minimalTripDistance,
        "speedThreshold": speedThreshold,
        "processInvalidPositions": processInvalidPositions,
        "useIgnition": useIgnition,
        "storeTime": storeTime,
        "port": port,
        "protocol": protocol,
        "parking.maxIdleSpeed": parkingMaxIdleSpeed,
        "parking.minIdleTime": parkingMinIdleTime,
        "mileageAccuracy": mileageAccuracy,
        "mileageCounter": mileageCounter,
        "color": color == null ? null : color,
        "EH": eh == null ? null : eh,
        "TD": td == null ? null : td,
        "devicePassword": devicePassword == null ? null : devicePassword,
      };
}

class ExtraInfo {
  ExtraInfo();

  factory ExtraInfo.fromJson(Map<String, dynamic> json) => ExtraInfo();

  Map<String, dynamic> toJson() => {};
}

class Parent {
  Parent({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
