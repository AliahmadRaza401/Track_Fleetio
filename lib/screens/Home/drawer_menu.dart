import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/drawerPageProvider.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/screens/Home/home.dart';
import 'package:track_flotilla/screens/authentication/login.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late DrawerPageProvider _drawerPageProvider;
  @override
  void initState() {
    super.initState();
    _drawerPageProvider =
        Provider.of<DrawerPageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryDark,
      body: Container(
        width: AppSizes.dynamicWidth(context, 1),
        height: AppSizes.dynamicHeight(context, 1),
        decoration: BoxDecoration(
          gradient: AppColors.purplegradient,
        ),
        child: SingleChildScrollView(
          child: Container(
            height: AppSizes.dynamicHeight(context, 1),
            // color: Colors.amber,
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/png/sidebar/whiteLogo.png',
                  width: AppSizes.dynamicWidth(context, 0.5),
                ),
                Column(
                  children: [
                    item("Home", "assets/png/sidebar/Vector.png", () {
                      _drawerPageProvider.setIndex(0);
                      z.close!();
                    }),
                    item("Monitoring", "assets/png/sidebar/Vector-1.png", () {
                      _drawerPageProvider.setIndex(1);
                      z.close!();
                    }),
                    item("Staff", "assets/png/sidebar/Vector-2.png", () {
                      _drawerPageProvider.setIndex(2);
                      z.close!();
                    }),
                    item("Geofence", "assets/png/sidebar/Vector-3.png", () {
                      _drawerPageProvider.setIndex(3);
                      z.close!();
                    }),
                    item("Reports", "assets/png/sidebar/Vector-4.png", () {
                      _drawerPageProvider.setIndex(4);
                      z.close!();
                    }),
                    item("Tracks", "assets/png/sidebar/Vector-5.png", () {
                      _drawerPageProvider.setIndex(5);
                      z.close!();
                    }),
                    item("Time Machine", "assets/png/sidebar/Vector-6.png", () {
                      _drawerPageProvider.setIndex(6);
                      z.close!();
                    }),
                    item("Schedule", "assets/png/sidebar/Vector-7.png", () {
                      _drawerPageProvider.setIndex(7);
                      z.close!();
                    }),
                    item("Commands", "assets/png/sidebar/Vector-8.png", () {
                      _drawerPageProvider.setIndex(8);
                      z.close!();
                    }),
                    item("Maintenance", "assets/png/sidebar/Group 14148.png",
                        () {
                      _drawerPageProvider.setIndex(9);
                      z.close!();
                    }),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    SharedPref.userLoggedIn(false);
                    Provider.of<DrawerPageProvider>(context, listen: false)
                        .setIndex(0);
                    Provider.of<MonitoringProvider>(context, listen: false)
                        .socPositionsList = [];
                    Provider.of<MonitoringProvider>(context, listen: false)
                        .socDevicesList = [];
                    AppRoutes.pushAndRemoveUntil(context, Login());
                  },
                  child: Container(
                    width: AppSizes.dynamicWidth(context, 0.4),
                    height: 65.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/png/sidebar/Vector-9.png',
                          width: 35.w,
                          height: 35.h,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        text(context, "Logout", 25.sp,
                            color: AppColors.primaryDark,
                            boldText: FontWeight.bold),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget item(title, image, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.amber,
        width: AppSizes.dynamicWidth(context, 0.5),
        margin: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 35.w,
              height: 35.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            text(
              context,
              title,
              24.sp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
