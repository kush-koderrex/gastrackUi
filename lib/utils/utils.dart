import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gas_track_ui/utils/snackbar.dart';
import 'package:gas_track_ui/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;


import 'app_colors.dart';

class AppStyles {
  // Define the reusable TextStyle for AppBar text
  static const Color cutstomIconColor = Color(0xF29F5BAC);

  static const TextStyle appBarTextStyle = TextStyle(
    fontFamily: 'Cerapro',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white
  );

  static TextStyle customTextStyle({double fontSize = 16.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
      fontFamily: 'Cerapro',
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

// You can add other reusable styles as needed
}



class Palette {
  static const MaterialColor kTolight = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      10:   Color(0xffffffff), //10%
      50:   Color(0xffce5641), //10%
      100:   Color(0xffb74c3a), //20%
      200:   Color(0xffa04332), //30%
      300:   Color(0xff89392b), //40%
      400:   Color(0xff733024), //50%
      500:   Color(0xff5c261d), //60%
      600:   Color(0xff451c16), //70%
      700:   Color(0xff2e130e), //80%
      800:   Color(0xff170907), //90%
      900:   Color(0xff000000), //100%
    },
  );
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.


class Utils {

  static String weight = "0";
  static String days = "0";
  static String battery = "0";
  static bool critical_flag =false;
  static String remainGas = "0";
  //
  // static String serviceUUID = "9999";
  // static String writeCharacteristicUUID = "9191";
  // static String readCharacteristicUUID = "8888";

  late SharedPreferences prefs;

  static String serviceUUID = "f000c0c0-0451-4000-b000-000000000000";
  static String writeCharacteristicUUID = "f000c0c1-0451-4000-b000-000000000000";
  static String readCharacteristicUUID = "f000c0c2-0451-4000-b000-000000000000";


  static String DeviiceName = "";



  static String cusUuid = "";


  static Future<void> onSubscribePressed(BluetoothCharacteristic characteristic) async {
    try {
      String op = characteristic.isNotifying == false ? "Subscribe" : "Unsubscribe";
      print("setNotifyValue operation: $op");
      print("Is notifying: ${characteristic.isNotifying}");

      // Toggle the notification state
      await characteristic.setNotifyValue(characteristic.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      developer.log("Subscribed to Service: ${characteristic}");

      // Check if the characteristic supports read and perform read
      if (characteristic.properties.read) {
        print("Descriptors: ${characteristic.descriptors.first}");
        await characteristic.read();
      } else {
        developer.log("This characteristic does not support READ.");
      }

      // Check if the characteristic supports notifications
      if (characteristic.properties.notify) {
        await characteristic.setNotifyValue(true); // Enable notifications
      } else {
        developer.log("This characteristic does not support NOTIFY.");
      }

    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
    }
  }

  static Future<void> subscribeToCharacteristic(
      BluetoothCharacteristic characteristic) async {
    try {
      if (characteristic.properties.notify) {
        await characteristic.setNotifyValue(true); // Enable notifications
      } else {
        developer.log("ERROR: This characteristic does not support NOTIFY.");
      }
    } catch (e) {
      developer.log("Failed to subscribe to characteristic: $e", error: e);
      await Future.delayed(const Duration(seconds: 1));
      await characteristic.setNotifyValue(true);
    }
  }


  // Function to handle Bluetooth write operation (General Request)
  static Future<void> onWritePressedgenreq(BluetoothCharacteristic characteristic) async {
    try {
      // Write a general request to the characteristic
      List<int> requestData = [0x40, 0xA8, 0x00, 0x01, 0x01, 0x01, 0xAA, 0x55];
      await characteristic.write(
        requestData,
        withoutResponse: characteristic.properties.writeWithoutResponse,
        allowLongWrite: true,
      );

      // Show success Snackbar
      Snackbar.show(ABC.c, "Write: Success", success: true);
      print("General Request Sent: ${characteristic}");

      // Optionally read the characteristic after writing if supported
      if (characteristic.properties.read) {
        await characteristic.read();
      }

    } catch (e) {
      // Handle errors and show error Snackbar
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  // Function to handle Bluetooth read operation
  static Future<void> onReadPressed(BluetoothCharacteristic characteristic) async {
    try {
      // Read from the Bluetooth characteristic
      await characteristic.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
      print("Start Reading");

    } catch (e) {
      // Handle errors and show error Snackbar
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
      print("Read Error: $e");
    }
  }

  static double emptyWeight = 14.8; // Empty weight of the cylinder
  static double fullWeight = 29.0; // Full weight of the cylinder


  // Function to calculate the gas percentage based on current weight
  static double calculateGasPercentage(double currentWeight) {

    if (currentWeight < emptyWeight) {
      return 0.0; // Prevent negative percentages if weight is below empty
    }
    return ((currentWeight - emptyWeight) / (fullWeight - emptyWeight)) * 100;
  }



  // static String serviceUUID = "f000c0c0-0451-4000-b000-000000000000";
  // static String writeCharacteristicUUID = "f000c0c1-0451-4000-b000-000000000000";
  // static String readCharacteristicUUID = "f000c0c2-0451-4000-b000-000000000000";

  static late BluetoothCharacteristic Writecharacteristic;
  static late BluetoothCharacteristic Readcharacteristic;

  static late BluetoothDevice device;


  static bool _isDeviceConnected = false;
  static BuildContext? _loaderContext;
  static BuildContext? _loadingDialoContext;
  static bool _isLoaderShowing = false;
  static bool _isLoadingDialogShowing = false;
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;
  static String model = '';
  static String osVersion = '';
  static String platform = '';
  static String imei = '';
  static String currentAddress = '';
  static String loaction = '';
  static var latitude;
  static var longitude;
  static var checkLogin;

  static String userpic = '';
  static String userlastlogin = '';
  static String userName = '';
  static String userkey = '';
  static String Devicesid = '';
  static String TOKEN = '';
  static String resetTpin = '';
  static String indexname = '';
  // var indexname;
  static Map Accountdata = {};
  static List<Map<String, dynamic>> submenu = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late BuildContext scaffoldContext;



  static void ShowDialog(BuildContext context, String message) {
    Timer? timer = Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                // Bottom rectangular box
                margin: EdgeInsets.only(
                    top: 40), // to push the box half way below circle
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(
                    top: 60, left: 20, right: 20), // spacing inside the box
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                child: CircleAvatar(
                  // Top Circle with icon
                  maxRadius: 40.0,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('images/japanlogo.png'),
                ),
              ),
            ],
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      context: context,
    );
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(  // Bottom rectangular box
                    margin: EdgeInsets.only(top: 40), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 16,
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    child: CircleAvatar( // Top Circle with icon
                      maxRadius: 40.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('images/japanlogo.png'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
           ).then((value){
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });*/
  }



  Future<Object?> _buildDialogContent(BuildContext context) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        title: Text('blured background'),
        content: Text('background should be blured and little bit darker '),
        elevation: 2,
        actions: [],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      context: context,
    );
  }

  // static void showLoader(BuildContext context) {
  //   if (!_isLoaderShowing) {
  //     _isLoaderShowing = true;
  //     _loaderContext = context;
  //     showDialog(
  //         context: _loaderContext!,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return const SpinKitRing(
  //             lineWidth: 2.0,
  //             color: AppColors.navColor,
  //           );
  //         }).then((value) => {_isLoaderShowing = false,/* Log.info('Loader hidden!')*/});
  //   }
  // }
  static Widget image(String thumbnail) {
    try {
      String placeholder =
          "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
      if (thumbnail?.isEmpty ?? true)
        thumbnail = placeholder;
      else {
        if (thumbnail.length % 4 > 0) {
          thumbnail +=
              '=' * (4 - thumbnail.length % 4); // as suggested by Albert221
        }
      }
      final _byteImage = Base64Decoder().convert(thumbnail);
      Widget image = Image.memory(_byteImage);
      return image;
    } catch (e) {
      String placeholder =
          "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
      final _byteImage = Base64Decoder().convert(placeholder);
      Widget image = Image.memory(_byteImage);
      return image;
    }
  }

  static void hideLoader() {
    if (_isLoaderShowing && _loaderContext != null) {
      Navigator.pop(_loaderContext!);
      _loaderContext = null;
    }
  }

  static void hideLoadingDialog() {
    if (_isLoadingDialogShowing && _loadingDialoContext != null) {
      Navigator.pop(_loadingDialoContext!);
      _loadingDialoContext = null;
    }
  }

  static void hideKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

}



class ValidationUtils {
  static final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  static bool isValidPhoneNumber(String number) {
    if (number.isEmpty || number.length < 10)
      return false;
    else
      return true;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty)
      return 'Phone number is required.';
    else if (value.length < 10 && value.length > 10)
      return 'Enter valid 10 digit phone number';
    else
      return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter email address';
    return null;
  }

  static String? validatePassword(String value) {
    if (value != null && value.isEmpty) return 'Password is required.';
    return null;
  }

  static bool isValidName(String s) {
    return _alphabetRegex.hasMatch(s);
  }

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password != null && password.length >= 6;
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierColor: Colors.black38,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            /* ? CircularPercentIndicator(
          radius: 20.0,
          lineWidth: 5.0,
          percent: 1.0,
          center:   Text("100%"),
          progressColor: Colors.green,
        )*/
            : CupertinoActivityIndicator(
                color: AppColors.primary_color,
                radius: 20,
                animating: true,
              ),
      ),
    );
  }
}
