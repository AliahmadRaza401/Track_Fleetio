import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerMenuWidget extends StatelessWidget {
final VoidCallback onClicked;
  const DrawerMenuWidget({Key? key,required this.onClicked}) : super(key: key);
  @override
  Widget build(BuildContext context)=>

      IconButton(
        icon:const Icon(FeatherIcons.alignLeft),
        color: Colors.white,
        iconSize:30.sp,
        onPressed: onClicked,
      );


}