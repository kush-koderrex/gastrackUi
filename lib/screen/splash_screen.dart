import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/LocalStorage.dart';
import 'package:gas_track_ui/Utils/Utils.dart';
import 'package:gas_track_ui/permissions/permissions.dart';
import 'package:gas_track_ui/screen/HomeScreen.dart';
import 'package:gas_track_ui/screen/Login_Screen.dart';
import 'package:gas_track_ui/screen/onBoardScreen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  check() async {
    var value = await PermissionAccess().getPermission();
    print("value");
    print(value);
    if (value != null) {
      if (value == true) {
        var userToken = await UserPreferences().getUserData();
        print("User ID: ${userToken["userId"]}");
        print("email ID: ${userToken["email"]}");
        print(Utils.cusUuid + "{Utils.cusUuid}");
        if (userToken["userId"] != null) {
          Utils.cusUuid = userToken["email"]!;
          print(Utils.cusUuid + " {Utils.cusUuid}");
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => const AddYouDeviceScreen(),
              builder: (context) => const Homescreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 3), () => navigateUser(context));
    Timer(
      const Duration(seconds: 3),
      () => check()
          // Navigator.pushAndRemoveUntil(
          // context,
          // MaterialPageRoute(builder: (context) => const OnBoardScreen()),
          // (Route<dynamic> route) => false),
      // (Route<dynamic> route) => false)
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFC54239),
                Color(0xFF7A2AAE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC54239),
                  Color(0xFF7A2AAE),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/Splashscreen/splashScreen.png",
                          height: 132,
                          width: 132,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/images/Splashscreen/building.png",
                    height: 200,
                    width: width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
