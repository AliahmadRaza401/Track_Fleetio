// To parse required this JSON data, do
//
//     final commandsModel = commandsModelFromJson(jsonString);

import 'dart:convert';

List<CommandsModel> commandsModelFromJson(String str) => List<CommandsModel>.from(json.decode(str).map((x) => CommandsModel.fromJson(x)));

String commandsModelToJson(List<CommandsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommandsModel {
    CommandsModel({
        required this.id,
        required this.attributes,
        required this.deviceId,
        required this.type,
        required this.textChannel,
        required this.description,
        required this.parentId,
        required this.directAccess,
        required this.groupAccess,
    });

    int id;
    Attributes attributes;
    int deviceId;
    String type;
    bool textChannel;
    String description;
    int parentId;
    bool directAccess;
    bool groupAccess;

    factory CommandsModel.fromJson(Map<String, dynamic> json) => CommandsModel(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
        deviceId: json["deviceId"],
        type: json["type"],
        textChannel: json["textChannel"],
        description: json["description"],
        parentId: json["parentId"],
        directAccess: json["directAccess"],
        groupAccess: json["groupAccess"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "deviceId": deviceId,
        "type": type,
        "textChannel": textChannel,
        "description": description,
        "parentId": parentId,
        "directAccess": directAccess,
        "groupAccess": groupAccess,
    };
}

class Attributes {
    Attributes({
        required this.data,
    });

    String data;

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        data: json["data"] == null ? null : json["data"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data,
    };
}
