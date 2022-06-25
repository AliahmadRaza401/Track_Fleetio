import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/dashboard_provider.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/screens/map/monitoring_map.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/custom_list_tile.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/screens/widgets/underconstruction.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:web_socket_channel/io.dart';

class MonitoringListPage extends StatefulWidget {
  MonitoringListPage({Key? key}) : super(key: key);

  @override
  State<MonitoringListPage> createState() => _MonitoringListPageState();
}

class _MonitoringListPageState extends State<MonitoringListPage> {
  late MonitoringProvider monitoringProvider;

  @override
  void initState() {
    super.initState();
    monitoringProvider =
        Provider.of<MonitoringProvider>(context, listen: false);
    monitoringProvider.socketConnect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;
    return Scaffold(
      appBar: customAppBar(context, "Monitoring"),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   width: 500.w,
              //   height: 85.h,
              //   child: TextField(
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: const Color(0xFFFFFFFF),
              //       isDense: true,
              //       contentPadding:
              //           const EdgeInsets.symmetric(horizontal: 15.0),
              //       /* -- Text and Icon -- */
              //       hintText: "Search...",
              //       hintStyle: const TextStyle(
              //         fontSize: 18,
              //         color: Color(0xFFB3B1B1),
              //       ), // TextStyle
              //       suffixIcon: const Icon(
              //         Icons.search,
              //         size: 26,
              //         color: Colors.black54,
              //       ), // Icon
              //       /* -- Border Styling -- */
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.r),
              //         borderSide: const BorderSide(
              //           width: 2.0,
              //           color: Color(0xFFD1D3D4),
              //         ), // BorderSide
              //       ), // OutlineInputBorder
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.r),
              //         borderSide: const BorderSide(
              //           width: 2.0,
              //           color: Color(0xFFD1D3D4),
              //         ), // BorderSide
              //       ), // OutlineInputBorder
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.r),
              //         borderSide: BorderSide(
              //           width: 2.0,
              //           color: Color.fromARGB(255, 207, 138, 148),
              //         ), // BorderSide
              //       ), // OutlineInputBorder
              //     ), // InputDecoration
              //   ),
              // ),

              Container(
                // color: Colors.amber,
                height: AppSizes.dynamicHeight(context, 0.9),
                child: Consumer<MonitoringProvider>(
                  builder: (context, value, child) {
                    if (value.socDevicesList.length == 0 ||
                        value.socDevicesList.isEmpty) {
                      return Container(
                        child: Center(
                          child: Column(
                            children: [
                              Lottie.asset('assets/json/Cloud loading.json'),
                              Text("Please wait until getting data..."),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return value.socPositionsList.isEmpty ||
                              value.socPositionsList.length < 0
                          ? Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                        'assets/json/Cloud loading.json'),
                                    Text("Please wait until getting data..."),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.socPositionsList.length == null
                                  ? 0
                                  : value.socPositionsList.length,
                              itemBuilder: (BuildContext context, i) {
                                if (value.socPositionsList.length.toString() ==
                                    "0") {
                                  return Center(
                                    child: Text("No Data"),
                                  );
                                } else {
                                  final index = value.socDevicesList.indexWhere(
                                      (element) =>
                                          element['entity']['id'].toString() ==
                                          value.socPositionsList[i]['deviceId']
                                              .toString());

                                  // value.setDevice(value.socDevicesList[index]);
                                  // value.setPosition(value.socPositionsList[i]);
                                  var dev = value.socDevicesList[index];
                                  var pos = value.socPositionsList[i];

                                  return InkWell(
                                    onTap: () {
                                      print(dev['entity']['name'].toString());
                                      AppRoutes.push(
                                          context,
                                          MonitoringMap(
                                            pos,
                                            dev['entity']['name'].toString(),
                                            dev['entity']['model'].toString(),
                                          ));
                                    },
                                    child: unitCard(
                                      dev['entity']['name'].toString(),
                                      pos['attributes']['motion'] == true &&
                                              pos['attributes']['parking'] ==
                                                  false
                                          ? "Moving"
                                          : pos['attributes']['motion'] ==
                                                      false &&
                                                  pos['attributes']
                                                          ['parking'] ==
                                                      false
                                              ? "Idle"
                                              : "Parked",
                                      dev['entity']['status'].toString(),
                                      pos['speed'].toStringAsFixed(0),
                                    ),
                                  );
                                }
                              },
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AddDestination()));
      //     // showAddDialog(context);
      //   },
      //   tooltip: "Add Grpup",
      //   child: Container(
      //     width: Responsive.isTablet(context) ? 70 : 56,
      //     height: Responsive.isTablet(context) ? 70 : 56,
      //     child: Icon(
      //       FeatherIcons.plus,
      //       size: Responsive.isTablet(context) ? 30.sp : 40.sp,
      //     ),
      //     decoration: const BoxDecoration(
      //       shape: BoxShape.circle,
      //       gradient:
      //           LinearGradient(colors: [Color(0xffDDA7AF), Color(0xff993535)]),
      //     ),
      //   ),
      // ),
    );
  }

  Widget unitCard(name, motionStatus, tStatus, speed) {
    return Container(
      width: AppSizes.dynamicWidth(context, 0.9),
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: Color(0xffD1D3D4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Image.asset(
                  'assets/png/unit1.png',
                  height: 65.h,
                  width: 65.w,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      context,
                      name.toString(),
                      24.sp,
                      boldText: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          motionStatus.toString() == "Moving"
                              ? 'assets/png/movings.png'
                              : motionStatus.toString() == "Parked"
                                  ? 'assets/png/parkeds.png'
                                  : 'assets/png/idles.png',
                          height: 20.h,
                          width: 20.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        text(context, motionStatus.toString(), 18.sp),
                        SizedBox(
                          width: 60.w,
                        ),
                        motionStatus.toString() == "Moving"
                            ? text(
                                context,
                                "${speed} km/h ",
                                18.sp,
                                color: Colors.green,
                                boldText: FontWeight.bold,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                text(context, tStatus.toString(), 18.sp),

                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: tStatus.toString() == "online"
                        ? Colors.green
                        : tStatus.toString() == "offline"
                            ? Colors.red
                            : Colors.blueGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(""),
                ),
                // Icon(Icons.more_vert),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
