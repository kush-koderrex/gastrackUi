import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/BackGroundService.dart';
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
  static const platform =
      MethodChannel('com.example.gas_track_ui/gtrack_process');
  String _statusMessage = '';
  String _logContent = '';
  // String name = widget.deviceInfo;
  // final TextEditingController _controller1 = TextEditingController(text: widget.deviceInfo);
  final TextEditingController _controller2 = TextEditingController(text: "15");

  Future<void> _launchTask() async {
    print("Background Service");
    String result;
    await requestPermissions();
    try {
      final value = "BLE Device";
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

  // test

  List<ScanResult> _scanResults = [];
  late BluetoothCharacteristic characteristic;
  List<BluetoothDevice> _systemDevices = [];
  List<BluetoothService> _services = [];
  List<BluetoothCharacteristic> _characteristic = [];
  late StreamSubscription<List<int>> _lastValueSubscription;
  List<int> _value = [];
  String formattedDate = '';

  // String serviceUUID = "9999";
  // String writeCharacteristicUUID = "9191";
  // String readCharacteristicUUID = "8888";
  //
  // late BluetoothCharacteristic Writecharacteristic;
  // late BluetoothCharacteristic Readcharacteristic;
  void updateDate() {
    DateTime now = DateTime.now();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    });
  }

  DeviceResponse? _deviceResponse;

  // test

  bool _isBluetoothEnabled = false; // Blu

  BluetoothAdapterState _adapterState =
      BluetoothAdapterState.unknown; // Default state
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  Future<void> checkBluetoothState() async {
    BluetoothAdapterState state = await FlutterBluePlus
        .adapterState.first; // Get the current Bluetooth state

    if (state == BluetoothAdapterState.on) {
      setState(() {
        _isBluetoothEnabled = true; // Update the state if Bluetooth is enabled
      });
      // onScanPressed(); // Start scanning for devices if Bluetooth is on
    } else {
      // Show a message or navigate if Bluetooth is off
      Fluttertoast.showToast(msg: "Please enable Bluetooth to add devices.");
      // Optionally navigate back or show a different screen
      Navigator.pop(context);
    }
  }

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  void initState() {
    // TODO: implement initState
    _launchTask();
    // await GasTrackService.startPeriodicTask("Project_RED_TTTP", 15);
    GasTrackService.startPeriodicTask("BLE Device", 15);
    getdaysofuse();
    // startBLETask(
    //   deviceName: "MyBLEDevice",
    //   duration: 15,
    //   serviceUUID: "f000c0c0-0451-4000-b000-000000000000",
    //   characteristicUUID: "f000c0c1-0451-4000-b000-000000000000",
    //   readCharacteristicUUID: "f000c0c2-0451-4000-b000-000000000000",
    //   customerId: "customer123",
    // );
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    checkBluetoothState();
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      // Filter results based on platformName being "BLE Device"
      _scanResults = results.where((result) {
        return result.device.platformName ==
            // "Project_RED_TTTP"; // Case-sensitive match
            "BLE Device"; // Case-sensitive match
      }).toList();
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    super.initState();
  }

  @override
  void dispose() {
    // Cancel the Bluetooth state subscription when widget is disposed
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  bool isConnected = false;
  bool isSubscribe = false;
  bool isGetData = false;
  FirestoreService service = FirestoreService();

  Future GetData() async {
    print("Searched Device");
    print(Utils.device.toString());
    print(Utils.device.connect());
    print(Utils.device.connectAndUpdateStream());
    Utils.device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    print("isConnected:- ${Utils.device.isConnected}");
    // print(Utils.device.isConnected);
    if (Utils.device.isConnected == true) {
      // print(Utils.device.discoverServices());
      // _services = await Utils.device.discoverServices();
      // print("_servicestest");
      // developer.log(_services.toString());
      //
      // for (var service in _services) {
      //   // Loop through each characteristic in the service
      //   for (var characteristic in service.characteristics) {
      //     // Check if the characteristic UUID matches the writeCharacteristicUUID
      //     if (characteristic.uuid.toString() == writeCharacteristicUUID) {
      //       Writecharacteristic = characteristic;
      //     }
      //     // Check if the characteristic UUID matches the readCharacteristicUUID
      //     else if (characteristic.uuid.toString() == readCharacteristicUUID) {
      //       Readcharacteristic = characteristic;
      //     }
      //   }
      // }

      // developer.log("Readcharacteristic:-${Readcharacteristic.toString()}");
      developer.log(
          "Readcharacteristic:-${Utils.Readcharacteristic.characteristicUuid.toString()}");

      // developer.log("Writecharacteristic:-${Writecharacteristic.toString()}");
      developer.log(
          "Writecharacteristic:-${Utils.Writecharacteristic.characteristicUuid.toString()}");

      developer.log("_characteristic--->" + _characteristic.toString());
      print("_characteristic length ->${_characteristic.length}");

      Utils.onSubscribePressed(Utils.Readcharacteristic);
      Utils.subscribeToCharacteristic(Utils.Readcharacteristic);

      print("Remote:-${Utils.Writecharacteristic.remoteId}");
      print("serviceUuid:-${Utils.Writecharacteristic.serviceUuid}");
      print(
          "characteristicUuid:-${Utils.Writecharacteristic.characteristicUuid}");
      print(
          "secondaryServiceUuid:-${Utils.Writecharacteristic.secondaryServiceUuid}");

      print("Read From:-${Utils.Readcharacteristic.characteristicUuid}");
      print("Is Subscribed:-${Utils.Readcharacteristic.isNotifying}");

      if (Utils.Readcharacteristic.isNotifying == true) {
        Utils.onWritePressedgenreq(Utils.Writecharacteristic);
        // print(_characteristic[_characteristic.length-2].characteristicUuid);
        Utils.onReadPressed(Utils.Readcharacteristic);
        _lastValueSubscription =
            Utils.Readcharacteristic.lastValueStream.listen((value) {
          _value = value;
        });

        String data = _value.toString();
        // print("Data:-${data}");

        print("RecData:-${data}");
        if (_value.isNotEmpty) {
          List<String> hexList = _value
              .map((decimal) => decimal.toRadixString(16).padLeft(2, '0'))
              .toList();
          String hexString = hexList.join('');
          print("When Data is not null:-${data}");
          print("hexString:-${hexString}");

          _deviceResponse = parseDeviceResponse(hexString);

          // print(_deviceResponse?.battery.toString());
          setState(() {
            Utils.battery = "${_deviceResponse?.battery.toString()}";
            Utils.weight =
                "${_deviceResponse?.beforeDecimal}.${_deviceResponse?.afterDecimal}";
            Utils.remainGas =
                Utils.calculateGasPercentage(double.parse(Utils.weight))
                    .toStringAsFixed(0);
            Utils.critical_flag = _deviceResponse!.critical;
          });

          print("battery:-${_deviceResponse?.battery.toString()}");
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
            customerId: Utils.cusUuid == null
                ? userData["email"]!
                : Utils.cusUuid, // Use appropriate customer_id
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

  Future<void> _refreshData() async {
    GetData();
    getdaysofuse();
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

  // Future<void> getdaysofuse() async {
  //   var userData = await UserPreferences().getUserData();
  //   var id= (Utils.cusUuid != null && Utils.cusUuid.isNotEmpty ) ? userData["email"]! : Utils.cusUuid;
  //   print("id");
  //   print(id.isEmpty);
  //   print(id);
  //   print(Utils.cusUuid);
  //   print(userData["email"]);
  //
  //
  //   // List<Map<String, dynamic>> readings = await service.getGasReadings(Utils.cusUuid);
  //   List<Map<String, dynamic>> readings = await service.getGasReadings(id);
  //
  //   int usageDays = calculateUsageDays(readings);
  //
  //   print('Usage days (${id}): $usageDays');
  //   print(id);
  //   setState(() {
  //     Utils.days =usageDays.toString();
  //   });
  //   developer.log(readings.toString());
  // }

  Future<void> getdaysofuse() async {
    var userData = await UserPreferences().getUserData();

    // Check if Utils.cusUuid is not null and not empty; otherwise, use userData["email"]
    var id = (Utils.cusUuid.isNotEmpty) ? Utils.cusUuid : userData["email"]!;
    // Use the resolved id for your service call
    List<Map<String, dynamic>> readings = await service.getGasReadings(id);

    int usageDays = calculateUsageDays(readings);

    print('Usage days (${id}): $usageDays');
    print(id);

    setState(() {
      Utils.days = usageDays.toString();
    });

    developer.log(readings.toString());
  }

  DeviceResponse? parseDeviceResponse(String response) {
    // Ensure the response is in uppercase
    response = response.toUpperCase();

    // Expected response length is 24 hex digits
    if (response.length != 24) {
      // print('Invalid response length: ${response.length}');
      return null;
    }

    try {
      // Parsing the response
      String deviceId = response.substring(0, 6); // 3 bytes -> 6 hex digits
      String reqCode = response.substring(6, 8); // 1 byte -> 2 hex digits
      String dataLength = response.substring(8, 10); // 1 byte -> 2 hex digits

      String beforeDecimal = response.substring(10, 12);
      String afterDecimal = response.substring(12, 14);
      String battery = response.substring(14, 16);
      bool buzzer = response.substring(16, 18) == '00';
      bool critical = response.substring(18, 20) == '10';
      String checksum = response.substring(20, 24); // 2 bytes -> 4 hex digits

      return DeviceResponse(
        deviceId: deviceId,
        reqCode: reqCode,
        dataLength: dataLength,
        beforeDecimal: beforeDecimal,
        afterDecimal: afterDecimal,
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 10.0), // Adjust the padding to position the image
          child: GestureDetector(
            onTap: () {
              // Add navigation or action on image tap here
              // Navigator.of(context)
              //     .pop(); // For example, this will pop the current screen
            },
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
            SizedBox(
              height: 5,
            ),
            Text(
              "${Utils.device.platformName}",
              style: AppStyles.customTextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (isConnected == true)
                    ? Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Connected",
                            style: AppStyles.customTextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "DisConnected",
                            style: AppStyles.customTextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                // Container(
                //   width: 6,
                //   height: 6,
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //     shape: BoxShape.circle,
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                size: 35,
              ), // Replace this with any icon you want
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuScreen()));
                // Add action here
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes icons white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
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
                        height: height * 0.40, // Adjust height of the effect
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
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          children: [
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
                                                              color:
                                                                  Colors.white,
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
                                                                      Color(
                                                                          0xF2BE3F44),

                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/svg/battery.svg', // Path to your SVG asset
                                                                    width: 15,
                                                                    height: 15,
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
                                                                          FontWeight
                                                                              .w500),
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

                                                  // Space between the first and second container
                                                  const SizedBox(
                                                      width:
                                                          5), // Adjust the width as needed

                                                  // Second Container

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
                                                              color:
                                                                  Colors.white,
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
                                                                      Color(
                                                                          0xF2A4386B),

                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/svg/weight.svg', // Path to your SVG asset
                                                                    width: 20,
                                                                    height: 20,
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
                                                                  child: Text(
                                                                    "${Utils.weight}",
                                                                    maxLines: 1,
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
                                                            // getdaysofuse();
                                                            _launchTaskUpload();
                                                          },
                                                          child: Card(
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
                                                                        Color(
                                                                            0xF2913189),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/svg/calendar.svg', // Path to your SVG asset
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      color: Colors
                                                                          .white,
                                                                    ), // Icon inside avatar
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Space between avatar and text
                                                                  Text(
                                                                    Utils.days,
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
                                                        Icon(
                                                          Icons.water_drop,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "${Utils.remainGas}%", // Replace with your desired text
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Cerapro',
                                                            fontSize: 31,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Remaining", // Replace with your desired text
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
                                        Column(
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
                                                            child: Image.asset(
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
                                                          (isConnected == true)
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
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              size: 14,
                                              Icons.sync,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Last Synced: $formattedDate",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Cerapro',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
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
            )
          : BluetoothOffScreen(adapterState: _adapterState),
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
