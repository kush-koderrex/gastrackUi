import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/AddYouDevice.dart';
import 'package:gas_track_ui/screen/FillOtherInformation.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    controller?.pauseCamera(); // Optional: Pause the camera before disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Device",style: AppStyles.appBarTextStyle,),
        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
            IconThemeData(color: Colors.white), // Makes the back arrow white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
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
          // Padding(
          //   padding: EdgeInsets.only(top: height / 8), // Adjust for gradient
          //   child: Container(
          //     height: height,
          //     width: width,
          //     decoration: BoxDecoration(
          //       color: Colors.white70.withOpacity(0.30),
          //       borderRadius: BorderRadius.circular(45.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 8.0),
          //       child: Container(
          //         width: width,
          //         height: height,
          //         decoration: BoxDecoration(
          //           color: Colors.white60,
          //           borderRadius: BorderRadius.circular(45.0),
          //         ),
          //         child: Container(
          //           width: width,
          //           height: height,
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(45.0),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.only(top: 10.0),
          //             child: Stack(
          //               children: [
          //                 Column(
          //                   children: <Widget>[
          //                     Expanded(
          //                       flex: 1,
          //                       child: QRView(
          //                         key: qrKey,
          //                         onQRViewCreated: _onQRViewCreated,
          //                       ),
          //                     ),
          //                     // Expanded(
          //                     //   flex: 1,
          //                     //   child: Center(
          //                     //     child: Text(
          //                     //       qrCodeResult != null
          //                     //           ? 'Scan Result: $qrCodeResult'
          //                     //           : 'Scan a QR code',
          //                     //     ),
          //                     //   ),
          //                     // )
          //                   ],
          //                 ),
          //                 // Overlay square
          //                 Center(
          //                   child: Container(
          //                     width: 250,  // Width of the square frame
          //                     height: 250, // Height of the square frame
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(20),
          //                       border: Border.all(color: Colors.white54, width: 4), // Border color and width
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.only(top: height / 8), // Adjust for gradient
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white70.withOpacity(0.30),
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        ),
                        // Expanded(
                        //   flex: 1,
                        //   child: Center(
                        //     child: Text(
                        //       qrCodeResult != null
                        //           ? 'Scan Result: $qrCodeResult'
                        //           : 'Scan a QR code',
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    // Overlay square
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 250, // Width of the square frame
                            height: 250, // Height of the square frame
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white54,
                                  width: 4), // Border color and width
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {

                                controller?.pauseCamera();
                                controller?.dispose();
                                showCustomDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppStyles.cutstomIconColor, // Button background color
                                foregroundColor:
                                    Colors.white, // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // Curved edges
                                ),
                                minimumSize: const Size(200, 50),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15), // Adjust button size
                                elevation: 5, // Elevation (shadow)
                              ),
                              child: const Text(
                                'Scan & Continue',
                                style: TextStyle(
                                    fontFamily: 'Cerapro',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  style: AppStyles.customTextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Text(
                  'Successfully',
                  style: AppStyles.customTextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
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
                    backgroundColor: AppStyles.cutstomIconColor, // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Curved edges
                    ),
                    minimumSize: const Size(200, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Adjust button size
                    elevation: 5, // Elevation (shadow)
                  ),
                  child:  Text(
                    'Done',
                    style: AppStyles.customTextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
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
