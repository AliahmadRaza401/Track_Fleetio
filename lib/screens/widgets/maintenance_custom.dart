import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/screens/widgets/maintnbutton.dart';

Widget maintenanceCustom(
  BuildContext context,
  String unitName,
  String name,
  String cost,
  String mileage,
  String engine,
  String date,
  String id,
) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 20.h,
      horizontal: 20.w,
    ),
    padding: EdgeInsets.only(bottom: 10.h),
    height: 310,
    width: 500.w,
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                'assets/vehicles/SideView/1.1.png',
                width: 64.0,
                height: 60.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Unit : ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "${unitName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Name : ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      )),
                  Text(
                    "${name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Cost : ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      )),
                  Text(
                    "${cost}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(children: [
                Image.asset(
                  "assets/png/redtank.png",
                  width: 50.0,
                  height: 54.0,
                ),
              ]),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text("Engine Oil",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        )),
                  )
                ],
              )
            ],
          )
        ],
      ),
      SizedBox(height: 5.0),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Target Values",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          )
        ],
      ),
      SizedBox(height: 20.0),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text("${mileage}",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/png/speedometer 1.png",
                      width: 39.0,
                      height: 39.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Mileage",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              width: 2,
              color: Colors.grey,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('${engine}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/png/engine.png",
                      width: 42.0,
                      height: 39.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("engine",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              width: 2,
              color: Colors.grey,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('${date}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/png/Schedule 1 1.png",
                      width: 39.0,
                      height: 39.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Date",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      buttonGradient(context, id),
    ]),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
  );
}
