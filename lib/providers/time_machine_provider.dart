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

class TimeMachineProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  var id;
  var statTime;

  var endTime;

  bool loading = false;
  var dataList = [];
  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

// __________________________Get All Vehicle Details
  Future fetchTimeMachineData(BuildContext context) async {
    setLoading(true);
    try {
      var userid = await SharedPref.getUserId();
      log('userid: $userid');

      var username = await SharedPref.getUserEmail();

      var password = await SharedPref.getUserPassword();

      print(ApiUri.getTimeLapHistory(
        id,
        statTime,
        endTime,
      ));
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.getTimeLapHistory(
          id,
          statTime,
          endTime,
        )),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        dataList = data['$id'];
        log('dataList: $dataList');

        setLoading(false);

        return dataList;
      } else {
        setLoading(false);
        log('response: ${response.body}');

        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      log('e: $e');
      setLoading(false);
    }
  }
}
