import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/DeviceAdded.dart';
import 'package:gas_track_ui/screen/OtpScreen.dart';
import 'package:gas_track_ui/utils/utils.dart';


class FullOtherInformation extends StatefulWidget {
  const FullOtherInformation({super.key});

  @override
  State<FullOtherInformation> createState() => _FullOtherInformationState();
}

class _FullOtherInformationState extends State<FullOtherInformation> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final _deviceNameController = TextEditingController();
    final _gasCompanyNameController = TextEditingController();
    final _gasConsumerNumberController = TextEditingController();
    int activeStep = 1;

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Setup",style: AppStyles.appBarTextStyle,),

        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
        IconThemeData(color: Colors.white), // Makes the back arrow white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
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
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    EasyStepper(
                                      activeStepIconColor: Colors.white,
                                      activeStepBackgroundColor: AppStyles.cutstomIconColor,
                                      activeStep: activeStep,
                                      lineStyle: const LineStyle(
                                        lineLength: 80,
                                        lineThickness: 1,
                                        lineSpace: 5,
                                      ),
                                      stepRadius: 15,
                                      unreachedStepIconColor: Colors.white,
                                      unreachedStepBorderColor: Colors.grey,
                                      unreachedStepTextColor: Colors.grey,
                                      showLoadingAnimation: true,
                                      steps: const [
                                        EasyStep(
                                          topTitle: true,
                                          icon: Icon(Icons.check),
                                          title: 'Step 1',
                                        ),
                                        EasyStep(
                                          topTitle: true,
                                          icon: Icon(Icons.check),
                                          title: 'Step 2',
                                        ),
                                        EasyStep(
                                          topTitle: true,
                                          icon: Icon(Icons.close),
                                          title: 'Step 3',
                                        ),
                                      ],
                                      onStepReached: (index) =>
                                          setState(() => activeStep = index),
                                    ),
                                    Text(
                                      'Additional Information',
                                      style: AppStyles.customTextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        'Please enter the required details',style:AppStyles.customTextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
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
                                  height: 60,
                                  child: TextFormField(
                                    controller: _deviceNameController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors
                                          .grey.shade200, // Grey inside color
                                      hintText: 'Device Name',
                                      hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 10),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 8),

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
                                Container(
                                  // color: Colors.cyan,
                                  width: 350,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _gasCompanyNameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors
                                          .grey.shade200, // Grey inside color
                                      hintText: 'Gas Company Name',
                                      hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 10),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 8),
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
                                Container(
                                  // color: Colors.cyan,
                                  width: 350,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _gasConsumerNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors
                                          .grey.shade200, // Grey inside color
                                      hintText: 'Gas Consumer Number',
                                      hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 10),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 8),

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

                                Stack(
                                  alignment: Alignment
                                      .topCenter, // Aligns children in the center of the stack
                                  children: [
                                    Image.asset(
                                      "assets/images/Splashscreen/building.png",
                                      width: width,
                                      height: height/3.5,
                                      color: Colors.grey,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: SizedBox(
                                        width: 350,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // if (Form.of(context)?.validate() ?? false) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DeviceaddedScreen(),
                                              ),
                                            );
                                            // }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:AppStyles.cutstomIconColor, // Button background color
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
                                          child:  Text(
                                            'Save & Continue',
                                            style: AppStyles.customTextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                                          ),
                                        ),
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


// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:gas_track_ui/screen/DeviceAdded.dart';
// import 'package:gas_track_ui/screen/OtpScreen.dart';
// import 'package:gas_track_ui/utils/utils.dart';
//
//
// class FullOtherInformation extends StatefulWidget {
//   const FullOtherInformation({super.key});
//
//   @override
//   State<FullOtherInformation> createState() => _FullOtherInformationState();
// }
//
// class _FullOtherInformationState extends State<FullOtherInformation> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     final _phoneController = TextEditingController();
//     int activeStep = 1;
//
//     String? _validatePhoneNumber(String? value) {
//       // Regular expression to validate phone number
//       final phoneRegExp = RegExp(r'^\+91\d{10}$');
//       if (value == null || value.isEmpty) {
//         return 'Please enter a phone number';
//       }
//       if (!phoneRegExp.hasMatch(value)) {
//         return 'Please enter a valid phone number (+91XXXXXXXXXX)';
//       }
//       return null;
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Complete Setup",style: AppStyles.appBarTextStyle,),
//
//         backgroundColor: Colors.transparent, // Makes the background transparent
//         elevation: 0, // Removes the shadow below the AppBar
//         centerTitle: true, // Optional: centers the title
//         iconTheme:
//         IconThemeData(color: Colors.white), // Makes the back arrow white
//         titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
//       ),
//       extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             // Gradient with Custom Clip Path at the top of the screen
//             ClipPath(
//               clipper:
//                   TopRoundedRectangleClipper(), // Custom clipper for the top curve
//               child: Container(
//                 height: height * 0.30, // Adjust height of the effect
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color(0xFFFA7365),
//                       Color(0xFF9A4DFF)
//                     ], // Gradient colors
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: EdgeInsets.only(top: height / 9.5), // Adjust for gradient
//               child: Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors.white54.withOpacity(0.30),
//                   borderRadius: BorderRadius.circular(45.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Container(
//                     width: width,
//                     height: height,
//                     decoration: BoxDecoration(
//                       color: Colors.white54.withOpacity(0.20),
//                       borderRadius: BorderRadius.circular(45.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Container(
//                         width: width,
//                         height: height,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(45.0),
//                         ),
//                         child: Padding(
//                             padding: const EdgeInsets.only(top: 5.0),
//                             child: Column(
//                               children: <Widget>[
//                                 Column(
//                                   children: [
//                                     EasyStepper(
//                                       activeStepIconColor: Colors.white,
//                                       activeStepBackgroundColor: AppStyles.cutstomIconColor,
//                                       activeStep: activeStep,
//                                       lineStyle: const LineStyle(
//                                         lineLength: 80,
//                                         lineThickness: 1,
//                                         lineSpace: 5,
//                                       ),
//                                       stepRadius: 15,
//                                       unreachedStepIconColor: Colors.white,
//                                       unreachedStepBorderColor: Colors.grey,
//                                       unreachedStepTextColor: Colors.grey,
//                                       showLoadingAnimation: true,
//                                       steps: const [
//                                         EasyStep(
//                                           topTitle: true,
//                                           icon: Icon(Icons.check),
//                                           title: 'Step 1',
//                                         ),
//                                         EasyStep(
//                                           topTitle: true,
//                                           icon: Icon(Icons.check),
//                                           title: 'Step 2',
//                                         ),
//                                         EasyStep(
//                                           topTitle: true,
//                                           icon: Icon(Icons.close),
//                                           title: 'Step 3',
//                                         ),
//                                       ],
//                                       onStepReached: (index) =>
//                                           setState(() => activeStep = index),
//                                     ),
//                                      Text(
//                                       'Additional Information',
//                                       style: AppStyles.customTextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                      Text(
//                                         'Please enter the required details',style:AppStyles.customTextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   // color: Colors.cyan,
//                                   width: 350,
//                                   height: 60,
//                                   child: TextFormField(
//                                     controller: _phoneController,
//                                     keyboardType: TextInputType.phone,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors
//                                           .grey.shade200, // Grey inside color
//                                       hintText: 'Device Name',
//                                       hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
//                                       prefixIcon: Container(
//                                         padding: const EdgeInsets.only(
//                                             right: 10.0, left: 10),
//                                         child: const Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             SizedBox(width: 8),
//
//                                           ],
//                                         ),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                           vertical: 16, horizontal: 12),
//                                     ),
//                                     validator: _validatePhoneNumber,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Container(
//                                   // color: Colors.cyan,
//                                   width: 350,
//                                   height: 60,
//                                   child: TextFormField(
//                                     controller: _phoneController,
//                                     keyboardType: TextInputType.phone,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors
//                                           .grey.shade200, // Grey inside color
//                                       hintText: 'Gas Company Name',
//                                       hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
//                                       prefixIcon: Container(
//                                         padding: const EdgeInsets.only(
//                                             right: 10.0, left: 10),
//                                         child: const Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             SizedBox(width: 8),
//                                           ],
//                                         ),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                           vertical: 16, horizontal: 12),
//                                     ),
//                                     validator: _validatePhoneNumber,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Container(
//                                   // color: Colors.cyan,
//                                   width: 350,
//                                   height: 60,
//                                   child: TextFormField(
//                                     controller: _phoneController,
//                                     keyboardType: TextInputType.phone,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors
//                                           .grey.shade200, // Grey inside color
//                                       hintText: 'Gas Consumer Number',
//                                       hintStyle: AppStyles.customTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
//                                       prefixIcon: Container(
//                                         padding: const EdgeInsets.only(
//                                             right: 10.0, left: 10),
//                                         child: const Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             SizedBox(width: 8),
//
//                                           ],
//                                         ),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8.0),
//                                         borderSide:
//                                             BorderSide.none, // Transparent border
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                           vertical: 16, horizontal: 12),
//                                     ),
//                                     validator: _validatePhoneNumber,
//                                   ),
//                                 ),
//
//                                 Stack(
//                                   alignment: Alignment
//                                       .topCenter, // Aligns children in the center of the stack
//                                   children: [
//                                     Image.asset(
//                                       "assets/images/Splashscreen/building.png",
//                                       width: width,
//                                       height: height/3.5,
//                                       color: Colors.grey,
//                                       fit: BoxFit.fitWidth,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 20.0),
//                                       child: SizedBox(
//                                         width: 350,
//                                         child: ElevatedButton(
//                                           onPressed: () {
//                                             // if (Form.of(context)?.validate() ?? false) {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => DeviceaddedScreen(),
//                                               ),
//                                             );
//                                             // }
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:AppStyles.cutstomIconColor, // Button background color
//                                             foregroundColor:
//                                             Colors.white, // Button text color
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(
//                                                   12), // Curved edges
//                                             ),
//                                             minimumSize: const Size(200, 50),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 30,
//                                                 vertical: 15), // Adjust button size
//                                             elevation: 5, // Elevation (shadow)
//                                           ),
//                                           child:  Text(
//                                             'Save & Continue',
//                                             style: AppStyles.customTextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             )),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
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
