import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/screens/map/vehicle_map.dart';
import 'package:track_flotilla/screens/widgets/imgTitleValue.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/constants.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../../helper/basic_fun.dart';
import '../../providers/dashboard_provider.dart';

class GridViewCard extends StatefulWidget {
  const GridViewCard({Key? key}) : super(key: key);

  @override
  State<GridViewCard> createState() => _GridViewCardState();
}

class _GridViewCardState extends State<GridViewCard> {
  late DashboardProvider _dashboardProvider;
  late LoadingProvider _loadingProvider;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    _loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    _dashboardProvider.fetchAllDevicesData(context);
    if (_dashboardProvider.positionsList.length > 6) {
      setState(() {
        pullUp = true;
      });
    } else {
      setState(() {
        pullUp = false;
      });
    }
  }

  void _onLoading() async {
    log("Pull _onLoading...");
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      smartItemCount += 5;
    });

    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    log("Pull _onRefresh...");
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 2));
    smartItemCount += 5;
    _refreshController.loadComplete();
  }

  bool pullUp = false;
  @override
  Widget build(BuildContext context) {
    print(
        '_dashboardProvider.allDevicesData.length: ${_dashboardProvider.allDevicesData.length}');
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: pullUp,
      header: const WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: _dashboardProvider.positionsList.length > 6
              ? smartItemCount
              : _dashboardProvider.positionsList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index >= _dashboardProvider.positionsList.length) {
              pullUp = false;

              return const Offstage();
            } else {
              return gridCard(context, index);
            }
          }),
    );
  }

  Widget gridCard(BuildContext context, int index) {
    log('index: $index');
    List data = _dashboardProvider.allDevicesData;
    print(
        '_dashboardProvider.allDevicesData: ${_dashboardProvider.allDevicesData.length}');
    print(
        '_dashboardProvider.positionsList: ${_dashboardProvider.positionsList.length}');
    var positionList = _dashboardProvider.positionsList
        .where((o) =>
            o['id'].toString() ==
            data[index]['entity']['positionId'].toString())
        .toList();

    // log("P : ${positionList.toString()}");
    var position = positionList.isNotEmpty ? positionList[0] : {};
    // log('position: $position');

    return InkWell(
      onTap: () {
        AppRoutes.push(
            context,
            VehicleMap(
              LatLng(
                  double.parse(position.containsKey('latitude') &&
                          position['latitude'] != null
                      ? position['latitude'].toString()
                      : "0.0"),
                  double.parse(position.containsKey('longitude') &&
                          position['longitude'] != null
                      ? position['longitude'].toString()
                      : "0.0")),
              data[index]['entity']['name'].toString(),
              position.containsKey('address') && position['address'] != null
                  ? position['address'].toString()
                  : "N/A",
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('batteryLevel') &&
                          position['attributes']['batteryLevel'] != null
                      ? position['attributes']['batteryLevel'].toString()
                      : "0"
                  : '0',
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('distance') &&
                          position['attributes']['distance'] != null
                      ? position['attributes']['distance']
                          .toStringAsFixed(2)
                          .toString()
                      : "0"
                  : '0',
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('hours') &&
                          position['attributes']['hours'] != null
                      ? position['attributes']['hours'].toString()
                      : "0"
                  : '0',
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('event') &&
                          position['attributes']['event'] != null
                      ? position['attributes']['event'].toString()
                      : "0"
                  : '0',
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('odometer') &&
                          position['attributes']['odometer'] != null
                      ? position['attributes']['odometer'].toString()
                      : "0"
                  : '0',
              data[index]['entity']['model'] == null
                  ? "N/A"
                  : data[index]['entity']['model'].toString(),
              data[index]['entity']['name'] == null
                  ? "N/A"
                  : data[index]['entity']['name'].toString(),
              position.containsKey('speed') && position['speed'] != null
                  ? position['speed'].toStringAsFixed(0).toString()
                  : "0",
              position.containsKey('attributes')
                  ? position['attributes'].containsKey('motion') &&
                          position['attributes'].containsKey('parking')
                      ? position['attributes']['motion'] == false &&
                              position['attributes']['parking'] == true
                          ? "Parked"
                          : position['attributes']['motion'] == false &&
                                  position['attributes']['parking'] == false
                              ? "Idle"
                              : position['attributes']['motion'] == true &&
                                      position['attributes']['parking'] == false
                                  ? "Moving"
                                  : "N/A"
                      : "N/A"
                  : "N/A",
              position['course'].toString(),
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 10.h,
        ),
        width: AppSizes.dynamicWidth(context, 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 5.0.r,
                spreadRadius: 2.r,
                offset: const Offset(0.0, 0.0)),
          ],
        ),
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
                    // color: Colors.green,

                    gradient: position.containsKey('attributes')
                        ? position['attributes'].containsKey('motion') &&
                                position['attributes'].containsKey('parking')
                            ? position['attributes']['motion'] == false &&
                                    position['attributes']['parking'] == true
                                ? AppColors.parkedGradi
                                : position['attributes']['motion'] == false &&
                                        position['attributes']['parking'] ==
                                            false
                                    ? AppColors.idleGradi
                                    : position['attributes']['motion'] ==
                                                true &&
                                            position['attributes']['parking'] ==
                                                false
                                        ? AppColors.movingGradi
                                        : AppColors.notResponceGradi
                            : AppColors.notResponceGradi
                        : AppColors.notResponceGradi,

                    // gradient: data[index]['entity']['status'] == "online"
                    //     ? AppColors.movingGradi
                    //     : data[index]['entity']['status'] == "offline"
                    //         ? AppColors.stopGradi
                    //         : data[index]['entity']['status'] == "unknown"
                    //             ? AppColors.notResponceGradi
                    //             : AppColors.movingGradi,
                    // border: Border.all(color: Colors.green),
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
                            position.containsKey('attributes')
                                ? position['attributes']
                                            .containsKey('motion') &&
                                        position['attributes']
                                            .containsKey('parking')
                                    ? position['attributes']['motion'] ==
                                                false &&
                                            position['attributes']['parking'] ==
                                                true
                                        ? "Parked"
                                        : position['attributes']['motion'] ==
                                                    false &&
                                                position['attributes']
                                                        ['parking'] ==
                                                    false
                                            ? "Idle"
                                            : position['attributes']
                                                            ['motion'] ==
                                                        true &&
                                                    position['attributes']
                                                            ['parking'] ==
                                                        false
                                                ? "Moving"
                                                : "N/A"
                                    : "N/A"
                                : "N/A",

                            // data[index]['entity']['status'] == "online"
                            //     ? "Moving"
                            //     : data[index]['entity']['status'] == "offline"
                            //         ? "Stopped"
                            //         : data[index]['entity']['status'] ==
                            //                 "unknown"
                            //             ? "N/A"

                            //                 : "N/A" ,
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Container(
                      //   width: 180.w,
                      //   height: Responsive.isTablet(context) ? 27.h : 25.h,
                      //   decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.only(bottomLeft: Radius.circular(7.r)),

                      //     // color:Colors.white,
                      //   ),
                      //   child: Text(
                      //     "Since 01h:22m:25s",
                      //     style: TextStyle(
                      //         fontSize:
                      //             Responsive.isTablet(context) ? 13.sp : 16.sp,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w300,
                      //         fontFamily: 'Poppins'),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // )
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
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        data[index]['entity']['category'] ==
                                                null
                                            ? "N/A"
                                            : data[index]['entity']['category']
                                                .toString(),
                                        22.sp,
                                        boldText: FontWeight.bold,
                                        color: Colors.white),
                                    text(
                                        context,
                                        data[index]['entity']['name'] == null
                                            ? "N/A"
                                            : data[index]['entity']['name']
                                                .toString(),
                                        22.sp,
                                        boldText: FontWeight.bold,
                                        color: Colors.white),
                                  ],
                                ),
                                // SizedBox(
                                //     width: 263.w,
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         text(
                                //             context,
                                //             data[index]['entity']['model'] == null
                                //                 ? "N/A"
                                //                 : data[index]['entity']['model']
                                //                     .toString(),
                                //             22.sp,
                                //             color: Colors.white),
                                //       ],
                                //     )),
                                Container(
                                  width: 260.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.r),
                                      bottomRight: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: text(
                                        context,
                                        data[index]['entity']['model'] == null
                                            ? "N/A"
                                            : data[index]['entity']['model']
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
                      width: Responsive.isTablet(context) ? 170.w : 170.w,
                      height: Responsive.isTablet(context) ? 190.h : 146.h,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Speed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.isTablet(context)
                                            ? 15.sp
                                            : 18.sp,
                                      ),
                                    ),
                                    Text(
                                      position.containsKey('speed') &&
                                              position['speed'] != null
                                          ? position['speed']
                                              .toStringAsFixed(0)
                                              .toString()
                                          : "0",
                                      style: GoogleFonts.quantico(
                                        fontSize: 26.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "km/h",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.isTablet(context)
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

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Responsive.isTablet(context) ? 250.w : 240.w,
                    height: Responsive.isTablet(context) ? 220.h : 200.h,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0.0, 0.0), //(x,y)
                              blurRadius: 5,
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xffE9EDF0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/png/servertime.png",
                              width: 30.w,
                              height: 30.h,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Server Time",
                                  style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                SizedBox(
                                  width: 160.w,
                                  child: AutoSizeText(
                                    position.containsKey('serverTime') &&
                                            position['serverTime'] != null
                                        ? dateTimeFormater(DateTime.parse(
                                            position['serverTime']))
                                        : "0.0",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/png/Status.png",
                              width: 30.w,
                              height: 30.h,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Device Time",
                                    style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: 5.h,
                                ),
                                SizedBox(
                                  width: 160.w,
                                  child: AutoSizeText(
                                    position.containsKey('deviceTime') &&
                                            position['deviceTime'] != null
                                        ? dateTimeFormater(DateTime.parse(
                                            position['deviceTime']))
                                        : "0.0",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
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
                    width: Responsive.isTablet(context) ? 250.w : 210.w,
                    height: Responsive.isTablet(context) ? 220.h : 200.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0.0, 4.0), //(x,y)
                            blurRadius: 17.0.r,
                            spreadRadius: 1.r),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: AppColors.primarygradient,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 30.w,
                            ),
                            Image.asset(
                              "assets/png/Driver.png",
                              width: 65.w,
                              height: 65.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 20, top: 0.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        // driverDialog(context, items,
                                        //     dobFormate.toString());
                                      },
                                      child: Icon(
                                        FeatherIcons.info,
                                        size: 30.sp,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        // SizedBox(
                        //     width: 145.w,
                        //     child: Text(
                        //       "35102-49345934503-3",
                        //       style: TextStyle(
                        //         fontSize: 15.sp,
                        //         fontFamily: 'Poppins',
                        //         color: Colors.white,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //       overflow: TextOverflow.ellipsis,
                        //     )),
                        SizedBox(
                            width: 200.w,
                            child: Tooltip(
                              waitDuration: const Duration(seconds: 2),
                              triggerMode: TooltipTriggerMode.tap,
                              message: "Nauman Aziz",
                              child: Text(
                                "N/A",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        SizedBox(
                          width: 120.w,
                          height: 23.h,
                          child: SizedBox(
                            width: 91.w,
                            height: 23.h,
                            child: Text(
                              "N/A",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontFamily: 'Poppins'),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h)
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //  count Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('odometer') &&
                                position['attributes']['odometer'] != null
                            ? position['attributes']['odometer'].toString()
                            : "0"
                        : '0',
                    "Mileage",
                    "assets/png/speedometer 1.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('hours') &&
                                position['attributes']['hours'] != null
                            ? position['attributes']['hours'].toString()
                            : "0"
                        : '0',
                    "Engine",
                    "assets/png/engine.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('batteryLevel') &&
                                position['attributes']['batteryLevel'] != null
                            ? position['attributes']['batteryLevel'].toString()
                            : "0"
                        : '0',
                    "Battery",
                    "assets/png/car-battery.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('event') &&
                                position['attributes']['event'] != null
                            ? position['attributes']['event'].toString()
                            : "0"
                        : '0',
                    "Event",
                    "assets/png/event.png"),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('sat') &&
                                position['attributes']['sat'] != null
                            ? position['attributes']['sat'].toString()
                            : "0"
                        : '0',
                    "Satellite",
                    "assets/png/satellite 1.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('distance') &&
                                position['attributes']['distance'] != null
                            ? position['attributes']['distance']
                                .toStringAsFixed(2)
                                .toString()
                            : "0"
                        : '0',
                    "Distance",
                    "assets/png/last location.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('battery') &&
                                position['attributes']['battery'] != null
                            ? position['attributes']['battery']
                                .toStringAsFixed(2)
                                .toString()
                            : "0"
                        : '0',
                    "T Battery",
                    "assets/png/trackb.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('MC') &&
                                position['attributes']['MC'] != null
                            ? position['attributes']['MC'].toString()
                            : "N/A"
                        : "N/A",
                    "GPS",
                    "assets/png/navi.png"),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('protocol') &&
                                position['attributes']['protocol'] != null
                            ? position['attributes']['protocol'].toString()
                            : "N/A"
                        : 'N/A',
                    "Protocol",
                    "assets/png/P.png"),
                imgTitleValue(
                    position.containsKey('outdated') &&
                            position['outdated'] != null
                        ? position['outdated'].toString()
                        : "N/A",
                    "Outdate",
                    "assets/png/event.png"),
                imgTitleValue(
                    position.containsKey('attributes')
                        ? position['attributes'].containsKey('altitude') &&
                                position['attributes']['altitude'] != null
                            ? position['attributes']['altitude'].toString()
                            : "N/A"
                        : 'N/A',
                    "Altitude",
                    "assets/png/altitude.png"),
                imgTitleValue(
                    position.containsKey('valid') && position['valid'] != null
                        ? position['valid'].toString()
                        : "N/A",
                    "Valid",
                    "assets/png/valid.png"),
              ],
            ),

            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                              position.containsKey('address') &&
                                      position['address'] != null
                                  ? position['address'].toString()
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dateformater(date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
