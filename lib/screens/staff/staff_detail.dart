import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/helper/basic_fun.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';

class StaffDetail extends StatelessWidget {
  String name = '';
  String driverID = '';
  String identityNum = '';
  String address = '';
  String dLicenseClass = '';
  String dLicenseNum = '';
  String dept = '';
  String dLExpDate = '';
  String expDate = '';
  StaffDetail(
      {required this.address,
      required this.dLExpDate,
      required this.dLicenseClass,
      required this.dLicenseNum,
      required this.dept,
      required this.driverID,
      required this.expDate,
      required this.identityNum,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customBackBtnAppBar(context, "Staff"),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Image.asset(
                      'assets/png/Driver.png',
                      width: 150.w,
                      height: 150.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    text(context, name, 26.sp, boldText: FontWeight.bold),
                    SizedBox(
                      height: 10.h,
                    ),
                    text(
                      context,
                      "Driver Id: $driverID",
                      26.sp,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 30.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryDark,
                                ),
                                child: Icon(Icons.mail, color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(
                                context,
                                "E-Mail",
                                22.sp,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryDark,
                                ),
                                child: Icon(Icons.call, color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(
                                context,
                                "Call",
                                22.sp,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryDark,
                                ),
                                child: Icon(Icons.calendar_month_outlined,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(
                                context,
                                "DOB",
                                22.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 60.h,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: 20.w,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF5E6E8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: text(
                          context,
                          "Attributes",
                          26.sp,
                          color: Color(0xff5F5F5F),
                          boldText: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Identity number", 22.sp),
                          text(context, identityNum, 22.sp),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Address", 22.sp),
                          Container(
                              alignment: Alignment.centerRight,
                              width: AppSizes.dynamicWidth(context, 0.6),
                              // color: Colors.amber,
                              child:
                                  text(context, address, 22.sp, maxLines: 4)),
                        ],
                      ),

                      //  License Number
                      Container(
                        height: 60.h,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: 20.w,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF5E6E8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: text(
                          context,
                          "License Info",
                          26.sp,
                          color: Color(0xff5F5F5F),
                          boldText: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Driver License Class", 22.sp),
                          text(context, dLicenseClass, 22.sp),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Driver License Number", 22.sp),
                          text(context, dLicenseNum, 22.sp, maxLines: 4),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Department", 22.sp),
                          text(context, dept, 22.sp, maxLines: 4),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "D/L Expiration Date", 22.sp),
                          text(context, dateTimeFormater(DateTime.parse(dLExpDate)),
                              22.sp,
                              maxLines: 4),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, "Expiration Date", 22.sp),
                          text(context,
                              dateTimeFormater(DateTime.parse(expDate)), 22.sp,
                              maxLines: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
