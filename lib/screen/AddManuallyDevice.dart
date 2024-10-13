import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/screen/FillOtherInformation.dart';
import 'package:gas_track_ui/utils/extra.dart';
import 'package:gas_track_ui/utils/snackbar.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'dart:developer' as developer;

class AddManuallyDeviceScreen extends StatefulWidget {
  const AddManuallyDeviceScreen({super.key});

  @override
  State<AddManuallyDeviceScreen> createState() =>
      _AddManuallyDeviceScreenState();
}

class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _systemDevices = [];
  // List<Item> items = []; // Changed to List<Item>
  bool _isBluetoothEnabled = false; // Bluetooth state variable

  // Method to check Bluetooth state
  Future<void> checkBluetoothState() async {
    BluetoothAdapterState state = await FlutterBluePlus.adapterState.first; // Get the current Bluetooth state

    if (state == BluetoothAdapterState.on) {
      setState(() {
        _isBluetoothEnabled = true; // Update the state if Bluetooth is enabled
      });
      onScanPressed(); // Start scanning for devices if Bluetooth is on
    } else {
      // Show a message or navigate if Bluetooth is off
      Fluttertoast.showToast(msg: "Please enable Bluetooth to add devices.");
      // Optionally navigate back or show a different screen
      Navigator.pop(context);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().then((_) {
      showCustomDialog(context);
      // If the connection was successful, print "Connected"
      print("Connected");
      Fluttertoast.showToast(msg: "Device Connected");
    }).catchError((e) {
      // If an error occurred during connection, print "Not connected"
      print("Not connected");
      Fluttertoast.showToast(msg: "Device Not connected");
      Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
    });
  }

  // This function updates the items list with device information from scan results
  // void updateItemsFromScanResults(List<ScanResult> scanResults) {
  //   items.clear(); // Clear the previous items
  //
  //   // Populate the items list with the names and distances from the scan results
  //   for (var result in scanResults) {
  //     var deviceInfo = Item(
  //       name: result.device.name.isNotEmpty ? result.device.name : "Unnamed Device", // Fallback for empty names
  //       distance: result.rssi.toDouble(), // Use RSSI as an example for distance
  //     );
  //
  //     items.add(deviceInfo); // Add the device info to the items list
  //   }
  // }

  // Example usage
  // void onScanResultsUpdated(List<ScanResult> scanResults) {
  //   updateItemsFromScanResults(scanResults);
  //   printDeviceList();
  // }
  //
  // void printDeviceList() {
  //   for (var item in items) {
  //     print('Device Name: ${item.name}, Distance: ${item.distance} meters');
  //   }
  // }

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  void initState() {
    super.initState();
    checkBluetoothState();
    onScanPressed();


    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      // Filter results based on platformName being "BLE Device"
      _scanResults = results.where((result) {
        return result.device.platformName == "BLE Device"; // Case-sensitive match
      }).toList();

      // if (mounted) {
      //   setState(() {
      //     updateItemsFromScanResults(_scanResults); // Call update method here
      //   });
      // }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });
    //
    // _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
    //   _scanResults = results;
    //
    //   if (mounted) {
    //     setState(() {
    //       updateItemsFromScanResults(_scanResults); // Call update method here
    //     });
    //   }
    // }, onError: (e) {
    //   Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    // });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  // void onConnectPressed(BluetoothDevice device) {
  //   device.connectAndUpdateStream().catchError((e) {
  //     Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
  //   });
  // }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e), success: false);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e), success: false);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void connectDevice(BluetoothDevice device) {
    device.connect().then((_) {
      // Connection successful
      Snackbar.show(ABC.c, "Connected to ${device.remoteId}", success: true);
    }).catchError((e) {
      // Connection failed, retry after delay
      Snackbar.show(ABC.c, "Connect Error: ${prettyException("Error:", e)}", success: false);
      Future.delayed(Duration(seconds: 5), () {
        connectDevice(device); // Retry connection
      });
    });
  }



  // void onConnectPressed(BluetoothDevice device) {
  //   // Try to connect to the device
  //   device.connect().then((_) {
  //     print("<-------------Connected --------------->");
  //     // Connection successful, show success toast
  //     Snackbar.show(ABC.c, "Connected to ${device.remoteId}", success: true);
  //   }).catchError((e) {
  //     print("<------------- Not Connected --------------->");
  //     // Connection failed, show error toast
  //     Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    developer.log("_scanResults ---->${_scanResults.toString()}");
    // developer.log("items ---->${items}");
    // developer.log("items ---->${items[2].name}");

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Container dimensions
    var containerHeight = height / 2;
    var containerWidth = width;

    // Center of the container
    var centerX = containerWidth / 2;
    var centerY = containerHeight / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adding Manually",
          style: AppStyles.appBarTextStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ClipPath(
            clipper: TopRoundedRectangleClipper(),
            child: Container(
              height: height * 0.30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFA7365), Color(0xFF9A4DFF)],
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: height / 2,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              buildRadarCircle(250 * _animation.value,
                                                  Colors.purple.withOpacity(0.1)),
                                              buildRadarCircle(200 * _animation.value,
                                                  Colors.purple.withOpacity(0.2)),
                                              buildRadarCircle(150 * _animation.value,
                                                  Colors.purple.withOpacity(0.3)),
                                              buildRadarCircle(100 * _animation.value,
                                                  Colors.purple.withOpacity(0.4)),
                                              buildRadarCircle(50 * _animation.value,
                                                  Colors.purple.withOpacity(0.5)),
                                              buildRadarCircle(25 * _animation.value,
                                                  Colors.purple.withOpacity(0.6)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // If items are available, show their avatars

                                    FutureBuilder(
                                      future: Future.delayed(Duration(seconds: 3)),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        // Check the connection state of the Future
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          // Optionally, show a loading indicator while waiting
                                          return Center(child: CircularProgressIndicator());
                                        } else {
                                          return Stack( // Use a Stack to allow Positioned widgets
                                            children: [
                                              if (_scanResults.isNotEmpty)
                                                Positioned(
                                                  left: centerX + 80,
                                                  bottom: centerY,
                                                  child: InkWell(

                                                    onTap: () async {
                                                      try {
                                                        await _scanResults[0].device.connect();
                                                        await _scanResults[0].device.createBond(); // If this completes without exception, assume success
                                                        Fluttertoast.showToast(
                                                          msg: 'Device bonded successfully!',
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.green,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                                () {
                                                                  showCustomDialog(context);
                                                            });


                                                      } catch (e) {
                                                        Fluttertoast.showToast(
                                                          msg: 'Failed to bond the device: ${e.toString()}',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      }
                                                      // showCustomDialog(context);
                                                    },
                                                    // onTap: () {
                                                    //
                                                    //   print(_scanResults[0].device);
                                                    //   // connectDevice(_scanResults[0].device);
                                                    //   // showCustomDialog(context);
                                                    //   onConnectPressed(_scanResults[0].device);
                                                    // },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor: Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[0].device.platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily: 'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (_scanResults.length > 1)
                                                Positioned(
                                                  right: centerX,
                                                  bottom: centerY + 90,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      try {
                                                        await _scanResults[1].device.connect();
                                                        await _scanResults[1].device.createBond(); // If this completes without exception, assume success
                                                        Fluttertoast.showToast(
                                                          msg: 'Device bonded successfully!',
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.green,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      } catch (e) {
                                                        Fluttertoast.showToast(
                                                          msg: 'Failed to bond the device: ${e.toString()}',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      }
                                                      showCustomDialog(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor: Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[1].device.platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily: 'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (_scanResults.length > 2)
                                                Positioned(
                                                  right: centerX + 20,
                                                  bottom: centerY,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showCustomDialog(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor: Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[2].device.platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily: 'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        }
                                      },
                                    ),






                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: Future.delayed(Duration(seconds: 3)),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: Text(
                                        "Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device",
                                        textAlign: TextAlign.center,
                                        style: AppStyles.customTextStyle(
                                          fontSize: 14,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                  return
                                    Container(
                                      child: Center(
                                        child: Text(
                                          "Device found. Please tap to add the device",
                                          textAlign: TextAlign.center,
                                          style: AppStyles.customTextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                          ), // Style for the text
                                        ),
                                      ),
                                    );
                                  //   ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: const Color(0xFFFA7365),
                                  //     shape: const StadiumBorder(),
                                  //   ),
                                  //   onPressed: () {
                                  //     onScanPressed();
                                  //   },
                                  //   child: const Text(
                                  //     "Scan Again",
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // );
                                },
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

  Widget buildRadarCircle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
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
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Image.asset(
                "assets/images/AddyourdeviceScreen/poupimage.png",
                fit: BoxFit.fitWidth,
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              // Name
              Center(
                child: Text(
                  'Device Selected',
                  style: AppStyles.customTextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Text(
                  'Successfully',
                  style: AppStyles.customTextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FullOtherInformation()));
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
                  child: Text(
                    'Done',
                    style: AppStyles.customTextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500),
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
}

class Item {
  final String name;
  final double distance;

  Item({required this.name, required this.distance});
}








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
//
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:gas_track_ui/utils/utils.dart';
// //
// // class AddManuallyDeviceScreen extends StatefulWidget {
// //   const AddManuallyDeviceScreen({super.key});
// //
// //   @override
// //   State<AddManuallyDeviceScreen> createState() => _AddManuallyDeviceScreenState();
// // }
// //
// // class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       duration: const Duration(seconds: 3),
// //       vsync: this,
// //     )..repeat(); // Repeat indefinitely to simulate the radar sweep
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     var height = MediaQuery.of(context).size.height;
// //     var width = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Adding Manually",style: AppStyles.appBarTextStyle,),
// //         backgroundColor: Colors.transparent, // Makes the background transparent
// //         elevation: 0, // Removes the shadow below the AppBar
// //         centerTitle: true, // Optional: centers the title
// //         iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
// //         titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
// //       ),
// //       extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
// //       body: Stack(
// //         children: [
// //           // Gradient with Custom Clip Path at the top of the screen
// //           ClipPath(
// //             clipper: TopRoundedRectangleClipper(), // Custom clipper for the top curve
// //             child: Container(
// //               height: height * 0.30, // Adjust height of the effect
// //               decoration: const BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [Color(0xFFFA7365), Color(0xFF9A4DFF)], // Gradient colors
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.only(top: height / 9.5), // Adjust for gradient
// //             child: Container(
// //               height: height,
// //               width: width,
// //               decoration: BoxDecoration(
// //                 color: Colors.white54.withOpacity(0.30),
// //                 borderRadius: BorderRadius.circular(45.0),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.9),
// //                     borderRadius: BorderRadius.circular(45.0),
// //                   ),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: <Widget>[
// //                       Center(
// //                         child: Stack(
// //                           alignment: Alignment.center,
// //                           children: [
// //                             // Radar Circles
// //                             buildRadarCircle(250, Colors.purple.withOpacity(0.1)),
// //                             buildRadarCircle(200, Colors.purple.withOpacity(0.2)),
// //                             buildRadarCircle(150, Colors.purple.withOpacity(0.3)),
// //                             buildRadarCircle(100, Colors.purple.withOpacity(0.4)),
// //
// //                             // Radar Beam
// //                             // AnimatedBuilder(
// //                             //   animation: _controller,
// //                             //   builder: (context, child) {
// //                             //     return Transform.rotate(
// //                             //       angle: _controller.value * 2 * pi,
// //                             //       child: CustomPaint(
// //                             //         painter: RadarBeamPainter(),
// //                             //         child: Container(),
// //                             //       ),
// //                             //     );
// //                             //   },
// //                             // ),
// //
// //                             // Mock Devices (Positioned randomly around the radar)
// //                             // Positioned(
// //                             //   top: 100,
// //                             //   left: 120,
// //                             //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
// //                             // ),
// //                             // Positioned(
// //                             //   bottom: 90,
// //                             //   right: 80,
// //                             //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
// //                             // ),
// //                             // Positioned(
// //                             //   bottom: 150,
// //                             //   left: 140,
// //                             //   child: Icon(Icons.bluetooth, color: Colors.blue, size: 30),
// //                             // ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(height: 20,),
// //                       Align(alignment:Alignment.center,child: Center(child: Text("Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device"))),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget buildRadarCircle(double radius, Color color) {
// //     return Container(
// //       width: radius,
// //       height: radius,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: color,
// //       ),
// //     );
// //   }
// // }
// //
// // // Custom clipper for creating a curved top
// // class TopRoundedRectangleClipper extends CustomClipper<Path> {
// //   final double radius; // Controls the corner radius
// //   final double heightFactor; // Controls the height to clip
// //
// //   // Default radius is 30, and heightFactor is 0.25 (i.e., 25% of the container height)
// //   TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});
// //
// //   @override
// //   Path getClip(Size size) {
// //     var clippedHeight = size.height * heightFactor; // Calculate clipped height based on the heightFactor
// //     var path = Path();
// //
// //     // Start from bottom-left corner
// //     path.moveTo(0, clippedHeight);
// //
// //     // Bottom line to the right
// //     path.lineTo(size.width, clippedHeight);
// //
// //     // Line to the top-right corner but we will start curving for the top corners
// //     path.lineTo(size.width, radius);
// //
// //     // Create a rounded corner on the top-right
// //     path.arcToPoint(
// //       Offset(size.width - radius, 0),
// //       radius: Radius.circular(radius),
// //       clockwise: false,
// //     );
// //
// //     // Line to the top-left with rounded corner
// //     path.lineTo(radius, 0);
// //     path.arcToPoint(
// //       Offset(0, radius),
// //       radius: Radius.circular(radius),
// //       clockwise: false,
// //     );
// //
// //     // Close the path back to the bottom-left corner
// //     path.lineTo(0, clippedHeight);
// //     path.close(); // Close the path to form the shape
// //
// //     return path;
// //   }
// //
// //   @override
// //   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// // }
// //
// // class RadarBeamPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final Paint paint = Paint()
// //       ..shader = RadialGradient(
// //         colors: [
// //           Colors.purple.withOpacity(0.7),
// //           Colors.transparent,
// //         ],
// //       ).createShader(Rect.fromCircle(center: Offset.zero, radius: 200));
// //
// //     canvas.drawArc(
// //       Rect.fromCircle(center: Offset.zero, radius: 200),
// //       -pi / 2,
// //       pi / 6, // Radar beam width
// //       true,
// //       paint,
// //     );
// //   }
// //
// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return true; // Always repaint the radar beam
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:gas_track_ui/screen/HomeScreen.dart';
// // //
// // //
// // //
// // // class AddManuallyDeviceScreen extends StatefulWidget {
// // //   const AddManuallyDeviceScreen({super.key});
// // //
// // //   @override
// // //   State<AddManuallyDeviceScreen> createState() => _AddManuallyDeviceScreenState();
// // // }
// // //
// // // class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     var height = MediaQuery.of(context).size.height;
// // //     var width = MediaQuery.of(context).size.width;
// // //     int activeStep = 2;
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Adding Manually"),
// // //         backgroundColor: Colors.transparent, // Makes the background transparent
// // //         elevation: 0, // Removes the shadow below the AppBar
// // //         centerTitle: true, // Optional: centers the title
// // //         iconTheme:
// // //         const IconThemeData(color: Colors.white), // Makes the back arrow white
// // //         titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
// // //       ),
// // //       extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
// // //       body: Stack(
// // //         children: [
// // //           // Gradient with Custom Clip Path at the top of the screen
// // //           ClipPath(
// // //             clipper:
// // //             TopRoundedRectangleClipper(), // Custom clipper for the top curve
// // //             child: Container(
// // //               height: height * 0.30, // Adjust height of the effect
// // //               decoration: const BoxDecoration(
// // //                 gradient: LinearGradient(
// // //                   colors: [
// // //                     Color(0xFFFA7365),
// // //                     Color(0xFF9A4DFF)
// // //                   ], // Gradient colors
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //
// // //           Padding(
// // //             padding: EdgeInsets.only(top: height / 9.5), // Adjust for gradient
// // //             child: Container(
// // //               height: height,
// // //               width: width,
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white54.withOpacity(0.30),
// // //                 borderRadius: BorderRadius.circular(45.0),
// // //               ),
// // //               child: Padding(
// // //                 padding: const EdgeInsets.only(top: 8.0),
// // //                 child: Container(
// // //                   width: width,
// // //                   height: height,
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.white54.withOpacity(0.20),
// // //                     borderRadius: BorderRadius.circular(45.0),
// // //                   ),
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.only(top: 10.0),
// // //                     child: Container(
// // //                       width: width,
// // //                       height: height,
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(45.0),
// // //                       ),
// // //                       child: Padding(
// // //                           padding: const EdgeInsets.only(top: 5.0),
// // //                           child: Column(
// // //                             children: <Widget>[
// // //
// // //
// // //
// // //
// // //                             ],
// // //                           )),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // Custom clipper for creating a curved top
// // // class TopRoundedRectangleClipper extends CustomClipper<Path> {
// // //   final double radius; // Controls the corner radius
// // //   final double heightFactor; // Controls the height to clip
// // //
// // //   // Default radius is 30, and heightFactor is 0.25 (i.e., 25% of the container height)
// // //   TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});
// // //
// // //   @override
// // //   Path getClip(Size size) {
// // //     var clippedHeight = size.height *
// // //         heightFactor; // Calculate clipped height based on the heightFactor
// // //     var path = Path();
// // //
// // //     // Start from bottom-left corner
// // //     path.moveTo(0, clippedHeight);
// // //
// // //     // Bottom line to the right
// // //     path.lineTo(size.width, clippedHeight);
// // //
// // //     // Line to the top-right corner but we will start curving for the top corners
// // //     path.lineTo(size.width, radius);
// // //
// // //     // Create a rounded corner on the top-right
// // //     path.arcToPoint(
// // //       Offset(size.width - radius, 0),
// // //       radius: Radius.circular(radius),
// // //       clockwise: false,
// // //     );
// // //
// // //     // Line to the top-left with rounded corner
// // //     path.lineTo(radius, 0);
// // //     path.arcToPoint(
// // //       Offset(0, radius),
// // //       radius: Radius.circular(radius),
// // //       clockwise: false,
// // //     );
// // //
// // //     // Close the path back to the bottom-left corner
// // //     path.lineTo(0, clippedHeight);
// // //     path.close(); // Close the path to form the shape
// // //
// // //     return path;
// // //   }
// // //
// // //   @override
// // //   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// // // }
