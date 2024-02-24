import 'package:cross_fitness/core/const/color_constants.dart';
import 'package:cross_fitness/core/const/global_constants.dart';
import 'package:cross_fitness/core/service/notification_service.dart';
import 'package:cross_fitness/data/user_data.dart';
import 'package:cross_fitness/screens/onboarding/page/onboarding_page.dart';
import 'package:cross_fitness/screens/settings/bloc/settings_bloc.dart';
import 'package:cross_fitness/screens/tab_bar/page/tab_bar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  SystemChrome is there to make sure the
  entire UI won’t turn around when the
  user rotates their phone 90 degrees.
  */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      NotificationService.flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // onSelectNotification: selectNotification,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
    selectNotification(payload);
  }

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;
    final isLoggedIn = currUser != null;
    if (isLoggedIn) {
      GlobalConstants.currentUser = UserData.fromFirebase(currUser);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cross fitness',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: ColorConstants.textColor,
            ),
          ),
          fontFamily: 'NotoSansKR',
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isLoggedIn ? const TabBarPage() : const OnboardingPage(),
      ),
    );
  }

  Future selectNotification(String? payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}
