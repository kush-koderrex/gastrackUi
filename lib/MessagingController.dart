import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:gas_track_ui/LocalStorage.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'package:gas_track_ui/utils/NotificationClass.dart';
import 'Utils/Utils.dart';
import 'firebase_options.dart';
import 'dart:developer' as developer;

StreamController<RemoteMessage> streamController =
    StreamController<RemoteMessage>.broadcast();

class MessagingController {
  /// Sets up Firebase and Firebase Messaging
  Future<void> setupFirebase() async {
    // Initialize Firebase app
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Handle incoming messages when app is in the foreground
    FirebaseMessaging.onMessage.listen(firebaseOnMessagingHandler);

    // Request notification permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        developer.log("FCM Token refreshed: $token");
      }
      // Update token in Firestore or backend
      updateFirebaseTokenWithToken(token);
    });
  }

  /// Updates the FCM token for the current user
  Future<void> updateFirebaseToken() async {
    var userData = await UserPreferences().getUserData();
    var token = await FirebaseMessaging.instance.getToken();
    var id = (Utils.cusUuid.isNotEmpty) ? Utils.cusUuid : userData["email"]!;

    if (token != null) {
      await FirestoreService().updateFCMToken(
        customerId: id,
        fcmToken: token,
      );
      print(token);
      print('FCM Token updated in Firestore successfully for ${id}');
    } else {
      if (kDebugMode) {
        developer.log("Failed to generate FCM token.");
      }
    }
  }

  /// Updates the FCM token using the provided token
  Future<void> updateFirebaseTokenWithToken(String token) async {
    var userData = await UserPreferences().getUserData();
    var id = (Utils.cusUuid.isNotEmpty) ? Utils.cusUuid : userData["email"]!;

    await FirestoreService().updateFCMToken(
      customerId: id,
      fcmToken: token,
    );
    print(token);
    print('FCM Token updated in Firestore successfully for ${id}');
  }
}

/// Handles incoming messages when the app is in the foreground
Future<void> firebaseOnMessagingHandler(RemoteMessage message) async {
  if (message.notification == null) {
    return;
  }

  // Initialize and display notifications
  NotificationClass.initNotifications();
  NotificationClass.showNotification(
    title: message.notification!.title ?? '',
    body: message.notification!.body ?? '',
  );

  // Broadcast the message to listeners
  streamController.add(message);

  if (kDebugMode) {
    developer.log('Handling a foreground message: ${message.messageId}');
  }
}

/// Sets up Firebase Crashlytics to handle errors
void setupCrashlytics() {
  const fatalError = true;

  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}

// import 'dart:async';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:gas_track_ui/LocalStorage.dart';
// import 'package:gas_track_ui/Services/FirebaseSevice.dart';
// import 'package:gas_track_ui/utils/NotificationClass.dart';
//
//
// import 'Utils/Utils.dart';
// import 'firebase_options.dart';
// import 'dart:developer' as developer;
//
// StreamController streamController = StreamController.broadcast();
//
// class MessagingController {
//   Future setupFirebase() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     FirebaseMessaging.onMessage.listen(firebaseOnMessagingHandler);
//     FirebaseMessaging.instance
//         .requestPermission(alert: true, sound: true, badge: true);
//     FirebaseMessaging.instance.onTokenRefresh.listen((event) {
//       if (kDebugMode) {
//         // developer.log(event);
//       }
//       // if (event.isNotEmpty) {
//       //   postToken(event);
//       // }
//     });
//   }
//
//
//
//   // updateFirebaseToken() async {
//   //   var token = await FirebaseMessaging.instance.getToken();
//   //   if (kDebugMode) {
//   //     developer.log(token.toString());
//   //   }
//   //   if (token != null) {
//   //     postToken(token);
//   //   }
//   // }
//
//   void updateFirebaseToken() async {
//     var userData = await UserPreferences().getUserData();
//     var token = await FirebaseMessaging.instance.getToken();
//
//     if (token != null) {
//       await FirestoreService().updateFCMToken(
//         customerId: Utils.cusUuid == null ? userData["email"]! : Utils.cusUuid,
//         fcmToken: token,
//       );
//       print('FCM Token updated in Firestore successfully for ${Utils.cusUuid == null ? userData["email"]! : Utils.cusUuid}');
//     }
//   }
//   // postToken(fcmtoken) {
//   //   if (token.isNotEmpty) {
//   //     httpPost(Urls.updateFirbaseToken, {"firebase_token": fcmtoken});
//   //   }
//   // }
// }
//
// Future<void> firebaseOnMessagingHandler(RemoteMessage message) async {
//   if (message.notification == null) {
//     return;
//   }
//   NotificationClass.initNotifications();
//   NotificationClass.showNotification(
//       title: "${message.notification!.title}",
//       body: "${message.notification!.body}");
//
//   // streamController.add(message);
//   if (kDebugMode) {
//     // developer.log('Handling a Foreground message ${message.messageId}');
//   }
// }
//
// @pragma('vm:entry-point')
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// //   // NotificationClass.initNotifications();
// //   // NotificationClass.showNotification(title: "${message.notification!.title}",body: "${message.notification!.body}");
// //
// //   if (message.messageId == null) {
// //     return;
// //   }
// //   streamController.add(message);
// //
// //   var pref = await SharedPreferences.getInstance();
// //   var unread = pref.get(Utils.countUnread);
// //   if (unread != null) {
// //     int.parse("$unread");
// //     if (kDebugMode) {
// //       // developer.log("UPDATEDD VALUE");
// //     }
// //     if (kDebugMode) {
// //       // developer.log((int.parse("$unread") + 1).toString());
// //     }
// //     pref.setInt(Utils.countUnread, (int.parse("$unread") + 1));
// //     // Controller.unreadCount.value=(int.parse("$unread")+1);
// //   }
// //   pref.setInt(Utils.countUnread, (int.parse("1")));
// //   if (kDebugMode) {
// //     // developer.log('Handling a background message ${message.messageId}');
// //   }
// // }
//
// setupCrashlytics() {
//   const fatalError = true;
//   FlutterError.onError = (errorDetails) {
//     if (fatalError) {
//       // If you want to record a "fatal" exception
//       FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
//       // ignore: dead_code
//     } else {
//       // If you want to record a "non-fatal" exception
//       FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
//     }
//   };
//   // Async exceptions
//   PlatformDispatcher.instance.onError = (error, stack) {
//     if (fatalError) {
//       // If you want to record a "fatal" exception
//       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//       // ignore: dead_code
//     } else {
//       // If you want to record a "non-fatal" exception
//       FirebaseCrashlytics.instance.recordError(error, stack);
//     }
//     return true;
//   };
// }
