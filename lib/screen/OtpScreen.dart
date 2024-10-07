import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/screen/AddYouDevice.dart';
import 'package:gas_track_ui/screen/Login_Screen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'package:pinput/pinput.dart';

class Otpscreen extends StatefulWidget {
  // Otpscreen({super.key, required verificationId});
  final String verificationId;

  const Otpscreen({Key? key, required this.verificationId}) : super(key: key);

  // String? verificationId;

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> verifyOtp() async {
    try {
      print(widget.verificationId);
      // Ensure the verificationId is not null
      if (widget.verificationId == null || widget.verificationId!.isEmpty) {
        Fluttertoast.showToast(msg: "Verification ID is missing.");
        return;
      }

      // Create a PhoneAuthCredential using the verificationId and OTP entered by the user
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!,
        smsCode: _otpController.text.trim(), // Use the OTP from the controller, trim whitespace
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);

      // Navigate to AddYourDeviceScreen on successful verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AddYouDeviceScreen(),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print("widget.verificationId");
    print(widget.verificationId);

    return Scaffold(
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
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      width: 150,
                                      height: 180,
                                      "assets/images/OtpScreen/otpScreen.png",
                                      fit: BoxFit
                                          .fill, // Ensures the image fills the container
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Enter Verification Code',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cerapro',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                            'We have sent the Verification',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Cerapro',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        const Text(' Code to +91 ******8945',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Cerapro',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: width / 1.5,
                                  height: 58,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Pinput(
                                          length: 6,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          controller: _otpController,
                                          onCompleted: (value) {
                                            verifyOtp();
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const AddYouDeviceScreen(),
                                            //   ),
                                            // );
                                          },
                                          validator: (value) {
                                            if (value != null &&
                                                value.length != 6) {
                                              return 'OTP should be of 6 digits.';
                                            } else {}
                                            return null;
                                          },
                                          defaultPinTheme: PinTheme(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppStyles
                                                      .cutstomIconColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 17,
                                              height: 16 / 17,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // if (Form.of(context)?.validate() ?? false) {
                                                  verifyOtp();
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         const AddYouDeviceScreen(),
                                                //   ),
                                                // );
                                                // }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppStyles
                                                    .cutstomIconColor, // Button background color
                                                foregroundColor: Colors
                                                    .white, // Button text color
                                                shape: RoundedRectangleBorder(
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
                                              child: const Text(
                                                'Verify & Continue',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Cerapro',
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 40),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Wrap(
                                              children: [
                                                const Text(
                                                    "Didn’t Receive the code? ",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Cerapro',
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                InkWell(
                                                    onTap: () {},
                                                    child: InkWell(
                                                        onTap: () async {},
                                                        child: const Text(
                                                          "Resend",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Cerapro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppStyles
                                                                  .cutstomIconColor,

                                                              // decoration: TextDecoration.underline,
                                                              decorationColor:
                                                                  Colors.red),
                                                        ))),
                                              ],
                                            ),
                                          ),
                                        ],
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
  TopRoundedRectangleClipper({this.radius = 0.0, this.heightFactor = 0.60});

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
