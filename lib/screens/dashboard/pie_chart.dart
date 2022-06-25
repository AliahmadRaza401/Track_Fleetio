import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:lottie/lottie.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../../utils/constants.dart';

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element
class PieChat_Screen extends StatelessWidget {
  TooltipBehavior tool;
  var vehiclecount;
  List data;

  PieChat_Screen(
      {Key? key,
      required this.tool,
      required this.data,
      required this.vehiclecount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SizedBox(
          width: 481.74.w,
          // height: 468.h,
          child: Column(
            children: [
              Center(
                child: Text("Car Status Graph",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu')),
              ),
              data.isEmpty
                  ? Lottie.asset("assets/raw/no_graph.json", height: 200.h)
                  : SizedBox(
                      height: 438.h,
                      child: Stack(
                        children: <Widget>[
                          SfCircularChart(
                            tooltipBehavior: tool,
                            series: <CircularSeries>[
                              RadialBarSeries(
                                gap: '6%',
                                radius: '100%',
                                dataSource: data,
                                cornerStyle: CornerStyle.bothCurve,
                                xValueMapper: (data, _) =>
                                    data['attributes']['motion'],
                                yValueMapper: (data, _) => data.length,
                                enableTooltip: true,
                                pointColorMapper: (data, _) => AppColors.pcolor,
                                // data.gStatus == "Parked"
                                //     ? AppColors.pcolor
                                //     : data.gStatus == "Moving"
                                //         ? AppColors.mcolor
                                //         : data.gStatus == "Offline"
                                //             ? AppColors.offcolor
                                //             : data.gStatus == "NetOff"
                                //                 ? AppColors.nrcolor
                                //                 : data.gStatus == "Idle"
                                //                     ? AppColors.icolor
                                //                     : AppColors.darkblue,
                              )
                            ],
                          ),
                          Positioned(
                            //  right:Responsive.isTablet(context)?250: 170,
                            left: 0,
                            top: 2,
                            child: Container(
                              width: 200.w,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      offset: const Offset(0.0, 4.0),
                                      //(x,y)
                                      blurRadius: 17.0.r,
                                      spreadRadius: 1.r,
                                    ),
                                  ],
                                  color: const Color(0xCDFFFFFF),
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      reverse: true,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 120.w,
                                              child: Text(
                                                "Parked",
                                                // data[index].gStatus +
                                                //     " on Map",
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: AppColors.darkblue,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Poppins',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Text(
                                              "6",
                                              // data[index]
                                              //     .countVehicles
                                              //     .toString(),
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: AppColors.darkblue,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            CircularPercentIndicator(
                                              radius: 10.0,
                                              lineWidth: 2.5,
                                              percent: 1.0,
                                              progressColor: AppColors.pcolor,
                                              //  data[index]
                                              //             .gStatus ==
                                              //         "Parked"
                                              //     ? AppColors.pcolor
                                              //     : data[index].gStatus ==
                                              //             "Moving"
                                              //         ? AppColors.mcolor
                                              //         : data[index]
                                              //                     .gStatus ==
                                              //                 "Offline"
                                              //             ? AppColors.offcolor
                                              //             : data[index]
                                              //                         .gStatus ==
                                              //                     "NetOff"
                                              //                 ? AppColors.nrcolor
                                              //                 : data[index]
                                              //                             .gStatus ==
                                              //                         "Idle"
                                              //                     ? AppColors.icolor
                                              //                     : AppColors.darkblue,
                                            ),
                                          ],
                                        );
                                      })),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            left: 0.0,
                            top: Responsive.isTablet(context) ? 140 : 100,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              constraints: BoxConstraints(
                                minWidth: 14.w,
                                minHeight: 14.h,
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/tom.png",
                                      width: 60.92.w, height: 60.92.h),
                                  Text("Total on Map",
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          color: AppColors.darkblue,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins')),
                                  Text(
                                    vehiclecount.toString() == "null"
                                        ? "0"
                                        : vehiclecount.toString(),
                                    style: TextStyle(
                                        fontSize: 28.sp,
                                        color: AppColors.darkblue,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }
}
