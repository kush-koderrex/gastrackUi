import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/LocalStorage.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'package:gas_track_ui/backService.dart';
import 'package:gas_track_ui/main.dart';
import 'package:gas_track_ui/permissions/bluetooth_off_screen.dart';
import 'package:gas_track_ui/screen/AddManuallyDevice.dart';
import 'package:gas_track_ui/screen/CylinderDetailScreen.dart';
import 'package:gas_track_ui/screen/MenuScreen.dart';
import 'package:gas_track_ui/utils/snackbar.dart';
import 'package:gas_track_ui/utils/utils.dart';

import 'package:flutter/services.dart';
import 'package:gas_track_ui/utils/extra.dart';

import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class DeviceResponse {
  String deviceId;
  String reqCode;
  String dataLength;
  String beforeDecimal;
  String afterDecimal;
  String battery;
  bool buzzer;
  bool critical;
  String checksum;

  DeviceResponse({
    required this.deviceId,
    required this.reqCode,
    required this.dataLength,
    required this.beforeDecimal,
    required this.afterDecimal,
    required this.battery,
    required this.buzzer,
    required this.critical,
    required this.checksum,
  });

  @override
  String toString() {
    return 'DEVICE ID: $deviceId\n'
        'REQ_CODE: $reqCode\n'
        'DATA LENGTH: $dataLength\n'
        'WEIGHT: $beforeDecimal.$afterDecimal kg\n'
        'BATTERY: $battery%\n'
        'BUZZER: ${buzzer ? "off" : "on"}\n'
        'CRITICAL: ${critical ? "off" : "on"}\n'
        'CHECKSUM: $checksum\n';
  }
}

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  void logInfo(String message) {
    developer.log(message, name: "GasTrack");
  }
  void logInfoBle(String message) {
    developer.log(message, name: "GasTrack Ble");
  }

  bool isLoading = false; // Manage loader visibility
  static const platform =
      MethodChannel('com.example.gas_track_ui/gtrack_process');
  String _statusMessage = '';
  String _logContent = '';
  // String name = widget.deviceInfo;
  // final TextEditingController _controller1 = TextEditingController(text: widget.deviceInfo);
  final TextEditingController _controller2 = TextEditingController(text: "15");

  var closeLoading;
  showLoading() {
    closeLoading = BotToast.showLoading();
  }

  Future<void> _launchTask() async {
    print("Background Service");
    String result;
    await requestPermissions();
    try {
      // final value = "BLE Device";
      final value = "Project_RED_TTTP";
      final duration = int.parse(_controller2.text);
      result = await platform.invokeMethod(
          'launchPeriodicTask', {'device': value, 'duration': duration});
    } on PlatformException catch (e) {
      result = "Failed to launch task: '${e.message}'.";
    }

    setState(() {
      _statusMessage = result;
    });
  }

  Future<void> _launchTaskUpload() async {
    print("Background Service");
    String result;
    await requestPermissions();
    try {
      result = await platform.invokeMethod('viewLogs');
    } on PlatformException catch (e) {
      result = "Failed to launch task: '${e.message}'.";
    }

    // setState(() {
    //   _statusMessage = result;
    // });
  }

  Future<void> checkBluetoothState() async {
    try {
      BluetoothAdapterState state = await FlutterBluePlus.adapterState.first;

      if (state == BluetoothAdapterState.on) {
        setState(() {
          _isBluetoothEnabled = true;
        });
      } else {
        Fluttertoast.showToast(msg: "Please enable Bluetooth to add devices.");
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Error checking Bluetooth state: $e');
    }
  }

  // TODO:kush
  // void processReceivedData(List<int> data) {
  //   if (data.isNotEmpty) {
  //     String hexString = data
  //         .map((decimal) => decimal.toRadixString(16).padLeft(2, '0'))
  //         .join('');
  //     print("🔢 Converted Hex Data: $hexString");
  //
  //     // Parse the response
  //     DeviceResponse? response = parseDeviceResponse(hexString);
  //     if (response != null) {
  //       print("📊 Parsed Data: $response");
  //       // updateUI(response);
  //     }
  //   }
  // }
  //
  // Future<void> sendCommandToDevice(List<int> command) async {
  //   if (Utils.Writecharacteristic != null) {
  //     await Utils.Writecharacteristic.write(command, withoutResponse: false);
  //     print("📤 Command Sent: $command");
  //   } else {
  //     print("⚠ No Write Characteristic Found!");
  //   }
  // }

  // Future<void> subscribeToNotifications() async {
  //   if (Utils.Readcharacteristic != null) {
  //     await Utils.Readcharacteristic.setNotifyValue(true);
  //     print("📡 Subscribed to Notifications!");
  //
  //     Utils.Readcharacteristic.lastValueStream.listen((value) {
  //       print("📥 Data Received: $value");
  //       processReceivedData(value);
  //     });
  //   } else {
  //     print("⚠ No Read Characteristic Found!");
  //   }
  // }

  Future<void> discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    print("🔍 Discovering Services...");

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print("🟢 Found Characteristic: ${characteristic.characteristicUuid}");

        if (characteristic.characteristicUuid.toString() ==
            Utils.readCharacteristicUUID) {
          Utils.Readcharacteristic = characteristic;
          print(
              "✅ Read Characteristic Assigned: ${characteristic.characteristicUuid}");
        }

        if (characteristic.characteristicUuid.toString() ==
            Utils.writeCharacteristicUUID) {
          Utils.Writecharacteristic = characteristic;
          print(
              "✅ Write Characteristic Assigned: ${characteristic.characteristicUuid}");
        }
      }
      setState(() {
        isLoading = false; // Show loader
      });
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      print("Connecting to ${device.platformName}...");

      await device.connect(timeout: const Duration(seconds: 2));
      print("✅ Connected Successfully!");

      Utils.device = device;

      await discoverServices(device);
    } catch (e) {
      print("❌ Connection Failed: $e");
    }
  }

  scanForDevice(String targetRemoteId) async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        String deviceId = result.device.remoteId.str;
        print("Found Device: ${result.device.platformName} - ID: $deviceId");

        if (deviceId == targetRemoteId) {
          print("✅ Target Device Found: Connecting...");
          connectToDevice(result.device);
          FlutterBluePlus.stopScan(); // Stop scanning after finding the device
          break;
        }
      }
    }, onError: (e) {
      print("Scan Error: $e");
    });
  }

  Future<void> connectAndDiscover(String remoteId) async {
    setState(() => isLoading = true); // Show loader

    Timer loaderTimeout = Timer(const Duration(minutes: 2), () {
      print("⏳ Timeout: Connection taking too long!");
      setState(() => isLoading = false);
      FlutterBluePlus.stopScan();
    });

    try {
      // Start scanning for devices
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      logInfoBle("🔍 Scanning for device: $remoteId");

      BluetoothDevice? targetDevice;

      await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
        for (ScanResult result in results) {
          if (result.device.remoteId.str == remoteId) {
            logInfoBle("✅ Device Found! Connecting...");
            targetDevice = result.device;
            FlutterBluePlus.stopScan();
            break;
          }
        }
        if (targetDevice != null) break;
      }

      if (targetDevice == null) {
        logInfoBle("❌ Device Not Found!");
        setState(() => isLoading = false);
        loaderTimeout.cancel();
        return;
      }

      // Connect to device
      logInfoBle("🔗 Connecting to ${targetDevice.platformName}...");
      await targetDevice.connect(timeout: const Duration(seconds: 5));
      logInfoBle("✅ Connected Successfully!");

      Utils.device = targetDevice;

      // Discover Services & Characteristics
      List<BluetoothService> services = await targetDevice.discoverServices();
      logInfoBle("🔍 Discovering Services...");

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          logInfoBle(
              "🟢 Found Characteristic: ${characteristic.characteristicUuid}");

          if (characteristic.characteristicUuid.toString() ==
              Utils.readCharacteristicUUID) {
            Utils.Readcharacteristic = characteristic;
            logInfoBle("✅ Read Characteristic Assigned");
          }

          if (characteristic.characteristicUuid.toString() ==
              Utils.writeCharacteristicUUID) {
            Utils.Writecharacteristic = characteristic;
            logInfoBle("✅ Write Characteristic Assigned");
          }
        }
      }

      logInfoBle("🔗 Connection & Discovery Complete!");
    } catch (e) {
      logInfoBle("❌ Connection Error: $e");
    } finally {
      loaderTimeout.cancel(); // Stop the timeout when process is done
      setState(() => isLoading = false); // Hide loader
    }
  }

  // Future<void> connectAndDiscover(String remoteId) async {
  //   if (Utils.device != null && Utils.device!.remoteId.str == remoteId && Utils.device!.isConnected) {
  //     print("✅ Device already connected!");
  //     return; // Prevent duplicate connection attempts
  //   }
  //
  //   setState(() => isLoading = true);
  //   FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  //
  //   BluetoothDevice? targetDevice;
  //
  //   await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
  //     for (ScanResult result in results) {
  //       if (result.device.remoteId.str == remoteId) {
  //         print("✅ Device Found! Connecting...");
  //         targetDevice = result.device;
  //         FlutterBluePlus.stopScan();
  //         break;
  //       }
  //     }
  //     if (targetDevice != null) break;
  //   }
  //
  //   if (targetDevice == null) {
  //     print("❌ Device Not Found!");
  //     setState(() => isLoading = false);
  //     return;
  //   }
  //
  //   try {
  //     print("🔗 Connecting to ${targetDevice.platformName}...");
  //     await targetDevice.connect(timeout: const Duration(seconds: 5));
  //     print("✅ Connected Successfully!");
  //
  //     Utils.device = targetDevice;
  //
  //     // Discover Services & Cache
  //     if (Utils.Readcharacteristic == null || Utils.Writecharacteristic == null) {
  //       await discoverServices(targetDevice);
  //     }
  //   } catch (e) {
  //     print("❌ Connection Error: $e");
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  // TODO:kush finsl
  Future<void> connectToSpecificDevice(String remoteId) async {
    setState(() {
      isLoading = true; // Show loader
    });
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 2));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.remoteId.str == remoteId) {
          print("✅ Device Found! Connecting...");
          FlutterBluePlus.stopScan();
          connectToDevice(result.device);
          break;
        }
      }
    }, onError: (e) {
      print("Scan Error: $e");
    });
  }

  // int calculateBatteryFromString(String numberString) {
  //   if (numberString.length < 2) {
  //     throw ArgumentError("Input string must have at least two characters.");
  //   }
  //
  //   // Convert "21" to "2.1"
  //   String formattedString = numberString.substring(0, numberString.length - 1) + "." + numberString.substring(numberString.length - 1);
  //   double voltage = double.parse(formattedString);
  //
  //   // Battery calculation
  //   double minVoltage = 2.0;
  //   double maxVoltage = 3.1;
  //   int battery = (((voltage - minVoltage) / (maxVoltage - minVoltage)) * 100).toInt();
  //
  //   return battery;
  // }

  int calculateBatteryFromString(String numberString) {
    if (numberString.length < 2) {
      throw ArgumentError("Input string must have at least two characters.");
    }

    // Convert hex to decimal
    int batteryHex = int.parse(numberString, radix: 16);

    // Convert to voltage
    double voltage = batteryHex / 10.0;

    // Battery calculation
    double minVoltage = 2.0;
    double maxVoltage = 3.1;
    int battery =
        (((voltage - minVoltage) / (maxVoltage - minVoltage)) * 100).toInt();

    return battery.clamp(0, 100); // Ensure it's within 0-100%
  }

  Future GetData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Searched Device");
    print(Utils.device);
    String? deviceMac = prefs.getString("bluetooth_device_mac");
    print(deviceMac);
    await connectAndDiscover(deviceMac!);
    Utils.device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    logInfo("isConnected:- ${Utils.device.isConnected}");
    if (Utils.device.isConnected == true) {
      logInfo("Readcharacteristic:-${Utils.Readcharacteristic.toString()}");
      logInfo("Writecharacteristic:-${Utils.Writecharacteristic.toString()}");
      logInfo("Readcharacteristic:-${Utils.Readcharacteristic.characteristicUuid.toString()}");
      logInfo("Writecharacteristic:-${Utils.Writecharacteristic.characteristicUuid.toString()}");
      logInfo("_characteristic--->" + _characteristic.toString());
      logInfo("_characteristic length ->${_characteristic.length}");
      Utils.onSubscribePressed(Utils.Readcharacteristic);
      Utils.subscribeToCharacteristic(Utils.Readcharacteristic);
      logInfo("Remote:-${Utils.Writecharacteristic.remoteId}");
      logInfo("serviceUuid:-${Utils.Writecharacteristic.serviceUuid}");
      logInfo("characteristicUuid:-${Utils.Writecharacteristic.characteristicUuid}");
      logInfo("secondaryServiceUuid:-${Utils.Writecharacteristic.secondaryServiceUuid}");
      logInfo("Read From:-${Utils.Readcharacteristic.characteristicUuid}");
      logInfo("Is Subscribed:-${Utils.Readcharacteristic.isNotifying}");

      if (Utils.Readcharacteristic.isNotifying == true)  {
        await Utils.onWritePressedgenreq(Utils.Writecharacteristic);
        // print(_characteristic[_characteristic.length-2].characteristicUuid);
        await Utils.onReadPressed(Utils.Readcharacteristic);


        // _lastValueSubscription =
        //     Utils.Readcharacteristic.lastValueStream.listen((value) {
        //   _value = value;
        // });

        int retryCount = 0;
        int maxRetries = 3;
        bool success = false;

        while (retryCount < maxRetries) {
          _lastValueSubscription = Utils.Readcharacteristic.lastValueStream.listen((value) {
            _value = value;
          });

          await Future.delayed(Duration(seconds: 2)); // Wait for data

          String data = _value.toString();
          print("Attempt re ${retryCount + 1}: Data -> ${data}");

          if (data.isNotEmpty) {
            success = true;
            break; // Exit retry loop if data is received
          }

          retryCount++;
        }
        if (!success) {
          print("❌ Failed to fetch data after $maxRetries retries.");
          Fluttertoast.showToast(
            msg: 'Failed to fetch data! Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }

        String data = _value.toString();
        print("Data:-${data}");
        print("RecData:-${data}");

        if (_value.isNotEmpty) {
          List<String> hexList = _value
              .map((decimal) => decimal.toRadixString(16).padLeft(2, '0'))
              .toList();
          String hexString = hexList.join('');
          print("When Data is not null:-${data}");
          print("hexString:-${hexString}");

          Utils.hexstring = hexString;

          _deviceResponse = parseDeviceResponse(hexString);
          print("_deviceResponse:-\n${_deviceResponse}");

          if (_deviceResponse != null) {
            // setState(() {
            //   var batcal = calculateBatteryFromString(_deviceResponse!.battery);
            //
            //   Utils.battery = "${batcal}";
            //   Utils.weight =
            //   "${_deviceResponse?.beforeDecimal}.${_deviceResponse
            //       ?.afterDecimal}";
            //   Utils.remainGas =
            //       Utils.calculateGasPercentage(double.parse(Utils.weight))
            //           .toStringAsFixed(0);
            //   Utils.critical_flag = _deviceResponse!.critical;
            // });

            setState(() {
              int batteryPercentage =
                  calculateBatteryFromString(_deviceResponse!.battery);

              Utils.battery = "$batteryPercentage";
              String weightStr =
                  "${_deviceResponse?.beforeDecimal}.${_deviceResponse?.afterDecimal}";

              // Remove unwanted characters from weight before parsing
              weightStr = weightStr.replaceAll(RegExp(r'[^0-9.]'), '');

              Utils.weight = weightStr;

              Utils.remainGas = Utils.calculateGasPercentage(
                      double.tryParse(Utils.weight) ?? 0.0)
                  .toStringAsFixed(0);

              Utils.critical_flag = _deviceResponse!.critical;
            });
          }

          // print("battery:-${batcal.toString()}");
          print("Battery: ${Utils.battery}");
          print("Weight: ${Utils.weight} kg");
          print("RemainGas:-${Utils.remainGas}");
          print(
              "weight:-${_deviceResponse?.beforeDecimal}.${_deviceResponse?.afterDecimal}");
          print("criticalFlag:-${_deviceResponse?.critical}}");
          var userData = await UserPreferences().getUserData();
          if (_deviceResponse?.critical != null &&
              _deviceResponse?.critical == true) {
            await _showCriticalNotification();
          }

          await FirestoreService().updateGasReadings(
            customerId:
                Utils.cusUuid == null ? userData["email"]! : Utils.cusUuid,
            remainGas: Utils.remainGas,
            weight: Utils.weight,
            battery: Utils.battery,
            // criticalFlag: false,
            criticalFlag: Utils.critical_flag,
            readingDate: DateTime.now(),
          );
          Fluttertoast.showToast(
            msg: 'Data Update successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          updateDate();
          isGetData = true;
        }
        isSubscribe = true;
      }
      isConnected = true;
    }
  }

  void updateDate() {
    DateTime now = DateTime.now();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    });
  }

  // Future<void> _refreshData() async {
  //   if (_isRefreshing) return;
  //   setState(() {
  //     _isRefreshing = true;
  //   });
  //
  //   try {
  //     await GetData();
  //     await getdaysofuse();
  //   } catch (e) {
  //     print("Catch Error:-" + e.toString());
  //     Fluttertoast.showToast(
  //       msg: 'Failed to refresh data! ',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   } finally {
  //     setState(() {
  //       _isRefreshing = false;
  //     });
  //   }
  // }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // Step 1: Fetch Latest Data First
      await GetData(); // Wait for BLE data to update Firestore

      // Step 2: Ensure Firestore has updated data before fetching days of use
      await Future.delayed(Duration(seconds: 2)); // Give Firestore time to update (adjust if needed)

      // Step 3: Fetch Updated Days of Use Data
      await getdaysofuse();
    } catch (e) {
      print("Error refreshing data: $e");
      Fluttertoast.showToast(
        msg: 'Failed to refresh data!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _showCriticalNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'critical_channel', // Channel ID
      'Critical Notifications', // Channel Name
      channelDescription: 'Notifications for critical events.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Critical Alert', // Notification Title
      'A critical event has been detected!', // Notification Body
      notificationDetails,
    );
  }

  Future<void> getdaysofuse() async {
    var userData = await UserPreferences().getUserData();

    // Check if Utils.cusUuid is not null and not empty; otherwise, use userData["email"]
    var id = (Utils.cusUuid.isNotEmpty) ? Utils.cusUuid : userData["email"]!;
    // Use the resolved id for your service call
    List<Map<String, dynamic>> readings = await service.getGasReadings(id);

    int usageDays = calculateUsageDays(readings);

    logInfo('Usage days (${id}): $usageDays');
    logInfo(id);

    setState(() {
      Utils.days = usageDays.toString();
    });

    logInfo(readings.toString());
  }

  // DeviceResponse? parseDeviceResponse(String response) {
  //   // Ensure the response is in uppercase
  //   response = response.toUpperCase();
  //
  //   // Expected response length is 24 hex digits
  //   if (response.length != 24) {
  //     // print('Invalid response length: ${response.length}');
  //     return null;
  //   }
  //
  //   try {
  //     // Parsing the response
  //     String deviceId = response.substring(0, 6); // 3 bytes -> 6 hex digits
  //     String reqCode = response.substring(6, 8); // 1 byte -> 2 hex digits
  //     String dataLength = response.substring(8, 10); // 1 byte -> 2 hex digits
  //     String beforeDecimal = response.substring(10, 12);
  //     String afterDecimal = response.substring(12, 14);
  //     String battery = response.substring(14, 16);
  //     bool buzzer = response.substring(16, 18) == '00';
  //     bool critical = response.substring(18, 20) == '10';
  //     String checksum = response.substring(20, 24); // 2 bytes -> 4 hex digits
  //
  //     return DeviceResponse(
  //       deviceId: deviceId,
  //       reqCode: reqCode,
  //       dataLength: dataLength,
  //       beforeDecimal: beforeDecimal,
  //       afterDecimal: afterDecimal,
  //       battery: battery,
  //       buzzer: buzzer,
  //       critical: critical,
  //       checksum: checksum,
  //     );
  //   } catch (e) {
  //     print('Error parsing response: $e');
  //     return null;
  //   }
  // }

  DeviceResponse? parseDeviceResponse(String response) {
    response = response.toUpperCase();

    if (response.length != 24) {
      return null;
    }

    try {
      String deviceId = response.substring(0, 6); // 3 bytes -> 6 hex digits
      String reqCode = response.substring(6, 8); // 1 byte -> 2 hex digits
      String dataLength = response.substring(8, 10); // 1 byte -> 2 hex digits

      // Convert hex to decimal
      int beforeDecimal = int.parse(response.substring(10, 12), radix: 16);
      int afterDecimal = int.parse(response.substring(12, 14), radix: 16);

      String battery = response.substring(14, 16);
      bool buzzer = response.substring(16, 18) == '00';
      bool critical = response.substring(18, 20) == '01';
      String checksum = response.substring(20, 24); // 2 bytes -> 4 hex digits

      return DeviceResponse(
        deviceId: deviceId,
        reqCode: reqCode,
        dataLength: dataLength,
        beforeDecimal: beforeDecimal.toString(),
        afterDecimal: afterDecimal.toString(),
        battery: battery,
        buzzer: buzzer,
        critical: critical,
        checksum: checksum,
      );
    } catch (e) {
      print('Error parsing response: $e');
      return null;
    }
  }

  List<ScanResult> _scanResults = [];
  late BluetoothCharacteristic characteristic;
  List<BluetoothDevice> _systemDevices = [];
  List<BluetoothService> _services = [];
  List<BluetoothCharacteristic> _characteristic = [];
  late StreamSubscription<List<int>> _lastValueSubscription;
  List<int> _value = [];
  String formattedDate = '';
  DeviceResponse? _deviceResponse;
  bool _isBluetoothEnabled = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  bool isConnected = false;
  bool isSubscribe = false;
  bool isGetData = false;
  FirestoreService service = FirestoreService();
  bool _isRefreshing = false;

  Future TryConnec() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Searched TryConnec");
    String? deviceMac = prefs.getString("bluetooth_device_mac");
    print(deviceMac);
    // await scanForDevice("59:42:26:B5:12:C1");

    // await connectToSpecificDevice("59:42:26:B5:12:C1");
    await connectAndDiscover(deviceMac!);
  }

  @override
  void initState() {
    // TODO:KUSH
    // TryConnec();
    // TODO:KUSH

    // TODO: implement initState
    if (_adapterStateSubscription == null) {
      _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
        setState(() {
          _adapterState = state;
          isConnected = (state == BluetoothAdapterState.on);
        });
      });
    }
    _launchTask();
    GasTrackService.startPeriodicTask("Project_RED_TTTP", 15);
    // GasTrackService.startPeriodicTask("BLE Device", 15);
    getdaysofuse();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    checkBluetoothState();
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {

      _scanResults = results.where((result) {
        return result.device.platformName ==
            "Project_RED_TTTP"; // Case-sensitive match
            // "BLE Device"; // Case-sensitive match
      }).toList();
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    super.initState();

    // Listen to Bluetooth adapter state changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        isConnected =
            (state == BluetoothAdapterState.on); // Update connection status
      });
    });

    checkBluetoothState();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel(); // Safe cancel with null check
    _scanResultsSubscription.cancel(); // Also cancel scan subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0), // Adjust the padding to position the image
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Image.asset(
                    'assets/images/HomeScreen/hcylender.png', // Replace with your image path
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  // "${Utils.device.platformName}",
                  Utils.device != null
                      ? Utils.device!.platformName
                      : "No Device Connected",
                  style: AppStyles.customTextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isConnected ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isConnected ? "Connected" : "Disconnected",
                          style: AppStyles.customTextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10.0),
                child: InkWell(
                  onTap: () {
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuScreen()));
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/svg/settingicon.svg', // Path to your SVG asset
                    width: 45,
                    height: 45,
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
            backgroundColor:
                Colors.transparent, // Makes the background transparent
            elevation: 0, // Removes the shadow below the AppBar
            centerTitle: true, // Optional: centers the title
            iconTheme:
                const IconThemeData(color: Colors.white), // Makes icons white
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          extendBodyBehindAppBar:
              true, // Ensures the body goes behind the AppBar
          body: _isBluetoothEnabled
              ? RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        // Gradient with Custom Clip Path at the top of the screen
                        ClipPath(
                          clipper:
                              TopRoundedRectangleClipper(), // Custom clipper for the top curve
                          child: Container(
                            height:
                                height * 0.40, // Adjust height of the effect
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
                          padding: EdgeInsets.only(
                              top: height / 7), // Adjust for gradient
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
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Column(
                                              children: [
                                                Text(Utils.hexstring),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      // First Container
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Card(
                                                              // elevation: 5,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12), // Padding inside the container
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12), // Rounded edges for the container
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center, // Center contents inside the container
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          22, // Size of the avatar
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xF2BE3F44),

                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/svg/battery.svg', // Path to your SVG asset
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ), // Icon inside avatar
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5), // Space between avatar and text
                                                                    Text(
                                                                      "${Utils.battery}%",
                                                                      style: AppStyles.customTextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Device Battery",
                                                              style: AppStyles
                                                                  .customTextStyle(
                                                                      fontSize:
                                                                          11.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                          width:
                                                              5), // Adjust the width as needed

                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Card(
                                                              // elevation: 5,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12), // Padding inside the container
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12), // Rounded edges for the container
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center, // Center contents inside the container
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          22, // Size of the avatar
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xF2A4386B),

                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/svg/weight.svg', // Path to your SVG asset
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ), // Icon inside avatar
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            2), // Space between avatar and text
                                                                    Container(
                                                                      // color: Colors.red,
                                                                      width: 40,
                                                                      child:
                                                                          Text(
                                                                        "${Utils.weight}",
                                                                        maxLines:
                                                                            1,
                                                                        style: AppStyles.customTextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Cylinder Weight",
                                                              style: AppStyles
                                                                  .customTextStyle(
                                                                      fontSize:
                                                                          11.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Space between the second and third container
                                                      const SizedBox(
                                                          width:
                                                              5), // Adjust the width as needed

                                                      // Third Container
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                getdaysofuse();
                                                                // _launchTaskUpload();
                                                              },
                                                              child: Card(
                                                                // elevation: 5,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12), // Padding inside the container
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12), // Rounded edges for the container
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center, // Center contents inside the container
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            22, // Size of the avatar
                                                                        backgroundColor:
                                                                            const Color(0xF2913189),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          'assets/images/svg/calendar.svg', // Path to your SVG asset
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ), // Icon inside avatar
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8), // Space between avatar and text
                                                                      Text(
                                                                        Utils
                                                                            .days,
                                                                        // Utils.days,
                                                                        style: AppStyles.customTextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Days of Use",
                                                              style: AppStyles
                                                                  .customTextStyle(
                                                                      fontSize:
                                                                          11.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CylinderDetailScreen()));
                                              },
                                              child: Stack(
                                                alignment: Alignment
                                                    .center, // Centers the text in the middle
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(0,
                                                        230), // Adj
                                                    child: Column(

                                                      children: [
                                                        Image.asset(
                                                          "assets/images/OnboardScreen/elipse.png",
                                                          width: width / 1.3,
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
                                                                width: width / 1.3,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Positioned(
                                                              top: 10,
                                                              left: width / 3.8,
                                                              child: Center(
                                                                child: Container(
                                                                  width: 250,
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        // color:Colors.red,
                                                                        child:
                                                                        Image.asset(
                                                                          "assets/images/OnboardScreen/gastrackname.png",
                                                                          width: 60,
                                                                          height: 7,
                                                                          fit: BoxFit
                                                                              .fill, // Ensures the image fills the container
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 40,
                                                                      ),
                                                                      (isConnected ==
                                                                          true)
                                                                          ? Container(
                                                                        width: 8,
                                                                        height: 8,
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                          color: Colors
                                                                              .green,
                                                                          shape: BoxShape
                                                                              .circle,
                                                                        ),
                                                                      )
                                                                          : Container(
                                                                        width: 8,
                                                                        height: 8,
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                          color: Colors
                                                                              .red,
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
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                              size: 14,
                                                              Icons.sync,
                                                              color: Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Last Synced: $formattedDate",
                                                              style: const TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: 'Cerapro',
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    "assets/images/HomeScreen/progcylinder.png",
                                                    fit: BoxFit.fitWidth,
                                                    height: height / 2,
                                                  ),
                                                  // Centered text
                                                  Positioned(
                                                    bottom: 100,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.water_drop,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Text(
                                                              "${Utils.remainGas}%", // Replace with your desired text
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Cerapro',
                                                                fontSize: 31,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                        const Text(
                                                          "Remaining", // Replace with your desired text
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Cerapro',
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
                )
              : BluetoothOffScreen(adapterState: _adapterState),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

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
