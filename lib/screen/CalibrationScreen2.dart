import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'package:easy_stepper/easy_stepper.dart';

import 'package:gas_track_ui/screen/DeviceAdded.dart';
import 'package:gas_track_ui/screen/SuccessScreen.dart';
import 'package:gas_track_ui/utils/utils.dart';

class CalibrationScreen2 extends StatefulWidget {
  const CalibrationScreen2({super.key});

  @override
  State<CalibrationScreen2> createState() => _CalibrationScreen2State();
}

class _CalibrationScreen2State extends State<CalibrationScreen2> {
  final _formKey = GlobalKey<FormState>();

  final _calValController =
      TextEditingController();


  int activeStep = 1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calibration", style: AppStyles.appBarTextStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
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
                padding: EdgeInsets.only(top: height / 9.5),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EasyStepper(
                                      activeStepIconColor: Colors.white,
                                      activeStepBackgroundColor:
                                          AppStyles.cutstomIconColor,
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
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 30),
                                      child: Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'Place a Known Weight that is more then 1KG on the Device and enter the Value Below eg.',
                                          style: AppStyles.customTextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: width/2,
                                        child: const Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("Weight: 1kg"),
                                                Spacer(),
                                                Text("Value: 0100"),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Text("Weight: 2kg"),
                                                Spacer(),
                                                Text("Value: 0200"),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Text("Weight: 3kg"),
                                                Spacer(),
                                                Text("Value: 0300"),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Form(
                                      child: Container(
                                        // color: Colors.cyan,
                                        width: 350,
                                        height: 60,
                                        child: TextFormField(
                                          enabled: true,
                                          controller: _calValController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors
                                                .grey.shade200, // Grey inside color
                                            hintText: 'Enter here',
                                            hintStyle:  AppStyles.customTextStyle(
                                                fontSize: 13.0,
                                                fontWeight:
                                                FontWeight.w400),
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
                                          // validator:,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 30),
                                      child: Center(
                                        child: Text(
                                          'Click Calibrate button to Calibrate the Device.',
                                          style: AppStyles.customTextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Image.asset(
                                      "assets/images/Splashscreen/building.png",
                                      width: width,
                                      height: height / 3.5,
                                      color: Colors.grey,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: SizedBox(
                                        width: 350,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // if (_formKey.currentState
                                            //         ?.validate() ??
                                            //     false) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>  SuccessScreen(true),
                                                ),
                                              );
                                            // }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppStyles.cutstomIconColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            minimumSize: const Size(200, 50),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 15),
                                            elevation: 5,
                                          ),
                                          child: Text(
                                            'Calibrate',
                                            style: AppStyles.customTextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText,
      {bool isPhone = false}) {
    return SizedBox(
      width: 350,
      height: 60,
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          hintText: hintText,
          hintStyle: AppStyles.customTextStyle(
              fontSize: 13.0, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          return null;
        },
      ),
    );
  }
}

class TopRoundedRectangleClipper extends CustomClipper<Path> {
  final double radius;
  final double heightFactor;

  TopRoundedRectangleClipper({this.radius = 30.0, this.heightFactor = 0.60});

  @override
  Path getClip(Size size) {
    var clippedHeight = size.height * heightFactor;
    var path = Path();
    path.moveTo(0, clippedHeight);
    path.lineTo(size.width, clippedHeight);
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0),
        radius: Radius.circular(radius), clockwise: false);
    path.lineTo(radius, 0);
    path.arcToPoint(Offset(0, radius),
        radius: Radius.circular(radius), clockwise: false);
    path.lineTo(0, clippedHeight);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
