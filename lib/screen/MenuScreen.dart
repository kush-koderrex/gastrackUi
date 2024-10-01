import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/CylinderDetailScreen.dart';
import 'package:gas_track_ui/screen/EditProfile.dart';
import 'package:gas_track_ui/screen/Firmware.dart';
import 'package:gas_track_ui/utils/utils.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final List<Map<String, dynamic>> items = [
      {
        "name": "Edit Profile",
        "image": "assets/images/ListIcons/user.png",
        "toggle": false
      },
      {
        "name": "Gas Usage",
        "image": "assets/images/ListIcons/gasusage.png",
        "toggle": false
      },
      {
        "name": "Device Sound",
        "image": "assets/images/ListIcons/volume-high.png",
        "toggle": true
      },
      {
        "name": "Auto Booking",
        "image": "assets/images/ListIcons/autobooking.png",
        "toggle": true
      },
      {
        "name": "Firmware Update",
        "image": "assets/images/ListIcons/firmware.png",
        "toggle": false
      },
      {
        "name": "Delete Device",
        "image": "assets/images/ListIcons/deleteDevice.png",
        "toggle": false
      },
      {
        "name": "Factory Reset",
        "image": "assets/images/ListIcons/factoryReset.png",
        "toggle": false
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Menu",
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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " Kitchen Cylinder",
                                      style: AppStyles.customTextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Connected",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontFamily: 'Cerapro',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 500,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero, // Remove padding
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                            child: Image.asset(
                                              items[index]['image'],
                                              width: 20,
                                              color: Colors.white,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            backgroundColor:
                                                AppStyles.cutstomIconColor,
                                            radius:
                                                30, // Adjust radius for avatar
                                          ),
                                          title: Text(
                                            items[index]['name'],
                                            style: AppStyles.customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (items[index][
                                                  'toggle']) // Toggle button for specific items
                                                Switch(
                                                  value: items[index]['toggle'],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      items[index]['toggle'] =
                                                          value;
                                                    });
                                                  },
                                                ),
                                              const Icon(Icons.chevron_right),
                                            ],
                                          ),
                                          onTap: () {
                                            _handleMenuItemTap(
                                                context, items[index]['name']);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contact Us",
                                      style: AppStyles.customTextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.mail,
                                          color: AppStyles.cutstomIconColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "gastrack.india@gmail.com",
                                          style: AppStyles.customTextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

  void _handleMenuItemTap(BuildContext context, String itemName) {
    // Handle specific actions based on the tapped menu item
    switch (itemName) {
      case "Edit Profile":
        // Navigate to the Edit Profile screen or perform an action
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfile(),
          ),
        );
        break;
      case "Gas Usage":
        // Navigate to Gas Usage details or perform an action
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CylinderDetailScreen(),
          ),
        );
        break;
      case "Device Sound":
        // Toggle sound settings or perform an action
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Device Sound tapped")));
        break;
      case "Auto Booking":
        // Navigate to auto booking options or perform an action
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Auto Booking tapped")));
        break;
      case "Firmware Update":
        // Trigger firmware update or perform an action
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirmwareUpdate(),
          ),
        );
        break;
      case "Delete Device":
        // Perform delete device action or show a confirmation dialog
        showCustomDialog(context);
        break;
      case "Factory Reset":
        // Trigger factory reset or show a confirmation dialog
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Factory Reset tapped")));
        break;
      default:
        // Handle unknown items
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$itemName tapped")));
        break;
    }
  }
}

// Custom clipper for creating a curved top
class TopRoundedRectangleClipper extends CustomClipper<Path> {
  final double radius;
  final double heightFactor;

  TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});

  @override
  Path getClip(Size size) {
    var clippedHeight = size.height * heightFactor;
    var path = Path();

    path.moveTo(0, clippedHeight);
    path.lineTo(size.width, clippedHeight);
    path.lineTo(size.width, radius);
    path.arcToPoint(
      Offset(size.width - radius, 0),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(radius, 0);
    path.arcToPoint(
      Offset(0, radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(0, clippedHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.cancel,
                      size: 35,
                      color: AppStyles.cutstomIconColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Name
              Center(
                child: Text(
                  'Are you sure you want to Delete device?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'By choosing to delete, the device will be permanently removed and you will lose all data',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Done Button
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.of(context).pop();
                    // await Future.delayed(Duration(seconds: 3));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppStyles.cutstomIconColor, // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Curved edges
                    ),
                    minimumSize: const Size(200, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Adjust button size
                    elevation: 5, // Elevation (shadow)
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// import 'package:flutter/material.dart';
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     final List<Map<String, dynamic>> items = [
//       {
//         "name": "Edit Profile",
//         "image": "assets/images/ListIcons/user.png",
//         "toggle": false
//       },
//       {
//         "name": "Gas Usage",
//         "image": "assets/images/ListIcons/gasusage.png",
//         "toggle": false
//       },
//       {
//         "name": "Device Sound",
//         "image": "assets/images/ListIcons/volume-high.png",
//         "toggle": true
//       },
//       {
//         "name": "Auto Booking",
//         "image": "assets/images/ListIcons/autobooking.png",
//         "toggle": true
//       },
//       {
//         "name": "Firmware Update",
//         "image": "assets/images/ListIcons/firmware.png",
//         "toggle": false
//       },
//       {
//         "name": "Delete Device",
//         "image": "assets/images/ListIcons/deleteDevice.png",
//         "toggle": false
//       },
//       {
//         "name": "Factory Reset",
//         "image": "assets/images/ListIcons/factoryReset.png",
//         "toggle": false
//       },
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Cylinder Details"),
//         backgroundColor: Colors.transparent, // Makes the background transparent
//         elevation: 0, // Removes the shadow below the AppBar
//         centerTitle: true, // Optional: centers the title
//         iconTheme: const IconThemeData(
//             color: Colors.white), // Makes the back arrow white
//         titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
//       ),
//       extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
//       body: Stack(
//         children: [
//           // Gradient with Custom Clip Path at the top of the screen
//           ClipPath(
//             clipper:
//                 TopRoundedRectangleClipper(), // Custom clipper for the top curve
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
//             padding:
//                 EdgeInsets.only(top: height / 9.5), // Adjust for gradient
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
//                           padding: const EdgeInsets.only(top: 10.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(" Kitchen Cylinder",style: TextStyle(fontSize: 20),),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 8,
//                                           height: 8,
//                                           decoration: const BoxDecoration(
//                                             color: Colors.green,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         const Text(
//                                           "Connected",
//                                           style:
//                                               TextStyle(color: Colors.green),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Container(
//                               // color: Colors.cyan,
//                               height: 500,
//                               child: ListView.builder(
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 padding: EdgeInsets.zero,  // This removes extra padding from the ListView
//                                 itemCount: items.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ListTile(
//
//                                       contentPadding: EdgeInsets.zero, // This removes any internal padding within each ListTile
//                                       leading: CircleAvatar(
//                                         child: Image.asset(
//                                           items[index]['image'],
//                                           width: 20,
//                                           color: Colors.white,
//                                           fit: BoxFit.fitWidth,
//                                         ),
//                                         backgroundColor: AppStyles.cutstomIconColor,
//                                         radius: 30, // Adjust radius for avatar size
//                                       ),
//                                       title: Text(items[index]['name']),
//                                       trailing: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           if (items[index]['toggle']) // Toggle button for specific items
//                                             Switch(
//                                               value: items[index]['toggle'],
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   items[index]['toggle'] = value;
//                                                 });
//                                               },
//                                             ),
//                                           const Icon(Icons.chevron_right), // ">" icon on the right
//                                         ],
//                                       ),
//                                       onTap: () {
//                                         // Handle list item tap, if needed
//                                       },
//                                     ),
//                                   );
//
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           const Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.mail,
//                                           color: AppStyles.cutstomIconColor,
//                                         ),
//                                         SizedBox(width: 5,),
//                                         Text("gastrack.india@gmail.com"),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
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
