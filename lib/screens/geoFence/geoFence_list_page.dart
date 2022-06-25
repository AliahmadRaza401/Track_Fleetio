import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/model/geoFenceModel.dart';
import 'package:track_flotilla/providers/geofence_provider.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/screens/geoFence/geoFence_handler.dart';
import 'package:track_flotilla/screens/geoFence/geofence_add.dart';
import 'package:track_flotilla/screens/map/geofence_Map.dart';
import 'package:track_flotilla/screens/widgets/custom_list_tile.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polymaker/core/models/trackingmode.dart';
import 'package:polymaker/polymaker.dart' as polymaker;

import '../widgets/input_field.dart';

class GeoFenceListPage extends StatefulWidget {
  // List geoFenceList = [];
  GeoFenceListPage();

  @override
  State<GeoFenceListPage> createState() => _GeoFenceListPageState();
}

class _GeoFenceListPageState extends State<GeoFenceListPage> {
  final _formKey = GlobalKey<FormState>();

  List locationList = [];
  List latlngList = [];
  var area = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List filterData = [];

  late GeoFenceProvider _geofenceProvider;
  @override
  void initState() {
    super.initState();
    _geofenceProvider = Provider.of<GeoFenceProvider>(context, listen: false);
    _geofenceProvider.fetchAllGeoFence(context);
    locationList = [];
  }

  void getLocation() async {
    var result = await polymaker.getLocation(
      context,
      trackingMode: TrackingMode.PLANAR,
      enableDragMarker: true,
    );
    var id = await SharedPref.getUserId();
    if (result != null) {
      setState(() {
        locationList = result;
      });

      var areaLat = locationList
          .map((val) => "${val.latitude} ${val.longitude}")
          .toString();
      area = 'LINESTRING $areaLat';
      log('area: $area');

      locationList
          .map((val) => latlngList.add(
                {
                  "lat": val.latitude,
                  "lng": val.longitude,
                },
              ))
          .toString();

      var geoReturn = await _geofenceProvider.addGeoFence(context, id,
          nameController.text, descriptionController.text, area, latlngList);
      nameController.clear();
      descriptionController.clear();
      latlngList.clear();
      locationList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GeoFenceProvider>(
        builder: (context, fence, child) {
          List data = searchController.text.isEmpty
              ? fence.allGeoFenceList
              : filterData;
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 500.w,
                    height: 85.h,
                    child: TextField(
                      controller: searchController,
                      onChanged: ((value) {
                        setState(() {
                          filterData = fence.allGeoFenceList
                              .where((filtData) => filtData['name']
                                  .toString()
                                  .toUpperCase()
                                  .contains(searchController.text
                                      .toString()
                                      .toUpperCase()))
                              .toList();
                        });
                      }),
                      decoration: myinputDecoration(),
                    ),
                  ),
                  fence.loading
                      ? loadingTextAimation()
                      : data.isEmpty
                          ? Center(child: Text("No Record Found"))
                          : Container(
                              height: AppSizes.dynamicHeight(context, 0.8),
                              // color: Colors.amber,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, i) {
                                  return InkWell(
                                    onTap: () {
                                      var groRadius = 0.0;
                                      List<LatlngModel> latlngList = [];
                                      if (data[i]['attributes']['type'] !=
                                          "circle") {
                                        for (var i in data[i]['attributes']
                                            ['latlng']) {
                                          LatlngModel latlng = LatlngModel(
                                            latitude: i['lat'],
                                            longitude: i['lng'],
                                          );
                                          latlngList.add(latlng);
                                          log("not Circle");
                                        }
                                      } else {
                                        groRadius =
                                            data[i]['attributes']['radius'];
                                        LatlngModel latlng = LatlngModel(
                                          latitude: data[i]['attributes']
                                              ['latlng'][0],
                                          longitude: data[i]['attributes']
                                              ['latlng'][1],
                                        );
                                        latlngList.add(latlng);
                                        log(" Circle");
                                      }

                                      String color =
                                          "${data[i]['attributes']['color']}";
                                      String split = color.substring(1);
                                      print('split: $split');

                                      String mergerColor = "0xff$split";

                                      print('mergerColor: $mergerColor');

                                      Color geoColor = color[0] == "#"
                                          ? Color(int.parse(mergerColor))
                                          : Colors.red;
                                      log('geoColor: $geoColor');
                                      print("hy");
                                      AppRoutes.push(
                                        context,
                                        GeofenceMap(
                                          latlng: latlngList,
                                          geoColor: geoColor,
                                          radius: groRadius,
                                          name: data[i]['name'].toString(),
                                        ),
                                      );
                                    },
                                    child: CustomListTile(
                                        name: data[i]['name'],
                                        imageUrl:
                                            "assets/png/geoFencelogo.png"),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // getLocation();
          geoFenceAlert();
          // AppRoutes.push(context, GeofenceAdd());
        },
        tooltip: "Add Geofence",
        child: Container(
          width: Responsive.isTablet(context) ? 70 : 56,
          height: Responsive.isTablet(context) ? 70 : 56,
          child: Icon(
            FeatherIcons.plus,
            size: Responsive.isTablet(context) ? 30.sp : 40.sp,
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                LinearGradient(colors: [Color(0xffDDA7AF), Color(0xff993535)]),
          ),
        ),
      ),
    );
  }

  geoFenceAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 76.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        gradient: AppColors.purplegradient,
                      ),
                      child: text(context, "Set GeoFence Name", 28.sp,
                          color: Colors.white),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 400.w,
                            child: TextFormField(
                              controller: nameController,
                              decoration: alertinputDecoration("name"),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "required";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            width: 400.w,
                            child: TextFormField(
                              maxLines: 5,
                              controller: descriptionController,
                              decoration: alertinputDecoration("description"),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "required";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          AppRoutes.pop(context);
                          getLocation();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 20.h,
                        ),
                        width: 164.w,
                        height: 76.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppColors.purplegradient,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: text(context, "Next", 28.w, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class LatlngModel {
  double latitude;
  double longitude;
  LatlngModel({required this.latitude, required this.longitude});
}
