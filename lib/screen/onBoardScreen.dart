import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/welcome_screen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          // Image at the top of the screen
          Column(
            children: [
              Image.asset(
                "images/OnboardScreen/onboard.png",
                height: height / 2,
                width: width,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: height * 0.040,
              ),
              Text(
                "Fast Track with GasTrack",
                style: const TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 18,
                    color: Color(0xFFC1B9B9),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.100,
              ),
              InkWell(
                  child: Container(
                    width: width / 2,
                    // width: width*0.60,
                    // height: height*0.060,
                    height: height / 12,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.bordergrey, width: 1),
                        shape: BoxShape.circle,
                        color: Color(0xFF7A2AAE)),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()));
                    // (Route<dynamic> route) => false);
                  }),
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
        ],
      ),

      // ListView(
      //   children: <Widget>[
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.max,
      //       children: <Widget>[
      //         Image.asset(
      //           "images/OnboardScreen/onboard.png",
      //           height: height * 0.080,
      //           width: width,
      //         ),
      //         Container(
      //           // color: Colors.grey,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const Expanded(flex: 1, child: SizedBox()),
      //               Expanded(
      //                 flex: 7,
      //                 child: Image.asset(
      //                   "images/OnboardScreen/onboard.png",
      //                   height: height * 0.080,
      //                   width: width,
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      //                 child: TextButton(
      //                   onPressed: () {
      //                     // print("Height:-$height , Weight$width");
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 const WelcomeScreen()));
      //                     // Navigator.push(
      //                     //     context,
      //                     //     MaterialPageRoute(
      //                     //         builder: (context) => const loginScreen()));
      //                     // (Route<dynamic> route) => false);
      //                     //signup screen
      //                   },
      //                   style: TextButton.styleFrom(
      //                       padding: EdgeInsets.zero,
      //                       minimumSize: const Size(30, 30),
      //                       tapTargetSize:
      //                           MaterialTapTargetSize.shrinkWrap,
      //                       alignment: Alignment.centerLeft),
      //                   child: const Text(
      //                     "Skip",
      //                     style: TextStyle(
      //                       decoration: TextDecoration.underline,
      //                       fontFamily: 'SourceSansPro',
      //                       color: AppColors.Textcolorheading,
      //                       fontWeight: FontWeight.w300,
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ),
      //                 // Text("SKIP",style: TextStyle(
      //                 //   decoration:
      //                 //   TextDecoration.underline,
      //                 //   color: Colors.grey,
      //                 //   // fontSize: 16,
      //                 //   fontFamily: "SourceSansPro",
      //                 //   fontWeight: FontWeight.w600,
      //                 // ),),
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //         SizedBox(
      //           height: height * 0.080,
      //         ),
      //         Align(
      //           alignment: Alignment.bottomCenter,
      //           child: Image.asset(
      //             "images/Spasc.png",
      //             height: height * 0.200,
      //           ),
      //         ),
      //         SizedBox(
      //           height: height * 0.040,
      //         ),
      //         Text(
      //           "Don’t miss out".toUpperCase(),
      //           style: const TextStyle(
      //               fontFamily: 'NotoSans',
      //               fontSize: 18,
      //               color: AppColors.primaryColorpink,
      //               fontWeight: FontWeight.bold),
      //         ),
      //
      //         SizedBox(
      //           height: height * 0.005,
      //         ),
      //         const Text(
      //           "Register and start your fashion \n journey to get -",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontFamily: 'SourceSansPro',
      //               fontSize: 16,
      //               color: AppColors.Textcolorheading,
      //               fontWeight: FontWeight.w400),
      //         ),
      //         // SizedBox(
      //         //   height: height*0.10,
      //         // ),
      //         const Padding(
      //           padding: EdgeInsets.all(12.0),
      //           child: Text(
      //             "Get extra 500 Off* on your first order when you log in. Offers & updates on fresh Indian fashion trends. Seamless sync of wishlist on all devices. Faster browsing and checkout while you shop. All your orders & status updates in one place..",
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //                 fontFamily: 'SourceSansPro',
      //                 fontSize: 15,
      //                 color: AppColors.Textcolorheading,
      //                 fontWeight: FontWeight.w400),
      //           ),
      //         ),
      //         SizedBox(
      //           height: height * 0.100,
      //         ),
      //         InkWell(
      //             child: Container(
      //               width: width / 2,
      //               // width: width*0.60,
      //               // height: height*0.060,
      //               height: height / 12,
      //               decoration: BoxDecoration(
      //                   border: Border.all(
      //                       color: AppColors.bordergrey, width: 1),
      //                   shape: BoxShape.circle,
      //                   color: Color(0xFF7A2AAE)),
      //               child: const Icon(
      //                 Icons.arrow_forward,
      //                 color: Colors.white,
      //               ),
      //             ),
      //             onTap: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => const WelcomeScreen()));
      //               // (Route<dynamic> route) => false);
      //             }),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
