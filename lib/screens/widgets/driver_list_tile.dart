import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';

class DriverListTile extends StatefulWidget {
  String name;
  String id;
  String imageUrl;

  DriverListTile({
    required this.name,
    required this.id,
    required this.imageUrl,
  });
  @override
  _DriverListTileState createState() => _DriverListTileState();
}

class _DriverListTileState extends State<DriverListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.amber,
        width: AppSizes.dynamicWidth(context, 0.9),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(widget.imageUrl),
                        maxRadius: 20,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "ID:${widget.id}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // PopupMenuButton(
                //   color: AppColors.primaryDark,
                //   onSelected: (value) {
                //     // your logic
                //   },
                //   itemBuilder: (BuildContext bc) {
                //     return const [
                //       PopupMenuItem(
                //         child: Text(
                //           "Delete",
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //         value: '/hello',
                //       ),
                //       PopupMenuItem(
                //         child: Text(
                //           "Cancel",
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //         value: '/about',
                //       ),
                //     ];
                //   },
                // ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyLight, width: 0.5)),
            ),
          ],
        ));
  }
}
