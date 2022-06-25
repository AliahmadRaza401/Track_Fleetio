import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/dashboard_provider.dart';
import 'package:track_flotilla/providers/time_machine_provider.dart';
import 'package:track_flotilla/screens/time_machine/time_machine_map.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_routes.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:track_flotilla/utils/shahdow.dart';
import 'package:track_flotilla/utils/toast.dart';

class TimeMachine extends StatefulWidget {
  TimeMachine({Key? key}) : super(key: key);

  @override
  State<TimeMachine> createState() => _TimeMachineState();
}

class _TimeMachineState extends State<TimeMachine> {
  TextEditingController stdate = TextEditingController();
  TextEditingController etdate = TextEditingController();
  late DashboardProvider _dashboardProvider;
  late TimeMachineProvider _timeMachineProvider;

  @override
  void initState() {
    super.initState();
    _timeMachineProvider =
        Provider.of<TimeMachineProvider>(context, listen: false);

    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
  }

  bool isLoading = true;

  @override
  void dispose() {
    _timeMachineProvider.dataList.clear();

    super.dispose();
  }

  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    dropdownvalue = dropdownvalue == null
        ? _dashboardProvider.allDevicesData[0]
        : dropdownvalue;

    List data = _dashboardProvider.allDevicesData;
    bool loading = Provider.of<TimeMachineProvider>(context).loading;

    setState(() {
      selectedDate1 = DateTime.now();
      final format = DateFormat('yyyy-MM-dd');

      DateTime fiftyDaysAgo = selectedDate1.subtract(const Duration(days: 1));
      final dateTime = DateTime.parse(fiftyDaysAgo.toString());
      var previousDay = format.format(dateTime);
      sttxt.text = sttxt.text == null || sttxt.text.isEmpty
          ? "${previousDay}"
              " "
              "${selectedTime.hour}:${selectedTime.minute}:00"
          : sttxt.text;

      edtxt.text = edtxt.text == null || edtxt.text.isEmpty
          ? "${format.format(selectedDate1).toString()}"
              " "
              "${selectedTime.hour}:${selectedTime.minute}:00"
          : edtxt.text;
    });

    return Scaffold(
        appBar: customAppBar(context, "Time Machine"),
        body: Container(
            width: AppSizes.dynamicWidth(context, 1),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StatefulBuilder(
                  builder: ((context, dopsSetState) => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            // color: Colors.amber,
                            height: AppSizes.dynamicHeight(context, 0.5),
                            width: AppSizes.dynamicWidth(context, 0.9),
                            child: Lottie.asset(
                              'assets/json/carsMoving.json',
                              width: AppSizes.dynamicWidth(context, 0.9),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            // color: Colors.green,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _selectedDateTime(context, dopsSetState);
                                    },
                                    child: Container(
                                      width: 500.w,
                                      height: 65.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(context, "Select Date",
                                                  18.sp),
                                              text(context,
                                                  sttxt.text.toString(), 22.sp),
                                            ],
                                          ),
                                          Icon(
                                            FeatherIcons.chevronDown,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectedToDateTime(
                                        context,
                                        dopsSetState,
                                      );
                                    },
                                    child: Container(
                                      width: 500.w,
                                      height: 65.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(context, "End Date", 18.sp),
                                              text(context,
                                                  edtxt.text.toString(), 22.sp),
                                            ],
                                          ),
                                          Icon(
                                            FeatherIcons.chevronDown,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  _dashboardProvider.allDevicesData == null ||
                                          _dashboardProvider
                                              .allDevicesData.isEmpty
                                      ? Text("No Device")
                                      : Container(
                                          width: 500.w,
                                          height: 75.h,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                          ),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              text(context, "Select Vehicle",
                                                  18.sp),
                                              Container(
                                                height: 45.h,
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  underline: SizedBox(),
                                                  // Initial Value
                                                  value: dropdownvalue,
                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  // Array list of items
                                                  items: data.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(
                                                        // "sdf",
                                                        items.containsKey(
                                                                'entity')
                                                            ? items["entity"]
                                                                    ['name']
                                                                .toString()
                                                            : "N/A",
                                                        style: TextStyle(
                                                          fontSize: 22.sp,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged: (newValue) {
                                                    dopsSetState(() {
                                                      dropdownvalue = newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final DateFormat format =
                                          new DateFormat("yyyy-MM-dd hh:mm");
                                      _timeMachineProvider.id =
                                          dropdownvalue["entity"]['id']
                                              .toString();
                                      _timeMachineProvider.statTime =
                                          isoDateFormter(
                                              format.parse(sttxt.text));
                                      _timeMachineProvider.endTime =
                                          isoDateFormter(
                                              format.parse(edtxt.text));
                                      await _timeMachineProvider
                                          .fetchTimeMachineData(context)
                                          .then((value) {
                                        log("on Done");
                                        if (_timeMachineProvider
                                                .dataList.isEmpty ||
                                            _timeMachineProvider.dataList ==
                                                []) {
                                          AppToast.infoToast("Oops!",
                                              "No, Data Found", context);
                                        } else {
                                          AppRoutes.push(
                                              context, TimeMachineMap());
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 500.w,
                                      height: 65.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primarygradient,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          loading
                                              ? text(
                                                  context,
                                                  "Loading...",
                                                  22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white,
                                                )
                                              : text(
                                                  context,
                                                  "Submit",
                                                  22.sp,
                                                  boldText: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ))),
            )));
  }

  isoDateFormter(data) {
    log('Mydata: $data');
    DateTime myDatetime = DateTime.parse(data.toString());
    var date = myDatetime.toIso8601String() + "z";
    print('date: $date');
    return date;
  }

  ///////////////// TO DATE  /////////////////

  DateTime selectedToDate = DateTime.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();

  DateTime selectedDate1 = DateTime.now().subtract(Duration(days: 1));
  TimeOfDay selectedTime =
      TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(hours: 24)));
  TextEditingController sttxt = TextEditingController();
  TextEditingController edtxt = TextEditingController();
  TextEditingController textVal1 = TextEditingController();
  TextEditingController textval2 = TextEditingController();

// DateTime selectedDate1 = DateTime.now().subtract(Duration(days: 1));
//   TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(hours: 24)));
//   DateTime selectedToDate = DateTime.now();
//   TimeOfDay selectedTimeTo = TimeOfDay.now();

  _selectedDateTime(BuildContext context, StateSetter dropsetState) async {
    await _selectDate(
      context,
      dropsetState,
    );
    await _selectTime(
      context,
      dropsetState,
    );
  }

  _selectDate(
    BuildContext context,
    StateSetter dropsetState,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime.now().subtract(Duration(days: 182)),
      lastDate: DateTime.now(),
      helpText: "SELECT FROM DATE",
      fieldHintText: "YEAR/MONTH/DATE",
      fieldLabelText: "FROM DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.primaryDark, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.primaryLight, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDate1) {
      dropsetState(() {
        selectedDate1 = selected;
        final format = DateFormat('yyyy-MM-dd');
        sttxt.text = "${format.format(selectedDate1).toString()}"
            " "
            "${selectedTime.hour}:${selectedTime.minute}:00";
      });
    } else if (selected != null && selected == selectedDate1) {
      dropsetState(() {
        selectedDate1 = selected;
        final format = DateFormat('yyyy-MM-dd');
        sttxt.text = "${format.format(selectedDate1).toString()}"
            " "
            "${selectedTime.hour}:${selectedTime.minute}:00";
      });
    }
  }

  _selectTime(BuildContext context, StateSetter dropsetState) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "SELECT FROM TIME",
      errorInvalidText: "Time Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.grey, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.primaryLight, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      dropsetState(() {
        selectedTime = timeOfDay;
        final format = DateFormat('yyyy-MM-dd');
        sttxt.text = "${format.format(selectedDate1).toString()}"
            " "
            "${selectedTime.hour}:${selectedTime.minute}:00";
      });
    }
  }

  _selectedToDateTime(BuildContext context, StateSetter dropsetState) async {
    await _selectDateTo(context, dropsetState);
    await _selectTimeTo(context, dropsetState);
  }

  _selectDateTo(
    BuildContext context,
    StateSetter dropsetState,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime.now().subtract(Duration(days: 182)),
      lastDate: DateTime.now(),
      helpText: "SELECT TO DATE",
      fieldHintText: "YEAR/MONTH/DATE",
      fieldLabelText: "TO DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.primaryDark, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.primaryLight, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && selected != selectedToDate) {
      dropsetState(() {
        selectedToDate = selected;
        final format = DateFormat('yyyy-MM-dd');
        edtxt.text = "${format.format(selectedToDate).toString()}"
            " "
            "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
      });
    } else if (selected != null && selected == selectedToDate) {
      dropsetState(() {
        selectedToDate = selected;
        final format = DateFormat('yyyy-MM-dd');
        edtxt.text = "${format.format(selectedToDate).toString()}"
            " "
            "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
      });
    }
  }

  _selectTimeTo(
    BuildContext context,
    StateSetter dropsetState,
  ) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeTo,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "SELECT TO TIME",
      errorInvalidText: "Time Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.grey, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.primaryLight, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTimeTo) {
      dropsetState(() {
        selectedTimeTo = timeOfDay;
        final format = DateFormat('yyyy-MM-dd');
        edtxt.text = "${format.format(selectedToDate).toString()}"
            " "
            "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
      });
    }
  }

// // var _d1 = DateFormat('yyyy-MM-dd').format(selectedDate1);
//   _selectedToDateTime(BuildContext context) async {
//     await _selectDateTo(context);
//     await _selectTimeTo(context);
//   }

//   _selectedDateTime(BuildContext context) async {
//     await _selectDate(context);
//     await _selectTime(context);
//   }

//   _selectDate(
//     BuildContext context,
//   ) async {
//     final DateTime? selected = await showDatePicker(
//       context: context,
//       initialDate: selectedDate1,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       helpText: "SELECT FROM DATE",
//       fieldHintText: "YEAR/MONTH/DATE",
//       fieldLabelText: "FROM DATE",
//       errorFormatText: "Enter a Valid Date",
//       errorInvalidText: "Date Out of Range",
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primaryDark, // header background color
//               onPrimary: Colors.Colors.white, // header text color
//               onSurface: AppColors.primaryLight, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: AppColors.primaryDark, // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (selected != null && selected != selectedDate1) {
//       setState(() {
//         selectedDate1 = selected;
//         final format = DateFormat('yyyy-MM-dd');
//         sttxt.text = "${format.format(selectedDate1).toString()}"
//             " "
//             "${selectedTime.hour}:${selectedTime.minute}:00";
//         log('sttxt.text: ${sttxt.text}');
//       });
//     } else if (selected != null && selected == selectedDate1) {
//       setState(() {
//         selectedDate1 = selected;
//         final format = DateFormat('yyyy-MM-dd');
//         sttxt.text = "${format.format(selectedDate1).toString()}"
//             " "
//             "${selectedTime.hour}:${selectedTime.minute}:00";
//         log('sttxt.text: ${sttxt.text}');
//       });
//     }
//   }

//   _selectTime(BuildContext context) async {
//     TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//       initialEntryMode: TimePickerEntryMode.dial,
//       helpText: "SELECT FROM TIME",
//       errorInvalidText: "Time Out of Range",
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primaryDark, // header background color
//               onPrimary: Colors.Colors.white, // header text color
//               onSurface: AppColors.primaryDark, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: AppColors.primaryDark, // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (timeOfDay != null && timeOfDay != selectedTime) {
//       setState(() {
//         selectedTime = timeOfDay;
//         final format = DateFormat('yyyy-MM-dd');
//         sttxt.text = "${format.format(selectedDate1).toString()}"
//             " "
//             "${selectedTime.hour}:${selectedTime.minute}:00";
//         log('sttxt.text: ${sttxt.text}');
//       });
//     }
//   }

//   _selectDateTo(BuildContext context) async {
//     final DateTime? selected = await showDatePicker(
//       context: context,
//       initialDate: selectedToDate,
//       firstDate: selectedDate1,
//       lastDate: DateTime.now(),
//       helpText: "SELECT TO DATE",
//       fieldHintText: "YEAR/MONTH/DATE",
//       fieldLabelText: "TO DATE",
//       errorFormatText: "Enter a Valid Date",
//       errorInvalidText: "Date Out of Range",
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primaryDark, // header background color
//               onPrimary: Colors.Colors.white, // header text color
//               onSurface: AppColors.primaryLight, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: AppColors.primaryDark, // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (selected != null && selected != selectedToDate) {
//       setState(() {
//         selectedToDate = selected;
//         final format = DateFormat('yyyy-MM-dd');
//         edtxt.text = "${format.format(selectedToDate).toString()}"
//             " "
//             "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
//         log('edtxt.text: ${edtxt.text}');
//       });
//     } else if (selected != null && selected == selectedToDate) {
//       setState(() {
//         selectedToDate = selected;
//         final format = DateFormat('yyyy-MM-dd');
//         edtxt.text = "${format.format(selectedToDate).toString()}"
//             " "
//             "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
//         log('edtxt.text: ${edtxt.text}');
//       });
//     }
//   }

//   _selectTimeTo(BuildContext context) async {
//     TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selectedTimeTo,
//       initialEntryMode: TimePickerEntryMode.dial,
//       helpText: "SELECT TO TIME",
//       errorInvalidText: "Time Out of Range",
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primaryDark, // header background color
//               onPrimary: Colors.Colors.white, // header text color
//               onSurface: AppColors.primaryDark, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 primary: AppColors.primaryDark, // button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (timeOfDay != null && timeOfDay != selectedTimeTo) {
//       setState(() {
//         selectedTimeTo = timeOfDay;
//         print('timeOfDay: $timeOfDay');
//         final format = DateFormat('yyyy-MM-dd');
//         edtxt.text = "${format.format(selectedToDate).toString()}"
//             " "
//             "${selectedTimeTo.hour}:${selectedTimeTo.minute}:00";
//         log('edtxt.text: ${edtxt.text}');
//       });
//     }
//   }

}
