import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget loadingTextAimation() {
  return Column(
    children: [
      Lottie.asset("assets/json/9329-loading.json"),
      Text("Please wait we are getting information for you.",
          style: TextStyle(
              fontSize: 20.sp,
              color: const Color(0xFF848282),
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold))
    ],
  );
}
