// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:track_flotilla/model/geoFenceModel.dart';
import 'package:track_flotilla/screens/dashboard/grid_view.dart';
import 'package:track_flotilla/screens/geoFence/geoFence_list_page.dart';
import 'package:track_flotilla/screens/map/map_services.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../widgets/imgTitleValue.dart';

class GeofenceMap extends StatefulWidget {
  String name;
  List<LatlngModel> latlng;
  final Color geoColor;
  final double radius;

  GeofenceMap(
      {required this.name,
      required this.latlng,
      required this.geoColor,
      required this.radius});
  @override
  State<GeofenceMap> createState() => GeofenceMapState();
}

class GeofenceMapState extends State<GeofenceMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final PanelController _pc1 = PanelController();
  final Set<Marker> markers = new Set();
  final Set<Circle> circle = Set<Circle>();
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;
  Set<Polygon> polygonSet = {};
  List<LatLng> polygonCoords = [];
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 90,
  );
  LatLng initLatlng = LatLng(31.582045, 74.329376);
  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _controller.complete(controller);
    initLatlng = LatLng(widget.latlng[0].latitude, widget.latlng[0].longitude);
    if (widget.latlng.length <= 1) {
      DeviceMarkers(initLatlng);
    } else {
      log(widget.latlng.length.toString());

      for (var i in widget.latlng) {
        polygonCoords.add(LatLng(i.latitude, i.longitude));
      }
      setPolygon();

      log("Map End");
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(widget.latlng[0].latitude, widget.latlng[0].longitude),
        zoom: 10,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    log(widget.geoColor.toString());
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
              polylines: _polyline,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: onMapCreated,
              polygons: polygonSet,
            ),
          ),
          SafeArea(child: AppBar()),
          zoomButtons(),
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
                      text(context, "GeoFence  (${widget.name})", 26.sp),
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
    print("Adding marker");
    final Uint8List markerIcon =
        await MapServices.getMarkerWithSize(80, "assets/png/geoFencelogo.png");
    //markers to place on map
    setState(() {
      // markers.add(Marker(
      //     markerId: MarkerId('Device'),
      //     rotation: 0,
      //     position: showLocation,
      //     infoWindow: InfoWindow(title: "Device 1"),
      //     draggable: false,
      //     zIndex: 2,
      //     flat: true,
      //     anchor: Offset(0.5, 0.5),
      //     icon: BitmapDescriptor.fromBytes(markerIcon)));

      circle.add(Circle(
          circleId: CircleId("Device"),
          // radius: showLocation.accuracy,
          radius: widget.radius,
          zIndex: 1,
          strokeColor: widget.geoColor,
          strokeWidth: 2,
          center: showLocation,
          fillColor: widget.geoColor.withAlpha(70)));
    });
    return markers;
  }

  Future setPolylineOnMap(LatLng latLng) async {
    log("String Polyline..............................");
    log("setPolyline ON:   ${LatLng(latLng.latitude, latLng.longitude).toString()}");

    setState(() {
      _polylineCoordinates.add(LatLng(latLng.latitude, latLng.longitude));
      _polyline.add(Polyline(
          width: 5,
          polylineId: PolylineId('polyline'),
          color: widget.geoColor,
          points: _polylineCoordinates));
    });
  }

  setPolygon() {
    // LatLng latlng1 = LatLng(start.latitude, start.latitude);
    // LatLng latlng2 = LatLng(end.latitude, end.longitude);
    // LatLng latlng3 = LatLng(latlng1.latitude, latlng2.longitude);
    // LatLng latlng4 = LatLng(latlng2.latitude, latlng1.longitude);

    // polygonCoords.add(latlng1);
    // polygonCoords.add(latlng2);
    // polygonCoords.add(latlng3);

    // polygonCoords.add(latlng4);
    print('widget.geoColor: ${widget.geoColor}');
    setState(() {
      polygonSet.add(Polygon(
        polygonId: const PolygonId('test'),
        points: polygonCoords,
        strokeColor: widget.geoColor,
        strokeWidth: 3,
        fillColor: widget.geoColor.withAlpha(70),
      ));
    });
  }
}
