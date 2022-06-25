import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_flotilla/api/api_uri.dart';
import 'package:track_flotilla/model/allDevicesModel.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:http/http.dart' as http;

class DriverProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  List allDriverDataList = [];

// __________________________Get All Vehicle Details
  Future fetchAllDriverData(BuildContext context) async {
    Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
    try {
      var userid = await SharedPref.getUserId();
      log('userid: $userid');

      var username = await SharedPref.getUserEmail();

      var password = await SharedPref.getUserPassword();

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.getAllDrivers),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.statusCode}');
      if (response.statusCode == 200) {
         allDriverDataList = jsonDecode(response.body);
        log('allDriverDataList: $allDriverDataList');

        Provider.of<LoadingProvider>(context).setLoading(false);

        return allDriverDataList;
      } else {
        Provider.of<LoadingProvider>(context).setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
    }
  }


}
