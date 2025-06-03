// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:camera_camera/camera_camera.dart'; // For XFile
//
// class PhotoHandler {
//   /// Converts an XFile (from camera) into a File object and stores it temporarily.
//   static Future<File> saveXFileToFile(File xfile) async {
//     final dir = await getTemporaryDirectory();
//     final filePath = p.join(dir.path, p.basename(xfile.path));
//     return await File(filePath).writeAsBytes(await xfile.readAsBytes());
//   }
//
//   /// Processes the image: resizes, compresses and returns metadata
//   static Future<Map<String, dynamic>?> processImage(File file) async {
//     try {
//       final originalBytes = await file.readAsBytes();
//       final decodedImage = img.decodeImage(originalBytes);
//       if (decodedImage == null) return null;
//
//       final resized = img.copyResize(decodedImage, width: 330, height: 250);
//       final compressedBytes = img.encodeJpg(resized, quality: 90);
//
//       final base64String = base64Encode(compressedBytes);
//       final fileName = p.basename(file.path);
//       final fileType = p.extension(file.path).replaceAll('.', '');
//
//       return {
//         'file': file,
//         'base64': base64String,
//         'fileName': fileName,
//         'fileType': fileType,
//         'fullDataUri': 'data:image/$fileType;base64,$base64String',
//       };
//     } catch (e) {
//       print('[PhotoHandler] Image processing failed: $e');
//       return null;
//     }
//   }
//
//   /// Checks if camera access is allowed and available
//   static Future<bool> checkCameraAvailability(BuildContext context) async {
//     if (kIsWeb) {
//       _showError(context, 'Camera is not supported on web.');
//       return false;
//     }
//
//     if (!Platform.isAndroid && !Platform.isIOS) {
//       _showError(context, 'Camera is only supported on mobile platforms.');
//       return false;
//     }
//
//     final status = await Permission.camera.request();
//     if (status.isGranted) {
//       return true;
//     } else if (status.isPermanentlyDenied) {
//       _showError(context, 'Camera permission is permanently denied. Please enable it in settings.');
//     } else {
//       _showError(context, 'Camera permission denied.');
//     }
//
//     return false;
//   }
//
//   static void _showError(BuildContext context, String message) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
// }
