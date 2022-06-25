import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_flotilla/api/api_uri.dart';
import 'package:track_flotilla/model/allDevicesModel.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class DashboardProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  List<AllDevicesModel> allDevicesDataList = [];
  List allDevicesData = [];
  List offlineDevicesData = [];
  List movingDevicesData = [];
  List idleDevicesData = [];
  List parkedDevicesData = [];
  List unknowDevicesData = [];
  List positionsList = [];

  var userid;
  var username;
  var password;

// __________________________Get All Vehicle Details
  Future fetchAllDevicesData(BuildContext context) async {
    LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    try {
      // loadingProvider.setLoading(true);
      userid = await SharedPref.getUserId();
      log('userid: $userid');

      username = await SharedPref.getUserEmail();

      password = await SharedPref.getUserPassword();
      log('username: $username');
      log('password: $password');
      log('userid: $userid');
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.fetchAllDevices(userid)),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log('response: ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            Map<String, dynamic>.from(json.decode(response.body));
        allDevicesData = jsonResponse['data'];
        Provider.of<MonitoringProvider>(context, listen: false).socDevicesList =
            jsonResponse['data'];

        // movingDevicesData = allDevicesData
        //     .where((o) => o['entity']['status'] == 'online')
        //     .toList();
        // idleDevicesData = allDevicesData
        //     .where((o) => o['entity']['status'] == 'offline')
        //     .toList();
        // unknowDevicesData = allDevicesData
        //     .where((o) => o['entity']['status'] == 'unknown')
        //     .toList();
        // print('unknowDevicesData: $unknowDevicesData');

        // await fetchAllPositions(context);
        // loadingProvider.setLoading(false);

        // print('data: $data');
        // log(data.map((data) => Entity.fromJson(data)).toList().toString());
        // allDevicesDataList =
        // allDevicesModelFromJson(jsonResponse) as List<AllDevicesModel>;
        // data.map((data) => AllDevicesModel.fromJson(data)).toList();
        // data.map((dynamic item) => AllDevicesModel.fromJson(item)).toList();
        // print('allDevicesDataList: $allDevicesDataList');

      } else {
        // loadingProvider.setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      print('e: $e');
      // loadingProvider.setLoading(false);
    }
  }

  // __________________________Get All Positions
  Future fetchAllPositions(BuildContext context) async {
    LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    log("get Positions");
    loadingProvider.setLoading(true);
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse(ApiUri.getAllPositions),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': basicAuth
        },
      );
      log("try in");
      log('response: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Map<String, dynamic> jsonResponse =
        //     Map<String, dynamic>.from(json.decode(response.body));
        positionsList = jsonDecode(response.body);
        log('positions data: $positionsList');

        movingDevicesData = positionsList
            .where((o) =>
                o['attributes']['motion'] == true &&
                o['attributes']['parking'] == false)
            .toList();

        idleDevicesData = positionsList
            .where((o) =>
                o['attributes']['motion'] == false &&
                o['attributes']['parking'] == false)
            .toList();

        parkedDevicesData = positionsList
            .where((o) =>
                o['attributes']['motion'] == false &&
                o['attributes']['parking'] == true)
            .toList();
        loadingProvider.setLoading(false);
      } else {
        loadingProvider.setLoading(false);
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      loadingProvider.setLoading(false);

      print('e: $e');
    }
  }

  int time = 60;

  timerDecrease() {
    time--;
    // print('time: $time');
    notifyListeners();
  }

// //Sockets init
//   var channel;
//   socketConnect() async {
//     // Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
//     String cookieID = await SharedPref.getCookieId();
//     log('cookieID: $cookieID');
//     channel = IOWebSocketChannel.connect(
//         'wss://app.trackfleetio.com/api/socket',
//         headers: {
//           'Cookie': cookieID,
//         });

//     channel.stream.listen((message) {
//       // Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
//       log('message: $message');
//       var data = jsonDecode(message);
//       if (data.containsKey("positions")) {
//         socPositionsList = data['positions'];
//         print('socPositionsList: $socPositionsList');
//       }
//       // channel.sink.add('received!');
//       // channel.sink.close(status.goingAway);
//     });
//   }
}
