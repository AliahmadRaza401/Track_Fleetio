import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget imgTitleValue(value, title, img) {
  return Container(
    height: 113.h,
    width: 92.w,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
        ),
        Image.asset(
          img,
          width: 42.w,
          height: 42.h,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
        ),
      ],
    ),
  );
}

Widget imgTitle(title, img) {
  return Container(
    height: 90.h,
    width: 92.w,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          img,
          width: 42.w,
          height: 42.h,
          // color: Colors.black,
        ),
        Container(
          padding: EdgeInsets.only(top: 5.h),
          // color: Colors.amber,
          alignment: Alignment.center,
          child: AutoSizeText(
            title,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
        // Text(
        //   title,
        //   style: TextStyle(fontSize: 20.sp, fontFamily: 'Poppins'),
        // ),
      ],
    ),
  );
}
