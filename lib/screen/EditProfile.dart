import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'dart:developer' as developer;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  Map<String, dynamic>? userData;
  bool isLoading = true;
  final firestoreService = FirestoreService();

  TextEditingController? _deviceNameController;
  TextEditingController? _gasCompanyNameController;
  TextEditingController? _gasConsumerNumberController;

  Future<void> fetchUserData() async {
    // Replace with actual user email/phone
    String email = Utils.cusUuid;  // Replace with actual email
    String phone = '';        // Replace with actual phone number if email is null

    var data = await FirestoreService().getUserData(email: email, phone: phone);
    developer.log(data.toString());

    setState(() {
      userData = data;
      isLoading = false;
       _deviceNameController = TextEditingController(text: '${userData!['device_name']}');
       _gasCompanyNameController = TextEditingController(text: '${userData!['gas_company']}');
       _gasConsumerNumberController = TextEditingController(text: '${userData!['gas_consumer_no']}');
    });
  }


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




  void updateCustomerGasDetails() async {
    try {
      await firestoreService.updateGasDetails(
        email: Utils.cusUuid,
        gasConsumerNo: _gasConsumerNumberController!.text,
        deviceName: _deviceNameController!.text,
        gasCompany: _gasCompanyNameController!.text,
        phone:  Utils.cusUuid,
      );
      print('Gas details updated successfully.');
      Fluttertoast.showToast(msg: "Gas details updated successfully.");


    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch user data when the screen is initialized
    fetchUserData();
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // final _phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: AppStyles.appBarTextStyle,
        ),

        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes the back arrow white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  // color: Colors.cyan,
                                  width: 350,
                                  height: 60,
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _deviceNameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors
                                          .grey.shade200, // Grey inside color
                                      hintText: 'Device Name',
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
                                      hintText: 'Company Name',
                                      hintStyle: AppStyles.customTextStyle(
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
                                      hintText: 'Eg:-3456335',
                                      hintStyle: AppStyles.customTextStyle(
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
                                      height: height / 3.5,
                                      color: Colors.grey,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: SizedBox(
                                        width: 350,
                                        child: ElevatedButton(
                                          onPressed: () async{
                                            updateCustomerGasDetails();
                                            // await FirestoreService().updateGasDetails(
                                            //   email: Utils.cusUuid,
                                            //   phone: "",
                                            //   gasConsumerNo: _gasConsumerNumberController.text,
                                            //   deviceName: _deviceNameController.text,
                                            //   gasCompany: _gasCompanyNameController.text,
                                            // );
                                            // if (Form.of(context)?.validate() ?? false) {
                                            // Navigator.pop(context);
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
                                                vertical:
                                                    15), // Adjust button size
                                            elevation: 5, // Elevation (shadow)
                                          ),
                                          child:  Text(
                                            'Update',
                                            style: AppStyles.customTextStyle(
                                                fontSize: 15.0,
                                                fontWeight:
                                                FontWeight.w500),
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
