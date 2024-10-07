// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:gas_track_ui/screen/FillOtherInformation.dart';
// import 'package:gas_track_ui/utils/extra.dart';
// import 'package:gas_track_ui/utils/snackbar.dart';
// import 'package:gas_track_ui/utils/utils.dart';
// import 'dart:developer' as developer;
//
// class AddManuallyDeviceScreen extends StatefulWidget {
//   const AddManuallyDeviceScreen({super.key});
//
//   @override
//   State<AddManuallyDeviceScreen> createState() =>
//       _AddManuallyDeviceScreenState();
// }
//
// class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen>
//     with SingleTickerProviderStateMixin {
//   Future<void> delay(int seconds) async {
//     await Future.delayed(Duration(seconds: seconds));
//   }
//
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   List<ScanResult> _scanResults = [];
//   List<BluetoothDevice> _systemDevices = [];
//   List<dynamic> items = [];
//
//   // This function updates the items list with device information from scan results
//   void updateItemsFromScanResults(List<ScanResult> scanResults) {
//     // Clear the previous items
//     items.clear();
//
//     // Populate the items list with the names and distances from the scan results
//     for (var result in scanResults) {
//       // Create a map for each device
//       var deviceInfo = {
//         'name': result.device.name, // Get the device name
//         'distance':
//             result.rssi.toDouble() // Use RSSI as an example for distance
//       };
//
//       // Add the device info to the items list
//       items.add(deviceInfo);
//     }
//   }
//
// // Example usage
//   void onScanResultsUpdated(List<ScanResult> scanResults) {
//     // Update the items list when scan results are updated
//     updateItemsFromScanResults(scanResults);
//
//     // Optionally print the list for debugging
//     printDeviceList();
//   }
//
//   void printDeviceList() {
//     for (var item in items) {
//       print(
//           'Device Name: ${item['name']}, Distance: ${item['distance']} meters');
//     }
//   }
//
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//
//   @override
//   void initState() {
//     onScanPressed();
//
//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       if (mounted) {
//         setState(() {});
//       }
//     }, onError: (e) {
//       Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });
//
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//
//     _animation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void onConnectPressed(BluetoothDevice device) {
//     device.connectAndUpdateStream().catchError((e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//           success: false);
//     });
//     // MaterialPageRoute route = MaterialPageRoute(
//     //     builder: (context) => DeviceScreen(device: device), settings: const RouteSettings(name: '/DeviceScreen'));
//     // Navigator.of(context).push(route);
//   }
//
//   Future onScanPressed() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
//           success: false);
//     }
//     try {
//       await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
//           success: false);
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("_scanResults");
//     developer.log("_scanResults ---->${_scanResults.toString()}");
//     // developer.log("_systemDevices ---->${_systemDevices.toString()}");
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//
//     // Container dimensions
//     var containerHeight = height / 2;
//     var containerWidth = width;
//
//     // Center of the container
//     var centerX = containerWidth / 2;
//     var centerY = containerHeight / 2;
//
//     // Log or print the center values
//     print('Center of the container is at: ($centerX, $centerY)');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Adding Manually",
//           style: AppStyles.appBarTextStyle,
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           ClipPath(
//             clipper: TopRoundedRectangleClipper(),
//             child: Container(
//               height: height * 0.30,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFFA7365), Color(0xFF9A4DFF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: height / 9.5),
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 color: Colors.white54.withOpacity(0.30),
//                 borderRadius: BorderRadius.circular(45.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(45.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         // color: Colors.cyan,
//                         height: height / 2,
//
//                         child: Stack(
//                           children: [
//                             Center(
//                               child: AnimatedBuilder(
//                                 animation: _animation,
//                                 builder: (context, child) {
//                                   return Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       buildRadarCircle(250 * _animation.value,
//                                           Colors.purple.withOpacity(0.1)),
//                                       buildRadarCircle(200 * _animation.value,
//                                           Colors.purple.withOpacity(0.2)),
//                                       buildRadarCircle(150 * _animation.value,
//                                           Colors.purple.withOpacity(0.3)),
//                                       buildRadarCircle(100 * _animation.value,
//                                           Colors.purple.withOpacity(0.4)),
//                                       buildRadarCircle(50 * _animation.value,
//                                           Colors.purple.withOpacity(0.5)),
//                                       buildRadarCircle(25 * _animation.value,
//                                           Colors.purple.withOpacity(0.6)),
//
//                                       // // Plot devices on the radar
//                                       // ...items.map((item) => buildItemDot(item)).toList(),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                             // Positioned(
//                             //     top: centerX,
//                             //     child: Container(
//                             //         child: Column(
//                             //       children: [
//                             //         CircleAvatar(
//                             //           child: Image.asset(
//                             //             "assets/images/ListIcons/autobooking.png",
//                             //             width: 10,
//                             //             color: Colors.white,
//                             //             fit: BoxFit.fitWidth,
//                             //           ),
//                             //           backgroundColor:
//                             //           AppStyles.cutstomIconColor,
//                             //           radius:
//                             //           20, // Adjust radius for avatar
//                             //         ),
//                             //         Text(items[0].name),
//                             //       ],
//                             //     ))),
//
//                             FutureBuilder(
//                               future: delay(3), // Delay for 1 second
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.done) {
//                                   return Positioned(
//                                     left: centerX + 80,
//                                     bottom: centerY,
//                                     child: InkWell(
//                                       onTap: () {
//                                         showCustomDialog(context);
//                                       },
//                                       child: Container(
//                                         child: Column(
//                                           children: [
//                                             CircleAvatar(
//                                               child: Image.asset(
//                                                 "assets/images/ListIcons/autobooking.png",
//                                                 width: 10,
//                                                 color: Colors.white,
//                                                 fit: BoxFit.fitWidth,
//                                               ),
//                                               backgroundColor:
//                                                   Color(0xF2A4386B),
//                                               radius: 20,
//                                             ),
//                                             Text(
//                                               items[0]
//                                                   .name, // Use items[0].name if available
//                                               style: TextStyle(
//                                                 fontFamily: 'Cerapro',
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 return SizedBox(); // Return an empty widget before delay
//                               },
//                             ),
//                             FutureBuilder(
//                               future: delay(6), // Delay for 3 seconds
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.done) {
//                                   return Positioned(
//                                     right: centerX,
//                                     bottom: centerY + 90,
//                                     child: InkWell(
//                                       onTap: () {
//                                         showCustomDialog(context);
//                                       },
//                                       child: Container(
//                                         child: Column(
//                                           children: [
//                                             CircleAvatar(
//                                               child: Image.asset(
//                                                 "assets/images/ListIcons/autobooking.png",
//                                                 width: 10,
//                                                 color: Colors.white,
//                                                 fit: BoxFit.fitWidth,
//                                               ),
//                                               backgroundColor:
//                                                   Color(0xF2A4386B),
//                                               radius: 20,
//                                             ),
//                                             Text(
//                                               items[1]
//                                                   .name, // Use items[1].name if available
//                                               style: TextStyle(
//                                                 fontFamily: 'Cerapro',
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 return SizedBox(); // Return an empty widget before delay
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // Container(
//                       //   child: Center(
//                       //     child: Text(
//                       //       "Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device",
//                       //       textAlign: TextAlign.center,
//                       //         style:
//                       //         AppStyles.customTextStyle(
//                       //             fontSize: 14.0,
//                       //             fontWeight:
//                       //             FontWeight.w400)// Optional: To center the text within its container
//                       //     ),
//                       //   ),
//                       // ),
//
//                       FutureBuilder(
//                         future: Future.delayed(Duration(
//                             seconds: 3)), // Use Future.delayed for a delay
//                         builder:
//                             (BuildContext context, AsyncSnapshot snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Container(
//                               child: Center(
//                                 child: Text(
//                                   "Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device",
//                                   textAlign: TextAlign.center,
//                                   style: AppStyles.customTextStyle(
//                                     fontSize: 14.0,
//                                     fontWeight: FontWeight.w400,
//                                   ), // Style for the text
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // Return something else once the Future completes
//                             return Container(
//                               child: Center(
//                                 child: Text(
//                                   "Device found. Please tap to add the device",
//                                   textAlign: TextAlign.center,
//                                   style: AppStyles.customTextStyle(
//                                     fontSize: 14.0,
//                                     fontWeight: FontWeight.w400,
//                                   ), // Style for the text
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildRadarCircle(double radius, Color color) {
//     return Container(
//       width: radius,
//       height: radius,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//       ),
//     );
//   }
//
//   Widget buildItemDot(Item item) {
//     double angle =
//         Random().nextDouble() * 2 * pi; // Random angle for positioning
//     double distance =
//         item.distance * _animation.value; // Animated distance from the center
//     double xOffset = (distance * cos(angle)); // X offset based on angle
//     double yOffset = (distance * sin(angle)); // Y offset based on angle
//
//     return Positioned(
//       left: xOffset + 125, // Adjust based on your radar circle size
//       top: yOffset + 125, // Adjust based on your radar circle size
//       child: Column(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.red,
//             ),
//           ),
//           const SizedBox(height: 4), // Space between dot and text
//           Text(
//             item.name,
//             style: const TextStyle(color: Colors.black, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Item class to represent device name and distance
// class Item {
//   final String name;
//   final double distance;
//
//   Item({required this.name, required this.distance});
// }
//
// // Custom clipper for creating a curved top
// class TopRoundedRectangleClipper extends CustomClipper<Path> {
//   final double radius;
//   final double heightFactor;
//
//   TopRoundedRectangleClipper({this.radius = 0.0, this.heightFactor = 0.60});
//
//   @override
//   Path getClip(Size size) {
//     var clippedHeight = size.height * heightFactor;
//     var path = Path();
//
//     path.moveTo(0, clippedHeight);
//     path.lineTo(size.width, clippedHeight);
//     path.lineTo(size.width, radius);
//     path.arcToPoint(
//       Offset(size.width - radius, 0),
//       radius: Radius.circular(radius),
//       clockwise: false,
//     );
//     path.lineTo(radius, 0);
//     path.arcToPoint(
//       Offset(0, radius),
//       radius: Radius.circular(radius),
//       clockwise: false,
//     );
//     path.lineTo(0, clippedHeight);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// void showCustomDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(20),
//           height: 350,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               InkWell(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Icon(
//                       Icons.cancel,
//                       size: 35,
//                       color: AppStyles.cutstomIconColor,
//                     ),
//                   ),
//                 ),
//               ),
//               Image.asset(
//                 "assets/images/AddyourdeviceScreen/poupimage.png",
//                 fit: BoxFit.fitWidth,
//                 width: 100,
//                 height: 100,
//               ),
//               SizedBox(height: 20),
//               // Name
//               Center(
//                 child: Text(
//                   'Device Selected',
//                   style: AppStyles.customTextStyle(
//                       fontSize: 24.0, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   'Successfully',
//                   style: AppStyles.customTextStyle(
//                       fontSize: 24.0, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Done Button
//               SizedBox(
//                 width: 250,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // Navigator.of(context).pop();
//                     // await Future.delayed(Duration(seconds: 3));
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 const FullOtherInformation()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         AppStyles.cutstomIconColor, // Button background color
//                     foregroundColor: Colors.white, // Button text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12), // Curved edges
//                     ),
//                     minimumSize: const Size(200, 50),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 15), // Adjust button size
//                     elevation: 5, // Elevation (shadow)
//                   ),
//                   child: Text(
//                     'Done',
//                     style: AppStyles.customTextStyle(
//                         fontSize: 15.0, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }