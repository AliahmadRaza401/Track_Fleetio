import 'package:provider/provider.dart';
import 'package:track_flotilla/providers/dashboard_provider.dart';
import 'package:track_flotilla/providers/drawerPageProvider.dart';
import 'package:track_flotilla/providers/driver_provider.dart';
import 'package:track_flotilla/providers/geofence_provider.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/providers/maintenance_provider.dart';
import 'package:track_flotilla/providers/monitoring_provider.dart';
import 'package:track_flotilla/providers/time_machine_provider.dart';

final multiProvider = [
  ChangeNotifierProvider<LoadingProvider>(
    create: (_) => LoadingProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<DrawerPageProvider>(
    create: (_) => DrawerPageProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<DashboardProvider>(
    create: (_) => DashboardProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<DriverProvider>(
    create: (_) => DriverProvider(),
  ),
  ChangeNotifierProvider<MonitoringProvider>(
    create: (_) => MonitoringProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<TimeMachineProvider>(
    create: (_) => TimeMachineProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<MaintenanceProvider>(
    create: (_) => MaintenanceProvider(),
    lazy: true,
  ),
   ChangeNotifierProvider<GeoFenceProvider>(
    create: (_) => GeoFenceProvider(),
    lazy: true,
  ),
];
