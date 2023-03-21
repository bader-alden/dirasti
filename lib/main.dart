

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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,flutterLocalNotificationsPlugin) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            enableLights: true,
            playSound: true,
            channel.id,
            channel.name,
            channel.description,
            icon: 'app_icon',
            // other properties...
          ),
        ));
  }
}
 AndroidNotificationChannel channel =  AndroidNotificationChannel(
  'high_importance_channel', // id
  'high_importance_channel', // id
  'High Importance Notifications', // description
  importance: Importance.max,
);
main() async {
  //WidgetsFlutterBinding.ensureInitialized();
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
  runApp( App());
}

var home_page_con=PageController(initialPage: 2);
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
    enabled: false,
      builder: (BuildContext context) {
       return FutureBuilder(
        future: futer(),
         builder: (context,snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Container(width: double.infinity,
                 height: double.infinity,
                 color: Color.fromARGB(255, 221, 221, 231),
                 child: Image.asset("assets/sc.gif", fit: BoxFit.fitHeight,));
           } else {
             return MaterialApp(
               title: "دراستي",
               theme: ThemeData(fontFamily: "cairo"),
               useInheritedMediaQuery: true,
               debugShowCheckedModeBanner: false,
               home: cache.get_data("id") == null
                   ? OnBoard()
                   : MultiBlocProvider(
                 providers: [
                   BlocProvider(
                     create: (BuildContext context) => BottomNavBloc(),
                   ),
                 ],
                 child: BlocBuilder<BottomNavBloc, BottomNavState>(
                   builder: (context, state) {
                     return Scaffold(
                       //backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                       bottomNavigationBar: CurvedNavigationBar(
                         backgroundColor: Colors.transparent,
                         color: Colors.transparent,
                         index: context.select((BottomNavBloc bloc) => bloc.state.index),
                         buttonBackgroundColor: orange,
                         height: 65,
                         items: [
                           Icon(Icons.notifications_none, size: 30,
                               color: context.select((BottomNavBloc bloc) => bloc.state.index) == 0 ? Colors.white : blue),
                           Icon(Icons.qr_code_sharp, size: 30,
                               color: context.select((BottomNavBloc bloc) => bloc.state.index) == 1 ? Colors.white : blue),
                           Padding(
                             padding: const EdgeInsets.all(4.0),
                             // child: Icon(Icons.circle_outlined, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 2 ? Colors.white : blue),
                             child: Image.asset("assets/clogo.png", height: 40,
                                 color: context.select((BottomNavBloc bloc) => bloc.state.index) == 2 ? Colors.white : blue),
                           ),
                           Icon(Icons.calendar_month_rounded, size: 30,
                               color: context.select((BottomNavBloc bloc) => bloc.state.index) == 3 ? Colors.white : blue),
                           Icon(Icons.settings, size: 30, color: context.select((BottomNavBloc bloc) => bloc.state.index) == 4 ? Colors.white : blue),
                         ],
                         onTap: (index) {
                           context.read<BottomNavBloc>().change_index(index);
                           home_page_con.jumpToPage(index);
                         },
                       ),
                       body: PageView(
                         onPageChanged: (index) {
                           context.read<BottomNavBloc>().change_index(index);
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
          }
         }
       );
      },

    );
  }


}
futer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cache.init();

  await dio.init();
  // cache.remove_data("id");
  if(cache.get_data("scode")==null){
    cache.save_data("scode", Uuid().v4());
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('app_icon')));
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  //flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessagingBackgroundHandler(message,flutterLocalNotificationsPlugin));
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'app_icon',
            ),
          ));
    }
  });
  await FirebaseMessaging.instance.subscribeToTopic("all");
  await Future.delayed(Duration(seconds: 5,milliseconds: 500));
  return true;
}