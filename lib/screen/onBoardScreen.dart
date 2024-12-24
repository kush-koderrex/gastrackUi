
import 'package:flutter/material.dart';
import 'package:gas_track_ui/LocalStorage.dart';
import 'package:gas_track_ui/screen/AddYouDevice.dart';
import 'package:gas_track_ui/screen/Login_Screen.dart';


import 'package:gas_track_ui/utils/app_colors.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {

  final prefs =  SharedPreferences.getInstance();
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
            const SizedBox(height: 40,),
            Column(
              children: [
                Image.asset(
                  "assets/images/OnboardScreen/elipse.png",
                  width: width / 1.3,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 5,),

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      "assets/images/OnboardScreen/elipse2.png",
                      width: width / 1.3,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Positioned(
                    top: 3,
                    left: 80,
                    child: Container(
                      width: 250,
                      child: Row(
                        children: [
                          Container(
                            // color:Colors.red,
                            child: Image.asset(
                              "assets/images/OnboardScreen/gastrackname.png",
                              width: width / 3,
                              height: 20,
                              fit: BoxFit.fill, // Ensures the image fills the container
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
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
                  height: 220,
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
                      // color: const Color(0xFF7A2AAE),
                      color: AppStyles.cutstomIconColor,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                  onTap: ()async
                  // {
                  //   var userToken = await prefs.getString("userToken");
                  //   if(userToken!=null && userToken!=""  ){
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const LoginScreen(),
                  //       ),
                  //     );
                  //   }else{
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const AddYouDeviceScreen(),
                  //       ),
                  //     );
                  //
                  //
                  //   }
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  // },
                      {
                    // final prefs = await SharedPreferences.getInstance();
                    var userToken = await UserPreferences().getUserData();

                    // Access the userId from the returned map
                    print("User ID: ${userToken["userId"]}");


                    if (userToken["userId"] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddYouDeviceScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
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
