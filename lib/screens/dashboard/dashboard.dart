import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:track_flotilla/providers/dashboard_provider.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/screens/Home/home.dart';
import 'package:track_flotilla/screens/dashboard/grid_view.dart';
import 'package:track_flotilla/screens/dashboard/pie_chart.dart';
import 'package:track_flotilla/screens/map/vehicle_map.dart';
import 'package:track_flotilla/screens/map/vehicle_units_map.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../providers/loading_provider.dart';
import '../../utils/responsive.dart';
import '../widgets/my_text.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late DashboardProvider _dashboardProvider;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  AnimationController? controller;
  Animation<Offset>? offset;
  late MonitoringProvider monitoringProvider;
  TooltipBehavior? _tooltipBehavior;
  TooltipBehavior? _tooltipBehavior1;
  TooltipBehavior? _tooltipBehavior2;
  @override
  void initState() {
    super.initState();
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.4))
        .animate(controller!);
    controller!.forward();
    monitoringProvider =
        Provider.of<MonitoringProvider>(context, listen: false);
    // monitoringProvider.socketConnect();
    /// initPlatformState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior1 = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    startTimer();
    getData();
  }

  dateFormet() {
    String formattedDate =
        DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now());
  }

  late Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        // _dashboardProvider.timerDecrease();
        if (_dashboardProvider.time == 0) {
          getData();
        } else {
          _dashboardProvider.timerDecrease();
        }
      },
    );
  }

  bool loading = true;
  var userName = '';
  getData() async {
    await _dashboardProvider.fetchAllDevicesData(context);
    await _dashboardProvider.fetchAllPositions(context);
    var val = await SharedPref.getUserName();
    if (mounted) {
      setState(() {
        userName = val;
        loading = false;
        _dashboardProvider.time = 60;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    //   _dashboardProvider.channel.sink.close();
    super.dispose();
  }

  void _onLoading() async {
    log("Pull Loading...");
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 2));
    smartItemCount += 5;
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    log("Pull Loading...");
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      smartItemCount += 5;
    });

    _refreshController.loadComplete();
  }

  double toolbarHeight = 400.h;
  double gridHeight = 700.h;
  bool ishow = true;
  @override
  Widget build(BuildContext context) {
    loading = Provider.of<LoadingProvider>(context).loading;
    log('loading: $loading');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: toolbarHeight,
        flexibleSpace: Stack(
          children: [
            SlideTransition(
              position: offset!,
              child: motionStatusCard(),
            ),
            Column(
              children: [
                Container(
                  // height: 210.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.purplegradient,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(22.r),
                        bottomRight: Radius.circular(22.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(0.0, 4.0), //(x,y)
                        blurRadius: 10.0.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 5, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // reuseableData.isLoadingv
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           ToastUtils.showCustomToast(context,
                              //               "Please Wait", Colors.blueAccent);
                              //         },
                              //         child: Icon(
                              //           FeatherIcons.alignLeft,
                              //           color: AppColors.white,
                              //           size: 30.sp,
                              //         ))
                              //     :
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  z.toggle!();
                                },
                              ),

                              SizedBox(
                                width: 10.w,
                              ),
                              Text("Dashboard",
                                  style: TextStyle(
                                      fontSize: 34.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                      fontFamily: 'Ubuntu')),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            getData();

                                            // Provider.of<LoadingProvider>(
                                            //   context,
                                            //   listen: false,
                                            // ).setLoading(true);
                                            // _dashboardProvider
                                            //     .fetchAllDevicesData(context);

                                            // Future.delayed(
                                            //     const Duration(
                                            //         milliseconds: 500), () {
                                            //           Provider.of<LoadingProvider>(
                                            //   context,
                                            //   listen: false,
                                            // ).setLoading(false);
                                            // });
                                            // setState(() {
                                            //   reuseableData.isLoadingv =
                                            //       true;
                                            //   reuseableData
                                            //       .isRefreshClicked = true;
                                            // });
                                            // _onRefresh();
                                          },
                                          child: const Icon(
                                              FeatherIcons.refreshCw,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                        child: Consumer<DashboardProvider>(
                                            builder: (context, value, child) {
                                          return Text(
                                            "${value.time}",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: AppColors.white,
                                                fontFamily: 'Poppins'),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // AwesomeNotifications()
                                      //     .getGlobalBadgeCounter()
                                      //     .then(
                                      //       (value) =>
                                      //           AwesomeNotifications()
                                      //               .setGlobalBadgeCounter(
                                      //                   value = 0),
                                      //     );
                                      // setState(() {
                                      //   reuseableData.isclicked = true;
                                      // });
                                      // if (reuseableData.isclicked) {
                                      //   setState(() {
                                      //     reuseableData.count = 0;
                                      //   });
                                      //   if (reuseableData.sd == "") {
                                      //   } else {
                                      //     AwesomeNotifications()
                                      //         .getGlobalBadgeCounter()
                                      //         .then(
                                      //           (value) =>
                                      //               AwesomeNotifications()
                                      //                   .setGlobalBadgeCounter(
                                      //                       value = 0),
                                      //         );
                                      //     Navigator.push(
                                      //         context,
                                      //         PageTransition(
                                      //             type: PageTransitionType
                                      //                 .rightToLeft,
                                      //             child: Notifications(
                                      //                 data: reuseableData
                                      //                     .notificationsData,
                                      //                 clicked: reuseableData
                                      //                     .isclicked)));
                                      //     setState(() {
                                      //       reuseableData.result = false;
                                      //     });
                                      //   }
                                      // }
                                    },
                                    child: Badge(
                                      shape: BadgeShape.square,
                                      borderRadius: BorderRadius.circular(5),
                                      position: BadgePosition.topEnd(
                                          top: -5, end: -5),
                                      padding: const EdgeInsets.all(2),
                                      badgeContent: Text(
                                        "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      child: Image.asset(
                                        "assets/png/notification.png",
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 15, right: 0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Welcome!",
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.sp,
                                            fontFamily: 'Ubuntu')),
                                    SizedBox(
                                      width: 300.w,
                                      child: Tooltip(
                                        waitDuration:
                                            const Duration(seconds: 2),
                                        triggerMode: TooltipTriggerMode.tap,
                                        message: userName,
                                        child: Text(
                                          userName.toString(),
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.sp,
                                              fontFamily: 'Ubuntu'),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    // Text("Sync Date & Time",
                                    //     style: TextStyle(
                                    //         color: AppColors.white,
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 19.sp,
                                    //         fontFamily: 'Ubuntu')),
                                    Text(
                                        DateFormat('EEE, MMM d, y')
                                            .format(DateTime.now())
                                            .toString(),
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20.sp,
                                            fontFamily: 'Ubuntu')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeInLeft(
                        child: text(context, "Monitoring", 25.sp,
                            boldText: FontWeight.w900, fontFamily: 'Ubuntu'),
                      ),
                      GestureDetector(
                          onTap: () {
                            switch (controller!.status) {
                              case AnimationStatus.completed:
                                setState(() {
                                  ishow = !ishow;
                                  toolbarHeight = Responsive.isTablet(context)
                                      ? 250.h
                                      : 230.h;
                                  gridHeight = 880.h;
                                });
                                controller!.reverse();
                                break;
                              case AnimationStatus.dismissed:
                                setState(() {
                                  ishow = !ishow;
                                  toolbarHeight = 400.h;
                                  gridHeight = 700.h;
                                });
                                controller!.forward();
                                break;
                              default:
                            }
                          },
                          child: ishow == true
                              ? Icon(FeatherIcons.eye,
                                  color: Colors.black, size: 30.sp)
                              : Icon(FeatherIcons.eyeOff,
                                  color: Colors.black, size: 30.sp))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        height: AppSizes.dynamicHeight(context, 1),
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
          // vertical: 20.h,
        ),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              loading
                  ? Column(
                      children: [
                        Lottie.asset("assets/json/9329-loading.json"),
                        Text("Please wait we are getting information for you.",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: const Color(0xFF848282),
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  : Column(
                      children: [
                        //  PieChat_Screen(
                        //       tool: _tooltipBehavior!,

                        //       vehiclecount: _dashboardProvider.positionsList.length, data: _dashboardProvider.positionsList,),
                        DelayedDisplay(
                            delay: Duration(milliseconds: 500),
                            // ignore: avoid_unnecessary_containers
                            child: Container(
                                height: gridHeight, child: GridViewCard())),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

//
  Widget motionStatusCard() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      // width: AppSizes.dynamicWidth(context, 1),
      height: 180.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VehicleUnitMap(
                    _dashboardProvider.positionsList,
                    "Total",
                  ));
            },
            child: statusCard(
              _dashboardProvider.positionsList.isEmpty
                  ? "0"
                  : _dashboardProvider.positionsList.length.toString(),
              "Total Units",
              AppColors.totalUnitGradi,
              'assets/png/Total units.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VehicleUnitMap(
                    _dashboardProvider.movingDevicesData,
                    "Moving",
                  ));
            },
            child: statusCard(
              _dashboardProvider.movingDevicesData.isEmpty
                  ? "0"
                  : _dashboardProvider.movingDevicesData.length.toString(),
              "Moving",
              AppColors.movingGradi,
              'assets/png/Group.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VehicleUnitMap(
                    _dashboardProvider.idleDevicesData,
                    "Idle",
                  ));
            },
            child: statusCard(
              _dashboardProvider.idleDevicesData.isEmpty
                  ? "0"
                  : _dashboardProvider.idleDevicesData.length.toString(),
              "Idle",
              AppColors.idleGradi,
              'assets/png/Car-idle.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VehicleUnitMap(
                    _dashboardProvider.parkedDevicesData,
                    "Parked",
                  ));
            },
            child: statusCard(
              _dashboardProvider.parkedDevicesData.isEmpty
                  ? "0"
                  : _dashboardProvider.parkedDevicesData.length.toString(),
              "Parked",
              AppColors.parkedGradi,
              'assets/png/Stop-car.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VehicleUnitMap(
                    _dashboardProvider.unknowDevicesData,
                    "Not Responce",
                  ));
            },
            child: statusCard(
              _dashboardProvider.unknowDevicesData.isEmpty
                  ? "0"
                  : _dashboardProvider.unknowDevicesData.length.toString(),
              "Not Responce",
              AppColors.notResponceGradi,
              'assets/png/Offline.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard(
    count,
    title,
    gradient,
    image,
  ) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 10.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3.0.r,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        width: 146.w,
        height: 150.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            text(context, count, 24.sp,
                color: Colors.white, boldText: FontWeight.bold),
            Image.asset(
              image,
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(context, title, 17.sp,
                    color: Colors.white, boldText: FontWeight.bold),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: Responsive.isTablet(context) ? 22.sp : 23.sp,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

























// import 'dart:developer';

// import 'package:animate_do/animate_do.dart';
// import 'package:badges/badges.dart';
// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:track_flotilla/providers/dashboard_provider.dart';
// import 'package:track_flotilla/screens/Home/home.dart';
// import 'package:track_flotilla/screens/dashboard/grid_view.dart';
// import 'package:track_flotilla/screens/map/vehicle_map.dart';
// import 'package:track_flotilla/screens/map/vehicle_units_map.dart';
// import 'package:track_flotilla/shared_pref/shared_pref.dart';
// import 'package:track_flotilla/utils/appColor.dart';
// import 'package:track_flotilla/utils/app_routes.dart';
// import 'package:track_flotilla/utils/app_size.dart';
// import 'package:track_flotilla/utils/constants.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import '../../providers/loading_provider.dart';
// import '../../utils/responsive.dart';
// import '../widgets/my_text.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;

// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard>      with SingleTickerProviderStateMixin{
//   late DashboardProvider _dashboardProvider;
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//         AnimationController? controller;
//   Animation<Offset>? offset;

//   @override
//   void initState() {
//     super.initState();
//     _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
//     controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 1));
//     offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.5))
//         .animate(controller!);
//     controller!.forward();
//     getData();
//   }

//   bool loading = true;
//   var userName = '';
//   getData() async {
//     await _dashboardProvider.fetchAllDevicesData(context);
//     await _dashboardProvider.fetchAllPositions(context);
//     var val = await SharedPref.getUserName();
//     setState(() {
//       userName = val;
//       loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _dashboardProvider.channel.sink.close();
//   }

//   void _onLoading() async {
//     log("Pull Loading...");
//     // monitor network fetch
//     await Future.delayed(const Duration(seconds: 2));
//     smartItemCount += 5;
//     _refreshController.loadComplete();
//   }

//   void _onRefresh() async {
//     log("Pull Loading...");
//     // monitor network fetch
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       smartItemCount += 5;
//     });

//     _refreshController.loadComplete();
//   }
//  double toolbarHeight = 400.h;
//    bool ishow = true;
//   @override
//   Widget build(BuildContext context) {
//     loading = Provider.of<LoadingProvider>(context).loading;
//     log('loading: $loading');
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarHeight: toolbarHeight,
//         flexibleSpace: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   // height: 210.h,
//                   decoration: BoxDecoration(
//                     gradient: AppColors.purplegradient,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(22.r),
//                         bottomRight: Radius.circular(22.r)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey,
//                         offset: const Offset(0.0, 4.0), //(x,y)
//                         blurRadius: 10.0.r,
//                         spreadRadius: 5.r,
//                       ),
//                     ],
//                   ),
//                   width: MediaQuery.of(context).size.width,
//                   child: SafeArea(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(top: 10, left: 5, right: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // reuseableData.isLoadingv
//                               //     ? GestureDetector(
//                               //         onTap: () {
//                               //           ToastUtils.showCustomToast(context,
//                               //               "Please Wait", Colors.blueAccent);
//                               //         },
//                               //         child: Icon(
//                               //           FeatherIcons.alignLeft,
//                               //           color: AppColors.white,
//                               //           size: 30.sp,
//                               //         ))
//                               //     :
//                               IconButton(
//                                 icon: Icon(
//                                   Icons.menu,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   z.toggle!();
//                                 },
//                               ),

//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text("Dashboard",
//                                   style: TextStyle(
//                                       fontSize: 34.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.white,
//                                       fontFamily: 'Ubuntu')),
//                               Row(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       GestureDetector(
//                                           onTap: () {
//                                             _dashboardProvider
//                                                 .fetchAllDevicesData(context);
//                                             // setState(() {
//                                             //   reuseableData.isLoadingv =
//                                             //       true;
//                                             //   reuseableData
//                                             //       .isRefreshClicked = true;
//                                             // });
//                                             // _onRefresh();
//                                           },
//                                           child: const Icon(
//                                               FeatherIcons.refreshCw,
//                                               color: Colors.white)),
//                                       SizedBox(
//                                         width: 10.w,
//                                       ),
//                                       SizedBox(
//                                         width: 30.w,
//                                         child: Text(
//                                           "0",
//                                           style: TextStyle(
//                                               fontSize: 16.sp,
//                                               color: AppColors.white,
//                                               fontFamily: 'Poppins'),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // AwesomeNotifications()
//                                       //     .getGlobalBadgeCounter()
//                                       //     .then(
//                                       //       (value) =>
//                                       //           AwesomeNotifications()
//                                       //               .setGlobalBadgeCounter(
//                                       //                   value = 0),
//                                       //     );
//                                       // setState(() {
//                                       //   reuseableData.isclicked = true;
//                                       // });
//                                       // if (reuseableData.isclicked) {
//                                       //   setState(() {
//                                       //     reuseableData.count = 0;
//                                       //   });
//                                       //   if (reuseableData.sd == "") {
//                                       //   } else {
//                                       //     AwesomeNotifications()
//                                       //         .getGlobalBadgeCounter()
//                                       //         .then(
//                                       //           (value) =>
//                                       //               AwesomeNotifications()
//                                       //                   .setGlobalBadgeCounter(
//                                       //                       value = 0),
//                                       //         );
//                                       //     Navigator.push(
//                                       //         context,
//                                       //         PageTransition(
//                                       //             type: PageTransitionType
//                                       //                 .rightToLeft,
//                                       //             child: Notifications(
//                                       //                 data: reuseableData
//                                       //                     .notificationsData,
//                                       //                 clicked: reuseableData
//                                       //                     .isclicked)));
//                                       //     setState(() {
//                                       //       reuseableData.result = false;
//                                       //     });
//                                       //   }
//                                       // }
//                                     },
//                                     child: Badge(
//                                       shape: BadgeShape.square,
//                                       borderRadius: BorderRadius.circular(5),
//                                       position: BadgePosition.topEnd(
//                                           top: -5, end: -5),
//                                       padding: const EdgeInsets.all(2),
//                                       badgeContent: Text(
//                                         "0",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 15.sp,
//                                             fontWeight: FontWeight.bold),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       child: Image.asset(
//                                         "assets/png/notification.png",
//                                         width: 40.w,
//                                         height: 40.h,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0, left: 15, right: 0, bottom: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Welcome!",
//                                         style: TextStyle(
//                                             color: AppColors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 22.sp,
//                                             fontFamily: 'Ubuntu')),
//                                     SizedBox(
//                                       width: 300.w,
//                                       child: Tooltip(
//                                         waitDuration:
//                                             const Duration(seconds: 2),
//                                         triggerMode: TooltipTriggerMode.tap,
//                                         message: userName,
//                                         child: Text(
//                                           userName.toString(),
//                                           style: TextStyle(
//                                               color: AppColors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 22.sp,
//                                               fontFamily: 'Ubuntu'),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text("Sync Date & Time",
//                                         style: TextStyle(
//                                             color: AppColors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 19.sp,
//                                             fontFamily: 'Ubuntu')),
//                                     Text("04-02-2022  12:00:00",
//                                         style: TextStyle(
//                                             color: AppColors.white,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15.sp,
//                                             fontFamily: 'Ubuntu')),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         height: AppSizes.dynamicHeight(context, 1),
//         margin: EdgeInsets.symmetric(
//           horizontal: 10.w,
//           vertical: 20.h,
//         ),
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 10.w,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FadeInLeft(
//                       child: text(context, "Monitoring", 25.sp,
//                           boldText: FontWeight.w900, fontFamily: 'Ubuntu'),
//                     ),
//                    GestureDetector(
//                                   onTap: () {
//                                     switch (controller!.status) {
//                                       case AnimationStatus.completed:
//                                         setState(() {
//                                           ishow = !ishow;
//                                           toolbarHeight =
//                                               Responsive.isTablet(context)
//                                                   ? 250.h
//                                                   : 210.h;
//                                         });
//                                         controller!.reverse();
//                                         break;
//                                       case AnimationStatus.dismissed:
//                                         setState(() {
//                                           ishow = !ishow;
//                                           toolbarHeight =
//                                               Responsive.isTablet(context)
//                                                   ? 440.h
//                                                   : 410.h;
//                                         });
//                                         controller!.forward();
//                                         break;
//                                       default:
//                                     }
//                                   },
//                                   child: ishow == true
//                                       ? Icon(FeatherIcons.eye,
//                                           color: Colors.black, size: 30.sp)
//                                       : Icon(FeatherIcons.eyeOff,
//                                           color: Colors.black, size: 30.sp))
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               SlideInRight(
//                 child: GestureDetector(
//                     child: Container(child: motionStatusCard())),
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               loading
//                   ? Column(
//                       children: [
//                         Lottie.asset("assets/json/9329-loading.json"),
//                         Text("Please wait we are getting information for you.",
//                             style: TextStyle(
//                                 fontSize: 20.sp,
//                                 color: const Color(0xFF848282),
//                                 fontFamily: 'Ubuntu',
//                                 fontWeight: FontWeight.bold))
//                       ],
//                     )
//                   : DelayedDisplay(
//                       delay: Duration(milliseconds: 500),
//                       // ignore: avoid_unnecessary_containers
//                       child: GestureDetector(child: GridViewCard())),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// //
//   Widget motionStatusCard() {
//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: 10.w,
//       ),
//       // width: AppSizes.dynamicWidth(context, 1),
//       height: 180.h,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           GestureDetector(
//             onTap: () {
//               AppRoutes.push(
//                   context,
//                   VehicleUnitMap(
//                     _dashboardProvider.positionsList,
//                     "Total",
//                   ));
//             },
//             child: statusCard(
//               _dashboardProvider.positionsList.isEmpty
//                   ? "0"
//                   : _dashboardProvider.positionsList.length.toString(),
//               "Total Monitoring",
//               AppColors.totalUnitGradi,
//               'assets/png/Total units.png',
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AppRoutes.push(
//                   context,
//                   VehicleUnitMap(
//                     _dashboardProvider.movingDevicesData,
//                     "Moving",
//                   ));
//             },
//             child: statusCard(
//               _dashboardProvider.movingDevicesData.isEmpty
//                   ? "0"
//                   : _dashboardProvider.movingDevicesData.length.toString(),
//               "Moving",
//               AppColors.movingGradi,
//               'assets/png/Group.png',
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AppRoutes.push(
//                   context,
//                   VehicleUnitMap(
//                     _dashboardProvider.idleDevicesData,
//                     "Idle",
//                   ));
//             },
//             child: statusCard(
//               _dashboardProvider.idleDevicesData.isEmpty
//                   ? "0"
//                   : _dashboardProvider.idleDevicesData.length.toString(),
//               "Idle",
//               AppColors.idleGradi,
//               'assets/png/Car-idle.png',
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AppRoutes.push(
//                   context,
//                   VehicleUnitMap(
//                     _dashboardProvider.parkedDevicesData,
//                     "Parked",
//                   ));
//             },
//             child: statusCard(
//               _dashboardProvider.parkedDevicesData.isEmpty
//                   ? "0"
//                   : _dashboardProvider.parkedDevicesData.length.toString(),
//               "Parked",
//               AppColors.parkedGradi,
//               'assets/png/Stop-car.png',
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AppRoutes.push(
//                   context,
//                   VehicleUnitMap(
//                     _dashboardProvider.unknowDevicesData,
//                     "Not Responce",
//                   ));
//             },
//             child: statusCard(
//               _dashboardProvider.unknowDevicesData.isEmpty
//                   ? "0"
//                   : _dashboardProvider.unknowDevicesData.length.toString(),
//               "Not Responce",
//               AppColors.notResponceGradi,
//               'assets/png/Offline.png',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget statusCard(
//     count,
//     title,
//     gradient,
//     image,
//   ) {
//     return GestureDetector(
//       child: Container(
//         margin: EdgeInsets.symmetric(
//           horizontal: 5.w,
//           vertical: 10.h,
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: 5,
//         ),
//         decoration: BoxDecoration(
//           gradient: gradient,
//           borderRadius: BorderRadius.circular(10.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 3.0.r,
//               offset: Offset(0, 0), // changes position of shadow
//             ),
//           ],
//         ),
//         width: 146.w,
//         height: 150.h,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             text(context, count, 24.sp,
//                 color: Colors.white, boldText: FontWeight.bold),
//             Image.asset(
//               image,
//               height: 40.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 text(context, title, 17.sp,
//                     color: Colors.white, boldText: FontWeight.bold),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.white,
//                   size: Responsive.isTablet(context) ? 22.sp : 23.sp,
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

























































