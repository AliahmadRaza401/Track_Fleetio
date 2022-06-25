import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/maintenance_provider.dart';
import 'package:track_flotilla/screens/maintenance/maintenance_handler.dart';
import 'package:track_flotilla/utils/appColor.dart';

Widget buttonGradient(BuildContext context, id) {
  return Container(
      child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Container(
        //   height: 55.h,
        //   width: 120.w,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10.r),
        //       color: Colors.white,
        //       border: Border.all(color: AppColors.primaryDark)
        //       // gradient: LinearGradient(
        //       //   begin: Alignment.topCenter,
        //       //   end: Alignment.bottomCenter,
        //       //   colors: [const Color(0xffC5C5C5), const Color(0xff8F8C8B)],
        //       //   stops: [0.0, 1.0],
        //       // ),
        //       ),
        //   child: Center(
        //     child: Text(
        //       'Edit',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: AppColors.primaryDark,
        //         letterSpacing: -0.3858822937011719,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),

        InkWell(
          onTap: (() {
            Provider.of<MaintenanceProvider>(context, listen: false)
                .deleteMaintenaince(context, id);
          
            // MaintenanceHander.deleteMaintenaince(context, id);
          }),
          child: Container(
            height: 55.h,
            width: 148.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 239, 108, 128),
                  const Color(0xffC72E45)
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Center(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xffffffff),
                  letterSpacing: -0.3858822937011719,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        // Container(
        //   height: 55.h,
        //   width: 178.w,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10.r),
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         Color.fromARGB(255, 111, 228, 109),
        //         const Color(0xff33A532)
        //       ],
        //       stops: [0.0, 1.0],
        //     ),
        //   ),
        //   child: Center(
        //     child: Text(
        //       'Complete',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: const Color(0xffffffff),
        //         letterSpacing: -0.3858822937011719,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
      ],
    ),
  ));
}
