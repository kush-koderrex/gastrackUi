import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:gas_track_ui/utils/utils.dart';

class SuccessScreen extends StatefulWidget {
  bool? isCalibrate;
  SuccessScreen(this.isCalibrate, {super.key});



  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {


  int activeStep = 2;

  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pop(context);
    });
  }

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
                                    (widget.isCalibrate == true)
                                        ? EasyStepper(
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
                                      onStepReached: (index) {
                                        setState(() {
                                          activeStep = index;
                                        });
                                      },
                                    )
                                        : const SizedBox(height: 100,), // Instead of `null`, returning an empty widget

                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Image.asset(
                                      "assets/images/AddyourdeviceScreen/poupimage.png",
                                      fit: BoxFit.fitWidth,
                                      width: 200,
                                      height: 200,
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    widget.isCalibrate == true?const Text(
                                      "Device Calibration Successful!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ):const Text(
                                      "Device Reset Successful!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
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
