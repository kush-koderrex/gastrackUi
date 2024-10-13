import 'dart:async';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/permissions/bluetooth_off_screen.dart';
import 'package:gas_track_ui/screen/CylinderDetailScreen.dart';
import 'package:gas_track_ui/screen/DeviceAdded.dart';
import 'package:gas_track_ui/screen/MenuScreen.dart';
import 'package:gas_track_ui/utils/utils.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();


}



class _HomescreenState extends State<Homescreen> {

  bool _isBluetoothEnabled = false; // Blu

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown; // Default state
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  Future<void> checkBluetoothState() async {
    BluetoothAdapterState state = await FlutterBluePlus.adapterState.first; // Get the current Bluetooth state

    if (state == BluetoothAdapterState.on) {
      setState(() {
        _isBluetoothEnabled = true; // Update the state if Bluetooth is enabled
      });
      // onScanPressed(); // Start scanning for devices if Bluetooth is on
    } else {
      // Show a message or navigate if Bluetooth is off
      Fluttertoast.showToast(msg: "Please enable Bluetooth to add devices.");
      // Optionally navigate back or show a different screen
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    checkBluetoothState();
    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
          setState(() {
            _adapterState = state;
          });
        });
    super.initState();
  }
  @override
  void dispose() {
    // Cancel the Bluetooth state subscription when widget is disposed
    _adapterStateSubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 10.0), // Adjust the padding to position the image
          child: GestureDetector(
            onTap: () {
              // Add navigation or action on image tap here
              Navigator.of(context)
                  .pop(); // For example, this will pop the current screen
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Image.asset(
                'assets/images/HomeScreen/hcylender.png', // Replace with your image path
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              "Kitchen Cylinder",
              style: AppStyles.customTextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Connected",
                  style: AppStyles.customTextStyle(
                      fontSize: 13.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                size: 35,
              ), // Replace this with any icon you want
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuScreen()));
                // Add action here
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes icons white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
      body: _isBluetoothEnabled?Stack(
        children: [
          // Gradient with Custom Clip Path at the top of the screen
          ClipPath(
            clipper:
                TopRoundedRectangleClipper(), // Custom clipper for the top curve
            child: Container(
              height: height * 0.40, // Adjust height of the effect
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
            padding: EdgeInsets.only(top: height / 7), // Adjust for gradient
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
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // First Container
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Card(
                                                // elevation: 5,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      12), // Padding inside the container
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // Rounded edges for the container
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center, // Center contents inside the container
                                                    children: [
                                                      CircleAvatar(
                                                        radius:
                                                            25, // Size of the avatar
                                                        backgroundColor: Color(0xF2BE3F44),



                                                    child: SvgPicture.asset(
                                                          'assets/images/svg/battery.svg', // Path to your SVG asset
                                                          width: 15,
                                                          height: 15,
                                                          color: Colors.white,
                                                        ), // Icon inside avatar
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              5), // Space between avatar and text
                                                      Text(
                                                        "80%",
                                                        style: AppStyles
                                                            .customTextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Device Battery",
                                                style:
                                                    AppStyles.customTextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Space between the first and second container
                                        const SizedBox(
                                            width:
                                                5), // Adjust the width as needed

                                        // Second Container

                                        Expanded(
                                          child: Column(
                                            children: [
                                              Card(
                                                // elevation: 5,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      12), // Padding inside the container
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // Rounded edges for the container
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center, // Center contents inside the container
                                                    children: [
                                                      CircleAvatar(
                                                        radius:
                                                            25, // Size of the avatar
                                                        backgroundColor:  Color(0xF2A4386B),


                                                  child: SvgPicture.asset(
                                                          'assets/images/svg/weight.svg', // Path to your SVG asset
                                                          width: 20,
                                                          height: 20,
                                                          color: Colors.white,
                                                        ), // Icon inside avatar
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // Space between avatar and text
                                                      Text(
                                                        "45",
                                                        style: AppStyles
                                                            .customTextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Cylinder Weight",
                                                style:
                                                    AppStyles.customTextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Space between the second and third container
                                        const SizedBox(
                                            width:
                                                5), // Adjust the width as needed

                                        // Third Container
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Card(
                                                // elevation: 5,
                                                child: Container(

                                                  padding: const EdgeInsets.all(
                                                      12), // Padding inside the container
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // Rounded edges for the container
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center, // Center contents inside the container
                                                    children: [
                                                      CircleAvatar(
                                                        radius:
                                                            25, // Size of the avatar
                                                        backgroundColor: Color(0xF2913189),
                                                        child: SvgPicture.asset(
                                                          'assets/images/svg/calendar.svg', // Path to your SVG asset
                                                          width: 20,
                                                          height: 20,
                                                          color: Colors.white,
                                                        ), // Icon inside avatar
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // Space between avatar and text
                                                      Text(
                                                        "38",
                                                        style: AppStyles
                                                            .customTextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Days of Use",
                                                style:
                                                    AppStyles.customTextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CylinderDetailScreen()));
                                },
                                child: Stack(
                                  alignment: Alignment
                                      .center, // Centers the text in the middle
                                  children: [
                                    Image.asset(
                                      "assets/images/HomeScreen/progcylinder.png",
                                      fit: BoxFit.fitWidth,
                                      height: height / 2,
                                    ),
                                    // Centered text
                                    Positioned(
                                      bottom: 100,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.water_drop,color: Colors.white,),
                                              Text(
                                                "72%", // Replace with your desired text
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Cerapro',
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "Remaining", // Replace with your desired text
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Cerapro',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/images/OnboardScreen/elipse.png",
                                    width: width / 1.3,
                                    fit: BoxFit.fill,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Image.asset(
                                          "assets/images/OnboardScreen/elipse2.png",
                                          width: width / 1.3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Positioned(
                                        top: 10,
                                        left:width/3.8 ,
                                        child: Center(
                                          child: Container(
                                            width: 250,
                                            child: Row(
                                              children: [
                                                Container(
                                                  // color:Colors.red,
                                                  child: Image.asset(
                                                    "assets/images/OnboardScreen/gastrackname.png",
                                                    width: 60,
                                                    height: 7,
                                                    fit: BoxFit
                                                        .fill, // Ensures the image fills the container
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 40,
                                                ),
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 14,
                                    Icons.sync,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Last Synced: 27-04-2024 13:22",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Cerapro',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
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
      ): BluetoothOffScreen(adapterState: _adapterState),
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
