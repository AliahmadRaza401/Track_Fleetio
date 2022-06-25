import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/api/api_uri.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:http/http.dart' as http;

class MaintenanceProvider extends ChangeNotifier {
  late BuildContext context;
    List maintenanceList = [];
  init({required BuildContext context}) {
    this.context = context;
  }

  bool loading = false;

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  // __________________________Get All Vehicle Details
  Future fetchAllMaintenance(BuildContext context) async {
    setLoading(true);
    try {
      var username = await SharedPref.getUserEmail();
      var password = await SharedPref.getUserPassword();

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.getAllMaintenance),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.statusCode}');
      log('response: ${response.body}');
      if (response.statusCode == 200) {
         maintenanceList = jsonDecode(response.body);
        // List commandModel = response.body as List;
        // commandsModelFromJson(response.body) as List<CommandsModel>;
        // print('commandModel: $commandModel');
        setLoading(false);

        return maintenanceList;
      } else {
        setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      log('e: $e');
      setLoading(false);
    }
  }

  Future deleteMaintenaince(BuildContext context, id) async {
    setLoading(true);
    try {
      var username = await SharedPref.getUserEmail();
      var password = await SharedPref.getUserPassword();

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.delete(
        Uri.parse(ApiUri.deleteMaintenance(id)),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.statusCode}');
      log('response: ${response.body}');
      if (response.statusCode == 204) {
        // List commandModel = response.body as List;
        // commandsModelFromJson(response.body) as List<CommandsModel>;
        // print('commandModel: $commandModel');
        setLoading(false);
        fetchAllMaintenance(context);
      } else {
        setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);

      log('e: $e');
    }
  }
}
