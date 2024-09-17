import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/welcome_screen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
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
                    "assets/images/LoginScreen/logincylinder.png",
                    fit: BoxFit.fill, // Ensures the image fills the container
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
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
                  const Text('Login or Create a New Account'),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350,
                height: 100,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Grey inside color
                    hintText: 'Enter phone number',
                    prefixIcon: Container(
                      padding: const EdgeInsets.only(right: 10.0,left: 10),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   'assets/india_flag.png', // Add the flag image
                          //   width: 24,
                          // ),
                          SizedBox(width: 8),
                          Text(
                            '+91',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none, // Transparent border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none, // Transparent border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none, // Transparent border
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                    // Your onPressed function here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.purple, // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12), // Curved edges
                    ),
                    minimumSize: const Size(200, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Adjust button size
                    elevation: 5, // Elevation (shadow)
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              Stack(
                alignment: Alignment
                    .center, // Aligns children in the center of the stack
                children: [
                  // Background image
                  Image.asset(
                    "assets/images/Splashscreen/building.png",
                    width: width,
                    color: Colors.black,
                    fit: BoxFit.fitWidth,
                  ),



                  // Centered button

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
