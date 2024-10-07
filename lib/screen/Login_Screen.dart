


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/screen/OtpScreen.dart';
import 'package:gas_track_ui/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String phoneNumber = ;
  String verificationId = "";
  String otpCode = "";
  bool otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> sendOtp() async {

    String phoneNumber = "+91" + _phoneController.text.trim();
    if (_validatePhoneNumber(phoneNumber) != null) {
      // Return if the phone number is invalid
      return;
    }

    print(phoneNumber);
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically verifies and signs in the user
        await _auth.signInWithCredential(credential);
        // Navigate to the next screen (if necessary) after successful verification
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
        });
        print(verificationId);
        Fluttertoast.showToast(
          msg: "OTP sent successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change this to TOP, CENTER, etc.
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.white, // Text color of the toast
          fontSize: 16.0, // Font size of the toast
        );
        // Navigate to the OTP screen after the OTP is sent
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otpscreen(verificationId: verificationId), // Pass verificationId if needed
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() {
          verificationId = verId;
        });
      },
    );
  }

  // Function to validate phone number
  String? _validatePhoneNumber(String? value) {
    // Regular expression to validate phone number
    final phoneRegExp = RegExp(r'^\+91\d{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number (+91XXXXXXXXXX)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    return Scaffold(
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
                            children: <Widget>[
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Image.asset(
                                    width: 60,
                                    height: 110,
                                    "assets/images/LoginScreen/logincylinder.png",
                                    fit: BoxFit
                                        .fill, // Ensures the image fills the container
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(
                                        'Welcome to ',
                                        style: AppStyles.customTextStyle(
                                            fontSize: 25.0,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                      ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                          colors: <Color>[
                                            Color(0xFFC54239),
                                            Color(0xFF7A2AAE),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: const Text(
                                          'GAS TRACK',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors
                                                .white, // This color will be overridden by the gradient
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Login or Create a New Account',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Cerapro',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                // color: Colors.cyan,
                                width: 350,
                                height: 80,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .grey.shade200, // Grey inside color
                                    hintText: 'Enter Mobile Number',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Cerapro',
                                        fontWeight: FontWeight.w400),
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, left: 10),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(width: 8),
                                          Text(
                                            '+91',
                                            style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Cerapro',
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide:
                                          BorderSide.none, // Transparent border
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide:
                                          BorderSide.none, // Transparent border
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide:
                                          BorderSide.none, // Transparent border
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 12),
                                  ),
                                  validator: _validatePhoneNumber,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 350,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // if (Form.of(context)?.validate() ?? false) {
                                    sendOtp();

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Otpscreen(verificationId: null,),
                                    //   ),
                                    // );
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.cutstomIconColor, // Button background color
                                    foregroundColor:
                                        Colors.white, // Button text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Curved edges
                                    ),
                                    minimumSize: const Size(200, 50),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15), // Adjust button size
                                    elevation: 5, // Elevation (shadow)
                                  ),
                                  child: const Text(
                                    'Send OTP',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Cerapro',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
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
                                    padding: const EdgeInsets.only(
                                        right: 50, top: 5.0, left: 50.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Divider(
                                                    thickness: 1,
                                                    color: Colors.grey[300])),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                'Or Continue with',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontFamily: 'Cerapro',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            Expanded(
                                                child: Divider(
                                                    thickness: 1,
                                                    color: Colors.grey[300])),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                                child: Container(
                                                  width: height * 0.060,
                                                  height: height * 0.060,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      radius: 72.0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/LoginScreen/Facebook.png'),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             const WelcomeScreen()));
                                                }),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            InkWell(
                                                child: Container(
                                                  width: height * 0.060,
                                                  height: height * 0.060,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[100],
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      radius: 72.0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/LoginScreen/Google.png'),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                               Otpscreen(verificationId: "",)));
                                                }),
                                          ],
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
