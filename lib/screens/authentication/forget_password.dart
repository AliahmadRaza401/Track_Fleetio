// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/authentication/singUp.dart';
import 'package:track_flotilla/screens/widgets/input_field.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/screens/widgets/outline_button.dart';
import 'package:track_flotilla/utils/app_size.dart';

import '../../utils/app_routes.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  void initState() {
    // Timer(Duration(seconds: 3), () {
    //   // checkUSer();
    // });
    super.initState();
  }

  TextEditingController emailcont = TextEditingController();
  TextEditingController passwordcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              width: AppSizes.dynamicWidth(context, 1),
              height: AppSizes.dynamicHeight(context, 1),
              decoration: BoxDecoration(
                // color: Colors.black,
                image: DecorationImage(
                  image: AssetImage("assets/png/bg2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
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
                      height: 20.h,
                    ),
                    Container(
                        // color: Colors.amber,
                        child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: AppSizes.dynamicWidth(context, 0.1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/png/logo.png",
                                width: 300.w,
                                height: 80.h,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: AppSizes.dynamicWidth(context, 0.03)),
                                child: text(
                                    context, "Lorem ipsum lorem ipsum", 18.sp,
                                    color: Color(0xff675E5E)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        text(context, "Forget Password", 35.sp,
                            boldText: FontWeight.bold, color: Colors.white),
                        SizedBox(
                          height: 20.h,
                        ),
                        inputTextField(context, "Email", passwordcont),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            outlineButton(context, "Send Code", () {
                              AppRoutes.pop(context);
                            }),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              )),
        ));
  }
}
