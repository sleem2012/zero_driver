import 'dart:io';

import 'package:driver/injection_container.dart' as di;
import 'package:driver/logic_layer/change_availability/change_availabilty_cubit.dart';
import 'package:driver/logic_layer/change_status/change_status_cubit.dart';
import 'package:driver/logic_layer/current_trip/current_trip_cubit.dart';
import 'package:driver/logic_layer/destination/destination_cubit.dart';
import 'package:driver/logic_layer/my_trips/my_trips_cubit.dart';
import 'package:driver/logic_layer/phone_verfication/phone_verfication_cubit.dart';
import 'package:driver/logic_layer/user_info/user_info_cubit.dart';
import 'package:driver/ui_layer/helpers/lang/lang.dart';
import 'package:driver/ui_layer/screens/blocked/blocked_screen.dart';
import 'package:driver/ui_layer/screens/chat/chat_screen.dart';
import 'package:driver/ui_layer/screens/complete_registration/complete_data.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/screens/destination/destination_screen.dart';
import 'package:driver/ui_layer/screens/help/help_screen.dart';
import 'package:driver/ui_layer/screens/home/home_screen.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:driver/ui_layer/screens/login/login_screen.dart';
import 'package:driver/ui_layer/screens/my_trips/my_trips_screen.dart';
import 'package:driver/ui_layer/screens/my_wallet/my_wallet_screen.dart';
import 'package:driver/ui_layer/screens/on_boarding/on_boarding_screen.dart';
import 'package:driver/ui_layer/screens/permission/permission_screen.dart';
import 'package:driver/ui_layer/screens/points/points_screen.dart';
import 'package:driver/ui_layer/screens/complete_registration/complete_registeration.dart';
import 'package:driver/ui_layer/screens/sign_up/sign_up_screen.dart';
import 'package:driver/ui_layer/screens/splash_screen/splash_screen.dart';
import 'package:driver/ui_layer/screens/support/support_screen.dart';
import 'package:driver/ui_layer/screens/update_profile/update_profile_screen.dart';
import 'package:driver/ui_layer/screens/complete_registration/update_car_info.dart';
import 'package:driver/ui_layer/screens/complete_registration/update_driver_license.dart';
import 'package:driver/ui_layer/screens/welcome_ads/welcome_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'domain_layer/local/shared_preferences.dart';
import 'domain_layer/remote/remote.dart';
import 'logic_layer/ads_cubit/ads_cubit.dart';
import 'logic_layer/check_profile/check_profile_cubit.dart';
import 'logic_layer/points/points_cubit.dart';
import 'logic_layer/receiver_details/get_receiver_details_cubit.dart';
import 'logic_layer/start_or_finish/start_or_finish_cubit.dart';
import 'logic_layer/trip_info/get_order_list_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Intl.defaultLocale = 'en';

  di.setUp();
  await Nations.boot(AppLangConfig());
  await DioHelper.init();
  await sharedPreferences();
  await Firebase.initializeApp();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
    'logo',
  );
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification:
              (int i, String? val, String? val2, String? val3) {});

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {});


  runApp(const MyApp());
}

class AndroidGoogleMapsFlutter {
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<GetOrderListCubit>()..getOrderList(),
        ),
        BlocProvider(
          create: (context) => di.sl<ChangeStatusCubit>(),
        ),
        BlocProvider(
            create: (context) => di.sl<ChangeAvailabilityCubit>()..start()),
        BlocProvider(
          create: (context) => di.sl<MyTripsCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CheckProfileCubit>(),
        ),
        BlocProvider(
          create: (context) => CurrentTripCubit()..getCurrentTrip(),
        ),
        BlocProvider(
          create: (context) => PointsCubit(),
        ),
        BlocProvider(
          create: (context) => PhoneVerficationCubit(),
        ),
        BlocProvider(
          create: (context) => StartOrFinishCubit(),
        ),
        BlocProvider(
          create: (context) =>
              GetReceiverDetailsCubit()..emit(GetReceiverDetailsInitial()),
        ),
        BlocProvider(
          create: (context) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (context) => DestinationCubit(),
        ),
        BlocProvider(
          create: (context) => AdsCubit(),
        ),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          locale: Nations.locale,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          supportedLocales: Nations.supportedLocales,
          builder: (BuildContext context, Widget? child) => child!,
          debugShowCheckedModeBanner: false,
          title: 'ZERO-Car',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const PlaceHolderWidget(),
          routes: {
            '/': (BuildContext context) => const SplashScreen(),
            OnBoardingScreen.routeName: (BuildContext context) =>
                const OnBoardingScreen(),
            LoginScreen.routeName: (BuildContext context) =>
                const LoginScreen(),
            SignUpScreen.routeName: (BuildContext context) =>
                const SignUpScreen(),
            HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
            LayoutScreen.routeName: (BuildContext context) =>
                const LayoutScreen(),
            PointsScreen.routeName: (BuildContext context) =>
                const PointsScreen(),
            UpdateDriverLicense.routeName: (BuildContext context) =>
                const UpdateDriverLicense(),
            UpdateCarInfo.routeName: (BuildContext context) =>
                const UpdateCarInfo(),
            CompleteRegisteration.routeName: (BuildContext context) =>
                const CompleteRegisteration(),
            UpdateProfile.routeName: (BuildContext context) =>
                const UpdateProfile(),
            PermissionScreen.routeName: (BuildContext context) =>
                const PermissionScreen(),
            MyTripsScreen.routeName: (BuildContext context) =>
                const MyTripsScreen(),
            MyWalletScreen.routeName: (BuildContext context) =>
                const MyWalletScreen(),
            CurrentTripPlaceHolder.routeName: (BuildContext context) =>
                const CurrentTripPlaceHolder(),
            // '/otp': (BuildContext context) => const OtpScreen(),
            HelpScreen.routeName: (BuildContext context) => const HelpScreen(),
            SupportScreen.routeName: (BuildContext context) =>
                const SupportScreen(),
            CompleteData.routeName: (BuildContext context) =>
                const CompleteData(),
            DestinationScreen.routeName: (BuildContext context) =>
                const DestinationScreen(),
            ChatScreen.routeName: (BuildContext context) => const ChatScreen(),
            BlockedScreen.routeName: (BuildContext context) =>
                const BlockedScreen(),
            WelcomeAds.routeName: (BuildContext context) => const WelcomeAds()
          },
        ),
      ),
    );
  }
}
