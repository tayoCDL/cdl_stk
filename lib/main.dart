import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sales_toolkit/Enviroment.dart';
import 'package:sales_toolkit/domain/user.dart';
import 'package:sales_toolkit/models/sequest_request.dart';
import 'package:sales_toolkit/util/consts.dart';
import 'package:sales_toolkit/theme/theme_config.dart';
import 'package:sales_toolkit/util/dialogs.dart';
import 'package:sales_toolkit/util/enum/ManageLoginState.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:sales_toolkit/view_models/app_provider.dart';
import 'package:sales_toolkit/view_models/auth_provider.dart';
import 'package:sales_toolkit/view_models/clientList.dart';
import 'package:sales_toolkit/view_models/home_provider.dart';
import 'package:sales_toolkit/view_models/onelogin_provider.dart';
import 'package:sales_toolkit/view_models/save_userRequest.dart';
import 'package:sales_toolkit/view_models/user_provider.dart';
import 'package:sales_toolkit/view_models/verifyotp_provider.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/views/splash/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';

const String onesignalId = "fbfb56c1-16aa-466a-8f6b-85ce4fa4883e";

void main() async{
//  await dotenv.load(fileName: Environment.fileName);
// bool kReleaseMode1 = false;
//  await dotenv.load(fileName: ".env.development");
// // await dotenv.load(fileName: ".env.production");
//  print(dotenv.env["baseUrl"]);
//
//   await Hive.initFlutter();
//   // await Hive.deleteBoxFromDisk('shopping_box');
//   await Hive.openBox('hive_sequest');_
//
//   HiveMethods().createSequestCredential();


  HttpOverrides.global = new MyHttpOverrides();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => OneLoginProvider()),
        ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
        ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ChangeNotifierProvider(create: (_)=>UserProvider()),
        ChangeNotifierProvider(create: (_)=>ClientListProvider()),
        ChangeNotifierProvider(create: (_)=>ManageLoginState()),

      ],
      child: MyApp(),
    ),
  );


  // await SentryFlutter.init(
  //       (options) {
  //     options.dsn = 'https://74e1d98d4f088bfe5efc4b5d46b8b90c@o4504095760711680.ingest.sentry.io/4506376916303872';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     //  options.attachStacktrace;
  //     //  options.autoSessionTrackingIntervalMillis;
  //   },
  //   appRunner: () =>

  //       runApp(
  //     MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => AppProvider()),
  //         ChangeNotifierProvider(create: (_) => HomeProvider()),
  //         ChangeNotifierProvider(create: (_) => OneLoginProvider()),
  //         ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
  //         ChangeNotifierProvider(create: (_)=> AuthProvider()),
  //         ChangeNotifierProvider(create: (_)=>UserProvider()),
  //         ChangeNotifierProvider(create: (_)=>ClientListProvider()),
  //         ChangeNotifierProvider(create: (_)=>ManageLoginState()),
  //
  //       ],
  //       child: MyApp(),
  //     ),
  //   ),
  // );




  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  // OneSignal.shared.setAppId(onesignalId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//     debugPrint("Accepted permission: $accepted");
//   });


  // var status = await OneSignal.shared.getDeviceState();
  // String playerId = status.userId;
  // String playerIdEmail = status.emailAddress;

  //print('this is player Id ${playerId} ${playerIdEmail}');
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  //
  // // Pass all uncaught errors from the framework to Crashlytics.
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;



}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthProvider authProvider;
  bool _jailbroken;
  bool _developerMode;
//  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();
 // Mixpanel mixpanel;


  @override
  void initState() {
    super.initState();
    initPlatformState();
    _logAppOpen();
    _setAnalyticsProperties();
  //  initMixpanel();

  }

  // Future<void> initMixpanel() async {
  //   mixpanel = await Mixpanel.init("01bcb7ad255ab432c537f04276890aed", trackAutomaticEvents: true);
  //   mixpanel.track('App Started');
  // }


  void _logAppOpen() async {
//    await _firebaseAnalytics.logAppOpen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // authProvider = Provider.of<AuthProvider>(context,listen: true);

   //  AuthProvider authProvider = AuthProvider();
   //   authProvider.appCloakLogin();
   //  Provider.of<AuthProvider>(context, listen: false);
    runCloak();
  }

  runCloak() async {
    // Run the function immediately
    print('running cloak');
    AuthProvider authProvider = AuthProvider();
    authProvider.appCloakLogin();

    // Set up a timer to run the function every 14 minutes
    Timer.periodic(Duration(minutes: 14), (Timer timer) {
      print('running cloak');
      authProvider.appCloakLogin();
    });
  }

  // runCloak() async{
  //   Timer.periodic(Duration(minutes: 1), (Timer timer) {
  //     // Call your function here
  //     print('running cloak');
  //   //  authProvider = Provider.of<AuthProvider>(context,listen: true);
  //     // Provider.of<AuthProvider>(context, listen: false);
  //     AuthProvider authProvider = AuthProvider();
  //     authProvider.appCloakLogin();
  //   });
  // }

  void _setAnalyticsProperties() async {
  //  await _firebaseAnalytics.setUserId('000001');
  //   await _firebaseAnalytics.setUserProperty(
  //     name: 'open_app',
  //     value: 'salestoolkit was opened',
  //   );
  }


  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  Widget build(BuildContext context) {
  //  Future<User> getUserData () => UserPreferences().getUser();
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return OverlaySupport(
          child: WillPopScope(
            onWillPop: () => Dialogs().showExitDialog(context),
              child:   MaterialApp(
                  key: appProvider.key,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: appProvider.navigatorKey,
                  title: Constants.appName,
                  theme: themeData(appProvider.theme),
                  darkTheme: themeData(ThemeConfig.darkTheme),
                  navigatorObservers: [
                    //FirebaseAnalyticsObserver(analytics: _firebaseAnalytics),
                  ],
                  home:Splash()
              //    home: _jailbroken == null ? Splash() : _jailbroken == true ? JailBroken() : Splash()
                //    home: MyHomePage(),
                //  Text('Jailbroken: ${_jailbroken == null ? "Unknown" : _jailbroken ? "YES" : "NO"}'),
              ),
          ),
        )

        ;
      },
    );
  }



  // Widget JailBroken(){
  //   return
  //     Scaffold(
  //     appBar: AppBar(),
  //     body: Column(
  //       children: [
  //         SizedBox(height: MediaQuery.of(context).size.height * 0.27),
  //         SvgPicture.asset("assets/images/no_loan.svg",
  //           height: 90.0,
  //           width: 90.0,),
  //         SizedBox(height: 20,),
  //         Text('Device Not Allowed.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
  //         SizedBox(height: 6,),
  //         Text('Security issue detected in your\ndevice, Salestoolkit won\'t open',style: TextStyle(color: Colors.black,fontSize: 14,),textAlign: TextAlign.center,),
  //         SizedBox(height: 20,),
  //         Container(
  //           width: 155,
  //           height: 40,
  //           decoration: BoxDecoration(
  //             color: Color(0xff077DBB),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: (){
  //               MyRouter.popPage(context);
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 0.0),
  //               child:   Text(
  //                 'Close App',
  //                 style: TextStyle( fontSize: 12,
  //                   color: Colors.white,),
  //               ),
  //
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoSansTextTheme(
        theme.textTheme,
      ),
    );
  }
}


class JailBroken extends StatelessWidget {
  const JailBroken({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.17),
              SvgPicture.asset("assets/images/no_loan.svg",
                height: 90.0,
                width: 90.0,),
              SizedBox(height: 20,),
              Text('Device Not Allowed.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 6,),
              Text('Sorry,Sales Toolkit detected that your phone is rooted, \nso it cannot be opened.',style: TextStyle(color: Colors.black,fontSize: 14,),textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Container(
                width: 155,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff077DBB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: (){
                    SystemNavigator.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child:   Text(
                      'Close App',
                      style: TextStyle( fontSize: 12,
                        color: Colors.white,),
                    ),

                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


class MyHomePage extends StatelessWidget {
  void _causeCrash() {
    // Simulate a crash by dividing by zero (which will throw a Dart exception).
    // int result = 10 ~/ 0;
    // print('Result: $result'); // This line won't be reached due to the crash.
    throw Error();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Crash'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _causeCrash,
          child: Text('Cause Crash'),
        ),
      ),
    );
  }
}




