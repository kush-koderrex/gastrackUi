import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_track_ui/screen/FillOtherInformation.dart';
import 'package:gas_track_ui/utils/extra.dart';
import 'package:gas_track_ui/utils/snackbar.dart';
import 'package:gas_track_ui/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:developer' as developer;

import 'package:permission_handler/permission_handler.dart';

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

Future<void> requestPermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.location,
    Permission.storage, // Add storage permission
  ].request();
}

class AddManuallyDeviceScreen extends StatefulWidget {
  const AddManuallyDeviceScreen({super.key});

  @override
  State<AddManuallyDeviceScreen> createState() =>
      _AddManuallyDeviceScreenState();
}

class _AddManuallyDeviceScreenState extends State<AddManuallyDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<ScanResult> _scanResults = [];
  late BluetoothCharacteristic characteristic;
  // String serviceUUID = "9999";
  // String writeCharacteristicUUID = "9191";
  // String readCharacteristicUUID = "8888";
  //
  // late BluetoothCharacteristic Writecharacteristic;
  String formattedDate = '';

  bool isLoading = false;
  bool isLoadingIndicater = false;

  List<BluetoothDevice> _systemDevices = [];
  List<BluetoothService> _services = [];
  List<BluetoothCharacteristic> _characteristic = [];
  // _services = [];
  // List<Item> items = []; // Changed to List<Item>
  bool _isBluetoothEnabled = false; // Bluetooth state variable
  bool _isDiscoveringServices = false;
  List<int> _value = [];
  late StreamSubscription<List<int>> _lastValueSubscription;

  static const platform =
  MethodChannel('com.gastrack.background/gtrack_process');
  String _statusMessage = '';
  String _logContent = '';
  DeviceResponse? _deviceResponse;

  final double emptyWeight = 14.8; // Empty weight of the cylinder
  final double fullWeight = 29.0; // Full weight of the cylinder
  // double gasPercentage = 0.0; // Percentage of gas remaining

  // Function to calculate gas percentage based on current weight
  double calculateGasPercentage(double currentWeight) {
    if (currentWeight < emptyWeight) {
      return 0.0; // Prevent negative percentages if weight is below empty
    }
    return ((currentWeight - emptyWeight) / (fullWeight - emptyWeight)) * 100;
  }

  Future onWritePressedgenreq(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.write(
          [0x40, 0xA8, 0x00, 0x01, 0x01, 0x01, 0xAA, 0x55],
          withoutResponse: characteristic.properties.writeWithoutResponse,
          allowLongWrite: true);
      // await c.write([0xa, 0x1, 0x2, 0x3c, 0x1, 0x37, 0xaa, 0x37], withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      print("General Request Send :-${characteristic}");
      if (characteristic.properties.read) {
        await characteristic.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  // Future onSubscribePressed(BluetoothCharacteristic characteristic) async {
  //   try {
  //     String op =
  //     characteristic.isNotifying == false ? "Subscribe" : "Unubscribe";
  //     await characteristic.setNotifyValue(characteristic.isNotifying == false);
  //     Snackbar.show(ABC.c, "$op : Success", success: true);
  //     print("Subscribed Service${characteristic}");
  //     if (characteristic.properties.read) {
  //       await characteristic.read();
  //     }
  //     if (mounted) {
  //       // setState(() {});
  //     }
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
  //         success: false);
  //   }
  // }


  Future onSubscribePressed(BluetoothCharacteristic characteristic) async {
    try {
      String op = characteristic.isNotifying == false ? "Subscribe" : "Unubscribe";
      print("setNotifyValueop");
      print(op);
      print(characteristic.isNotifying == false);

      await characteristic.setNotifyValue(characteristic.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      developer.log("Subscribed Service:-${characteristic}");
      if (characteristic.properties.read) {
        print("Descriter:-${characteristic.descriptors.first}");
        // await characteristic.read();
        if (characteristic.properties.read) {
          await characteristic.read();
        } else {
          developer.log("This characteristic does not support READ.");
        }
      }
      if (characteristic.properties.notify) {
        await characteristic.setNotifyValue(true);  // Enable notifications
      } else {
        developer.log("This characteristic does not support NOTIFY.");
      }
      if (mounted) {
        // setState(() {});
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  Future<void> subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      if (characteristic.properties.notify) {
        await characteristic.setNotifyValue(true);  // Enable notifications


        // characteristic.lastValueStream.listen((value) {
        //   // Process the incoming notification data here
        //   developer.log("Notification received: $value");
        //
        // });
        //
        // developer.log("Subscribed to notifications for characteristic ${characteristic.uuid}");
      } else {
        developer.log("ERROR: This characteristic does not support NOTIFY.");
      }
    } catch (e) {
      developer.log("Failed to subscribe to characteristic: $e", error: e);
      await Future.delayed(Duration(seconds: 1));
      await characteristic.setNotifyValue(true);
    }
  }


  Future onReadPressed(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
      print("Start Reading");
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
      print("Read Error ${e}");
    }
  }

  // Method to check Bluetooth state
  Future<void> checkBluetoothState() async {
    BluetoothAdapterState state = await FlutterBluePlus
        .adapterState.first; // Get the current Bluetooth state

    if (state == BluetoothAdapterState.on) {
      setState(() {
        _isBluetoothEnabled = true; // Update the state if Bluetooth is enabled
      });
      onScanPressed(); // Start scanning for devices if Bluetooth is on
    } else {
      // Show a message or navigate if Bluetooth is off
      Fluttertoast.showToast(msg: "Please enable Bluetooth to add devices.");
      // Optionally navigate back or show a different screen
      Navigator.pop(context);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().then((_) {
      showCustomDialog(context);
      // If the connection was successful, print "Connected"
      print("Connected");
      Fluttertoast.showToast(msg: "Device Connected");
    }).catchError((e) {
      // If an error occurred during connection, print "Not connected"
      print("Not connected");
      Fluttertoast.showToast(msg: "Device Not connected");
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
  }

  Future onConnectPressedee(BluetoothDevice device) async {
    try {
      await device.connectAndUpdateStream();
      Snackbar.show(ABC.c, "Connect: Success", success: true);
    } catch (e) {
      if (e is FlutterBluePlusException &&
          e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        Snackbar.show(ABC.c, prettyException("Connect Error:", e),
            success: false);
      }
    }
  }

  Future onDiscoverServicesPressed(BluetoothDevice device) async {
    if (mounted) {
      // setState(() {
      //   _isDiscoveringServices = true;
      // });
    }
    try {
      _services = await device.discoverServices();

      print("_servicestest");
      // print(_services);
      Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Discover Services Error:", e),
          success: false);
      print("Discover Services Error:$e");
    }
    if (mounted) {
      // setState(() {
      //   _isDiscoveringServices = false;
      // });
    }
  }

  Future<void> _launchTask(String deviceName) async {
    print("Task Launched Succes");
    String result;
    await requestPermissions();
    try {
      final value = deviceName;
      final duration = 1;
      result = await platform.invokeMethod(
          'launchPeriodicTask', {'device': value, 'duration': duration});
    } on PlatformException catch (e) {
      result = "Failed to launch task: '${e.message}'.";
    }

    setState(() {
      _statusMessage = result;
    });
  }

  // This function updates the items list with device information from scan results
  // void updateItemsFromScanResults(List<ScanResult> scanResults) {
  //   items.clear(); // Clear the previous items
  //
  //   // Populate the items list with the names and distances from the scan results
  //   for (var result in scanResults) {
  //     var deviceInfo = Item(
  //       name: result.device.name.isNotEmpty ? result.device.name : "Unnamed Device", // Fallback for empty names
  //       distance: result.rssi.toDouble(), // Use RSSI as an example for distance
  //     );
  //
  //     items.add(deviceInfo); // Add the device info to the items list
  //   }
  // }

  // Example usage
  // void onScanResultsUpdated(List<ScanResult> scanResults) {
  //   updateItemsFromScanResults(scanResults);
  //   printDeviceList();
  // }
  //
  // void printDeviceList() {
  //   for (var item in items) {
  //     print('Device Name: ${item.name}, Distance: ${item.distance} meters');
  //   }
  // }

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    checkBluetoothState();
    onScanPressed();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      // Filter results based on platformName being "BLE Device"
      _scanResults = results.where((result) {
        return result.device.platformName ==
            // "Project_RED_TTTP"; // Case-sensitive match
            "BLE Device"; // Case-sensitive match
      }).toList();

      // if (mounted) {
      //   setState(() {
      //     updateItemsFromScanResults(_scanResults); // Call update method here
      //   });
      // }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });
    //
    // _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
    //   _scanResults = results;
    //
    //   if (mounted) {
    //     setState(() {
    //       updateItemsFromScanResults(_scanResults); // Call update method here
    //     });
    //   }
    // }, onError: (e) {
    //   Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    // });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _controller.dispose();
    _lastValueSubscription.cancel();

    isConnected =false;
    isSubscribe =false;
    isGetData =false;
    count =0;
    super.dispose();
  }

  // void onConnectPressed(BluetoothDevice device) {
  //   device.connectAndUpdateStream().catchError((e) {
  //     Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
  //   });
  // }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
          success: false);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    if (mounted) {
      // setState(() {});
    }
  }

  void connectDevice(BluetoothDevice device) {
    device.connect().then((_) {
      // Connection successful
      Snackbar.show(ABC.c, "Connected to ${device.remoteId}", success: true);
    }).catchError((e) {
      // Connection failed, retry after delay
      Snackbar.show(ABC.c, "Connect Error: ${prettyException("Error:", e)}",
          success: false);
      Future.delayed(Duration(seconds: 5), () {
        connectDevice(device); // Retry connection
      });
    });
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
      bool critical = response.substring(18, 20) == '00';
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

  bool isConnected =false;
  bool isSubscribe =false;
  bool isGetData =false;
  var count  =0;
  bool isCount = false;


  Future GetData()async
  {
    isLoading = true;
    print("Searched Device");
    Utils.device =_scanResults[0].device;
    developer.log("Scan Results:-${_scanResults[0].toString()}");
    developer.log("Scan Results:-${_scanResults[0].runtimeType.toString()}");
    developer.log("Scan Results array:-${_scanResults.toString()}");
    developer.log("Scan length:-${_scanResults.length.toString()}");
    print(_scanResults[0]);
    print(_scanResults[0].device.toString());
    print(_scanResults[0].device.connect());
    print(_scanResults[0].device.connectAndUpdateStream());
    _scanResults[0].device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(
          ABC.c,
          prettyException(
              "Connect Error:",
              e),
          success: false);
    });
    print("isConnected:- ${_scanResults[0].device.isConnected}");
    // print(_scanResults[0].device.isConnected);
    if (_scanResults[0].device.isConnected == true) {

      // print(_scanResults[0].device.discoverServices());
      _services = await _scanResults[0].device.discoverServices();
      print("_servicestest");
      developer.log(_services.toString());

      for (var service in _services) {
        // Loop through each characteristic in the service
        for (var characteristic in service.characteristics) {
          // Check if the characteristic UUID matches the writeCharacteristicUUID
          if (characteristic.uuid.toString() == Utils.writeCharacteristicUUID) {
            Utils.Writecharacteristic = characteristic;
          }
          // Check if the characteristic UUID matches the readCharacteristicUUID
          else if (characteristic.uuid.toString() == Utils.readCharacteristicUUID) {
            Utils.Readcharacteristic = characteristic;
          }
        }
      }

      // developer.log("Readcharacteristic:-${Readcharacteristic.toString()}");
      developer.log("Readcharacteristic:-${Utils.Readcharacteristic.characteristicUuid.toString()}");

      // developer.log("Writecharacteristic:-${Writecharacteristic.toString()}");
      developer.log("Writecharacteristic:-${Utils.Writecharacteristic.characteristicUuid.toString()}");

      for (var service in _services) {
        // Loop through each characteristic in the service
        for (var characteristic in service.characteristics) {
          // Add each characteristic to the _characteristic list
          _characteristic.add(characteristic);
        }
      }
      // print("_characteristic-------------------------->");
      developer.log("_characteristic--->" + _characteristic.toString());
      print("_characteristic length ->${_characteristic.length}");

      onSubscribePressed(Utils.Readcharacteristic);
      subscribeToCharacteristic(Utils.Readcharacteristic);


      print("Remote:-${Utils.Writecharacteristic.remoteId}");
      print("serviceUuid:-${Utils.Writecharacteristic.serviceUuid}");
      print("characteristicUuid:-${Utils.Writecharacteristic.characteristicUuid}");
      print("secondaryServiceUuid:-${Utils.Writecharacteristic.secondaryServiceUuid}");

      // onSubscribePressed(Utils.Readcharacteristic);
      // print("Read---->Read---->");
      print("Read From:-${Utils.Readcharacteristic.characteristicUuid}");
      print("Is Subscribed:-${Utils.Readcharacteristic.isNotifying}");

      if (Utils.Readcharacteristic.isNotifying ==
          true) {
        onWritePressedgenreq(Utils.Writecharacteristic);
        // print(_characteristic[_characteristic.length-2].characteristicUuid);
        onReadPressed(Utils.Readcharacteristic);
        _lastValueSubscription = Utils.Readcharacteristic.lastValueStream.listen((value) {
          _value = value;});

        String data = _value.toString();
        // print("Data:-${data}");
        print("RecData:-${data}");


        if(_value.isNotEmpty){
          List<String> hexList = _value
              .map((decimal) => decimal.toRadixString(16).padLeft(2, '0'))
              .toList();
          String hexString = hexList.join('');
          print("When Data is not null:-${data}");
          print("hexString:-${hexString}");

          _deviceResponse = parseDeviceResponse(hexString);

          // print(_deviceResponse?.battery.toString());
          // setState(() {
          Utils.battery = "${_deviceResponse?.battery.toString()}";
          Utils.weight = "${_deviceResponse?.beforeDecimal}.${_deviceResponse?.afterDecimal}";
          Utils.remainGas = calculateGasPercentage(double.parse(Utils.weight)).toStringAsFixed(0);
          // });
          print("battery:-${_deviceResponse?.battery.toString()}");
          print("weight:-${_deviceResponse?.beforeDecimal}.${_deviceResponse?.afterDecimal}");

          Fluttertoast.showToast(
            msg: 'Device Connect successfully!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Future.delayed(
              Duration(
                  seconds: 1),
                  () {
                _lastValueSubscription.cancel();
                showCustomDialog(context);
              });
          isLoading = false;

          isGetData=true;
        }
        isSubscribe = true;
      }
      isConnected =true;
    }

    // onConnectPressed(_scanResults[0].device);
    // onConnectPressedee(_scanResults[0].device);
    // onDiscoverServicesPressed(_scanResults[0].device);

    // _launchTask(_scanResults[0].device.toString());

    // showCustomDialog(context);
  }



  // void onConnectPressed(BluetoothDevice device) {
  //   // Try to connect to the device
  //   device.connect().then((_) {
  //     print("<-------------Connected --------------->");
  //     // Connection successful, show success toast
  //     Snackbar.show(ABC.c, "Connected to ${device.remoteId}", success: true);
  //   }).catchError((e) {
  //     print("<------------- Not Connected --------------->");
  //     // Connection failed, show error toast
  //     Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    developer.log("_scanResults ---->${_scanResults.toString()}");
    // developer.log("items ---->${items}");
    // developer.log("items ---->${items[2].name}");

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Container dimensions
    var containerHeight = height / 2;
    var containerWidth = width;

    // Center of the container
    var centerX = containerWidth / 2;
    var centerY = containerHeight / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adding Manually",
          style: AppStyles.appBarTextStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: height / 2,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: AnimatedBuilder(

                                        animation: _animation,
                                        builder: (context, child) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              buildRadarCircle(
                                                  250 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.1)),
                                              buildRadarCircle(
                                                  200 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.2)),
                                              buildRadarCircle(
                                                  150 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.3)),
                                              buildRadarCircle(
                                                  100 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.4)),
                                              buildRadarCircle(
                                                  50 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.5)),
                                              buildRadarCircle(
                                                  25 * _animation.value,
                                                  Colors.purple
                                                      .withOpacity(0.6)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // If items are available, show their avatars

                                    FutureBuilder(
                                      future:
                                      Future.delayed(Duration(seconds: 3)),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        // Check the connection state of the Future
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Optionally, show a loading indicator while waiting
                                          return Container();
                                            // Center(
                                          //     child:
                                          //     CircularProgressIndicator());
                                        } else {
                                          return Stack(
                                            // Use a Stack to allow Positioned widgets
                                            children: [
                                              if (_scanResults.isNotEmpty)
                                                Positioned(
                                                  left: centerX + 80,
                                                  bottom: centerY,
                                                  child: InkWell(
                                                    onTap: () async {
                                                        var count =0;
                                                        while(!isConnected || !isSubscribe || !isGetData){
                                                          print("isConnected:-${isConnected}");
                                                          print("isSubscribe:-${isSubscribe}");
                                                          print("isGetData:-${isGetData}");

                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds:
                                                                  5));

                                                          GetData();
                                                          count++;
                                                          print("while Count:-${count}");
                                                          print("while isConnected :-${isConnected}");
                                                          print("while isSubscribe:-${isSubscribe}");
                                                        }


                                                      // GetData();
                                                      // if (count<5){
                                                      //   while(!isConnected || !isSubscribe || !isGetData  ){
                                                      //     print("isConnected:-${isConnected}");
                                                      //     print("isSubscribe:-${isSubscribe}");
                                                      //     print("isGetData:-${isGetData}");
                                                      //     await Future.delayed(
                                                      //         Duration(
                                                      //             seconds:
                                                      //             1));
                                                      //
                                                      //     GetData();
                                                      //     print("Count:-${count}");
                                                      //     count++;
                                                      //
                                                      //
                                                      //   }
                                                      // }else{
                                                      //   Fluttertoast.showToast(
                                                      //     msg:
                                                      //     'Something Went Wrong',
                                                      //     toastLength:
                                                      //     Toast.LENGTH_LONG,
                                                      //     gravity: ToastGravity
                                                      //         .BOTTOM,
                                                      //     backgroundColor:
                                                      //     Colors.green,
                                                      //     textColor:
                                                      //     Colors.white,
                                                      //     fontSize: 16.0,
                                                      //   );
                                                      // }

                                                    },

                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit:
                                                            BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor:
                                                          Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[0]
                                                              .device
                                                              .platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (_scanResults.length > 1)
                                                Positioned(
                                                  right: centerX,
                                                  bottom: centerY + 90,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      try {
                                                        await _scanResults[1]
                                                            .device
                                                            .connect();
                                                        await _scanResults[1]
                                                            .device
                                                            .createBond(); // If this completes without exception, assume success
                                                        Fluttertoast.showToast(
                                                          msg:
                                                          'Device bonded successfully!',
                                                          toastLength:
                                                          Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                          Colors.green,
                                                          textColor:
                                                          Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      } catch (e) {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                          'Failed to bond the device: ${e.toString()}',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                          Colors.red,
                                                          textColor:
                                                          Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      }
                                                      showCustomDialog(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit:
                                                            BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor:
                                                          Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[1]
                                                              .device
                                                              .platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (_scanResults.length > 2)
                                                Positioned(
                                                  right: centerX + 20,
                                                  bottom: centerY,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showCustomDialog(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Image.asset(
                                                            "assets/images/ListIcons/autobooking.png",
                                                            width: 10,
                                                            color: Colors.white,
                                                            fit:
                                                            BoxFit.fitWidth,
                                                          ),
                                                          backgroundColor:
                                                          Color(0xF2A4386B),
                                                          radius: 20,
                                                        ),
                                                        Text(
                                                          _scanResults[2]
                                                              .device
                                                              .platformName, // Accessing item name
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Cerapro',
                                                            fontSize: 11,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: Future.delayed(Duration(seconds: 3)),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Text(
                                        "Scanning for nearby devices. Please ensure your Bluetooth is turned on and you are close to the device",
                                        textAlign: TextAlign.center,
                                        style: AppStyles.customTextStyle(
                                          fontSize: 14,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                  return  isLoading
                                      ? Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      size: 80,
                                      color:
                                      AppStyles.cutstomIconColor,
                                    ),
                                  ):Container(
                                    child: Center(
                                      child: Text(
                                        "Device found. Please tap to add the device",
                                        textAlign: TextAlign.center,
                                        style: AppStyles.customTextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                        ), // Style for the text
                                      ),
                                    ),
                                  );
                                  //   ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: const Color(0xFFFA7365),
                                  //     shape: const StadiumBorder(),
                                  //   ),
                                  //   onPressed: () {
                                  //     onScanPressed();
                                  //   },
                                  //   child: const Text(
                                  //     "Scan Again",
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // );
                                },
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
    );
  }

  Widget buildRadarCircle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.cancel,
                        size: 35,
                        color: AppStyles.cutstomIconColor,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/AddyourdeviceScreen/poupimage.png",
                  fit: BoxFit.fitWidth,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                // Name
                Center(
                  child: Text(
                    'Device Selected',
                    style: AppStyles.customTextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                ),
                Center(
                  child: Text(
                    'Successfully',
                    style: AppStyles.customTextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 20),
                // Done Button
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.of(context).pop();
                      // await Future.delayed(Duration(seconds: 3));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const FullOtherInformation()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppStyles.cutstomIconColor, // Button background color
                      foregroundColor: Colors.white, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      minimumSize: const Size(200, 50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15), // Adjust button size
                      elevation: 5, // Elevation (shadow)
                    ),
                    child: Text(
                      'Done',
                      style: AppStyles.customTextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Item {
  final String name;
  final double distance;

  Item({required this.name, required this.distance});
}