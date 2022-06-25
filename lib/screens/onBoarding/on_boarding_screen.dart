import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_flotilla/utils/appColor.dart';

import '../authentication/login.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  void _onIntroEnd(context) {
    _storeOnboardInfo();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  Widget _buildImage(String assetName, [double width = 320]) {
    return Lottie.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
        fontSize: 19.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        color: Colors.black);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: Colors.black),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,

      pages: [
        PageViewModel(
          title: "Why Fleetio?",
          body:
              "We provide you with peace of mind, giving up to the minute information on the location of your vehicle",
          image: _buildImage('assets/json/1111.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Product Range",
          body:
              "We provide you variety of packages for your ease. Upgrade anytime.",
          image: _buildImage('assets/json/2222.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Call Center",
          body: "24/7 call center for your help. ",
          image: _buildImage('assets/json/3333.json'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text(
        'Skip',
        style: TextStyle(
            fontSize: 18,
            color: AppColors.primaryLight,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: AppColors.primaryDark,
      ),
      done: const Text('Done',
          style: TextStyle(
              fontSize: 18,
              color: AppColors.primaryLight,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,

      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: AppColors.primaryDark,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
