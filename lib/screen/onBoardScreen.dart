import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/Login_Screen.dart';
import 'package:gas_track_ui/screen/welcome_screen.dart';
import 'package:gas_track_ui/utils/app_colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/OnboardScreen/onboard.png",
              height: height / 2,
              width: width,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20,),
            Column(
              children: [
                Image.asset(
                  "assets/images/OnboardScreen/elipse.png",
                  width: width / 1.2,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 250,
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/images/OnboardScreen/gastrackname.png",
                          width: width / 2,
                          height: 30,
                          fit: BoxFit.fill, // Ensures the image fills the container
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomCenter, // Aligns children in the center of the stack
                  children: [
                    Image.asset(
                      "assets/images/OnboardScreen/elipse2.png",
                      width: width / 1.2,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20,),
            const Text(
              "Fast Track with GasTrack",
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 25,
                color: Color(0xFFC1B9B9),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            Stack(
              alignment: Alignment.center, // Aligns children in the center of the stack
              children: [
                // Background image
                Image.asset(
                  "assets/images/Splashscreen/building.png",
                  width: width,
                  color: Colors.black,
                  fit: BoxFit.fitWidth,
                ),

                // Centered button
                InkWell(
                  child: Container(
                    width: width / 2,
                    height: height / 12,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.bordergrey, width: 1),
                      shape: BoxShape.circle,
                      color: const Color(0xFF7A2AAE),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
