import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class BluetoothAdapter {

  static bool isBluetoothOn = false;

  static void initBleStateStream() {
    /**
     * call this method in main file or when you initialize dependencies it should be done
     * before calling the check method
     */

    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        isBluetoothOn = true;
      } else {
        isBluetoothOn = false;
      }
    });
  }

  Future<bool> enableBT() async {
    print("isbluettoth turn on is ${isBluetoothOn}");
    if (Platform.isAndroid) {
      if (isBluetoothOn) {
        return true;
      } else {
        try {
          await FlutterBluePlus.turnOn();
          return isBluetoothOn;
        } catch (e) {
          // show toast to turn on bluetooth
          return false;
        }
      }
    } else {
      if (isBluetoothOn) {
        return true;
      } else {
        // you can show toast message here
        return false;
      }
    }
  }
  /*Future<bool> enableBT() async {
    bool androidAbove12 = await _androidVerAbove12();

    bool bleEnable =
        await (FlutterBluePlus.adapterState.first) == BluetoothAdapterState.on
            ? true
            : false;

    if (bleEnable) {
      return true;
    } else {
      if (androidAbove12) {
        showToast("Please turn on bluetooth");
        return false;
      } else {
        await FlutterBluePlus.turnOn();
        return await (FlutterBluePlus.adapterState.first) ==
                BluetoothAdapterState.on
            ? true
            : false;
      }
    }
  }*/


}
