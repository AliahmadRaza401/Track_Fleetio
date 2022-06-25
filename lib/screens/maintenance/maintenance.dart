import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/providers/maintenance_provider.dart';
import 'package:track_flotilla/screens/maintenance/maintenance_handler.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/screens/widgets/maintenance_custom.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  late MaintenanceProvider _maintenanceProvider;
  @override
  void initState() {
    super.initState();
    _maintenanceProvider =
        Provider.of<MaintenanceProvider>(context, listen: false);
    getData();
  }

  getData() async {
    await _maintenanceProvider.fetchAllMaintenance(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, "Maintenance"),
        body: Consumer<MaintenanceProvider>(
            builder: ((context, maintenanceProvider, child) {
          return Container(
            // color: Colors.amber,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 240.w,
                        height: 160.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 15,
                              top: 15,
                              child: Image.asset(
                                'assets/png/schedule.png',
                                width: 50.w,
                                height: 50.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        maintenanceProvider.maintenanceList
                                                    .isNotEmpty ||
                                                maintenanceProvider
                                                        .maintenanceList !=
                                                    null
                                            ? maintenanceProvider
                                                .maintenanceList.length
                                                .toString()
                                            : "0",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
                                          child: Text("schedule",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              )),
                                        ),
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 112, 0, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xFFF96ACC9), Color(0xFFF566374)],
                            )),
                      ),
                      Container(
                        width: 240.w,
                        height: 160.h,
                        child: Stack(children: [
                          Positioned(
                            left: 15,
                            top: 15,
                            child: Image.asset(
                              'assets/png/due-date.png',
                              height: 30.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("0",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
                                        child: Text("Due",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                            )),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.fromLTRB(0, 112, 0, 0),
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 228, 179, 138),
                                Color.fromARGB(255, 249, 145, 60)
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 240.w,
                        height: 160.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 15,
                              top: 15,
                              child: Image.asset(
                                'assets/png/complete.png',
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("0",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
                                          child: Text("Complete",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              )),
                                        ),
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 112, 0, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 76, 238, 114),
                                Color.fromARGB(255, 20, 131, 46)
                              ],
                            )),
                      ),
                      Container(
                        width: 240.w,
                        height: 160.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 15,
                              top: 15,
                              child: Image.asset(
                                'assets/png/overdue.png',
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("0",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
                                          child: Text("Over due",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              )),
                                        ),
                                        Container(
                                          // margin: EdgeInsets.fromLTRB(0, 112, 0, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 243, 117, 130),
                                Color.fromARGB(255, 241, 9, 32)
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    height: AppSizes.dynamicHeight(context, 0.55),
                    // color: Colors.amber,
                    child: maintenanceProvider.loading
                        ? loadingTextAimation()
                        : ListView.builder(
                            itemCount: maintenanceProvider.maintenanceList ==
                                    null
                                ? 0
                                : maintenanceProvider.maintenanceList.length,
                            itemBuilder: (BuildContext context, i) {
                              String formaDate = "N/R";
                              if (maintenanceProvider.maintenanceList[i]
                                          ['attributes']['date'] !=
                                      null &&
                                  maintenanceProvider.maintenanceList[i]
                                          ['attributes']['date'] !=
                                      0) {
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');
                                formaDate = formatter.format(DateTime.parse(
                                    maintenanceProvider.maintenanceList[i]
                                        ['attributes']['date']));
                                print(formaDate);
                              }

                              return maintenanceCustom(
                                context,
                                maintenanceProvider.maintenanceList[i]
                                            ['deviceName'] ==
                                        null
                                    ? "N/R"
                                    : maintenanceProvider.maintenanceList[i]
                                            ['deviceName']
                                        .toString(),
                                maintenanceProvider.maintenanceList[i]
                                            ['name'] ==
                                        null
                                    ? "N/R"
                                    : maintenanceProvider.maintenanceList[i]
                                            ['name']
                                        .toString(),
                                maintenanceProvider.maintenanceList[i]
                                            ['cost'] ==
                                        null
                                    ? "N/R"
                                    : maintenanceProvider.maintenanceList[i]
                                            ['cost']
                                        .toString(),
                                maintenanceProvider.maintenanceList[i]
                                            ['attributes']['mileage'] ==
                                        null
                                    ? "N/R"
                                    : maintenanceProvider.maintenanceList[i]
                                            ['attributes']['mileage']
                                        .toString(),
                                maintenanceProvider.maintenanceList[i]
                                            ['attributes']['hours'] ==
                                        null
                                    ? "N/R"
                                    : maintenanceProvider.maintenanceList[i]
                                            ['attributes']['hours']
                                        .toString(),
                                "${formaDate}",
                                maintenanceProvider.maintenanceList[i]['id']
                                    .toString(),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }))
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AddDestination()));
        //     // showAddDialog(context);
        //   },
        //   tooltip: "Add Command",
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
}
