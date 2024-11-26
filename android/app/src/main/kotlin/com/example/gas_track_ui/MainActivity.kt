package com.example.gas_track_ui

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity: FlutterActivity()


//package com.gastrack.gtrack_background

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.work.*
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileWriter
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.UUID
import java.util.concurrent.TimeUnit
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanSettings
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import android.content.ContentValues
import android.provider.MediaStore
import android.os.Environment
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.gastrack.background/gtrack_process"
    private val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if flutterEngine is not null
        flutterEngine?.dartExecutor?.binaryMessenger?.let { binaryMessenger ->
            MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                val formattedTimestamp = LocalDateTime.now().format(formatter)
                if (call.method == "launchPeriodicTask") {
                    val deviceName = call.argument<String>("device")?: "Project_RED_TTTP"
                    val duration=call.argument<Int>("duration")?: 15
                    requestPermissions()
                    launchPeriodicTask(deviceName,duration)
                    result.success("Successfully launched at: $formattedTimestamp")
                }
                else if (call.method == "viewLogs"){
                    val success = result.success(viewLogs())
                }
                else if (call.method == "viewDeviceLogs"){
                    val success = result.success(viewDeviceLogs())
                }
                else if (call.method == "deleteLogs"){
                    result.success(deleteLogs())
                }
                else if (call.method == "deleteDeviceLogs"){
                    result.success(deleteDeviceLogs())
                }
                else if (call.method == "downloadLogs"){
                    result.success(downloadLogs())
                }
                else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun downloadLogs(): String {
        val fileNames = listOf("gastrack_dlogs.csv", "gastrack_logs.csv")
        val internalStorageDir=applicationContext?.filesDir
        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())

        // Loop through each file and move it to the system-wide Downloads directory
        for (fileName in fileNames) {
            Log.d("LOGS","Filename:$fileName")
            val sourceFile = File(internalStorageDir, fileName)

            // Check if the source file exists
            if (sourceFile.exists()) {
                Log.d("LOGS","Filename:$fileName exists")

                val fileNameWithTimestamp = fileName.replace(".csv", "_$timestamp.csv")

                try {
                    // Use MediaStore to add file to Downloads directory
                    val resolver = context.contentResolver
                    val contentValues = ContentValues().apply {
                        put(MediaStore.Downloads.DISPLAY_NAME, fileNameWithTimestamp)
                        put(MediaStore.Downloads.MIME_TYPE, "text/csv")
                        put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                    }

                    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

                    if (uri != null) {
                        resolver.openOutputStream(uri).use { outputStream ->
                            FileInputStream(sourceFile).use { inputStream ->
                                inputStream.copyTo(outputStream!!)
                            }
                        }

                        Log.d("LOGS", "$fileName moved successfully to $fileNameWithTimestamp in Downloads.")

                    } else {
                        Log.e("LOGS", "Failed to create URI for $fileNameWithTimestamp.")
                        return "Failed to download log files"

                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("LOGS", "Failed to move $fileName: ${e.message}")
                    return "Failed to download log files"

                }
            } else {
                Log.e("LOGS", "$fileName does not exist in the internal storage.")
                return "Failed to download log files"

            }
        }
        return "Downloaded logs successfully"
    }

    private fun viewDeviceLogs(): String {
        val logFile = File(applicationContext.filesDir, "gastrack_dlogs.csv")
        val directory=applicationContext?.filesDir
        if (logFile.exists()){
            Log.d("LOGS","Log file exists. Returning Content")
            return logFile.readText()
        }
        else{
            return "Log File does not exist"
        }
    }

    private fun viewLogs(): String {
        val logFile = File(applicationContext.filesDir, "gastrack_logs.csv")
        val directory=applicationContext?.filesDir
        if (logFile.exists()){
            Log.d("LOGS","Log file exists. Returning Content")
            return logFile.readText()
        }
        else{
            return "Log File does not exist"
        }
    }
    private fun deleteLogs(): String {
        val logFile = File(applicationContext.filesDir, "gastrack_logs.csv")
        val directory=applicationContext?.filesDir
        if (logFile.exists()){
            logFile.delete()
            return "Log File deleted Successfully"
        }
        else{
            return "Log File does not exist"
        }
    }

    private fun deleteDeviceLogs(): String {
        val logFile = File(applicationContext.filesDir, "gastrack_dlogs.csv")
        val directory=applicationContext?.filesDir
        if (logFile.exists()){
            logFile.delete()
            return "Log File deleted Successfully"
        }
        else{
            return "Log File does not exist"
        }
    }

    // Request the necessary permissions
    private fun requestPermissions() {
        val permissions =
            arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.POST_NOTIFICATIONS,
                Manifest.permission.WAKE_LOCK
            )

        if (
            permissions.all {
                ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
            }
        ) {
            // Permissions are already granted
            return
        }

        // Request permissions
        val REQUEST_CODE_PERMISSIONS = 1001 // Define the request code here
        ActivityCompat.requestPermissions(this, permissions, REQUEST_CODE_PERMISSIONS)
    }

    // Launch the Work manager worker thread
    private fun launchPeriodicTask(deviceName:String,duration:Int) {
        val inputData = Data.Builder()
            .putString("device", deviceName)
            .build()
        val workManager = WorkManager.getInstance(applicationContext)

        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
            .setRequiresCharging(false)
            .setRequiresBatteryNotLow(false)
            .setRequiresStorageNotLow(false)
            .setRequiresDeviceIdle(false)
            .build()

        val periodicWorkRequest =
            PeriodicWorkRequestBuilder<SampleWorker>(duration.toLong(), TimeUnit.MINUTES)
                .setInitialDelay(10, TimeUnit.SECONDS)
                .addTag("critical_gas_check")
                .setInputData(inputData)  // Set the input data here
                .setConstraints(constraints)
                .build()
        workManager.enqueueUniquePeriodicWork(
            "PeriodicTask",
            ExistingPeriodicWorkPolicy.REPLACE,
            periodicWorkRequest
        )
    }
}

// Work manager worker class
class SampleWorker(appContext: Context, params: WorkerParameters) : Worker(appContext, params) {
    private val logFileName = "gastrack_logs.csv"
    private val dlogFileName = "gastrack_dlogs.csv"
    private val logFile: File = File(applicationContext.filesDir, logFileName)
    private val dlogFile: File = File(applicationContext.filesDir, dlogFileName)
    private val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
    private var startTime= LocalDateTime.now()

    private fun logDeviceData(data: List<String>) {
        try {
            val fileWriter = FileWriter(dlogFile, true) // Append mode
            val csvLine = data.joinToString(",") + "\n"
            Log.d("LOGS", "Writing $csvLine to the logs")
            fileWriter.write(csvLine)
            fileWriter.flush()
            fileWriter.close()
        } catch (e: Exception) {
            Log.e("CsvLogger", "Error writing to CSV log: ${e.message}")
        }
    }

    private fun logData(data: List<String>) {
        try {
            val fileWriter = FileWriter(logFile, true) // Append mode
            val csvLine = data.joinToString(",") + "\n"
            Log.d("LOGS", "Writing $csvLine to the logs")
            fileWriter.write(csvLine)
            fileWriter.flush()
            fileWriter.close()
        } catch (e: Exception) {
            Log.e("CsvLogger", "Error writing to CSV log: ${e.message}")
        }
    }

    override fun doWork(): Result {
        val formattedTimestamp = LocalDateTime.now().format(formatter)

        // Check if the permissions are granted
        if (
            ContextCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.BLUETOOTH_CONNECT
            ) == PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            // Initialize Bluetooth and start the BLE scan
            val bluetoothManager =
                applicationContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            val bluetoothAdapter = bluetoothManager.adapter
            if (bluetoothAdapter != null && bluetoothAdapter.isEnabled) {
                logDeviceData(listOf(formattedTimestamp,"BLE Scan Initiated"))
                val deviceName = inputData.getString("device") ?: "Project_RED_TTTP"
                startBLEScan(bluetoothAdapter,deviceName)
                return Result.success()
            } else {
                logDeviceData(listOf(formattedTimestamp,"ERROR:","Bluetooth is disabled or not available."))
                return Result.failure()
            }
        } else {
            logDeviceData(listOf(formattedTimestamp,"ERROR:","Bluetooth permissions not granted"))
            return Result.failure()
        }
        return Result.success()
    }

    private fun closeConnection(gatt: BluetoothGatt?) {
        try {
            gatt?.let {
                it.disconnect()
                it.close() // Optionally close the GATT connection
            }
        } catch (e: Exception) {
            Log.e("BluetoothGatt", "Failed to close GATT connection: ${e.message}", e)
        }
    }

    private fun startBLEScan(bluetoothAdapter: BluetoothAdapter,deviceName: String) {
        val bondedDevices = bluetoothAdapter.bondedDevices
        val formattedTimestamp = LocalDateTime.now().format(formatter)

        val bondedDevice = bondedDevices.firstOrNull { it.name == deviceName }
        if (bondedDevice != null) {
            logDeviceData(listOf(formattedTimestamp, "Device found in bonded list. Connecting directly to $deviceName"))
            Log.d(formattedTimestamp, "Device found in bonded list. Connecting directly to $deviceName")
            connectToGatt(bondedDevice, deviceName)
        }else{
            logDeviceData(listOf(formattedTimestamp, "Device not found in bonded list. Starting BLE scan for $deviceName"))
            Log.d(formattedTimestamp, "Device not found in bonded list. Starting BLE scan for $deviceName")
            val SCAN_TIMEOUT_MS = 30000L // Set timeout duration (e.g., 20 seconds)
            val handler = Handler(Looper.getMainLooper())
            val bluetoothLeScanner = bluetoothAdapter.bluetoothLeScanner
            val formattedTimestamp = LocalDateTime.now().format(formatter)
            val scanCallback =
                object : ScanCallback() {
                    override fun onScanResult(callbackType: Int, result: ScanResult?) {
                        super.onScanResult(callbackType, result)
                        val scanResult = result?.device?.name ?: "Unknown Device"
                        if (scanResult == deviceName) {
                            bluetoothLeScanner.stopScan(this) // Stop scanning after the device is found
                            handler.removeCallbacksAndMessages(null)
                            if (result?.device!=null) {
                                val gasTrackDevice: BluetoothDevice = result.device
                                connectToGatt(gasTrackDevice, deviceName)
                            }
                        }
                    }
                    override fun onScanFailed(errorCode: Int) {
                        super.onScanFailed(errorCode)
                        logDeviceData(listOf(formattedTimestamp,"ERROR:Scan failed with error code: $errorCode"))
                    }
                }
            val scanFilter = ScanFilter.Builder()
                .setDeviceName(deviceName)
                .build()
            val scanSettings = ScanSettings.Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                .build()

            bluetoothLeScanner.startScan(listOf(scanFilter), scanSettings, scanCallback)
            // Schedule the timeout task
            handler.postDelayed({
                bluetoothLeScanner.stopScan(scanCallback) // Stop scanning after the timeout
                logDeviceData(listOf(formattedTimestamp,"ERROR:Scan timed out after ${SCAN_TIMEOUT_MS / 1000} seconds"))
            }, SCAN_TIMEOUT_MS)
        }



    }

    private fun connectToGatt(gasTrackDevice:BluetoothDevice,deviceName: String){
        val serviceUUID = UUID.fromString("f000c0c0-0451-4000-b000-000000000000")
        val writeCharacteristicUUID = UUID.fromString("f000c0c1-0451-4000-b000-000000000000")
        val readCharacteristicUUID = UUID.fromString("f000c0c2-0451-4000-b000-000000000000")

        gasTrackDevice.connectGatt(
            applicationContext,
            false,
            object : BluetoothGattCallback() {

                // GATT Connection change call back
                fun calculateBattery(voltage: Double): Int {
                    val minVoltage = 2.0
                    val maxVoltage = 3.1

                    // Ensure that all values are Double for proper division
                    val battery = (((voltage - minVoltage) / (maxVoltage - minVoltage)) * 100).toInt()
                    return battery
                }

                override fun onConnectionStateChange(
                    gatt: BluetoothGatt?,
                    status: Int,
                    newState: Int
                ) {
                    val formattedTimestamp = LocalDateTime.now().format(formatter)
                    if (status == BluetoothGatt.GATT_SUCCESS) {
                        if (newState == BluetoothProfile.STATE_CONNECTED) {
                            //Discover the services
                            gatt?.discoverServices()
                        } else if (
                            newState == BluetoothProfile.STATE_DISCONNECTED
                        ) {
                            logDeviceData(listOf(formattedTimestamp,"ERROR:GATT Disconnected"))
                            closeConnection(gatt)
                        }
                    } else {
                        logDeviceData(listOf(formattedTimestamp,"ERROR:GATT Connection failed with status: $status"))
                        closeConnection(gatt)
                    }
                }

                // GATT Services Discovered Callback
                override fun onServicesDiscovered(
                    gatt: BluetoothGatt?,
                    status: Int
                ) {
                    val service = gatt?.getService(serviceUUID)
                    val readDeviceCharacteristic = service?.getCharacteristic(readCharacteristicUUID)
                    // Write to the device
                    subscribeDevice(gatt, readDeviceCharacteristic)
                }

                // Subscribe to the notification characteristic
                private fun subscribeDevice(
                    gatt: BluetoothGatt?,
                    readDeviceCharacteristic: BluetoothGattCharacteristic?
                ){
                    val formattedTimestamp = LocalDateTime.now().format(formatter)
                    if (readDeviceCharacteristic != null) {
                        gatt?.setCharacteristicNotification(
                            readDeviceCharacteristic,
                            true
                        )
                        val descriptor =
                            readDeviceCharacteristic.getDescriptor(
                                UUID.fromString(
                                    "00002902-0000-1000-8000-00805f9b34fb"
                                )
                            )
                        descriptor.value =
                            BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                        gatt?.writeDescriptor(descriptor)
                    } else {
                        logDeviceData(listOf(formattedTimestamp,"ERROR:Failed to Subscribe!"))
                        closeConnection(gatt)
                    }
                }

                // Write general request to the device
                private fun writeToDevice(
                    gatt: BluetoothGatt?,
                    writeDeviceCharacteristic: BluetoothGattCharacteristic?
                ) {
                    val formattedTimestamp = LocalDateTime.now().format(formatter)
                    if (writeDeviceCharacteristic != null) {
                        val generalRequest =
                            byteArrayOf(
                                0x40.toByte(),
                                0xA8.toByte(),
                                0x00.toByte(),
                                0x01.toByte(),
                                0x01.toByte(),
                                0x01.toByte(),
                                0xAA.toByte(),
                                0x55.toByte()
                            )
                        writeDeviceCharacteristic.value = generalRequest
                        logDeviceData(listOf(formattedTimestamp,"Succes:Write to device Succes"))
                        val success =
                            gatt?.writeCharacteristic(writeDeviceCharacteristic)
                                ?: false
                    } else {
                        logDeviceData(listOf(formattedTimestamp,"ERROR:Write to device failed"))
                        closeConnection(gatt)
                    }
                }

                // Callback function when descriptor is written
                override fun onDescriptorWrite(
                    gatt: BluetoothGatt?,
                    descriptor: BluetoothGattDescriptor?,
                    status: Int
                ) {
                    val formattedTimestamp = LocalDateTime.now().format(formatter)
                    if (status == BluetoothGatt.GATT_SUCCESS) {

                        // Now that the descriptor write is complete, write to
                        // the characteristic
                        logDeviceData(listOf(formattedTimestamp,"Descriptor Write Successful"))

//                                            Log.d("BLE", "Descriptor Write Successful")
                        val service = gatt?.getService(serviceUUID)
                        logDeviceData(listOf(formattedTimestamp,"Initiating write"))
//                                            Log.d("connection", "Initiating write")
                        val writeDeviceCharacteristic =
                            service?.getCharacteristic(writeCharacteristicUUID)
                        writeToDevice(gatt, writeDeviceCharacteristic)
                    } else {
                        // Handle error
                        println("Failed to write descriptor")
                        closeConnection(gatt)
                    }
                }
                // onCharacteristicChanged will be for Notify
                override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                    val currentTimestamp = LocalDateTime.now()
                    val formattedTimestamp = currentTimestamp.format(formatter)

                    val data = characteristic?.value?.joinToString("") { String.format("%02x", it) }
                    val weight="${data?.substring(10,12)?.toInt(16)}.${data?.substring(12,14)}"
                    val voltage=data?.substring(14,16)?.toInt(16)?.div(10.0)?:0.0
                    val criticalFlag:String?= data?.substring(18,20)
                    val battery = calculateBattery(voltage)
                    val device_id= deviceName.last()
                    logDeviceData(listOf(formattedTimestamp,"Device Response Successful $data"))

                    val duration: Duration = Duration.between(startTime, currentTimestamp)
                    val secondsDifference: Long = duration.toSeconds()
                    logDeviceData(listOf(formattedTimestamp,"Response:$data", "Secs:$secondsDifference"))

                    if (criticalFlag=="01"){
                        showNotification(
                            12,
                            "Critical Alert",
                            "Elapsed:$secondsDifference secs. $deviceName Cylinder is low on gas! Please order!"
                        )
                    }
                    logData(listOf(formattedTimestamp,"$device_id Weight:$weight","Battery:$battery","Voltage:$voltage","Critical:$criticalFlag"))
                    closeConnection(gatt)
                }
                //Call back function when characteristic is read
                override fun onCharacteristicRead(
                    gatt: BluetoothGatt?,
                    characteristic: BluetoothGattCharacteristic?,
                    status: Int
                ) {
                    val currentTimestamp = LocalDateTime.now()
                    val formattedTimestamp = currentTimestamp.format(formatter)
                    if (status == BluetoothGatt.GATT_SUCCESS) {
                        val data = characteristic?.value?.joinToString("") { String.format("%02x", it) }
                        val weight="${data?.substring(10,12)?.toInt(16)}.${data?.substring(12,14)}"
                        val voltage=data?.substring(14,16)?.toInt(16)?.div(10.0)?:0.0
                        val criticalFlag: String?= data?.substring(18,20)
                        val battery = calculateBattery(voltage)
                        val device_id= deviceName.last()

                        val duration: Duration = Duration.between(startTime, currentTimestamp)
                        val secondsDifference: Long = duration.toSeconds()
                        logDeviceData(listOf(formattedTimestamp,"Response:$data", "Secs:$secondsDifference"))


                        if (criticalFlag=="01"){
                            showNotification(
                                12,
                                "Critical Alert",
                                "Elapsed:$secondsDifference secs. $deviceName Cylinder is low on gas! Please order!"
                            )
                        }
                        logData(listOf(formattedTimestamp,"$device_id Weight:$weight","Battery:$battery","Voltage:$voltage","Critical:$criticalFlag"))
                        closeConnection(gatt)
                    } else {
                        logDeviceData(listOf(formattedTimestamp,"ERROR:Failed to read characteristic"))
                        closeConnection(gatt)
                    }
                }

                // Callback function when a characterisitc is Written
                override fun onCharacteristicWrite(
                    gatt: BluetoothGatt?,
                    characteristic: BluetoothGattCharacteristic?,
                    status: Int
                ) {
                    val formattedTimestamp = LocalDateTime.now().format(formatter)


                    if (status == BluetoothGatt.GATT_SUCCESS) {
                        logDeviceData(listOf(formattedTimestamp,"General Request Successful"))

                        // check for notification
                        val serviceUUID=UUID.fromString("f000c0c0-0451-4000-b000-000000000000");
                        val readCharacteristicUUID=UUID.fromString("f000c0c2-0451-4000-b000-000000000000");
                        val service = gatt?.getService(serviceUUID)
                        val readCharacteristic = service?.getCharacteristic(readCharacteristicUUID)
                        gatt?.readCharacteristic(readCharacteristic)

                    } else {
                        logDeviceData(listOf(formattedTimestamp,"ERROR:General Request Failed"))
                        closeConnection(gatt)
                    }
                }
            },2
        )
    }

    private fun showNotification(notif_id: Int, title: String, message: String) {
        val channelId = "background_task_channel"
        val notificationId = notif_id

        // Create a notification channel if the device is running Android 8.0 (Oreo) or higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Background Task Channel"
            val descriptionText = "Channel for background task notifications"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel =
                NotificationChannel(channelId, name, importance).apply {
                    description = descriptionText
                }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }

        // Build the notification
        val builder =
            NotificationCompat.Builder(applicationContext, channelId)
                .setSmallIcon(R.mipmap.ic_launcher) // Replace with your app icon
                .setContentTitle(title)
                .setContentText(message)
                .setPriority(NotificationCompat.PRIORITY_HIGH)

        // Show the notification
        with(NotificationManagerCompat.from(applicationContext)) {
            notify(notificationId, builder.build())
        }
    }
}


