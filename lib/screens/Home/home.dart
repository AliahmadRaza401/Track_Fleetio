import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/drawerPageProvider.dart';
import 'package:track_flotilla/screens/Home/drawer_menu.dart';
import 'package:track_flotilla/screens/command/command.dart';
import 'package:track_flotilla/screens/dashboard/dashboard.dart';
import 'package:track_flotilla/screens/geoFence/geoFence.dart';
import 'package:track_flotilla/screens/maintenance/maintenance.dart';
import 'package:track_flotilla/screens/monitoring/monitoring_list_page.dart';
import 'package:track_flotilla/screens/reports/reports.dart';
import 'package:track_flotilla/screens/schedule/schedule.dart';
import 'package:track_flotilla/screens/splash/splash.dart';
import 'package:track_flotilla/screens/staff/staff.dart';
import 'package:track_flotilla/screens/time_machine/time_machine.dart';
import 'package:track_flotilla/screens/tracks/tracks.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';

import '../../utils/appColor.dart';
import '../monitoring/monitoring.dart';
import '../widgets/drawermenu_widget.dart';

final ZoomDrawerController z = ZoomDrawerController();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int index = Provider.of<DrawerPageProvider>(context).index;
    print('index: $index');
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      style: DrawerStyle.Style1,
      openCurve: Curves.fastOutSlowIn,
      disableGesture: false,
      mainScreenTapClose: false,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      backgroundColor: Colors.white,
      showShadow: true,
      angle: 0.0,
      clipMainScreen: true,
      mainScreen: index == 0
          ? Dashboard()
          : index == 1
              ? MonitoringListPage()
              : index == 2
                  ? Staff()
                  : index == 3
                      ? GeoFence()
                      : index == 4
                          ? Reports()
                          : index == 5
                              ? Tracks()
                              : index == 6
                                  ? TimeMachine()
                                  : index == 7
                                      ? Schedule()
                                      : index == 8
                                          ? Command()
                                          : index == 9
                                              ? Maintenance()
                                              : Dashboard(),
      menuScreen: MenuScreen(),
    );
  }
}
