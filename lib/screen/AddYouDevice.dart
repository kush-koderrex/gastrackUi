import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/AddManuallyDevice.dart';
import 'package:gas_track_ui/screen/DeviceSearchScreen.dart';
import 'package:gas_track_ui/screen/OtpScreen.dart';
import 'package:gas_track_ui/screen/QrScannerScreen.dart';
import 'package:gas_track_ui/Bargraph.dart';
import 'package:gas_track_ui/utils/utils.dart';

class AddYouDeviceScreen extends StatefulWidget {
  const AddYouDeviceScreen({super.key});

  @override
  State<AddYouDeviceScreen> createState() => _AddYouDeviceScreenState();
}

class _AddYouDeviceScreenState extends State<AddYouDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int activeStep = 0;
    int activeStep2 = 0;
    int reachedStep = 0;
    int upperBound = 5;
    double progress = 0.2;
    Set<int> reachedSteps = <int>{0, 2, 4, 5};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Setup",
          style: AppStyles.appBarTextStyle,),

        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes the back arrow white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
      body: SingleChildScrollView(
        child: Stack(
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
              padding:
                  EdgeInsets.only(top: height / 9.5), // Adjust for gradient
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
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                EasyStepper(
                                  activeStepIconColor: Colors.white,
                                  activeStepBackgroundColor: AppStyles.cutstomIconColor,
                                  activeStep: activeStep,
                                  lineStyle: const LineStyle(
                                    lineLength: 80,
                                    lineThickness: 1,
                                    lineSpace: 5,
                                  ),
                                  stepRadius: 15,
                                  unreachedStepIconColor: Colors.white,
                                  unreachedStepBorderColor: Colors.grey,
                                  unreachedStepTextColor: Colors.grey,
                                  showLoadingAnimation: false,
                                  steps: const [
                                    EasyStep(
                                      topTitle: true,
                                      icon: Icon(Icons.check),
                                      title: 'Step 1',
                                    ),
                                    EasyStep(
                                      topTitle: true,
                                      icon: Icon(Icons.close),
                                      title: 'Step 2',
                                    ),
                                    EasyStep(
                                      topTitle: true,
                                      icon: Icon(Icons.close),
                                      title: 'Step 3',
                                    ),
                                  ],
                                  onStepReached: (index) =>
                                      setState(() => activeStep = index),
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      width: 121,
                                      height: 123,
                                      "assets/images/AddyourdeviceScreen/cylinder.png",
                                      fit: BoxFit
                                          .fill, // Ensures the image fills the container
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Add your Device',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Cerapro',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                            'From below options, Scan device ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Cerapro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                        Text(' code or Add manually',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Cerapro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width / 1.5,
                                  height: 58,
                                  child: const Row(
                                    children: [],
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment
                                      .topCenter, // Aligns children in the center of the stack
                                  children: [
                                    const SizedBox(height: 40),
                                    // Background image
                                    Image.asset(
                                      "assets/images/Splashscreen/building.png",
                                      width: width,
                                      color: Colors.grey,
                                      fit: BoxFit.fitWidth,
                                    ),

                                    // Centered button

                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // if (Form.of(context)?.validate() ??
                                                    //     false) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const QrScannerScreen(),
                                                      ),
                                                    );
                                                    // }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: AppStyles.cutstomIconColor, // Button background color
                                                    foregroundColor: Colors
                                                        .white, // Button text color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20), // Curved edges
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
                                                  child: Image.asset(
                                                    "assets/images/AddyourdeviceScreen/scanner.png",
                                                    fit: BoxFit
                                                        .fill, // Ensures the image fills the container
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                "Scan device Code",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cerapro',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // if (Form.of(context)?.validate() ??
                                                    //     false) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            // RadarUI(),
                                                            const AddManuallyDeviceScreen(),
                                                      ),
                                                    );
                                                    // }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: AppStyles.cutstomIconColor, // Button background color
                                                    foregroundColor: Colors
                                                        .white, // Button text color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20), // Curved edges
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
                                                  child: Image.asset(
                                                    "assets/images/AddyourdeviceScreen/signal.png",
                                                    fit: BoxFit
                                                        .fill, // Ensures the image fills the container
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                "Add Manually",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cerapro',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
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
