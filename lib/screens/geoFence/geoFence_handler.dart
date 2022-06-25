import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/api/api_uri.dart';
import 'package:track_flotilla/model/geoFenceModel.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:track_flotilla/utils/toast.dart';

class GeoFenceHander {
  // __________________________Get All Vehicle Details
  static Future fetchAllGeoFence(BuildContext context) async {
    Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
    try {
      var username = await SharedPref.getUserEmail();
      var password = await SharedPref.getUserPassword();

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.getAllGeoFences),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.body}');
      if (response.statusCode == 200) {
        List geofenceModel = jsonDecode(response.body);
        // List<GeofenceModel> geofenceModel =
        //     geofenceModelFromJson(response.body) as List<GeofenceModel>;

        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

        return geofenceModel;
      } else {
        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      log('e: $e');
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
    }
  }

  static addGeoFence(
    BuildContext context,
    id,
    name,
    desc,
    area,
    latlnglist,
  ) async {
    print('area: $area');
    print('desc: $desc');
    print('name: $name');
    print('id: $id');
    print('latlnglist: $latlnglist');
    Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
    try {
      log("Adding geofence........");
      var username = await SharedPref.getUserEmail();
      var password = await SharedPref.getUserPassword();

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(Uri.parse(ApiUri.addGeoFence),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'authorization': basicAuth
          },
          body: jsonEncode({
            "id": id.toString(),
            "name": name.toString(),
            "description": desc.toString(),
            "area": area.toString(),
            "calendarId": 0,
            "attributes": {
              "type": "polyline",
              "color": "red",
              "latlng": latlnglist,
              "polylineDistance": 0,
            },
          }));

      log('response: ${response.body}');
      if (response.statusCode == 200) {
        log("Add Done........");
        AppToast.successToast("Success", "GeoFence Added Success", context);
        fetchAllGeoFence(context);
        // List<GeofenceModel> geofenceModel =
        //     geofenceModelFromJson(response.body) as List<GeofenceModel>;

        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

        return true;
      } else {
        log("Add fail........");
        AppToast.failureToast("Fail", "GeoFence Added Fail", context);
        Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
        return false;
      }
    } catch (e) {
      AppToast.failureToast("Oops!", "Something went wrong", context);

      log('e: $e');

      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      return false;
    }
  }
}
