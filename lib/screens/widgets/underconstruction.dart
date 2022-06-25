import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/app_size.dart';

Widget underconstruction(BuildContext context) {
  return Container(
    height: AppSizes.dynamicHeight(context, 0.6),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/png/undercons.png',
          width: AppSizes.dynamicWidth(context, 0.9),
        ),
        SizedBox(
          height: 20.h,
        ),
        text(context, "Underconstruction!", 25.sp, boldText: FontWeight.bold),
        text(context, "we are working on it", 22.sp),
      ],
    ),
  );
}
