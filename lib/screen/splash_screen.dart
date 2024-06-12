import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/onBoardScreen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 3), () => navigateUser(context));
    Timer(
        const Duration(seconds: 3),
        () =>   Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardScreen()),
                (Route<dynamic> route) => false
        ),
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
          decoration: BoxDecoration(
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
            decoration: BoxDecoration(
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
                          "images/Splashscreen/splashScreen.png",
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
                    "images/Splashscreen/building.png",
                    height: 200,
                    width: width,
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           mainAxisSize: MainAxisSize.max,
          //           children: <Widget>[
          //             Align(
          //               alignment: Alignment.bottomCenter,
          //               child: Image.asset(
          //                 "images/Splashscreen/splashScreen.png",
          //                 height: 132,
          //                 width: 132,
          //               ),
          //             ),
          //           ],
          //         ),
          //         Align(
          //           alignment: Alignment.bottomCenter,
          //           child: Image.asset(
          //             "images/Splashscreen/building.png",
          //             height: 200,
          //             width: width,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),


        // Container(
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("images/Rectangle.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   child: Center(
        //     child: Container(
        //       child: Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               mainAxisSize: MainAxisSize.max,
        //               children: <Widget>[
        //                 Align(
        //                   alignment: Alignment.bottomCenter,
        //                   child: Image.asset(
        //                     "images/SplashScreenLogo.png",
        //                     height: 132,
        //                     width: 132,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  // navigateUser(BuildContext context) {
  //   if(PrefUtils.getUserkey().isNotEmpty){
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const OnBoardScreen()),
  //             (Route<dynamic> route) => false
  //     );
  //   }else{
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const OnBoardScreen()),
  //             (Route<dynamic> route) => false
  //     );
  //   }
  // }
}
