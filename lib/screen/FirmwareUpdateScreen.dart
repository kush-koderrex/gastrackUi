import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

import 'package:gas_track_ui/screen/HomeScreen.dart';
import 'package:gas_track_ui/utils/utils.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class FirmwareUpdateScreen extends StatefulWidget {
  const FirmwareUpdateScreen({super.key});

  @override
  State<FirmwareUpdateScreen> createState() => _FirmwareUpdateScreenState();
}

class _FirmwareUpdateScreenState extends State<FirmwareUpdateScreen> {
  Color blendWithWhite(Color color, [double amount = 0.2]) => Color.fromARGB(
      color.alpha,
      color.red + ((255 - color.red) * amount).round(),
      color.green + ((255 - color.green) * amount).round(),
      color.blue + ((255 - color.blue) * amount).round());
  bool isLoading = false;
  bool isShow = false;
  bool isShowText = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double percent = 35;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firmware Update",
          style: AppStyles.appBarTextStyle,
        ),

        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme: const IconThemeData(
            color: Colors.white), // Makes the back arrow white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
      body: Stack(
        children: [
          // Gradient with Custom Clip Path at the top of the screen
          ClipPath(
            clipper:
                TopRoundedRectangleClipper(), // Custom clipper for the top curve
            child: Container(
              height: height * 0.30, // Adjust height of the effect
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFA7365),
                    Color(0xFF9A4DFF)
                  ], // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: height / 9.5), // Adjust for gradient
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white54.withOpacity(0.30),
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white54.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  isShow?Image.asset(
                                    "assets/images/Firmware/firmwareUpdate.gif",
                                    fit: BoxFit.fill,
                                    width: 215,
                                    height: 240,
                                  ):
                                  Image.asset(
                                    "assets/images/Firmware/firmware.png",
                                    fit: BoxFit.fill,
                                    width: 215,
                                    height: 240,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isShow?
                                  Text(
                                    'Updating Firmware',
                                    style: AppStyles.customTextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500),
                                  ):
                                  Text(
                                    'Your Firmware version',
                                    style: AppStyles.customTextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isShow?
                                  Text('Warning! Do not close the app or',
                                      style: AppStyles.customTextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400)):
                                  Text('Version 3.3.1',
                                      style: AppStyles.customTextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isShow?
                                  Text('disconnect Bluetooth during update',
                                      style: AppStyles.customTextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400)):
                                  Text('New Update available!',
                                      style: AppStyles.customTextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(
                                alignment: Alignment
                                    .topCenter, // Aligns children in the center of the stack
                                children: [
                                  Image.asset(
                                    "assets/images/Splashscreen/building.png",
                                    width: width,
                                    height: height / 3.5,
                                    color: Colors.grey,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  isShow
                                      ? Container(
                                          width: width / 1.4,
                                          child: RoundedProgressBar(
                                            childLeft: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text("${percent.toInt()}%",
                                                  style: const TextStyle(
                                                    fontFamily: 'Cerapro',
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ),
                                            style: RoundedProgressBarStyle(
                                                colorProgress: AppStyles
                                                    .cutstomIconColor,
                                                backgroundProgress:
                                                    blendWithWhite(
                                                        AppStyles
                                                            .cutstomIconColor,
                                                        0.9),
                                                borderWidth: 0,
                                                widthShadow: 0,
                                                // widthShadow: 10,
                                                colorBorder:
                                                    AppStyles.cutstomIconColor),
                                            // RoundedProgressBarStyle(
                                            //     borderWidth: 0,
                                            //     widthShadow: 0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            percent: percent,
                                          ),

                                          // RoundedProgressBar(
                                          //     style: RoundedProgressBarStyle(
                                          //         colorProgress :Colors.white,
                                          //         backgroundProgress: Colors.white,
                                          //         widthShadow: 30,
                                          //         colorBorder:
                                          //             AppStyles.cutstomIconColor),
                                          //     childLeft: Text("$percent%",
                                          //         style:
                                          //             TextStyle(color: Colors.white)),
                                          //     percent: percent,
                                          //     theme: RoundedProgressBarTheme.purple),
                                        )
                                      : isLoading
                                          ? Center(
                                              child: LoadingAnimationWidget
                                                  .staggeredDotsWave(
                                                size: 80,
                                                color:
                                                    AppStyles.cutstomIconColor,
                                              ),
                                            )
                                          : isShowText
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: SizedBox(
                                                    width: 350,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // if (Form.of(context)?.validate() ?? false) {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 3),
                                                            () {
                                                          setState(() {
                                                            isLoading = false;
                                                            isShowText =false;
                                                          });
                                                        });

                                                        // }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: AppStyles
                                                            .cutstomIconColor, // Button background color
                                                        foregroundColor: Colors
                                                            .white, // Button text color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12), // Curved edges
                                                        ),
                                                        minimumSize:
                                                            const Size(200, 50),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 30,
                                                            vertical:
                                                                15), // Adjust button size
                                                        elevation:
                                                            5, // Elevation (shadow)
                                                      ),
                                                      child: Text(
                                                        'Check for Update',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: SizedBox(
                                                    width: 350,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            isShow =true;
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: AppStyles
                                                              .cutstomIconColor, // Button background color
                                                          foregroundColor: Colors
                                                              .white, // Button text color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12), // Curved edges
                                                          ),
                                                          minimumSize:
                                                              const Size(
                                                                  200, 50),
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 30,
                                                              vertical:
                                                                  15), // Adjust button size
                                                          elevation:
                                                              5, // Elevation (shadow)
                                                        ),
                                                        child: Text(
                                                          'Update Now',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )),
                                                  ),
                                                )
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for creating a curved top
class TopRoundedRectangleClipper extends CustomClipper<Path> {
  final double radius; // Controls the corner radius
  final double heightFactor; // Controls the height to clip

  // Default radius is 30, and heightFactor is 0.25 (i.e., 25% of the container height)
  TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});

  @override
  Path getClip(Size size) {
    var clippedHeight = size.height *
        heightFactor; // Calculate clipped height based on the heightFactor
    var path = Path();

    // Start from bottom-left corner
    path.moveTo(0, clippedHeight);

    // Bottom line to the right
    path.lineTo(size.width, clippedHeight);

    // Line to the top-right corner but we will start curving for the top corners
    path.lineTo(size.width, radius);

    // Create a rounded corner on the top-right
    path.arcToPoint(
      Offset(size.width - radius, 0),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Line to the top-left with rounded corner
    path.lineTo(radius, 0);
    path.arcToPoint(
      Offset(0, radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Close the path back to the bottom-left corner
    path.lineTo(0, clippedHeight);
    path.close(); // Close the path to form the shape

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
