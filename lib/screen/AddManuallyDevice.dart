import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/utils/utils.dart';

class AddManuallyDeviceScreen extends StatefulWidget {
  const AddManuallyDeviceScreen({super.key});

  @override
  State<AddManuallyDeviceScreen> createState() => _AddManuallyDeviceScreenState();
}

class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // Repeat indefinitely to simulate the radar sweep
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding Manually",style: AppStyles.appBarTextStyle,),
        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
      body: Stack(
        children: [
          // Gradient with Custom Clip Path at the top of the screen
          ClipPath(
            clipper: TopRoundedRectangleClipper(), // Custom clipper for the top curve
            child: Container(
              height: height * 0.30, // Adjust height of the effect
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFA7365), Color(0xFF9A4DFF)], // Gradient colors
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Radar Circles
                            buildRadarCircle(250, Colors.purple.withOpacity(0.1)),
                            buildRadarCircle(200, Colors.purple.withOpacity(0.2)),
                            buildRadarCircle(150, Colors.purple.withOpacity(0.3)),
                            buildRadarCircle(100, Colors.purple.withOpacity(0.4)),

                            // Radar Beam
                            // AnimatedBuilder(
                            //   animation: _controller,
                            //   builder: (context, child) {
                            //     return Transform.rotate(
                            //       angle: _controller.value * 2 * pi,
                            //       child: CustomPaint(
                            //         painter: RadarBeamPainter(),
                            //         child: Container(),
                            //       ),
                            //     );
                            //   },
                            // ),

                            // Mock Devices (Positioned randomly around the radar)
                            // Positioned(
                            //   top: 100,
                            //   left: 120,
                            //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
                            // ),
                            // Positioned(
                            //   bottom: 90,
                            //   right: 80,
                            //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
                            // ),
                            // Positioned(
                            //   bottom: 150,
                            //   left: 140,
                            //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(alignment:Alignment.center,child: Center(child: Text("Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device"))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadarCircle(double radius, Color color) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
    var clippedHeight = size.height * heightFactor; // Calculate clipped height based on the heightFactor
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

class RadarBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purple.withOpacity(0.7),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 200));

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: 200),
      -pi / 2,
      pi / 6, // Radar beam width
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint the radar beam
  }
}







// import 'package:flutter/material.dart';
// import 'package:gas_track_ui/screen/HomeScreen.dart';
//
//
//
// class AddManuallyDeviceScreen extends StatefulWidget {
//   const AddManuallyDeviceScreen({super.key});
//
//   @override
//   State<AddManuallyDeviceScreen> createState() => _AddManuallyDeviceScreenState();
// }
//
// class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     int activeStep = 2;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Adding Manually"),
//         backgroundColor: Colors.transparent, // Makes the background transparent
//         elevation: 0, // Removes the shadow below the AppBar
//         centerTitle: true, // Optional: centers the title
//         iconTheme:
//         const IconThemeData(color: Colors.white), // Makes the back arrow white
//         titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
//       ),
//       extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
//       body: Stack(
//         children: [
//           // Gradient with Custom Clip Path at the top of the screen
//           ClipPath(
//             clipper:
//             TopRoundedRectangleClipper(), // Custom clipper for the top curve
//             child: Container(
//               height: height * 0.30, // Adjust height of the effect
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFFFA7365),
//                     Color(0xFF9A4DFF)
//                   ], // Gradient colors
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.only(top: height / 9.5), // Adjust for gradient
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 color: Colors.white54.withOpacity(0.30),
//                 borderRadius: BorderRadius.circular(45.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   width: width,
//                   height: height,
//                   decoration: BoxDecoration(
//                     color: Colors.white54.withOpacity(0.20),
//                     borderRadius: BorderRadius.circular(45.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: Container(
//                       width: width,
//                       height: height,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(45.0),
//                       ),
//                       child: Padding(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Column(
//                             children: <Widget>[
//
//
//
//
//                             ],
//                           )),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Custom clipper for creating a curved top
// class TopRoundedRectangleClipper extends CustomClipper<Path> {
//   final double radius; // Controls the corner radius
//   final double heightFactor; // Controls the height to clip
//
//   // Default radius is 30, and heightFactor is 0.25 (i.e., 25% of the container height)
//   TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});
//
//   @override
//   Path getClip(Size size) {
//     var clippedHeight = size.height *
//         heightFactor; // Calculate clipped height based on the heightFactor
//     var path = Path();
//
//     // Start from bottom-left corner
//     path.moveTo(0, clippedHeight);
//
//     // Bottom line to the right
//     path.lineTo(size.width, clippedHeight);
//
//     // Line to the top-right corner but we will start curving for the top corners
//     path.lineTo(size.width, radius);
//
//     // Create a rounded corner on the top-right
//     path.arcToPoint(
//       Offset(size.width - radius, 0),
//       radius: Radius.circular(radius),
//       clockwise: false,
//     );
//
//     // Line to the top-left with rounded corner
//     path.lineTo(radius, 0);
//     path.arcToPoint(
//       Offset(0, radius),
//       radius: Radius.circular(radius),
//       clockwise: false,
//     );
//
//     // Close the path back to the bottom-left corner
//     path.lineTo(0, clippedHeight);
//     path.close(); // Close the path to form the shape
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
