import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/Home/home.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';

AppBar customAppBar(BuildContext context, title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    toolbarHeight: 110.h,
    flexibleSpace: Column(
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
              padding: const EdgeInsets.only(top: 10, left: 5, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          z.toggle!();
                        },
                      ),
                      Text(title.toString(),
                          style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontFamily: 'Ubuntu')),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

AppBar customBackBtnAppBar(BuildContext context, title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    toolbarHeight: 110.h,
    flexibleSpace: Column(
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
              padding: const EdgeInsets.only(top: 10, left: 5, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          AppRoutes.pop(context);
                        },
                      ),
                      Text(title.toString(),
                          style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontFamily: 'Ubuntu')),
                      SizedBox(
                        width: 80.w,
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.notifications,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
