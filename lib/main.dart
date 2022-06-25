import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/screens/splash/splash.dart';

import 'providers/multi_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(540, 1179),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MultiProvider(
        providers: multiProvider,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // textTheme: TextTheme(button: TextStyle(fontSize: 20.sp)),
          ),
          builder: (context, widget) {
            // ScreenUtil.setContext(context);
            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: const SplashScreen(),
        ),
      ),
    );
    //  ScreenUtilInit(
    //     designSize: const Size(540, 1179),
    //     minTextAdapt: true,
    //     builder: () {
    //       return MaterialApp(
    //           title: 'Track Flotilla',
    //           debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //             primarySwatch: Colors.blue,
    //           ),
    //           home: SplashScreen());
    //     });
  }
}
