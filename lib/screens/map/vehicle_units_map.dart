// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:track_flotilla/screens/dashboard/grid_view.dart';
import 'package:track_flotilla/screens/map/map_services.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../../providers/dashboard_provider.dart';
import '../widgets/imgTitleValue.dart';

class VehicleUnitMap extends StatefulWidget {
  List data;
  String type;
  VehicleUnitMap(this.data, this.type);
  @override
  State<VehicleUnitMap> createState() => VehicleUnitMapState();
}

class VehicleUnitMapState extends State<VehicleUnitMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final PanelController _pc1 = PanelController();
  final Set<Circle> circle = Set<Circle>();
  Iterable markers = [];
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late DashboardProvider _dashboardProvider;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 18,
  );

  late LatLng selectedLatlng = LatLng(0.032, 0.3432432);
  var vehicleData;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;

    if (widget.data.isNotEmpty) {
      addAllMarkers();
      var vehicleList = _dashboardProvider.allDevicesData
          .where((o) =>
              o['entity']['positionId'].toString() ==
              widget.data[0]["id"].toString())
          .toList();
      setState(() {
        vehicleData = vehicleList.isNotEmpty ? vehicleList[0] : {};
        selectedLatlng =
            LatLng(widget.data[0]["latitude"], widget.data[0]["longitude"]);
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: selectedLatlng,
          zoom: 4.5,
        ),
      ));
    }
  }

  addAllMarkers() async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(
        50, "assets/vehicles/TopView/1.1.png");
    double lat;
    double lng;
    double routation;
    if (mounted) {
      Iterable _markers = Iterable.generate(widget.data.length, (index) {
        // status = data[index]["GStatus"];
        lat = widget.data[index]["latitude"];
        lng = widget.data[index]["longitude"];
        routation = widget.data[index]['course'];
        LatLng latLngMarker = LatLng(lat, lng);
        addCustomWindow();

        return Marker(
          markerId: MarkerId("marker$index"),
          position: latLngMarker,
          rotation: routation,
          onTap: () {
            var vehicleList = _dashboardProvider.allDevicesData
                .where((o) =>
                    o['entity']['positionId'].toString() ==
                    widget.data[index]["id"].toString())
                .toList();

            setState(() {
              selectedIndex = index;
              vehicleData = vehicleList.isNotEmpty ? vehicleList[0] : {};
              selectedLatlng = latLngMarker;
            });
          },
          // rotation: vid == "1.19" ?0:vid == "1.20" ?0:data[index]["Direction"].toDouble(),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        );
      });

      setState(() {
        markers = _markers;
      });
    }
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("DAta:_________${widget.data.toString()}");
    return new Scaffold(
      appBar: customBackBtnAppBar(
        context,
        " ${widget.type}  (${widget.data.isEmpty ? 0 : widget.data.length})",
      ),
      body: Stack(
        children: [
          Container(
            width: AppSizes.dynamicWidth(context, 1),
            height: AppSizes.dynamicHeight(context, 1),
            child: GoogleMap(
              mapType: MapType.normal,
              markers: Set.from(markers),
              zoomControlsEnabled: false,
              circles: circle,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: onMapCreated,
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100.h,
            width: 150.w,
            offset: 30,
          ),
          vehicleListView(),
          zoomButtons(),
          slidingUpPanel(),
        ],
      ),
    );
  }

  Widget slidingUpPanel() {
    return vehicleData == null
        ? SizedBox()
        : SlidingUpPanel(
            maxHeight: 550.h,
            minHeight: 100.h,
            renderPanelSheet: false,
            controller: _pc1,
            panel: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 11, right: 11, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r)),
                  width: 498.w,
                  height: 470.h,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 180.w,
                            height: 66.h,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              gradient: widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('motion') &&
                                          widget.data[selectedIndex]['attributes']
                                              .containsKey('parking')
                                      ? widget.data[selectedIndex]['attributes']['motion'] == false &&
                                              widget.data[selectedIndex]['attributes']
                                                      ['parking'] ==
                                                  true
                                          ? AppColors.parkedGradi
                                          : widget.data[selectedIndex]['attributes']['motion'] == false &&
                                                  widget.data[selectedIndex]['attributes']
                                                          ['parking'] ==
                                                      false
                                              ? AppColors.idleGradi
                                              : widget.data[selectedIndex]['attributes']['motion'] == true &&
                                                      widget.data[selectedIndex]['attributes']['parking'] == false
                                                  ? AppColors.movingGradi
                                                  : AppColors.notResponceGradi
                                      : AppColors.notResponceGradi
                                  : AppColors.notResponceGradi,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 10.0.r,
                                    spreadRadius: 2.r,
                                    offset: const Offset(0.0, 4.0)),
                              ],
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.r),
                                  bottomLeft: Radius.circular(20.r)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 153.w,
                                  height: 30.h,
                                  child: FittedBox(
                                    child: Text(
                                      widget.data[selectedIndex]
                                              .containsKey('attributes')
                                          ? widget.data[selectedIndex]['attributes']
                                                      .containsKey('motion') &&
                                                  widget.data[selectedIndex]['attributes']
                                                      .containsKey('parking')
                                              ? widget.data[selectedIndex]['attributes']
                                                              ['motion'] ==
                                                          false &&
                                                      widget.data[selectedIndex]
                                                                  ['attributes']
                                                              ['parking'] ==
                                                          true
                                                  ? "Parked"
                                                  : widget.data[selectedIndex]['attributes']
                                                                  ['motion'] ==
                                                              false &&
                                                          widget.data[selectedIndex]['attributes']['parking'] == false
                                                      ? "Idle"
                                                      : widget.data[selectedIndex]['attributes']['motion'] == true && widget.data[selectedIndex]['attributes']['parking'] == false
                                                          ? "Moving"
                                                          : "N/A"
                                              : "N/A"
                                          : "N/A",
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 263.w,
                                      height: 114.h,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primarygradient,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2.h,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              text(
                                                  context,
                                                  _dashboardProvider.allDevicesData[
                                                                      selectedIndex]
                                                                  ['entity']
                                                              ['category'] ==
                                                          null
                                                      ? "N/A"
                                                      : _dashboardProvider
                                                          .allDevicesData[
                                                              selectedIndex]
                                                              ['entity']
                                                              ['category']
                                                          .toString(),
                                                  22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white),
                                              text(
                                                  context,
                                                  _dashboardProvider.allDevicesData[
                                                                      selectedIndex]
                                                                  ['entity']
                                                              ['name'] ==
                                                          null
                                                      ? "N/A"
                                                      : _dashboardProvider
                                                          .allDevicesData[
                                                              selectedIndex]
                                                              ['entity']['name']
                                                          .toString(),
                                                  22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white),
                                            ],
                                          ),
                                          Container(
                                            width: 260.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.r),
                                                bottomRight:
                                                    Radius.circular(10.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: text(
                                                  context,
                                                  _dashboardProvider.allDevicesData[
                                                                      selectedIndex]
                                                                  ['entity']
                                                              ['model'] ==
                                                          null
                                                      ? "N/A"
                                                      : _dashboardProvider
                                                          .allDevicesData[
                                                              selectedIndex]
                                                              ['entity']
                                                              ['model']
                                                          .toString(),
                                                  22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -130.h,
                                right: 0,
                                left: 0,
                                child: Image.asset(
                                  "assets/vehicles/SideView/1.1.png",
                                  width: 160.w,
                                  height: 160.h,
                                ),
                              ),
                            ],
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
                                          width: Responsive.isTablet(context)
                                              ? 100.w
                                              : 80.32.w,
                                          height: Responsive.isTablet(context)
                                              ? 100.h
                                              : 80.32.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primaryDark,
                                              width: 3.w,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x3f000000),
                                                blurRadius: 31.r,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            color: const Color(0xfff3f3f3),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                style: GoogleFonts.quantico(
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
                                          width: Responsive.isTablet(context)
                                              ? 100.w
                                              : 80.32.w,
                                          height: Responsive.isTablet(context)
                                              ? 100.h
                                              : 80.32.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primaryDark,
                                              width: 3.w,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x3f000000),
                                                blurRadius: 31.r,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            color: const Color(0xfff3f3f3),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                style: GoogleFonts.quantico(
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
                                          width: Responsive.isTablet(context)
                                              ? 118.12.w
                                              : 111.12.h,
                                          height: Responsive.isTablet(context)
                                              ? 118.12.h
                                              : 111.12.h,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Speed",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Responsive.isTablet(
                                                          context)
                                                      ? 15.sp
                                                      : 18.sp,
                                                ),
                                              ),
                                              Text(
                                                widget.data[selectedIndex]
                                                            ['speed'] ==
                                                        null
                                                    ? "0"
                                                    : widget.data[selectedIndex]
                                                            ['speed']
                                                        .toStringAsFixed(0)
                                                        .toString(),
                                                style: GoogleFonts.quantico(
                                                  fontSize: 26.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "km/h",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Responsive.isTablet(
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
                      Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            "assets/png/last location.png",
                            width: 50.w,
                            height: 40.h,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  widget.data[selectedIndex]
                                              .containsKey('address') &&
                                          widget.data[selectedIndex]
                                                  ['address'] !=
                                              null
                                      ? widget.data[selectedIndex]['address']
                                          .toString()
                                      : "N/A",
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
                      SizedBox(height: 30.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          imgTitleValue(
                              widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('odometer') &&
                                          widget.data[selectedIndex]
                                                  ['attributes']['odometer'] !=
                                              null
                                      ? widget.data[selectedIndex]['attributes']
                                              ['odometer']
                                          .toString()
                                      : "0"
                                  : '0',
                              "Mileage",
                              "assets/png/speedometer 1.png"),
                          imgTitleValue(
                              widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('hours') &&
                                          widget.data[selectedIndex]
                                                  ['attributes']['hours'] !=
                                              null
                                      ? widget.data[selectedIndex]['attributes']
                                              ['hours']
                                          .toString()
                                      : "0"
                                  : '0',
                              "Engine",
                              "assets/png/engine.png"),
                          imgTitleValue(
                              widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('batteryLevel') &&
                                          widget.data[selectedIndex]
                                                      ['attributes']
                                                  ['batteryLevel'] !=
                                              null
                                      ? widget.data[selectedIndex]['attributes']
                                              ['batteryLevel']
                                          .toString()
                                      : "0"
                                  : '0',
                              "Battery",
                              "assets/png/car-battery.png"),
                          imgTitleValue(
                              widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('event') &&
                                          widget.data[selectedIndex]
                                                  ['attributes']['event'] !=
                                              null
                                      ? widget.data[selectedIndex]['attributes']
                                              ['event']
                                          .toString()
                                      : "0"
                                  : '0',
                              "Event",
                              "assets/png/event.png"),
                          imgTitleValue(
                              widget.data[selectedIndex]
                                      .containsKey('attributes')
                                  ? widget.data[selectedIndex]['attributes']
                                              .containsKey('distance') &&
                                          widget.data[selectedIndex]
                                                  ['attributes']['distance'] !=
                                              null
                                      ? widget.data[selectedIndex]['attributes']
                                              ['distance']
                                          .toStringAsFixed(2)
                                          .toString()
                                      : "0"
                                  : '0',
                              "Distance",
                              "assets/png/last location.png"),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 10),
                      //       child: text(
                      //         context,
                      //         "Reports",
                      //         24.sp,
                      //         boldText: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 20.h,
                      // ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //     horizontal: 20.w,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(10),
                      //         topRight: Radius.circular(10),
                      //         bottomLeft: Radius.circular(10),
                      //         bottomRight: Radius.circular(10)),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.5),
                      //         spreadRadius: 3,
                      //         blurRadius: 2,
                      //         offset: Offset(
                      //             0, 0), // changes position of shadow
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //         MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       imgTitle("Event", "assets/png/event.png"),
                      //       imgTitle("Tracks", "assets/png/tracks.png"),
                      //       imgTitle("Reports", "assets/png/open.png"),
                      //       imgTitle(
                      //           "Command", "assets/png/altitude.png"),
                      //       imgTitle("Street View",
                      //           "assets/png/street view.png"),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget vehicleListView() {
    return Container(
      width: AppSizes.dynamicWidth(context, 1),
      height: 140.h,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length == null ? 0 : widget.data.length,
        itemBuilder: (BuildContext context, i) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = i;
                selectedLatlng = LatLng(
                    widget.data[i]["latitude"], widget.data[i]["longitude"]);
                addCustomWindow();
              });
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: selectedLatlng,
                  zoom: 15.5,
                ),
              ));
            },
            child: Container(
              width: 200.w,
              height: 120.h,
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: selectedIndex == i
                    ? Border.all(color: AppColors.primaryDark, width: 2)
                    : null,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/vehicles/SideView/1.1.png',
                          width: 128.w,
                          height: 43.h,
                        ),
                        text(
                            context,
                            _dashboardProvider.allDevicesData[i]['entity']
                                    ['name']
                                .toString(),
                            18.sp),
                      ],
                    ),
                  ),
                  Container(
                    height: 30.h,
                    width: 200.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7.r),
                        bottomRight: Radius.circular(7.r),
                      ),
                    ),
                    child: text(
                      context,
                      _dashboardProvider.allDevicesData[i]['entity']['model']
                          .toString(),
                      18.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  addCustomWindow() {
    _customInfoWindowController.addInfoWindow!(
      Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: widget.data[selectedIndex].containsKey('attributes')
                        ? widget.data[selectedIndex]['attributes']
                                    .containsKey('motion') &&
                                widget.data[selectedIndex]['attributes']
                                    .containsKey('parking')
                            ? widget.data[selectedIndex]['attributes']['motion'] == false &&
                                    widget.data[selectedIndex]['attributes']
                                            ['parking'] ==
                                        true
                                ? Colors.red
                                : widget.data[selectedIndex]['attributes']['motion'] == false &&
                                        widget.data[selectedIndex]['attributes']
                                                ['parking'] ==
                                            false
                                    ? Colors.yellow
                                    : widget.data[selectedIndex]['attributes']
                                                    ['motion'] ==
                                                true &&
                                            widget.data[selectedIndex]
                                                    ['attributes']['parking'] ==
                                                false
                                        ? Colors.green
                                        : AppColors.grey
                            : AppColors.grey
                        : AppColors.grey,
                    width: 2.w),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.2),
                      blurRadius: 4.r,
                      offset: const Offset(0, 4)),
                ],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    Center(
                        child: SizedBox(
                      width: 150.w,
                      height: 30.h,
                      child: Text(
                        _dashboardProvider.allDevicesData[selectedIndex]
                                ['entity']['name']
                            .toString(),
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Text(
                        _dashboardProvider.allDevicesData[selectedIndex]
                                ['entity']['model']
                            .toString(),
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp)),
                  ],
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 20.w,
              height: 20.h,
              color: widget.data[selectedIndex].containsKey('attributes')
                  ? widget.data[selectedIndex]['attributes']
                              .containsKey('motion') &&
                          widget.data[selectedIndex]['attributes']
                              .containsKey('parking')
                      ? widget.data[selectedIndex]['attributes']['motion'] ==
                                  false &&
                              widget.data[selectedIndex]['attributes']
                                      ['parking'] ==
                                  true
                          ? Colors.red
                          : widget.data[selectedIndex]['attributes']
                                          ['motion'] ==
                                      false &&
                                  widget.data[selectedIndex]['attributes']
                                          ['parking'] ==
                                      false
                              ? Colors.yellow
                              : widget.data[selectedIndex]['attributes']
                                              ['motion'] ==
                                          true &&
                                      widget.data[selectedIndex]['attributes']
                                              ['parking'] ==
                                          false
                                  ? Colors.green
                                  : AppColors.grey
                      : AppColors.grey
                  : AppColors.grey,
            ),
          ),
        ],
      ),
      selectedLatlng,
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
                            print("pop");
                            AppRoutes.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new)),
                      SizedBox(
                        width: 30.w,
                      ),
                      text(
                          context,
                          "( ${widget.type} )  ${widget.data.isEmpty ? 0 : widget.data.length}",
                          26.sp),
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
}
