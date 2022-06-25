import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/driver_provider.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/screens/staff/staff_detail.dart';
import 'package:track_flotilla/screens/widgets/custom_list_tile.dart';
import 'package:track_flotilla/screens/widgets/driver_list_tile.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/screens/widgets/underconstruction.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../widgets/input_field.dart';

class StaffListPage extends StatefulWidget {
  StaffListPage({Key? key}) : super(key: key);

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  late DriverProvider driverProvider;

  @override
  void initState() {
    super.initState();
    driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.fetchAllDriverData(context);
  }

  TextEditingController searchController = TextEditingController();
  List filterData = [];
  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;
    var data = searchController.text.isEmpty
        ? driverProvider.allDriverDataList
        : filterData;

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 500.w,
                height: 85.h,
                child: TextField(
                  controller: searchController,
                  onChanged: ((value) {
                    setState(() {
                      filterData = driverProvider.allDriverDataList
                          .where((filtData) => filtData['name']
                              .toString()
                              .toUpperCase()
                              .contains(searchController.text
                                  .toString()
                                  .toUpperCase()))
                          .toList();
                    });
                  }),
                  decoration: myinputDecoration(),
                ),
              ),
              Container(
                // color: Colors.amber,
                height: AppSizes.dynamicHeight(context, 0.7),
                child: loading
                    ? Center(child: loadingTextAimation())
                    : data.isEmpty
                        ? Center(child: Text("No Record Found"))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length == null ? 0 : data.length,
                            itemBuilder: (BuildContext context, i) {
                              if (data.isEmpty) {
                                return Center(
                                  child: Text("No Data"),
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    print("asd");
                                    AppRoutes.push(
                                        context,
                                        StaffDetail(
                                          address: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']
                                                  ['driverAddress']
                                              .toString(),
                                          dLExpDate: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']
                                                  ['dateOfBirthGregorian']
                                              .toString(),
                                          dLicenseClass: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']['licenseClass']
                                              .toString(),
                                          dLicenseNum: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']['licenseNumb']
                                              .toString(),
                                          dept: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']['department']
                                              .toString(),
                                          driverID: driverProvider
                                              .allDriverDataList[i]['uniqueId']
                                              .toString(),
                                          expDate: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']
                                                  ['licenseExpDate']
                                              .toString(),
                                          identityNum: driverProvider
                                              .allDriverDataList[i]
                                                  ['attributes']
                                                  ['identityNumber']
                                              .toString(),
                                          name: driverProvider
                                              .allDriverDataList[i]['name']
                                              .toString(),
                                        ));
                                  },
                                  child: DriverListTile(
                                      name: data[i]['name'].toString(),
                                      id: data[i]['id'].toString(),
                                      imageUrl: 'assets/png/Driver.png'),
                                );
                              }
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AddDestination()));
      //     // showAddDialog(context);
      //   },
      //   tooltip: "Add Staff",
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
