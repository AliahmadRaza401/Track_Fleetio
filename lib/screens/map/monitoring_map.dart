// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_new, unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/screens/dashboard/grid_view.dart';
import 'package:track_flotilla/screens/map/map_services.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../widgets/imgTitleValue.dart';

class MonitoringMap extends StatefulWidget {
  var position;
  String vehName;
  String vehModel;
  MonitoringMap(
      @required this.position, @required this.vehName, @required this.vehModel);
  @override
  State<MonitoringMap> createState() => MonitoringMapState();
}

class MonitoringMapState extends State<MonitoringMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final PanelController _pc1 = PanelController();
  // final Set<Marker> markers = new Set();
  final Set<Circle> circle = Set<Circle>();

  LatLng kLocations = const LatLng(0.0, 0.0);
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Stream<dynamic>? locationStream;
  StreamSubscription? locationStreamSubscription;
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> marker = new Set();
  final kMarkerId = MarkerId('MarkerId1');
  static var kDuration = const Duration(milliseconds: 6100);
  final animarkercontroller = Completer<GoogleMapController>();
  static var kAnimarkerDuration = const Duration(milliseconds: 6000);
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 18,
  );
  late MonitoringProvider monitoringProvider;
  var p;
  static final kPolylineId = PolylineId('polyline');
  @override
  void initState() {
    super.initState();
    monitoringProvider =
        Provider.of<MonitoringProvider>(context, listen: false);
  }

  startStream() {
    // final uniqueKLocations = kLocations.toSet().toList();
    // log(uniqueKLocations.toString());

    locationStream = Stream.periodic(kDuration, (count) => kLocations);

    locationStreamSubscription = locationStream!.listen((value) {
      addAllpolyline(kLocations);
      newLocationUpdate(value, 0.0);
    });
  }

  void newLocationUpdate(LatLng latLng, routation) async {
    var myMarker;
    // log("New Location ____________________________: ${latLng.latitude.toString()}");
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(
        50, "assets/vehicles/TopView/1.1.png");
    myMarker = Marker(
      markerId: kMarkerId,
      position: latLng,
      draggable: false,
      zIndex: 2,
      // flat: true,
      anchor: const Offset(0.5, 0.5),
      rotation: routation.toDouble(),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );

    marker.clear();
    circle.clear();
    markers[kMarkerId] = myMarker;

    // if (mounted) {
    //   _customInfoWindowController.addInfoWindow!(
    //     Column(
    //       children: [
    //         Expanded(
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               border: Border.all(
    //                   color: p['attributes']['motion'] == true &&
    //                           p['attributes']['parking'] == false
    //                       ? Colors.green
    //                       : p['attributes']['motion'] == false &&
    //                               p['attributes']['parking'] == false
    //                           ? Colors.yellow
    //                           : Colors.red,
    //                   width: 2.w),
    //               boxShadow: [
    //                 BoxShadow(
    //                     color: const Color(0xFF000000).withOpacity(0.2),
    //                     blurRadius: 4.r,
    //                     offset: const Offset(0, 4)),
    //               ],
    //               borderRadius: BorderRadius.circular(20.r),
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsets.only(
    //                 top: 10,
    //               ),
    //               child: Column(
    //                 children: [
    //                   Center(
    //                       child: SizedBox(
    //                     width: 150.w,
    //                     height: 30.h,
    //                     child: Text(
    //                       "name",
    //                       // vehicleData['entity']['name'].toString(),
    //                       style:
    //                           TextStyle(fontFamily: 'Ubuntu', fontSize: 16.sp),
    //                       overflow: TextOverflow.ellipsis,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   )),
    //                   Text("model",
    //                       // vehicleData['entity']['model'].toString(),
    //                       style: TextStyle(
    //                           fontFamily: 'Ubuntu',
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 14.sp)),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         ClipPath(
    //           clipper: TriangleClipper(),
    //           child: Container(
    //             width: 20.w,
    //             height: 20.h,
    //             color: p['attributes']['motion'] == true &&
    //                     p['attributes']['parking'] == false
    //                 ? Colors.green
    //                 : p['attributes']['motion'] == false &&
    //                         p['attributes']['parking'] == false
    //                     ? Colors.yellow
    //                     : Colors.red,
    //           ),
    //         ),
    //       ],
    //     ),
    //     LatLng(latLng.latitude, latLng.longitude),
    //   );
    // }
  }

  @override
  void dispose() {
    markers.clear();
    locationStreamSubscription?.cancel();
    // monitoringProvider.channel.sink.close();
    locationStream = null;
    locationStreamSubscription!.cancel();
    _customInfoWindowController.dispose();
    polylineCoordinates = [];
    polylineCoordinates.clear();
    _polylines.clear();
    super.dispose();
  }

  addAllpolyline(LatLng LatLng) {
    polylineCoordinates.add(LatLng);

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Consumer<MonitoringProvider>(builder: (context, value, child) {
        final indexPosition = value.socPositionsList.indexWhere(
            (element) => element['deviceId'] == widget.position['deviceId']);

        value.setMapPosition(value.socPositionsList[indexPosition]);

        p = value.socPositionsList[indexPosition];
        kLocations = LatLng(p['latitude'], p['longitude']);

        return Stack(
          children: [
            Container(
              width: AppSizes.dynamicWidth(context, 1),
              height: AppSizes.dynamicHeight(context, 1),
              child: Animarker(
                duration: kAnimarkerDuration,
                curve: Curves.linear,
                mapId: animarkercontroller.future
                    .then<int>((value) => value.mapId),
                useRotation: true,
                markers: markers.values.toSet(),
                zoom: 17,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: marker,
                  polylines: _polylines,
                  zoomControlsEnabled: false,

                  circles: circle,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    animarkercontroller.complete(controller);
                    _controller.complete(controller);
                    // log(LatLng(widget.position['latitude'],
                    //         widget.position['longitude'])
                    //     .toString());
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(widget.position['latitude'],
                            widget.position['longitude']),
                        zoom: 16.5,
                      ),
                    ));
                    _customInfoWindowController.googleMapController =
                        controller;

                    DeviceMarkers(LatLng(widget.position['latitude'],
                        widget.position['longitude']));
                    startStream();
                  },
                  // onCameraMove: (position) {
                  //   _customInfoWindowController.onCameraMove!();
                  // },
                ),
              ),
            ),
            // CustomInfoWindow(
            //   controller: _customInfoWindowController,
            //   height: 100.h,
            //   width: 150.w,
            //   offset: 30,
            // ),
            SafeArea(child: AppBar()),
            zoomButtons(),
            value.mapPosition == null
                ? SizedBox()
                : SlidingUpPanel(
                    maxHeight: 730.h,
                    minHeight: 100.h,
                    renderPanelSheet: false,
                    controller: _pc1,
                    panel: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 11, right: 11, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r)),
                          width: 498.w,
                          height: 470.h,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 30.w,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(
                                          context,
                                          widget.vehName.toString(),
                                          26.sp,
                                          boldText: FontWeight.bold,
                                        ),
                                        text(context,
                                            widget.vehModel.toString(), 26.sp),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 180.w,
                                    height: 66.h,
                                    margin: const EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      gradient: value.mapPosition['attributes']
                                                      ['motion'] ==
                                                  true &&
                                              value.mapPosition['attributes']
                                                      ['parking'] ==
                                                  false
                                          ? AppColors.movingGradi
                                          : value.mapPosition['attributes']
                                                          ['motion'] ==
                                                      false &&
                                                  value.mapPosition[
                                                              'attributes']
                                                          ['parking'] ==
                                                      false
                                              ? AppColors.idleGradi
                                              : AppColors.parkedGradi,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 10.0.r,
                                            spreadRadius: 2.r,
                                            offset: const Offset(0.0, 4.0)),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.r),
                                          bottomLeft: Radius.circular(20.r)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 153.w,
                                          height: 30.h,
                                          child: FittedBox(
                                            child: Text(
                                              value.mapPosition['attributes']
                                                              ['motion'] ==
                                                          true &&
                                                      value.mapPosition[
                                                                  'attributes']
                                                              ['parking'] ==
                                                          false
                                                  ? "Moving"
                                                  : value.mapPosition['attributes']
                                                                  ['motion'] ==
                                                              false &&
                                                          value.mapPosition[
                                                                      'attributes']
                                                                  ['parking'] ==
                                                              false
                                                      ? "Idle"
                                                      : "Parked",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // 2nd Row

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: Responsive.isTablet(context)
                                        ? 250.w
                                        : 255.08.w,
                                    height: Responsive.isTablet(context)
                                        ? 220.h
                                        : 200.h,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              offset: const Offset(
                                                  0.0, 0.0), //(x,y)
                                              blurRadius: 5,
                                              spreadRadius: 1),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: Color(0xffE9EDF0)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "assets/png/servertime.png",
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Server Time",
                                                  style: TextStyle(
                                                      color: AppColors.grey,
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins'),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                SizedBox(
                                                  width: 150.w,
                                                  child: AutoSizeText(
                                                    value.mapPosition.containsKey(
                                                                'serverTime') &&
                                                            value.mapPosition[
                                                                    'serverTime'] !=
                                                                null
                                                        ? value.mapPosition[
                                                                'serverTime']
                                                            .toString()
                                                        : "0.0",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins'),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "assets/png/Status.png",
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Device Time",
                                                    style: TextStyle(
                                                        color: AppColors.grey,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins'),
                                                    textAlign:
                                                        TextAlign.center),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                SizedBox(
                                                  width: 150.w,
                                                  child: AutoSizeText(
                                                    value.mapPosition.containsKey(
                                                                'deviceTime') &&
                                                            value.mapPosition[
                                                                    'deviceTime'] !=
                                                                null
                                                        ? value.mapPosition[
                                                                'deviceTime']
                                                            .toString()
                                                        : "0.0",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins'),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.amber,
                                    child: Center(
                                      child: SizedBox(
                                        width: Responsive.isTablet(context)
                                            ? 170.w
                                            : 170.w,
                                        height: Responsive.isTablet(context)
                                            ? 190.h
                                            : 146.h,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: Responsive.isTablet(
                                                          context)
                                                      ? 100.w
                                                      : 80.32.w,
                                                  height: Responsive.isTablet(
                                                          context)
                                                      ? 100.h
                                                      : 80.32.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          AppColors.primaryDark,
                                                      width: 3.w,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x3f000000),
                                                        blurRadius: 31.r,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                    color:
                                                        const Color(0xfff3f3f3),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "RPM",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        "0",
                                                        style: GoogleFonts
                                                            .quantico(
                                                          fontSize: 22.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  width: Responsive.isTablet(
                                                          context)
                                                      ? 100.w
                                                      : 80.32.w,
                                                  height: Responsive.isTablet(
                                                          context)
                                                      ? 100.h
                                                      : 80.32.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          AppColors.primaryDark,
                                                      width: 3.w,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x3f000000),
                                                        blurRadius: 31.r,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                    color:
                                                        const Color(0xfff3f3f3),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Fuel",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        "0",
                                                        style: GoogleFonts
                                                            .quantico(
                                                          fontSize: 22.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Litres",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              top: 0,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  width: Responsive.isTablet(
                                                          context)
                                                      ? 118.12.w
                                                      : 111.12.h,
                                                  height: Responsive.isTablet(
                                                          context)
                                                      ? 118.12.h
                                                      : 111.12.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x3f000000),
                                                        blurRadius: 10.r,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                    gradient: AppColors
                                                        .primarygradient,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Speed",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Responsive
                                                                  .isTablet(
                                                                      context)
                                                              ? 15.sp
                                                              : 18.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        value.mapPosition[
                                                                'speed']
                                                            .toStringAsFixed(0),
                                                        style: GoogleFonts
                                                            .quantico(
                                                          fontSize: 26.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        "km/h",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Responsive
                                                                  .isTablet(
                                                                      context)
                                                              ? 14.sp
                                                              : 16.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.h),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  imgTitleValue(
                                      value.mapPosition['protocol'].toString(),
                                      "Protocol",
                                      "assets/png/P.png"),
                                  imgTitleValue(
                                      value.mapPosition['attributes']
                                                  ['signalStrength'] ==
                                              null
                                          ? "N/A"
                                          : value.mapPosition['attributes']
                                                  ['signalStrength']
                                              .toString(),
                                      "Signal",
                                      "assets/png/sim.png"),
                                  imgTitleValue(
                                      value.mapPosition['valid'].toString(),
                                      "Valid",
                                      "assets/png/valid.png"),
                                  imgTitleValue(
                                      value.mapPosition['outdated'].toString(),
                                      "Outdated",
                                      "assets/png/event.png"),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  imgTitleValue(
                                      value.mapPosition['altitude'].toString(),
                                      "Altitude",
                                      "assets/png/altitude.png"),
                                  imgTitleValue(
                                      value.mapPosition['attributes']
                                                  ['batteryLevel '] ==
                                              null
                                          ? "N/A"
                                          : value.mapPosition['attributes']
                                                  ['batteryLevel ']
                                              .toString(),
                                      "TBattery",
                                      "assets/png/trackb.png"),
                                  imgTitleValue(
                                      value.mapPosition['attributes']
                                                  ['networkType'] ==
                                              null
                                          ? "N/A"
                                          : value.mapPosition['attributes']
                                                  ['networkType']
                                              .toString(),
                                      "Network",
                                      "assets/png/gps.png"),
                                  imgTitleValue(
                                      value.mapPosition['attributes']['MC']
                                          .toString(),
                                      "GPS",
                                      "assets/png/satellite 1.png"),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/png/last location.png",
                                    width: 50.w,
                                    height: 40.h,
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Address",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Container(
                                        width: 380.w,
                                        child: AutoSizeText(
                                          value.mapPosition['address']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontFamily: 'Poppins'),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        );
      }),
    );
  }

  Widget AppBar() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: AppSizes.dynamicWidth(context, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: 20.w,
            ),
            width: AppSizes.dynamicWidth(context, 0.95),
            height: 76.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // color: Colors.amber,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            AppRoutes.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new)),
                      SizedBox(
                        width: 30.w,
                      ),
                      text(context, widget.vehName.toString(), 26.sp),
                    ],
                  ),
                ),
                // Icon(Icons.search),
              ],
            ),
          ),
        ],
      ),
    );
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
                mapController.animateCamera(
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
                mapController.animateCamera(
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

  Future<Set<Marker>> DeviceMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(
        50, "assets/vehicles/TopView/1.1.png");
    //markers to place on map
    setState(() {
      marker.add(Marker(
          markerId: MarkerId('Device'),
          rotation: widget.position['course'],
          position: showLocation,
          infoWindow: InfoWindow(title: "Device 1"),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));

      circle.add(Circle(
        circleId: CircleId("Device"),
        // radius: showLocation.accuracy,
        radius: 30,
        zIndex: 1,
        strokeColor: widget.position['attributes']['motion'] == true &&
                widget.position['attributes']['parking'] == false
            ? Colors.green
            : widget.position['attributes']['motion'] == false &&
                    widget.position['attributes']['parking'] == false
                ? Colors.yellow
                : Colors.red,
        strokeWidth: 2,
        center: showLocation,
        fillColor: widget.position['attributes']['motion'] == true &&
                widget.position['attributes']['parking'] == false
            ? Colors.green.withAlpha(70)
            : widget.position['attributes']['motion'] == false &&
                    widget.position['attributes']['parking'] == false
                ? Colors.yellow.withAlpha(70)
                : Colors.red.withAlpha(70),
      ));
    });
    return marker;
  }
}
