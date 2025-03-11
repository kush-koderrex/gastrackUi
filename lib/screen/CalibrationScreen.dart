import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:gas_track_ui/screen/CalibrationScreen2.dart';

import 'package:gas_track_ui/screen/DeviceAdded.dart';
import 'package:gas_track_ui/utils/utils.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _deviceNameController =
      TextEditingController(text: Utils.device?.platformName);
  final _gasCompanyNameController = TextEditingController();
  final _gasConsumerNumberController = TextEditingController();
  final firestoreService = FirestoreService();

  void updateCustomerGasDetails() async {
    try {
      await firestoreService.updateGasDetails(
        email: Utils.cusUuid,
        gasConsumerNo: _gasConsumerNumberController.text,
        deviceName: _deviceNameController.text,
        gasCompany: _gasCompanyNameController.text,
        phone: Utils.cusUuid,
      );
      print('Gas details updated successfully.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DeviceaddedScreen(),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  int activeStep = 0;

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
                                    Column(
                                      children: <Widget>[
                                        Transform.translate(
                                          offset: Offset(-20,
                                              0), // Adjust the X value to shift left
                                          child: Transform.rotate(
                                            angle: -3.1416 /
                                                20, // Rotate 90 degrees (pi/2 radians)
                                            child: Stack(
                                              alignment: Alignment
                                                  .center, // Centers the text in the middle
                                              children: [
                                                Image.asset(
                                                  "assets/images/HomeScreen/progcylinder.png",
                                                  fit: BoxFit.fitWidth,
                                                  height: height / 3,
                                                ),
                                                // Centered text
                                                const Positioned(
                                                  bottom: 100,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Remove Cylinder", // Replace with your desired text
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Cerapro',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(90,
                                              -50), // Adjust the X value to shift left
                                          child: Transform.rotate(
                                            angle: 3.1416 /
                                                20, // Rotate 90 degrees (pi/2 radians)
                                            child: Image.asset(
                                              "assets/images/arrow.png",
                                              height: 50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, -45), //
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/images/OnboardScreen/elipse.png",
                                                width: width / 2,
                                                fit: BoxFit.fill,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Image.asset(
                                                      "assets/images/OnboardScreen/elipse2.png",
                                                      width: width / 2,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Positioned(
                                                    top: 6,
                                                    left: width / 6,
                                                    child: Center(
                                                      child: Container(
                                                        width: 250,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/OnboardScreen/gastrackname.png",
                                                              width: 60,
                                                              height: 7,
                                                              fit: BoxFit
                                                                  .fill, // Ensures the image fills the container
                                                            ),
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 30),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'STEP 1 : Remove the Cylinder on the Device. Wipe the top of the Device with a Clean cloth',
                                        style: AppStyles.customTextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
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
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CalibrationScreen2(),
                                              ),
                                            );
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
                                            'OK',
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
    return Container(
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
