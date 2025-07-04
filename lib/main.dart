import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/Bloc/user/user_bloc.dart';
import 'package:dirasti/Layout/add_course.dart';
import 'package:dirasti/Layout/notification_page.dart';
import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:huawei_push/huawei_push.dart' hide RemoteMessage, Importance;
import 'package:huawei_push/huawei_push.dart' as huawi show RemoteMessage;
import 'dart:io';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'Layout/calendar.dart';
import 'Layout/home_page.dart';
import 'Layout/on_board.dart';
import 'Layout/setting.dart';
import 'dart:convert';
import './utils/cache.dart';
import 'firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';

// void backgroundMessageCallback(
//     huawi.RemoteMessage remoteMessage, flutterLocalNotificationsPlugin) async {
//   String? data = remoteMessage.data;
//
//   Push.localNotification({
//     HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
//     HMSLocalNotificationAttr.MESSAGE: data
//   });
//   RemoteMessageNotification? notification = remoteMessage.notification;
//   if (notification != null) {
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         data,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             enableLights: true,
//             playSound: true,
//             channel.id,
//             channel.name,
//             //channel.description,
//             icon: 'app_icon',
//             // other properties...
//           ),
//         ));
//   }
// }

void _onMessageReceiveError(Object error) {
  // Called when an error occurs while receiving the data message
}

// Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage message, flutterLocalNotificationsPlugin) async {
//   await Firebase.initializeApp();
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null) {
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             enableLights: true,
//             playSound: true,
//             channel.id,
//             channel.name,
//             //channel.description,
//             icon: 'app_icon',
//             // other properties...
//           ),
//         ));
//   }
// }

// AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'high_importance_channel', // id
//   //'High Importance Notifications', // description
//   importance: Importance.max,
// );
// void _onMessageReceived(
//     huawi.RemoteMessage remoteMessage, flutterLocalNotificationsPlugin) {
//   // Called when a data message is received
//   String? data = remoteMessage.data;
//   RemoteMessageNotification? notification = remoteMessage.notification;
//   if (notification != null) {
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         data,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             enableLights: true,
//             playSound: true,
//             channel.id,
//             channel.name,
//             //channel.description,
//             icon: 'app_icon',
//             // other properties...
//           ),
//         ));
//   }
// }

main() async {
  // await futer();
  //   const platform = MethodChannel('samples.flutter.dev/battery');
  // // try {
  //      platform.invokeMethod('add');
  // } on PlatformException catch (e) {
  //   print( "Failed to get battery level: '${e.message}'.");
  // }

  // const notiplatform = MethodChannel('samples.flutter.dev/noti');
  // try {
  //   await notiplatform.invokeMethod('getBatteryLevel');
  // } on PlatformException catch (e) {
  //   print( "Failed to get battery level: '${e.message}'.");
  // }

  // await dio.init();
  // await cache.init();
  // // cache.remove_data("id");
  // if(cache.get_data("scode")==null){
  //   cache.save_data("scode", Uuid().v4());
  // }
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('app_icon')));
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  // // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessagingBackgroundHandler(message,flutterLocalNotificationsPlugin));
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channelDescription: channel.description,
  //             icon: 'app_icon',
  //           ),
  //         ));
  //   }
  // });
  runApp(App());
}

bool is_init = false;
var home_page_con = PageController(initialPage: 2);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return FutureBuilder<Map<String, dynamic>>(
        future: futer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !is_init) {
            return Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromARGB(255, 221, 221, 231),
                child: Image.asset(
                  "assets/sc.gif",
                  fit: BoxFit.fitHeight,
                ));
          } else {
            if (snapshot.data != null && snapshot.data!['isValid']) {
              is_init = true;
              return MaterialApp(
                title: "دراستي",
                theme: ThemeData(fontFamily: "cairo"),
                useInheritedMediaQuery: true,
                debugShowCheckedModeBanner: false,
                home: cache.get_data("TOKEN1") == null
                    ? OnBoard()
                    : MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (BuildContext context) =>
                          BottomNavBloc(),
                    ),
                  ],
                  child: BlocBuilder<BottomNavBloc, BottomNavState>(
                    builder: (context, state) {
                      return Scaffold(
                        //backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                        bottomNavigationBar: CurvedNavigationBar(
                          backgroundColor: Colors.transparent,
                          color: Colors.transparent,
                          index: context.select(
                                  (BottomNavBloc bloc) =>
                              bloc.state.index),
                          buttonBackgroundColor: orange,
                          height: 65,
                          items: [
                            Icon(Icons.notifications_none,
                                size: 30,
                                color: context.select(
                                        (BottomNavBloc bloc) =>
                                    bloc.state.index) ==
                                    0
                                    ? Colors.white
                                    : blue),
                            Icon(Icons.qr_code_sharp,
                                size: 30,
                                color: context.select(
                                        (BottomNavBloc bloc) =>
                                    bloc.state.index) ==
                                    1
                                    ? Colors.white
                                    : blue),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              // child: Icon(Icons.circle_outlined, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 2 ? Colors.white : blue),
                              child: Image.asset("assets/clogo.png",
                                  height: 40,
                                  color: context.select(
                                          (BottomNavBloc bloc) =>
                                      bloc.state.index) ==
                                      2
                                      ? Colors.white
                                      : blue),
                            ),
                            Icon(Icons.calendar_month_rounded,
                                size: 30,
                                color: context.select(
                                        (BottomNavBloc bloc) =>
                                    bloc.state.index) ==
                                    3
                                    ? Colors.white
                                    : blue),
                            Icon(Icons.settings,
                                size: 30,
                                color: context.select(
                                        (BottomNavBloc bloc) =>
                                    bloc.state.index) ==
                                    4
                                    ? Colors.white
                                    : blue),
                          ],
                          onTap: (index) {
                            context
                                .read<BottomNavBloc>()
                                .change_index(index);
                            home_page_con.jumpToPage(index);
                          },
                        ),
                        body: PageView(
                          physics: BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            context
                                .read<BottomNavBloc>()
                                .change_index(index);
                          },
                          controller: home_page_con,
                          children: [
                            NotificationPage(),
                            AddCourse(),
                            HomePage(),
                            Calendar(),
                            Setting(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              final deviceInfo = snapshot.data!;
              String rejectionReason = "";
              if (!deviceInfo['isPhysicalDevice']) {
                rejectionReason =
                "This app cannot run on emulators or virtual devices for security reasons.";
              } else if (deviceInfo['isDeveloperMode']) {
                rejectionReason =
                "Developer mode must be disabled to use this app.";
              } else if (deviceInfo['isJailbroken']) {
                rejectionReason =
                "This app cannot run on jailbroken/rooted devices.";
              }

              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 80,
                            color: Colors.red,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Access Denied",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            rejectionReason,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}

Future<Map<String, dynamic>> futer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cache.init();
  await dio.init();
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // cache.remove_data("id");
  if (cache.get_data("scode") == null) {
    cache.save_data("scode", Uuid().v4());
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('app_icon')));
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await Future.delayed(Duration(seconds: 4, milliseconds: 500));
  var info = await DeviceInfoPlugin().androidInfo;
  var is_dev = await FlutterJailbreakDetection.developerMode;
  var is_jill = await FlutterJailbreakDetection.jailbroken;

  return {
    'isValid': info.isPhysicalDevice && !is_dev && !is_jill,
    'isPhysicalDevice': info.isPhysicalDevice,
    'isDeveloperMode': is_dev,
    'isJailbroken': is_jill
  };
}
