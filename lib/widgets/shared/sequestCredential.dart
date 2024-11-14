// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class SequestCredential {
//
//   saveString() async {
//     final storage = FlutterSecureStorage();
//     String key = 'my_key';
//     String value = 'Mobiluser@123';
//
//     await storage.write(key: key, value: value);
//     print('String saved');
//   }
//
//   getString() async {
//     final storage = FlutterSecureStorage();
//     String key = 'my_key';
//
//     String value = await storage.read(key: key);
//
//     return value;
//     if (value != null) {
//       print('Retrieved string: $value');
//     } else {
//       print('String not found');
//     }
//   }
//
// }
