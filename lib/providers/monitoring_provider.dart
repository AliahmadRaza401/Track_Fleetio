import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:web_socket_channel/io.dart';

class MonitoringProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  List socPositionsList = [];
  List socDevicesList = [];
  bool loading = true;
  var position;
  var device;
  var mapPosition;

  setMapPosition(val) {
    // Future.delayed(Duration.zero, () async {
    mapPosition = val;
    // notifyListeners();
    // });
  }

  setPosition(val) {
    position = val;
    // notifyListeners();
  }

  setDevice(val) {
    device = val;
    // notifyListeners();
  }

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  updateDatainList(data) {
    socDevicesList.add(data);

    notifyListeners();
  }
  updateDatainPositionList(data) {
    socPositionsList.add(data);

    notifyListeners();
  }
  var channel;
  socketConnect() async {
    String cookieID = await SharedPref.getCookieId();
    log('cookieID: $cookieID');
    channel = IOWebSocketChannel.connect(
        'wss://app.trackfleetio.com/api/socket',
        headers: {
          'Cookie': cookieID,
        });

    channel.stream.listen((message) {
      log('message: $message');
      var data = jsonDecode(message);
      if (data.containsKey("positions")) {
        for (var i in data['positions']) {
          socPositionsList.removeWhere((it) => it['deviceId'] == i['deviceId']);

           updateDatainPositionList(i);
        }
      }
      if (data.containsKey("devices")) {
        for (var i in data['devices']) {
          socDevicesList.removeWhere((it) => it['id'] == i['id']);
          updateDatainList(i);
        }
      }
      // print('socDevicesList: $socDevicesList');
      // print('socPositionsList: $socPositionsList');

      // channel.sink.add('received!');
      // channel.sink.close(status.goingAway);
    });
  }
}
