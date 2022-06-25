// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:track_flotilla/screens/dashboard/grid_view.dart';
import 'package:track_flotilla/screens/map/map_services.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../widgets/imgTitleValue.dart';

class VehicleMap extends StatefulWidget {
  late final LatLng latLng;
  String vehcleNumber;
  String name;
  String model;
  String status;
  String speed;
  String address;
  String milage;
  String engine;
  String battery;
  String distance;
  String event;
  String routation;
  VehicleMap(
    @required this.latLng,
    @required this.vehcleNumber,
    @required this.address,
    @required this.battery,
    @required this.distance,
    @required this.engine,
    @required this.event,
    @required this.milage,
    @required this.model,
    @required this.name,
    @required this.speed,
    @required this.status,
    @required this.routation,
  );
  @override
  State<VehicleMap> createState() => VehicleMapState();
}

class VehicleMapState extends State<VehicleMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final PanelController _pc1 = PanelController();
  final Set<Marker> markers = new Set();
  final Set<Circle> circle = Set<Circle>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          Container(
            width: AppSizes.dynamicWidth(context, 1),
            height: AppSizes.dynamicHeight(context, 1),
            child: GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              zoomControlsEnabled: false,
              circles: circle,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _controller.complete(controller);
                DeviceMarkers(widget.latLng);

                controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: widget.latLng,
                    zoom: 15.5,
                  ),
                ));
              },
            ),
          ),
          SafeArea(child: AppBar()),
          zoomButtons(),
          SlidingUpPanel(
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
                              gradient: widget.status == "Moving"
                                  ? AppColors.movingGradi
                                  : widget.status == "Idle"
                                      ? AppColors.idleGradi
                                      : widget.status == "Parked"
                                          ? AppColors.parkedGradi
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
                                      widget.status.toString(),
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
                      SizedBox(
                        height: 0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            // fit: StackFit.passthrough,
                            children: [
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
                                              text(context, widget.name, 22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white),
                                              text(context, widget.vehcleNumber,
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
                                                  context, widget.model, 22.sp,
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
                                                widget.speed,
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
                                  widget.address,
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
                          imgTitleValue(widget.milage, "Mileage",
                              "assets/png/speedometer 1.png"),
                          imgTitleValue(
                              widget.engine, "Engine", "assets/png/engine.png"),
                          imgTitleValue(widget.battery, "Battery",
                              "assets/png/car-battery.png"),
                          imgTitleValue(
                              widget.event, "Event", "assets/png/event.png"),
                          imgTitleValue(widget.distance, "Distance",
                              "assets/png/last location.png"),
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
      ),
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
                      text(context, widget.vehcleNumber.toString(), 26.sp),
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
      markers.add(Marker(
          markerId: MarkerId('Device'),
          rotation: double.parse(widget.routation),
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
        radius: 90,
        zIndex: 1,
        strokeColor: widget.status == "Moving"
            ? Colors.green
            : widget.status == "Idle"
                ? Colors.yellow
                : widget.status == "Parked"
                    ? Colors.red
                    : Colors.green,
        strokeWidth: 2,
        center: showLocation,
        fillColor: widget.status == "Moving"
            ? Colors.green.withAlpha(70)
            : widget.status == "Idle"
                ? Colors.yellow.withAlpha(70)
                : widget.status == "Parked"
                    ? Colors.red.withAlpha(70)
                    : Colors.green.withAlpha(70),
      ));
    });
    return markers;
  }
}
