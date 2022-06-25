// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, avoid_types_as_parameter_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:track_flotilla/api/api_uri.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/screens/Home/home.dart';
import 'package:track_flotilla/screens/authentication/login.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/constants.dart';
import 'package:track_flotilla/utils/toast.dart';

import '../../utils/app_routes.dart';

class AuthServices {
  static Future signIn(
      {required BuildContext context,
      @required email,
      @required password,
      @required rememberME}) async {
    try {
      var result;
      Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
      print(email);
      print("Sign In ---------------------------");
      final _response = await http.post(
        Uri.parse(ApiUri.login),
        headers: {
          "Accept": "application/json",
        },
        body: {"email": email, "password": password, "app": ApiUri.appkey},
      );

      result = jsonDecode(_response.body);
      var h = _response.headers;
      print('h: $h');
      // log("Cookies: ${_response.headers['set-cookie']}");
      log('result: ${_response.body}');
      // log(result['id'].toString());
      // log(result['name'].toString());
      if (_response.statusCode == 200) {
        SharedPref.saveUserEmail(email.toString());
        SharedPref.saveUserPassword(password.toString());
        SharedPref.saverememberMe(rememberME);
        SharedPref.userLoggedIn(true);

        SharedPref.saveCookieId(_response.headers['set-cookie'].toString());
        SharedPref.saveUserId(result['id'].toString());
        SharedPref.saveUserName(result['name'].toString());
        AppRoutes.pushAndRemoveUntil(context, Home());
        AppToast.successToast("Success!", "Login Successfully done", context);
      } else {
        log(" Not Okay");
        AppToast.failureToast(
            "UnAuthorized!", "Your given Email Password is Wrong", context);
      }
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);

      return result;
    } catch (e) {
      // AppToast.failureToast(
      //     "UnAuthorized!", "Your given Email Password is Wrong", context);
      AppToast.warningToast("Oops!", "Some thing went wrong", context);

      print('e: $e');
      Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
      return e.toString();
    }
  }

  // //  _________________ sign Up__________________________________

  // Future signUp({
  //   required BuildContext context,
  //   @required name,
  //   @required email,
  //   @required password,
  //   @required cPassword,
  //   @required bool userTypeFac = true,
  //   @required factoryName,
  //   @required factoryImage,
  // }) async {
  //   try {
  //     print("Sign Up ---------------------------");
  //     Provider.of<LoadingProvider>(context, listen: false).setLoading(true);

  //     final _response = await http.post(
  //       Uri.parse(API.signUp),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "name": name,
  //         "email": email,
  //         "password": password,
  //         "c_password": cPassword,
  //         "user_type": "farmer"
  //       }),
  //     );
  //     result = jsonDecode(_response.body);
  //     Map<String, dynamic> jsonRes = jsonDecode(_response.body);
  //     // print('jsonRes: $jsonRes');
  //     print('result: $result');

  //     if (result['status'] == 'Success') {
  //       Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  //       // var token = result['data']['token'].toString();
  //       // var userType = result['data']['data']['user_type'].toString();
  //       // var userName = result['data']['data']['name'].toString();
  //       // var userId = result['data']['data']['id'].toString();
  //       AppRoutes.push(context, Login());
  //       AppToast.successToast(
  //           "Success!", "Account created successfully", context);
  //       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       //   content: Text("Account created!"),
  //       // ));
  //       // MotionToast.success(
  //       //   title: const Text("SignUp Success!"),
  //       //   description: const Text("Your account created successfully Done"),
  //       // ).show(context);
  //     } else {
  //       Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Email already exist"),
  //       ));

  //       // MotionToast.warning(
  //       //   title: const Text("SignUp Fail"),
  //       //   description: const Text("Email is already exist"),
  //       // ).show(context);

  //       Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  //     }
  //     return result;
  //   } catch (e) {
  //     AppToast.warningToast("Oops!", "Some thing went wrong", context);

  //     // MotionToast.warning(
  //     //   title: Text("Oops!"),
  //     //   description: Text("Some thing went wrong"),
  //     // ).show(context);
  //     Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  //     print('e: $e');
  //     return e;
  //   }
  // }
}
