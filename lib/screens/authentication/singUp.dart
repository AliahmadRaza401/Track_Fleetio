// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:track_flotilla/screens/widgets/input_field.dart';
import 'package:track_flotilla/screens/widgets/logo.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/screens/widgets/outline_button.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/toast.dart';

import '../../utils/app_routes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<Offset>? animation;
  @override
  void initState() {
    // Timer(Duration(seconds: 3), () {
    //   // checkUSer();
    // });
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    animation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(0.2, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInCubic,
    ));
    super.initState();
  }

  TextEditingController nameCont = TextEditingController();

  TextEditingController emailcont = TextEditingController();
  TextEditingController passwordcont = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: AppSizes.dynamicWidth(context, 1),
                  height: AppSizes.dynamicHeight(context, 1),
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage("assets/png/bg1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              AppRoutes.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 170.h,
                      ),
                      Container(
                          // color: Colors.amber,
                          child: Column(
                        children: [
                          // SlideTransition(
                          //   position: animation!,
                          //   child: logowithText(context),
                          // ),
                          logowithText(context),
                          SizedBox(
                            height: 170.h,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: AppSizes.dynamicWidth(context, 0.05)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(context, "Register", 40.sp,
                                    color: Colors.white),
                                SizedBox(
                                  height: 20,
                                ),
                                DelayedDisplay(
                                    delay: Duration(milliseconds: 500),
                                    child: inputTextField(
                                        context, "Full Name", nameCont)),
                                SizedBox(
                                  height: 20,
                                ),
                                DelayedDisplay(
                                    delay: Duration(milliseconds: 500),
                                    child: inputTextField(
                                        context, "Email", emailcont)),
                                SizedBox(
                                  height: 20.h,
                                ),
                                DelayedDisplay(
                                  delay: Duration(seconds: 1),
                                  child: inputTextField(
                                      context, "password", passwordcont),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          padding: EdgeInsets.all(7),
                                          child: Image.asset(
                                            'assets/png/google.png',
                                            width: 30.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          padding: EdgeInsets.all(7),
                                          child: Image.asset(
                                            'assets/png/fb.png',
                                            width: 30.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        AppRoutes.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(context, "Already a Member?",
                                              20.sp,
                                              color: Colors.white),
                                          text(context, "Login", 20.sp,
                                              boldText: FontWeight.bold,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90.w,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DelayedDisplay(
                                        delay: Duration(seconds: 1),
                                        child: outlineButton(
                                            context, "Register", () {})),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  )),
            ],
          ),
        )));
  }
}
