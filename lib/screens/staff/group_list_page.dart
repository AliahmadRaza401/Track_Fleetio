import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/widgets/custom_list_tile.dart';
import 'package:track_flotilla/screens/widgets/underconstruction.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/responsive.dart';

class GroupListPage extends StatefulWidget {
  GroupListPage({Key? key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 500.w,
                height: 85.h,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
                    /* -- Text and Icon -- */
                    hintText: "Search...",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB3B1B1),
                    ), // TextStyle
                    suffixIcon: const Icon(
                      Icons.search,
                      size: 26,
                      color: Colors.black54,
                    ), // Icon
                    /* -- Border Styling -- */
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: Color(0xFFD1D3D4),
                      ), // BorderSide
                    ), // OutlineInputBorder
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: Color(0xFFD1D3D4),
                      ), // BorderSide
                    ), // OutlineInputBorder
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Color.fromARGB(255, 207, 138, 148),
                      ), // BorderSide
                    ), // OutlineInputBorder
                  ), // InputDecoration
                ),
              ),
              underconstruction(context),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AddDestination()));
      //     // showAddDialog(context);
      //   },
      //   tooltip: "Add Grpup",
      //   child: Container(
      //     width: Responsive.isTablet(context) ? 70 : 56,
      //     height: Responsive.isTablet(context) ? 70 : 56,
      //     child: Icon(
      //       FeatherIcons.plus,
      //       size: Responsive.isTablet(context) ? 30.sp : 40.sp,
      //     ),
      //     decoration: const BoxDecoration(
      //       shape: BoxShape.circle,
      //       gradient:
      //           LinearGradient(colors: [Color(0xffDDA7AF), Color(0xff993535)]),
      //     ),
      //   ),
      // ),
    );
  }
}
