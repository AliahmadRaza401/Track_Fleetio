import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/constants.dart';

import '../../utils/appColor.dart';

Widget inputTextField(context, label, myController,
    {function, function2, password = false, icon, keyboardType = ""}) {
  return Container(
    width: 400.w,
    color: AppColors.noColor,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (function == "")
          ? () {
              return null;
            }
          : function,
      controller: myController,
      textInputAction: TextInputAction.next,
      keyboardType:
          keyboardType == "" ? TextInputType.emailAddress : keyboardType,
      obscureText: password == true ? obscureText : false,
      cursorColor: AppColors.white,
      cursorWidth: 1.0,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
      ),
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        focusColor: AppColors.grey,
        hoverColor: AppColors.grey,
        fillColor: AppColors.noColor,
        filled: true,
        isDense: true,
        hintText: label,
        // suffixIcon: Image.asset(
        //   "$icon",
        //   scale: 6.0,
        //   color: Colors.white,
        // ),
        hintStyle: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
        ),
        errorStyle: TextStyle(
          color: Colors.yellow[400],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.balck),
        ),
        contentPadding: EdgeInsets.only(
          left: AppSizes.dynamicWidth(context, .05),
          bottom: AppSizes.dynamicHeight(context, .017),
          top: AppSizes.dynamicHeight(context, .017),
        ),
      ),
    ),
  );
}

Widget inputPasseordTextField(context, label, myController, Widget button,
    {function, function2, password = false, icon, keyboardType = ""}) {
  return Container(
    width: 400.w,
    color: AppColors.noColor,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (function == "")
          ? () {
              return null;
            }
          : function,
      controller: myController,
      textInputAction: TextInputAction.next,
      keyboardType:
          keyboardType == "" ? TextInputType.emailAddress : keyboardType,
      obscureText: password == true ? obscureText : false,
      cursorColor: AppColors.white,
      cursorWidth: 1.0,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
      ),
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        focusColor: AppColors.grey,
        hoverColor: AppColors.grey,
        fillColor: AppColors.noColor,
        filled: true,
        isDense: true,
        hintText: label,
        suffixIcon: button,
        hintStyle: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
        ),
        errorStyle: TextStyle(
          color: Colors.yellow[400],
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: AppColors.balck),
        ),
        contentPadding: EdgeInsets.only(
          left: AppSizes.dynamicWidth(context, .05),
          bottom: AppSizes.dynamicHeight(context, .017),
          top: AppSizes.dynamicHeight(context, .017),
        ),
      ),
    ),
  );
}

myinputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
    /* -- Text and Icon -- */
    hintText: "Search...",
    hintStyle: const TextStyle(
      fontSize: 18,
      color: Color(0xFFB3B1B1),
    ), // TextStyle
    suffixIcon: const Icon(
      Icons.search,
      size: 26,
      color: Colors.black54,
    ), // Icon
    /* -- Border Styling -- */
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFFD1D3D4),
      ), // BorderSide
    ), // OutlineInputBorder
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFFD1D3D4),
      ), // BorderSide
    ), // OutlineInputBorder
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(
        width: 2.0,
        color: Color.fromARGB(255, 207, 138, 148),
      ), // BorderSide
    ), // OutlineInputBorder
  );
}

alertinputDecoration(hint) {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    /* -- Text and Icon -- */
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 18,
      color: Color(0xFFB3B1B1),
    ), // TextStyle
    // Icon
    /* -- Border Styling -- */
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 2.0,
        color: Colors.black,
      ), // BorderSide
    ), // OutlineInputBorder
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 2.0,
        color: Colors.black45,
      ), // BorderSide
    ), // OutlineInputBorder
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(
        width: 2.0,
        color: Color.fromARGB(255, 207, 138, 148),
      ), // BorderSide
    ), // OutlineInputBorder
  );
}
