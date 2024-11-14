// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:version_check/version_check.dart';
//
//
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'version_check demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: MyHomePage(title: 'version_check demo'),
// //     );
// //   }
// // }
//
// class VersionCheckScreen extends StatefulWidget {
//   VersionCheckScreen({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _VersionCheckScreenState createState() => _VersionCheckScreenState();
// }
//
// class _VersionCheckScreenState extends State<VersionCheckScreen> {
//   String version = '';
//   String storeVersion = '';
//   String storeUrl = '';
//   String packageName = '';
//   @override
//   void initState() {
//     super.initState();
//     checkVersion();
//   }
//
//   final versionCheck = VersionCheck(
//     packageName: Platform.isIOS
//         ? 'com.creditdirect.sales_toolkit'
//         : 'com.creditdirect.sales_toolkit',
//     packageVersion: '1.0.1',
//     showUpdateDialog: customShowUpdateDialog,
//   );
//
//   Future checkVersion() async {
//     await versionCheck.checkVersion(context);
//     setState(() {
//       version = versionCheck.packageVersion;
//       packageName = versionCheck.packageName;
//       storeVersion = versionCheck.storeVersion;
//       storeUrl = versionCheck.storeUrl;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'packageVersion = $version',
//             ),
//             Text(
//               'storeVersion = $storeVersion',
//             ),
//             Text(
//               'storeUrl = $storeUrl',
//             ),
//             Text(
//               'packageName = $packageName',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.store),
//         onPressed: () async {
//           await versionCheck.launchStore();
//         },
//       ),
//     );
//   }
// }
//
// void customShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => AlertDialog(
//       title: Text('NEW Update Available'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: <Widget>[
//             Text(
//                 'Do you REALLY want to update to ${versionCheck.storeVersion}?'),
//             Text('(current version ${versionCheck.packageVersion})'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Update'),
//           onPressed: () async {
//             await versionCheck.launchStore();
//             Navigator.of(context).pop();
//           },
//         ),
//         TextButton(
//           child: Text('Close'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     ),
//   );
// }