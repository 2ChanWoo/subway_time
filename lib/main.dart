import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:subway_time/screens/main_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(411,683),
      allowFontScaling: false,
      builder: () => MaterialApp(
        home: SafeArea(
          child: MainScreen(),
        ),

      ),
    );
  }
}
