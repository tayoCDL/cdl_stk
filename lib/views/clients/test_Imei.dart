// import 'package:flutter/material.dart';
// import 'package:device_info/device_info.dart';
//
//
//
// class TestImei extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String deviceId = 'Loading...';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getDeviceId();
//     });
//   }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     getDeviceId();
//   }
//
//   Future<void> getDeviceId() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     if (Theme.of(context).platform == TargetPlatform.iOS) {
//       // For iOS
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       setState(() {
//         deviceId = iosInfo.identifierForVendor;
//       });
//     } else {
//       // For Android
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       setState(() {
//         deviceId = androidInfo.androidId;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Identifier'),
//       ),
//       body: Center(
//         child: Text('Device ID: $deviceId'),
//       ),
//     );
//   }
// }
