import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:track_flotilla/utils/shahdow.dart';

class Reports extends StatefulWidget {
  Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  TextEditingController stdate = TextEditingController();
  TextEditingController etdate = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Reports"),
      body: Container(
        width: AppSizes.dynamicWidth(context, 1),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 500.w,
                    height: 65.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(context, "Select Date", 18.sp),
                            text(context, "This Month", 22.sp),
                          ],
                        ),
                        Icon(
                          FeatherIcons.chevronDown,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 65.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(context, "Report Template", 18.sp),
                            text(context, "This Trip", 22.sp),
                          ],
                        ),
                        Icon(
                          FeatherIcons.chevronDown,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                 
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 65.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(context, "Select Unit", 22.sp),
                        Icon(
                          FeatherIcons.chevronDown,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 65.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primarygradient,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          context,
                          "Submit",
                          22.sp,
                          boldText: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // color: Colors.amber,
                    height: AppSizes.dynamicHeight(context, 0.5),
                    child: Center(
                      child: Image.asset(
                        "assets/png/barperson.png",
                        width: AppSizes.dynamicWidth(context, 0.8),
                        height: AppSizes.dynamicHeight(context, 0.3),
                      ),
                    ),
                  ),
                ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AddDestination()));
          // showAddDialog(context);
        },
        tooltip: "Add Destination",
        child: Container(
          width: Responsive.isTablet(context) ? 70 : 56,
          height: Responsive.isTablet(context) ? 70 : 56,
          child: Icon(
            FeatherIcons.plus,
            size: Responsive.isTablet(context) ? 30.sp : 40.sp,
          ),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, gradient:
                LinearGradient(colors: [Color(0xffDDA7AF), Color(0xff993535)]),),
        ),
      ),
    );
  }
}
