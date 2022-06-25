// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/screens/authentication/auth_services.dart';
import 'package:track_flotilla/screens/authentication/forget_password.dart';
import 'package:track_flotilla/screens/authentication/singUp.dart';
import 'package:track_flotilla/screens/widgets/input_field.dart';
import 'package:track_flotilla/screens/widgets/logo.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/screens/widgets/outline_button.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';

import '../../providers/loading_provider.dart';
import '../../utils/app_routes.dart';
import '../Home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<Offset>? animation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
    SharedPref.saveUserFirstTime(true);
    getPref();
    super.initState();
  }

  getPref() async {
    var rememberMe = await SharedPref.getrememberMe();
    print('rememberMe: $rememberMe');
    var userName = await SharedPref.getUserEmail();
    print('userName: $userName');

    var password = await SharedPref.getUserPassword();
    print('password: $password');
    if (rememberMe == true) {
      emailcont.text = userName;
      passwordcont.text = password;
    }
  }

  bool isChecked = false;
  TextEditingController emailcont = TextEditingController();
  TextEditingController passwordcont = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(
                        //         Icons.arrow_back,
                        //         color: Colors.white,
                        //         size: 30,
                        //       ),
                        //       onPressed: () {
                        //         AppRoutes.pop(context);
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 250.h,
                        ),
                        Container(
                            // color: Colors.amber,
                            padding: EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                // SlideTransition(
                                //   position: animation!,
                                //   child: logowithText(context),
                                // ),
                                logowithText(context),
                                SizedBox(
                                  height: 200.h,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left:
                                          AppSizes.dynamicWidth(context, 0.05)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(context, "Login", 40.sp,
                                          color: Colors.white),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      DelayedDisplay(
                                          delay: Duration(milliseconds: 700),
                                          child: inputTextField(
                                            context,
                                            "Email",
                                            emailcont,
                                            function: (v) {
                                              if (v!.isEmpty || v == null) {
                                                return "UserName Required";
                                              }
                                            },
                                          )),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      DelayedDisplay(
                                        delay: Duration(seconds: 1),
                                        child: inputTextField(
                                          context,
                                          "password",
                                          passwordcont,
                                          // IconButton(
                                          //   onPressed: () {},
                                          //   icon: Icon(
                                          //     Icons.visibility,
                                          //     color: Colors.white,
                                          //   ),
                                          // ),
                                          function: (v) {
                                            if (v!.isEmpty || v == null) {
                                              return "Password is Required";
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: 50.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  value: isChecked,
                                                  onChanged: (value) {
                                                    isChecked = !isChecked;
                                                    setState(() {});
                                                  },
                                                ),
                                                Text(
                                                  "Remember Me",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                AppRoutes.push(
                                                    context, ForgetPassword());
                                              },
                                              child: text(context,
                                                  "Forgot Password?", 20.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      loading
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                DelayedDisplay(
                                                  delay: Duration(seconds: 1),
                                                  child: outlineButton(
                                                      context, "Login", () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      AuthServices.signIn(
                                                        context: context,
                                                        email: emailcont.text
                                                            .trim(),
                                                        password: passwordcont
                                                            .text
                                                            .trim(),
                                                        rememberME: isChecked,
                                                      );
                                                      log(" Validate");
                                                    } else {
                                                      log("Not Validate");
                                                    }

                                                    // AppRoutes.push(
                                                    //     context, Home());
                                                  }),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     // Row(
                                      //     //   children: [
                                      //     //     Container(
                                      //     //       decoration: BoxDecoration(
                                      //     //         color: Colors.white,
                                      //     //         borderRadius:
                                      //     //             BorderRadius.circular(
                                      //     //                 5.r),
                                      //     //       ),
                                      //     //       padding: EdgeInsets.all(7),
                                      //     //       child: Image.asset(
                                      //     //         'assets/png/google.png',
                                      //     //         width: 30.w,
                                      //     //       ),
                                      //     //     ),
                                      //     //     SizedBox(
                                      //     //       width: 10.w,
                                      //     //     ),
                                      //     //     Container(
                                      //     //       decoration: BoxDecoration(
                                      //     //         color: Colors.white,
                                      //     //         borderRadius:
                                      //     //             BorderRadius.circular(
                                      //     //                 5.r),
                                      //     //       ),
                                      //     //       padding: EdgeInsets.all(7),
                                      //     //       child: Image.asset(
                                      //     //         'assets/png/fb.png',
                                      //     //         width: 30.w,
                                      //     //       ),
                                      //     //     ),
                                      //     //   ],
                                      //     // ),

                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         AppRoutes.push(context, SignUp());
                                      //       },
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.start,
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           text(context, "New Here? ",
                                      //               20.sp,
                                      //               color: Colors.white),
                                      //           text(context, "Register", 20.sp,
                                      //               boldText: FontWeight.bold,
                                      //               color: Colors.white),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 90.w,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        )));
  }
}
