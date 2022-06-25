import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';

import 'my_text.dart';

Widget outlineButton(BuildContext context, String name, onTap()) {
  return InkWell(
      onTap: onTap,
      child: Container(
          width: 400.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                9.r,
              )),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20.h,
          ),
          child: text(
            context,
            name,
            22.sp,
            boldText: FontWeight.bold,
            color: AppColors.primaryDark,
          )));
}
