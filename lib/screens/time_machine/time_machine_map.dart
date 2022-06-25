// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_typing_uninitialized_variables, prefer_collection_literals, unrelated_type_equality_checks, file_names, must_be_immutable, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:track_flotilla/providers/time_machine_provider.dart';
import 'package:track_flotilla/screens/map/map_services.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';

import 'dart:ui' as ui;
import 'package:lottie/lottie.dart' as lottie;

import 'package:intl/intl.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:track_flotilla/utils/toast.dart';

import '../../utils/appColor.dart';

class TimeMachineMap extends StatefulWidget {
  TimeMachineMap({
    Key? key,
  }) : super(key: key);

  @override
  _TimeMachineMapState createState() => _TimeMachineMapState();
}

class _TimeMachineMapState extends State<TimeMachineMap> {
  static final kMarkerId = MarkerId('MarkerId1');
  static final kPolylineId = PolylineId('polyline');
  static var kDuration = Duration(milliseconds: 6100);
  static var kAnimarkerDuration = Duration(milliseconds: 6000);

  static final kLocations = [];

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  late GoogleMapController _mapController;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> _marker = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  //String googleAPiKey = "AIzaSyD-sDEsdys11SYanLPAWLrKMATyXzdNzSI";

  Uint8List? markerIcon;

  List<dynamic>? latlng;

  final PanelController _pc1 = PanelController();
  double _value = 0;

  LatLng? _currentPosition;
  String _address = '';

  Stream<dynamic>? locationStream;
  Stream<dynamic>? polylineStream;

  StreamSubscription? locationStreamSubscription;
  StreamSubscription? polylineStreamSubscription;
  late TimeMachineProvider _timeMachineProvider;
  var speed;
  bool loading = true;
  @override
  void initState() {
    polylinePoints = PolylinePoints();
    // startCustomMarker();
    // endCustomMarker();
    _timeMachineProvider =
        Provider.of<TimeMachineProvider>(context, listen: false);
    showLocationPins(
        LatLng(_timeMachineProvider.dataList[0]['lat'],
            _timeMachineProvider.dataList[0]['lng']),
        LatLng(
            _timeMachineProvider
                .dataList[_timeMachineProvider.dataList.length - 1]['lat'],
            _timeMachineProvider
                .dataList[_timeMachineProvider.dataList.length - 1]['lng']));
    super.initState();
  }

  @override
  void dispose() {
    _marker.clear();
    _polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    locationStreamSubscription?.cancel();
    polylineStreamSubscription?.cancel();
    _timeMachineProvider.dataList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<TimeMachineProvider>(context).loading;

    return Scaffold(
      appBar: customBackBtnAppBar(context, "Time Machine"),
      body: Stack(
        children: [
          Animarker(
            duration: kAnimarkerDuration,
            curve: Curves.ease,
            mapId: controller.future.then<int>((value) => value.mapId),
            useRotation: true,
            // rippleColor: Colors.orange,
            // rippleDuration: Duration(milliseconds: 500),
            // rippleRadius: 0.1,
            markers: markers.values.toSet(),
            zoom: 17,

            child: loading
                ? CircularProgressIndicator()
                : GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    mapType: MapType.normal,
                    onCameraMove: (position) {
                      // _customInfoWindowController.onCameraMove!();
                    },
                    onTap: (position) {
                      //_customInfoWindowController.hideInfoWindow!();
                    },
                    markers: _marker,
                    polylines: _polylines,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(_timeMachineProvider.dataList[0]['lat'],
                            _timeMachineProvider.dataList[0]['lng']),
                        zoom: 12),
                    onMapCreated: (gController) {
                      _mapController = gController;
                      controller.complete(gController);

                      startStream();
                      addAllpolyline();
                    }),
          ),
          zoomButtons(),

          // CustomInfoWindow(
          //   controller: _customInfoWindowController,
          //   height: 75.h,
          //   width: 150.w,
          //   offset: 30,
          // ),

          Positioned(
            right: 10,
            bottom: 20,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: Responsive.isTablet(context) ? 118.12.w : 140.h,
                height: Responsive.isTablet(context) ? 118.12.h : 140.h,
                padding: EdgeInsets.symmetric(
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x3f000000),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: AppColors.primarygradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Speed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.isTablet(context) ? 15.sp : 18.sp,
                      ),
                    ),
                    Text(
                      speed == null ? "0" : speed.toString(),
                      style: GoogleFonts.quantico(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "km/h",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.isTablet(context) ? 14.sp : 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading
              ? Container(
                  color: Colors.grey.withOpacity(0.5),
                  alignment: Alignment.center,
                  height: AppSizes.dynamicHeight(context, 1),
                  width: AppSizes.dynamicWidth(context, 1),
                  child: Center(
                    child: loadingTextAimation(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  addAllpolyline() {
    polylineCoordinates = [];
    polylineCoordinates.clear();
    _polylines.clear();
    for (var element in _timeMachineProvider.dataList) {
      polylineCoordinates.add(LatLng(element['lat'], element['lng']));

      if (mounted) {
        setState(() {
          _polylines.add(Polyline(
            width: 4,
            polylineId: kPolylineId,
            color: AppColors.primaryDark,
            points: polylineCoordinates,
          ));
        });
      }
    }
  }

  startStream() {
    setState(() {
      loading = false;
    });
    if (mounted) {
      if (locationStreamSubscription != null &&
          locationStreamSubscription!.isPaused) {
        locationStreamSubscription!.resume();
      } else {
        locationStream = Stream.periodic(
            kDuration, (count) => _timeMachineProvider.dataList[count]);

        locationStreamSubscription = locationStream!
            .take(_timeMachineProvider.dataList.length)
            .listen((value) {
          speed = value['s'].toStringAsFixed(0).toString();

          newLocationUpdate(LatLng(value['lat'], value['lng']), 0.0);
        }, onDone: () {
          log("History Complete");
          AppToast.successToast("Finish!", "Your History End ", context);
        });
      }
    }
  }

  void showLocationPins(LatLng start, LatLng end) async {
    final Uint8List startmarkerIcon = await MapServices.getMarkerWithSize(
        70, "assets/png/startMarkerIcon.png");
    final Uint8List endmarkerIcon =
        await MapServices.getMarkerWithSize(70, "assets/png/endMarkericon.png");

    _marker.add(Marker(
      markerId: MarkerId('sourcePosition'),
      position: start,
      icon: BitmapDescriptor.fromBytes(startmarkerIcon),
    ));

    _marker.add(
      Marker(
        markerId: MarkerId('destinationPosition'),
        position: end,
        icon: BitmapDescriptor.fromBytes(endmarkerIcon),
      ),
    );
  }

  var marker;

  void newLocationUpdate(LatLng latLng, dir) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(
        50, "assets/vehicles/TopView/1.1.png");
    marker = Marker(
      markerId: kMarkerId,
      position: latLng,
      draggable: false,
      zIndex: 2,
      anchor: Offset(0.5, 0.5),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    // polylineCoordinates.add(LatLng(latLng.latitude, latLng.longitude));

    if (mounted) {
      setState(() {
        markers[kMarkerId] = marker;
        // isPlaying = true;
        // _polylines.add(Polyline(
        //   width: 4,
        //   polylineId: kPolylineId,
        //   color: AppColors.primaryDark,
        //   points: polylineCoordinates,
        // ));
      });
    }
  }

  pauseSubscription() {
    setState(() {
      // isPlaying = false;
    });
    locationStreamSubscription?.pause();
    polylineStreamSubscription?.pause();
  }

  stopStreams() {
    if (mounted) {
      setState(() {
        // kPolyline.clear();
        // kSpeed.clear();
        // kDuration = Duration(milliseconds: 800);
        // kAnimarkerDuration = Duration(milliseconds: 300);
        // kIngStatus.clear();
        // kGpsLocationTime.clear();
        // kReceiveLocationTime.clear();
        // kVehicleStatus.clear();
        // kAlarm.clear();
        // kDirection.clear();
        _marker.clear();
        //markers.clear();
        _polylines.clear();
        polylineCoordinates.clear();
        locationStreamSubscription?.cancel();
        locationStreamSubscription = null;
        polylineStreamSubscription?.cancel();
        polylineStreamSubscription = null;

        // isPlaying = false;
      });
    }
  }

  setCircleMarker() async {
    await getBytesFromAsset("assets/images/orangecircle.png", 40).then((value) {
      setState(() {
        markerIcon = value;
      });
    });
  }

  Widget zoomButtons() {
    return Positioned(
      top: AppSizes.dynamicHeight(context, 0.2),
      right: 10.w,
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _mapController.animateCamera(
                  CameraUpdate.zoomIn(),
                );
              },
              child: Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            InkWell(
              onTap: () {
                _mapController.animateCamera(
                  CameraUpdate.zoomOut(),
                );
              },
              child: Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  Icons.remove,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromAssetStart(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromAssetEnd(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
