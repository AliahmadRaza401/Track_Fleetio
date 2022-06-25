// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_flotilla/screens/Home/home.dart';
import 'package:track_flotilla/screens/authentication/login.dart';
import 'package:track_flotilla/screens/onBoarding/on_boarding_screen.dart';
import 'package:track_flotilla/screens/widgets/logo.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/screens/widgets/outline_button.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<Offset>? animation;
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      checkUSer();
    });
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    animation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(0.05, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInCubic,
    ));
    // getUser();
    super.initState();
  }

  // late var userLoggedIn;
  // getUser() async {
  //   var val = await SharedPref.getUserLoggedIn();
  //   setState(() {
  //     userLoggedIn = val;
  //   });
  //   print('userLoggedIn: $userLoggedIn');
  // }

  checkUSer() async {
    var isUserFirstTime;
    isUserFirstTime = await SharedPref.getUserFirstTime();

    var userLoggedIn = await SharedPref.getUserLoggedIn();
    print('isUserFirstTime: $isUserFirstTime');
    if (isUserFirstTime == true) {
      if (userLoggedIn == true) {
        AppRoutes.pushAndRemoveUntil(context, Home());
      } else {
        AppRoutes.pushAndRemoveUntil(context, Login());
      }
    } else {
      AppRoutes.pushAndRemoveUntil(context, OnBoarding());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: AppSizes.dynamicWidth(context, 1),
            height: AppSizes.dynamicHeight(context, 1),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/png/bgSplash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SlideTransition(
                      position: animation!,
                      child: logowithText(context),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 20,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     alignment: Alignment.bottomCenter,
                //     child: outlineButton(context, "Get Started", () {
                //       AppRoutes.push(context, Login());
                //     }),
                //   ),
                // ),
                // Positioned(
                //   bottom: 20,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     alignment: Alignment.bottomCenter,
                //     child: DelayedDisplay(
                //       delay: Duration(seconds: 1),
                //       child: Container(
                //         width: 140,
                //         height: 40,
                //         decoration: BoxDecoration(
                //           border: Border.all(width: 1, color: Colors.white),
                //           borderRadius: BorderRadius.circular(5.r),
                //         ),
                //         child: AnimatedButton.strip(
                //           width: 140,
                //           height: 40,
                //           text: 'Get Started',
                //           isReverse: true,
                //           backgroundColor: Colors.transparent,
                //           selectedTextColor: Colors.black,
                //           stripTransitionType:
                //               StripTransitionType.LEFT_TO_RIGHT,
                //           selectedBackgroundColor: Colors.white,
                //           textStyle: TextStyle(
                //             color: Colors.white,
                //             fontSize: 22.sp,
                //             fontWeight: FontWeight.bold,
                //           ),
                //           onPress: () {
                //             Future.delayed(const Duration(milliseconds: 300),
                //                 () {
                //               if (userLoggedIn == true) {
                //                 AppRoutes.push(context, Home());
                //               } else {
                //                 AppRoutes.push(context, Login());
                //               }
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )));
  }
}
