import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/app_size.dart';

Widget logowithText(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(
      left: AppSizes.dynamicWidth(context, 0.1),
      top: AppSizes.dynamicHeight(context, 0.05),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/png/logo.png",
          width: 300.w,
          height: 80.h,
        ),
        // Container(
        //   padding: EdgeInsets.only(left: AppSizes.dynamicWidth(context, 0.03)),
        //   child: text(context, "Lorem ipsum lorem ipsum", 18.sp,
        //       color: Color(0xff675E5E)),
        // )
      ],
    ),
  );
}
