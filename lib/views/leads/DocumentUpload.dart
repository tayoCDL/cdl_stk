// import 'dart:convert';
// import 'dart:io' as Io;
// import 'dart:ui' as ui;
// import 'dart:io';
// import 'dart:math';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sales_toolkit/util/router.dart';
// import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
// import 'package:sales_toolkit/view_models/addClient.dart';
// import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
// import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
// import 'package:sales_toolkit/widgets/Stepper.dart';
// import 'package:sales_toolkit/widgets/dropdown.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
//
// import '../../palatte.dart';
//
//
// class LeadDocumentUpload extends StatefulWidget {
//   const LeadDocumentUpload({Key key}) : super(key: key);
//
//   @override
//   _LeadDocumentUploadState createState() => _LeadDocumentUploadState();
// }
//
// class _LeadDocumentUploadState extends State<LeadDocumentUpload> {
//   @override
//   TextEditingController passport = TextEditingController();
//   TextEditingController esignature = TextEditingController();
//   TextEditingController proof_of_residence = TextEditingController();
//   TextEditingController proof_of_identity = TextEditingController();
//   TextEditingController proof_of_employment = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//
//   // final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
//
//   void _handleClearButtonPressed() {
//     signatureGlobalKey.currentState.clear();
//   }
//
//
//   File uploadimage;
//   final ImagePicker _picker = ImagePicker();
//
//   String _fileName = '...';
//   String _path = '...';
//   String _extension;
//   String signatureBase64;
//   bool _hasValidMime = false;
//   String appendBase64 = '';
//   FileType _pickingType;
//   DateTime selectedDate = DateTime.now();
//   DateTime CupertinoSelectedDate = DateTime.now();
//
//
//   TextEditingController _controller = new TextEditingController();
//   File chosenImage;
//
//   List<String> residenceArray = [];
//   List<String> collectResidence = [];
//   List<dynamic> allResidence = [];
//
//   List<String> identityArray = [];
//   List<String> collectIdentity = [];
//   List<dynamic> allIdentity = [];
//
//   List<String> employmentArray = [];
//   List<String> collectEmployment = [];
//   List<dynamic> allEmployment = [];
//
//   int employmentInt,identityInt,residenceInt;
//
//   String passportFileName,passportFileSize,passportFiletype,passportFileLocation,newFileLocation;
//   String residenceFileName,residenceFileSize,residenceFiletype,residenceFileLocation;
//   String identityFileName,identityFileSize,identityFiletype,identityFileLocation;
//   String employmentFileName,employmentFileSize,employmentFiletype,employmentFileLocation;
//
//   bool _isLoading = false;
//
//   AddClientProvider addClientProvider = AddClientProvider();
//
//   void _handleSaveButtonPressed() async {
//     final data =
//     await signatureGlobalKey.currentState.toImage(pixelRatio: 3.0);
//     final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
//     final encoded = base64.encode(bytes.buffer.asUint8List());
//
//     debugPrint("onPressed " + encoded);
//     print(bytes.elementSizeInBytes);
//
//     setState(() {
//       signatureBase64 = encoded;
//       esignature.text = 'Signature appended';
//     });
//
//
//     // await Navigator.of(context).push(
//     //   MaterialPageRoute(
//     //     builder: (BuildContext context) {
//     //       return Scaffold(
//     //         appBar: AppBar(),
//     //         body: Center(
//     //           child: Container(
//     //             color: Colors.grey[300],
//     //             child: Image.memory(bytes.buffer.asUint8List()),
//     //           ),
//     //         ),
//     //       );
//     //     },
//     //   ),
//     // );
//     Navigator.pop(context);
//
//
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     getResidentialList();
//     getEmploymentList();
//     getIdentityList();
//
//     _controller.addListener(() => _extension = _controller.text);
//   }
//
//   getResidentialList(){
//     final Future<Map<String,dynamic>> respose =   RetCodes().EmploymentStatus('50');
//     // respose.then((response) {
//     //   print('marital array');
//     //   print(response['data']);
//     //   List<dynamic> newEmp = response['data'];
//     //
//     //   setState(() {
//     //     allResidence = newEmp;
//     //   });
//     //
//     //   for(int i = 0; i < newEmp.length;i++){
//     //     print(newEmp[i]['name']);
//     //     collectResidence.add(newEmp[i]['name']);
//     //   }
//     //   print('vis alali');
//     //   print(collectResidence);
//     //
//     //   setState(() {
//     //     residenceArray = collectResidence;
//     //   });
//     // }
//     // );
//
//     respose.then((response) async {
//       print(response['data']);
//
//       if(response['status'] == false){
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         List<dynamic> mtBool = jsonDecode(prefs.getString('prefsProofOfResidence'));
//
//
//         //
//         if(prefs.getString('prefsProofOfResidence').isEmpty){
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.red,
//             title: 'Offline mode',
//             message: 'Unable to load data locally ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//         //
//         else {
//
//           setState(() {
//             allResidence = mtBool;
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectResidence.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             residenceArray = collectResidence;
//           });
//
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.orange,
//             title: 'Offline mode',
//             message: 'Locally saved data loaded ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//
//       } else {
//         List<dynamic> newEmp = response['data'];
//
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         prefs.setString('prefsProofOfResidence', jsonEncode(newEmp));
//
//
//         setState(() {
//           allResidence = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           collectResidence.add(newEmp[i]['name']);
//         }
//         print('vis alali');
//         print(collectResidence);
//
//         setState(() {
//           residenceArray = collectResidence;
//         });
//       }
//
//     }
//     );
//   }
//
//   getEmploymentList(){
//     final Future<Map<String,dynamic>> respose =   RetCodes().EmploymentStatus('51');
//     // respose.then((response) {
//     //   print('marital array');
//     //   print(response['data']);
//     //   List<dynamic> newEmp = response['data'];
//     //
//     //   setState(() {
//     //     allEmployment = newEmp;
//     //   });
//     //
//     //   for(int i = 0; i < newEmp.length;i++){
//     //     print(newEmp[i]['name']);
//     //     collectEmployment.add(newEmp[i]['name']);
//     //   }
//     //   print('vis alali');
//     //   print(collectEmployment);
//     //
//     //   setState(() {
//     //     employmentArray = collectEmployment;
//     //   });
//     // }
//     // );
//
//     respose.then((response) async {
//       print(response['data']);
//
//       if(response['status'] == false){
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         List<dynamic> mtBool = jsonDecode(prefs.getString('prefsProofOfEmployment'));
//
//
//         //
//         if(prefs.getString('prefsProofOfEmployment').isEmpty){
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.red,
//             title: 'Offline mode',
//             message: 'Unable to load data locally ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//         //
//         else {
//
//           setState(() {
//             allEmployment = mtBool;
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectEmployment.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             employmentArray = collectEmployment;
//           });
//
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.orange,
//             title: 'Offline mode',
//             message: 'Locally saved data loaded ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//
//       } else {
//         List<dynamic> newEmp = response['data'];
//
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         prefs.setString('prefsProofOfEmployment', jsonEncode(newEmp));
//
//
//         setState(() {
//           allEmployment = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           collectEmployment.add(newEmp[i]['name']);
//         }
//         print('vis alali');
//         print(collectEmployment);
//
//         setState(() {
//           employmentArray = collectEmployment;
//         });
//       }
//
//     }
//     );
//   }
//
//   getIdentityList(){
//     final Future<Map<String,dynamic>> respose =   RetCodes().EmploymentStatus('1');
//     // respose.then((response) {
//     //   print('marital array');
//     //   print(response['data']);
//     //   List<dynamic> newEmp = response['data'];
//     //
//     //   setState(() {
//     //     allIdentity = newEmp;
//     //   });
//     //
//     //   for(int i = 0; i < newEmp.length;i++){
//     //     print(newEmp[i]['name']);
//     //     collectIdentity.add(newEmp[i]['name']);
//     //   }
//     //   print('vis alali');
//     //   print(collectIdentity);
//     //
//     //   setState(() {
//     //     identityArray = collectIdentity;
//     //   });
//     // }
//     // );
//
//
//
//     respose.then((response) async {
//       print(response['data']);
//
//       if(response['status'] == false){
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         List<dynamic> mtBool = jsonDecode(prefs.getString('prefsProofOfIdentity'));
//
//
//         //
//         if(prefs.getString('prefsProofOfIdentity').isEmpty){
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.red,
//             title: 'Offline mode',
//             message: 'Unable to load data locally ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//         //
//         else {
//
//           setState(() {
//             allIdentity = mtBool;
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectIdentity.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             identityArray = collectIdentity;
//           });
//
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.orange,
//             title: 'Offline mode',
//             message: 'Locally saved data loaded ',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//
//       } else {
//         List<dynamic> newEmp = response['data'];
//
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         prefs.setString('prefsProofOfIdentity', jsonEncode(newEmp));
//
//
//         setState(() {
//           allIdentity = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           collectIdentity.add(newEmp[i]['name']);
//         }
//         print('vis alali');
//         print(collectIdentity);
//
//         setState(() {
//           identityArray = collectIdentity;
//         });
//       }
//
//     }
//     );
//   }
//
//
//
//   void _openFileExplorer() async {
//     if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//       try {
//         _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//         // List<int> imageBytes = _path.readAsBytesSync();
//         // String baseimage = base64Encode(imageBytes);
//
//         print('file extension ${_path.split('.').last}');
//
//         final bytes = Io.File(_path).readAsBytesSync();
//         final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
//         String img64 = base64Encode(bytes);
//
//         // get file size
//         final kb = byeInLength / 1024;
//         final mb = kb / 1024;
//         print('this is the MB ${mb}');
//         String filesizeAsString  = mb.toString();
//         print('this is file sizelenght ${filesizeAsString}');
//         print('image base64 ${img64}');
//
//         setState(() {
//           passportFileLocation = img64;
//           passportFileSize = filesizeAsString;
//           passportFiletype = _path.split('.').last;
//
//         });
//
//
//
// print('passport file location ${passportFiletype} ');
//
//   setState(() {
//     if(passportFiletype == 'png'){
//       appendBase64 ='data:image/png;base64,';
//     }
//     else if(passportFiletype == 'jpg'){
//       appendBase64 = 'data:image/jpeg;base64,';
//     } else if(passportFiletype == 'jpeg'){
//       appendBase64 ='data:image/jpeg;base64,';
//     }
//
//   });
//
//   newFileLocation = appendBase64 + passportFileLocation;
//
//       } on PlatformException catch (e) {
//         print("Unsupported operation" + e.toString());
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _fileName = _path != null ? _path.split('/').last : '...';
//         passport.text = _fileName;
//         passportFileName = _fileName;
//
//       });
//     }
//   }
//
//   void _openResidenceExplorer() async {
//     if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//       try {
//         _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//         // List<int> imageBytes = _path.readAsBytesSync();
//         // String baseimage = base64Encode(imageBytes);
//
//         print('file extension ${_path.split('.').last}');
//
//         final bytes = Io.File(_path).readAsBytesSync();
//         final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
//         String img64 = base64Encode(bytes);
//
//         // get file size
//         final kb = byeInLength / 1024;
//         final mb = kb / 1024;
//         print('this is the MB ${mb}');
//         String filesizeAsString  = mb.toString();
//         print('this is file sizelenght ${filesizeAsString}');
//         print('image base64 ${img64}');
//
//         setState(() {
//           residenceFileLocation = img64;
//           residenceFileSize = filesizeAsString;
//           residenceFiletype = _path.split('.').last;
//         });
//
//
//
//       } on PlatformException catch (e) {
//         print("Unsupported operation" + e.toString());
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _fileName = _path != null ? _path.split('/').last : '...';
//         proof_of_residence.text = _fileName;
//         residenceFileName = _fileName;
//
//       });
//     }
//   }
//
//   void _openIdentityExplorer() async {
//     if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//       try {
//         _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//         // List<int> imageBytes = _path.readAsBytesSync();
//         // String baseimage = base64Encode(imageBytes);
//
//         print('file extension ${_path.split('.').last}');
//
//         final bytes = Io.File(_path).readAsBytesSync();
//         final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
//         String img64 = base64Encode(bytes);
//
//         // get file size
//         final kb = byeInLength / 1024;
//         final mb = kb / 1024;
//         print('this is the MB ${mb}');
//         String filesizeAsString  = mb.toString();
//         print('this is file sizelenght ${filesizeAsString}');
//         print('image base64 ${img64}');
//
//         setState(() {
//           identityFileLocation = img64;
//           identityFileSize = filesizeAsString;
//           identityFiletype = _path.split('.').last;
//         });
//
//
//
//       } on PlatformException catch (e) {
//         print("Unsupported operation" + e.toString());
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _fileName = _path != null ? _path.split('/').last : '...';
//         proof_of_identity.text = _fileName;
//         identityFileName = _fileName;
//
//       });
//     }
//   }
//
//   void _openEmploymentExplorer() async {
//     if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//       try {
//         _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//         // List<int> imageBytes = _path.readAsBytesSync();
//         // String baseimage = base64Encode(imageBytes);
//
//         print('file extension ${_path.split('.').last}');
//
//         final bytes = Io.File(_path).readAsBytesSync();
//         final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
//         String img64 = base64Encode(bytes);
//
//         // get file size
//         final kb = byeInLength / 1024;
//         final mb = kb / 1024;
//         print('this is the MB ${mb}');
//         String filesizeAsString  = mb.toString();
//         print('this is file sizelenght ${filesizeAsString}');
//         print('image base64 ${img64}');
//
//         setState(() {
//           employmentFileLocation = img64;
//           employmentFileSize = filesizeAsString;
//           employmentFiletype = _path.split('.').last;
//         });
//
//
//
//       } on PlatformException catch (e) {
//         print("Unsupported operation" + e.toString());
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _fileName = _path != null ? _path.split('/').last : '...';
//         proof_of_employment.text = _fileName;
//         employmentFileName = _fileName;
//
//       });
//     }
//   }
//
//
//
//   void takePhoto(ImageSource source) async {
//     // final pickedFile = await _picker.getImage(
//     //   source: source,
//     // );
//    // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//     var choosedimage = await ImagePicker.pickImage(source: source);
//         print(choosedimage);
//
//     setState(() {
//       uploadimage = choosedimage;
//       String getPath  = choosedimage.toString();
//       _fileName = getPath != null ? getPath.split('/').last : '...';
//         // _openFileExplorer(getPath);
//       passport.text = _fileName;
//     });
//   }
//
//   int random(min, max){
//     return min + Random().nextInt(max - min);
//   }
//
//   Widget bottomSheet() {
//     return Container(
//       height: 100.0,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 20,
//       ),
//       child: Column(
//         children: <Widget>[
//           Text(
//             "Pick from...",
//             style: TextStyle(
//               fontSize: 20.0,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//             FlatButton.icon(
//               icon: Icon(Icons.camera),
//               onPressed: () {
//                 takePhoto(ImageSource.camera);
//               },
//               label: Text("Camera"),
//             ),
//             FlatButton.icon(
//               icon: Icon(Icons.image),
//               onPressed: () {
//                 _openFileExplorer();
//               },
//               label: Text("Gallery"),
//             ),
//           ])
//         ],
//       ),
//     );
//   }
//
//   Widget signatureBottomSheet() {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Append Signature',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: (){
//               MyRouter.popPage(context);
//             },
//             icon: Icon(Icons.cancel,color: Colors.black,),
//           ),
//         ],
//         elevation: 6,
//       ),
//       body:  Container(
//         height:  MediaQuery.of(context).size.height * 0.51,
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 20,
//         ),
//         child: Column(
//           children: <Widget>[
//
//             // Container(
//             //   height:  MediaQuery.of(context).size.height * 0.30,
//             //     child: SfSignaturePad(
//             //         key: signatureGlobalKey,
//             //         backgroundColor: Colors.white,
//             //         strokeColor: Colors.black,
//             //         minimumStrokeWidth: 1.0,
//             //         maximumStrokeWidth: 4.0),
//             //     decoration:
//             //     BoxDecoration(border: Border.all(color: Colors.grey))),
//
//           ],
//         ),
//       ),
//       bottomNavigationBar:  DoubleBottomNavComponent(text1: 'Clear',text2: 'Done',callAction2: (){
//         _handleSaveButtonPressed();
//
//       },callAction1: (){
//         _handleClearButtonPressed();
//       },),
//     );
//
//
//
//     //   Container(
//     //   height:  MediaQuery.of(context).size.height * 0.51,
//     //   width: MediaQuery.of(context).size.width,
//     //   margin: EdgeInsets.symmetric(
//     //     horizontal: 20,
//     //     vertical: 20,
//     //   ),
//     //   child: Column(
//     //     children: <Widget>[
//     //       Text(
//     //         "Append Signature",
//     //         style: TextStyle(
//     //           fontSize: 20.0,
//     //           fontWeight: FontWeight.bold,
//     //           fontFamily: 'Nunito SansRegular'
//     //         ),
//     //       ),
//     //       SizedBox(
//     //         height: 20,
//     //       ),
//     //     Container(
//     //         child: SfSignaturePad(
//     //             key: signatureGlobalKey,
//     //             backgroundColor: Colors.white,
//     //             strokeColor: Colors.black,
//     //             minimumStrokeWidth: 1.0,
//     //             maximumStrokeWidth: 4.0),
//     //         decoration:
//     //         BoxDecoration(border: Border.all(color: Colors.grey))),
//     //
//     //     ],
//     //   ),
//     // );
//   }
//
//
//   Widget build(BuildContext context) {
//
//     var submitLoandocumentInfo = () async{
//       setState(() {
//         _isLoading = true;
//       });
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     //  return MyRouter.pushPage(context, CustomerPreview());
//
//      // print(random(1000000, 9000000));
//       if(dateController.text.isEmpty){
//         return Flushbar(
//                 flushbarPosition: FlushbarPosition.TOP,
//                 flushbarStyle: FlushbarStyle.GROUNDED,
//           backgroundColor: Colors.red,
//           title: "Validation error",
//           message: 'Fill all fields before submitting',
//           duration: Duration(seconds: 3),
//         ).show(context);
//       }
//           print('passport Location ${passportFileLocation}' );
//
//          String passportLocation =  passportFileLocation;
//
//
//
//       List<Map<dynamic,dynamic>> loanDocumentData= [
//         {
//
//           "documentKey": random(1000000, 9000000),
//           "documentTypeId": 66,
//           "status" : "ACTIVE",
//           "attachment" : {
//
//             "location" : signatureBase64,
//             "name" : "Client Signature",
//             "description" : "Client signature",
//             "fileName" : "Client signature.png",
//             "type" :  "image/png"
//           }
//         },
//         {
//           "documentTypeId": residenceInt,
//           "status" : "ACTIVE",
//           "documentKey": random(1000000, 9000000),
//           "attachment" : {
//
//             "location" : residenceFileLocation,
//             "name" : residenceFileName,
//             "description" : "Proof Of Residence",
//             "fileName" : residenceFileName,
//             // "size" : int.parse(residenceFileSize),
//             "type" : residenceFiletype == 'png' ? "image/png" : residenceFiletype == 'jpg' ? "image/jpg" : residenceFiletype == 'pdf' ? 'application/pdf' : ''
//           }
//         },
//         {
//           "documentTypeId": employmentInt,
//           "status" : "ACTIVE",
//           "documentKey": random(1000000, 9000000),
//           "attachment" : {
//
//             "location" : employmentFileLocation,
//             "name" : employmentFileName,
//             "description" : "Proof Of Employment",
//             "fileName" : employmentFileName,
//             // "size" : int.parse(employmentFileSize),
//             "type" : employmentFiletype == 'png' ? "image/png" : employmentFiletype == 'jpg' ? "image/jpg" : employmentFiletype == 'pdf' ? 'application/pdf' : ''
//           }
//         },
//         {
//           "expiryDate" :dateController.text,
//           "locale": "en",
//           "dateFormat": "dd MMMM yyyy",
//           "documentTypeId": identityInt,
//           "documentKey": random(1000000, 9000000),
//           "description": "Client's identity",
//           "status" : "ACTIVE",
//           "attachment" : {
//
//             "location" : identityFileLocation,
//             "name" : identityFileName,
//             "description" : "Client's identity",
//             "fileName" : identityFileName,
//             // "size" : int.parse(identityFileSize),
//             "type" : identityFiletype == 'png' ? "image/png" : identityFiletype == 'jpg' ? "image/jpg" : identityFiletype == 'pdf' ? 'application/pdf' : ''
//           }
//         }
//       ];
//
//
//       print('this is loan doc ${loanDocumentData}');
//
//       final Future<Map<String,dynamic>> respose =  addClientProvider.addDocumentUpload(loanDocumentData,newFileLocation,passportFiletype,3);
//       print('start response from login');
//
//       print(respose.toString());
//
//
//       respose.then((response) {
//
//             //  return print('response from backend ${response}');
//         if(response['status'] == false){
//           setState(() {
//             _isLoading = false;
//           });
//
//
//           if(response['message'] == 'Network_error'){
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//               backgroundColor: Colors.orangeAccent,
//               title: 'Network Error',
//               message: 'Proceed, data has been saved to draft',
//               duration: Duration(seconds: 3),
//             ).show(context);
//
//           //  return MyRouter.pushPage(context, DocumentUpload());
//           }
//
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.red,
//             title: 'Error',
//             message: response['message'],
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//         else {
//           setState(() {
//             _isLoading = false;
//           });
//           MyRouter.pushPage(context, CustomerPreview());
 //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//             backgroundColor: Colors.green,
//             title: "Success",
//             message: 'Client profile sreation successful',
//             duration: Duration(seconds: 3),
//           ).show(context);
//
//         }
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       );
//
//     };
//
//
//
//     return LoadingOverlay(
//       isLoading: false,
//       progressIndicator: Container(
//         height: 120,
//         width: 120,
//         child:  Lottie.asset('assets/images/newLoader.json'),
//       ),
//       child: Scaffold(
//         body: GestureDetector(
//           onTap: (){
//             FocusScope.of(context).requestFocus(new FocusNode());
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 ProgressStepper(stepper: 0.99,title: 'Document Upload',subtitle: 'Client Preview',),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//                         child: Container(
//                           padding: EdgeInsets.only(top: 10,left: 10,right: 10),
//                           height: MediaQuery.of(context).size.height * 0.075,
//                           decoration: BoxDecoration(
//                             color: Color(0xffFC2E83).withOpacity(0.2),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(5),
//                             ),
//                           ),
//                             child: Text('Ensure you enter correct information, some of the information provided will later be matched with your BVN details.',style: TextStyle(fontSize: 11,color: Color(0xffFC2E83)),)),
//                       ),
//
//                         SizedBox(height: 10,),
//                       Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
//                           child: Container(
//                               height: 50,
//                               child: InkWell(
//                                 onTap: (){
//
//                                 },
//                                 child: Container(
//
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).backgroundColor,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//
//                                   child: TextFormField(
//                                     controller: passport,
//                                     autofocus: false,
//                                     readOnly: true,
//
//                                     decoration: InputDecoration(
//                                       focusedBorder:OutlineInputBorder(
//                                         borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                                       ),
//
//                                       border: OutlineInputBorder(
//
//                                       ),
//                                       suffixIcon: IconButton(
//                                         onPressed: (){
//
//                                           showModalBottomSheet(
//                                             context: context,
//                                             builder: ((builder) => bottomSheet()),
//                                           );
//                                         },
//                                         icon:Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                           ,) ,
//                                       )
//                                       ,
//                                     //  contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
//
//                                       labelText: 'Passport photograph *',
//                                       hintStyle: kBodyPlaceholder,
//                                     ),
//                                     style: TextStyle(  fontSize: 17,
//
//                                       color: Colors.black,),
//                                     // keyboardType: inputType,
//                                     // textInputAction: inputAction,
//                                   ),
//                                 ),
//                               )
//
//                           )
//                       ),
//                       _smallInfo('Upload a clear passport photograph with white background'),
//                       SizedBox(height: 30,),
//                       Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
//                           child: Container(
//                               height: 50,
//                               child: InkWell(
//                                 onTap: (){
//
//                                 },
//                                 child: Container(
//                                   height: 71,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).backgroundColor,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//
//                                   child: TextFormField(
//                                     controller: esignature,
//                                     autofocus: false,
//                                     readOnly: true,
//                                     decoration: InputDecoration(
//                                       focusedBorder:OutlineInputBorder(
//                                         borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                                       ),
//                                       border: OutlineInputBorder(
//
//                                       ),
//                                       suffixIcon: IconButton(
//                                         onPressed: (){
//                                           showModalBottomSheet(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(15.0),
//                                             ),
//                                             context: context,
//                                             builder: ((builder) => signatureBottomSheet()),
//                                           );
//                                         // MyRouter.pushPage(context, SignaturePadApp());
//                                         },
//                                         icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                           ,) ,
//                                       )
//                                       ,
//                                       contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
//
//                                       labelText: 'E Signature *',
//                                       hintStyle: kBodyPlaceholder,
//                                     ),
//                                     style: kBodyText,
//                                     // keyboardType: inputType,
//                                     // textInputAction: inputAction,
//                                   ),
//                                 ),
//                               )
//
//                           )
//                       ),
//                       _smallInfo('Upload an image of your signature on white background'),
//
//
//                       SizedBox(height: 60,),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //   children: [
//                       //     Container(
//                       //       width: MediaQuery.of(context).size.width * 0.5,
//                       //       child: Padding(
//                       //           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
//                       //           child: Container(
//                       //               height: 50,
//                       //               child: InkWell(
//                       //                 onTap: (){
//                       //
//                       //                 },
//                       //                 child: Container(
//                       //                   height: 71,
//                       //                   decoration: BoxDecoration(
//                       //                     color: Theme.of(context).backgroundColor,
//                       //                     borderRadius: BorderRadius.circular(5),
//                       //                   ),
//                       //
//                       //                   child: TextFormField(
//                       //                     controller: proof_of_residence,
//                       //                     autofocus: false,
//                       //                     readOnly: true,
//                       //                     decoration: InputDecoration(
//                       //                       focusedBorder:OutlineInputBorder(
//                       //                         borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//                       //
//                       //                       ),
//                       //                       border: OutlineInputBorder(
//                       //
//                       //                       ),
//                       //                       suffixIcon: IconButton(
//                       //                         onPressed: (){
//                       //                           _openResidenceExplorer();
//                       //                         },
//                       //                         icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                       //                           ,) ,
//                       //                       )
//                       //                       ,
//                       //                       contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//                       //
//                       //                       labelText: 'Residence *',
//                       //                       hintStyle: kBodyPlaceholder,
//                       //                     ),
//                       //                     style: kBodyText,
//                       //                     // keyboardType: inputType,
//                       //                     // textInputAction: inputAction,
//                       //                   ),
//                       //                 ),
//                       //               )
//                       //
//                       //           )
//                       //       ),
//                       //     ),
//                       //
//                       //
//                       //     Container(
//                       //       width: MediaQuery.of(context).size.width * 0.5,
//                       //       child: Padding(
//                       //           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
//                       //           child: Container(
//                       //               height: 50,
//                       //               child: InkWell(
//                       //                 onTap: (){
//                       //
//                       //                 },
//                       //                 child: Container(
//                       //                   height: 51,
//                       //                   decoration: BoxDecoration(
//                       //                     color: Theme.of(context).backgroundColor,
//                       //                     borderRadius: BorderRadius.circular(5),
//                       //                   ),
//                       //
//                       //                   child:
//                       //                   DropDownComponent(items: residenceArray,
//                       //                       onChange: (String item){
//                       //                         setState(() {
//                       //
//                       //                           List<dynamic> selectID =   allResidence.where((element) => element['name'] == item).toList();
//                       //                           print('this is select ID');
//                       //                           print(selectID[0]['id']);
//                       //                           residenceInt = selectID[0]['id'];
//                       //                           print('end this is select ID');
//                       //
//                       //                         });
//                       //                       },
//                       //                       label: "Document Type * ",
//                       //                       selectedItem: "-----",
//                       //                       validator: (String item){
//                       //
//                       //                       }
//                       //                   ),
//                       //                 ),
//                       //               )
//                       //
//                       //           )
//                       //       ),
//                       //     ),
//                       //
//                       //   ],
//                       // ),
//
//                       Padding(
//                         padding: EdgeInsets.only(top: 2,left: 10,right: 10),
//                         child: proofOfResidence(),
//                       ),
//
//                       Padding(
//                         padding: EdgeInsets.only(top: 0,left: 10,right: 10),
//                         child: proofOfIdentity(),
//                       ),
//
//                       Padding(
//                         padding: EdgeInsets.only(top: 0,left: 10,right: 10),
//                         child: proofOfEmployment(),
//                       ),
//
//
//
//
//
//
//
//                     ],
//                   ),
//                 )
//
//
//
//
//
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Complete',callAction2: (){
//
//           submitLoandocumentInfo();
//         //  MyRouter.pushPage(context, MainScreen());
//         },callAction1: (){
//           MyRouter.popPage(context);
//         },),
//       ),
//     );
//   }
//
//   Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,{bool isPassword = false}){
//     var MediaSize = MediaQuery.of(context).size;
//     return   Container(
//       height: MediaSize.height * 0.090,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).backgroundColor,
//
//             // set border width
//             borderRadius: BorderRadius.all(
//                 Radius.circular(5.0)), // set rounded corner radius
//           ),
//           child: TextFormField(
//
//             style: TextStyle(fontFamily: 'Nunito SansRegular'),
//             keyboardType: TextInputType.number,
//
//             controller: editController,
//
//             decoration: InputDecoration(
//
//                 suffixIcon: isPassword == true ? Icon(Icons.remove_red_eye,color: Colors.black38
//                   ,) : null,
//                 focusedBorder:OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 1),
//
//                 ),
//
//                 border: OutlineInputBorder(
//
//                 ),
//                 labelText: labelText,
//                 floatingLabelStyle: TextStyle(color:Color(0xff205072)),
//                 hintText: hintText,
//                 hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
//                 labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)
//
//             ),
//             textInputAction: TextInputAction.done,
//           ),
//         ),
//       ),
//     );
//
//
//
//   }
//
//
//   _smallInfo(String descriptions){
//     return   Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
//       child: Text(descriptions,
//         style: TextStyle(color: Color(0xff354052),
//             fontFamily: 'Nunito SansRegular',
//             fontSize: 9),
//       ),
//     );
//
//   }
//
//   retsNx360dates(DateTime selected){
//     String newdate = selectedDate.toString().substring(0,10);
//     print(newdate);
//
//     String formattedDate = DateFormat.yMMMMd().format(selected);
//
//     print(formattedDate);
//
//     String removeComma = formattedDate.replaceAll(",", "");
//     print('removeComma');
//     print(removeComma);
//
//     List<String> wordList = removeComma.split(" ");
//     //14 December 2011
//
//     //[January, 18, 1991]
//     String o1 = wordList[0];
//     String o2 = wordList[1];
//     String o3 = wordList[2];
//
//     String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;
//
//     print('newOO ${newOO}');
//
//     String concatss = newOO + " " + o1 + " " + o3;
//     print(concatss);
//
//     print(wordList);
//     return concatss;
//   }
//
//   // _selectDate(BuildContext context) async {
//   //   final DateTime selected = await showDatePicker(
//   //     context: context,
//   //     initialDate: selectedDate,
//   //     firstDate: DateTime(1930),
//   //     lastDate: DateTime(2025),
//   //   );
//   //   if (selected != null && selected != selectedDate)
//   //     setState(() {
//   //       selectedDate = selected;
//   //       print(selected);
//   //       //  date = selected.toString();
//   //
//   //       String vasCoddd = retsNx360dates(selected);
//   //
//   //       dateController.text = vasCoddd;
//   //
//   //       //    String newdate = selectedDate.toString().substring(0,10);
//   //       //    print(newdate);
//   //       //
//   //       // String formattedDate = DateFormat.yMMMMd().format(selected);
//   //       //
//   //       // print(formattedDate);
//   //       //
//   //       //  String removeComma = formattedDate.replaceAll(",", "");
//   //       //    print('removeComma');
//   //       //    print(removeComma);
//   //       //
//   //       //  List<String> wordList = removeComma.split(" ");
//   //       //  //14 December 2011
//   //       //
//   //       //  //[January, 18, 1991]
//   //       //  String o1 = wordList[0];
//   //       //  String o2 = wordList[1];
//   //       //  String o3 = wordList[2];
//   //       //
//   //       //  String concatss = o2 + " " + o1 + " " + o3;
//   //       //  print("concatss");
//   //       //  print(concatss);
//   //       //
//   //       //  print(wordList);
//   //       //
//   //       //  dateController.text = concatss;
//   //
//   //     });
//   // }
//
//   showDatePicker() {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext builder) {
//           return Container(
//             height: MediaQuery.of(context).copyWith().size.height*0.40,
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   height: 200,
//                   child: CupertinoDatePicker(
//                     mode: CupertinoDatePickerMode.date,
//                     onDateTimeChanged: (value) {
//                       if (value != null && value != CupertinoSelectedDate)
//                         setState(() {
//                           CupertinoSelectedDate = value;
//                           print(CupertinoSelectedDate);
//                           String retDate = retsNx360dates(CupertinoSelectedDate);
//                           print('ret Date ${retDate}');
//                           dateController.text = retDate;
//                         });
//
//                     },
//                     initialDateTime: DateTime.now(),
//                     minimumYear: 1960,
//                     maximumYear: 2022,
//                   ),
//                 ),
//                 CupertinoButton(
//                   child: const Text('OK'),
//                   onPressed: () => Navigator.of(context).pop(),
//                 )
//               ],
//             ),
//           );
//         }
//     );
//   }
//
//   BoxDecoration myBoxDecoration() {
//     return BoxDecoration(
//       border: Border.all(
//           color: Colors.grey,
//           width: 1
//       ),
//
//     );
//   }
//
//
//   Widget proofOfResidence(){
//     return Column(
//
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text('Proof Of Residence',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
//             Text('')
//           ],
//         ),
//         SizedBox(height: 20,),
//         Container(
//           height: MediaQuery.of(context).size.height * 0.30,
//           padding: EdgeInsets.only(top: 3),
//           decoration: BoxDecoration(
//
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 Container(
//                   height: 70,
//                   child: DropDownComponent(items: residenceArray,
//                       onChange: (String item){
//                         setState(() {
//
//                           List<dynamic> selectID =   allResidence.where((element) => element['name'] == item).toList();
//                           print('this is select ID');
//                           print(selectID[0]['id']);
//                           residenceInt = selectID[0]['id'];
//                           print('end this is select ID');
//
//                         });
//                       },
//                       label: "Proof Of Residence Document * ",
//                       selectedItem: "-----",
//                       validator: (String item){
//
//                       }
//                   ),
//                 ),
//               SizedBox(height: 15,),
//
//                 Container(
//                   width: MediaQuery.of(context).size.width * 1,
//
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 1),
//                       child: Container(
//                           height: 80,
//                           child: InkWell(
//                             onTap: (){
//
//                             },
//                             child: Container(
//                               height: 70,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).backgroundColor,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//
//                               child: TextFormField(
//                                 controller: proof_of_residence,
//                                 autofocus: false,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   focusedBorder:OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                                   ),
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//
//                                   ),
//                                   suffixIcon: IconButton(
//                                     onPressed: (){
//                                       _openResidenceExplorer();
//                                     },
//                                     icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                       ,) ,
//                                   )
//                                   ,
//                                   // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//
//                                   labelText: 'Proof Of Residence *',
//                                   hintStyle: kBodyPlaceholder,
//                                 ),
//                                 style: kBodyText,
//                                 // keyboardType: inputType,
//                                 // textInputAction: inputAction,
//                               ),
//                             ),
//                           )
//
//                       )
//                   ),
//                 ),
//
//                 SizedBox(height: 15,),
//
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   Widget proofOfIdentity(){
//     return Column(
//
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text('Proof Of Identity',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
//             Text('')
//           ],
//         ),
//         SizedBox(height: 10,),
//         Container(
//           height: MediaQuery.of(context).size.height * 0.40,
//           padding: EdgeInsets.only(top: 3),
//           decoration: BoxDecoration(
//
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 1),
//                       child: Container(
//                           height: 70,
//                           child: InkWell(
//                             onTap: (){
//
//                             },
//                             child: Container(
//                               height: 71,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).backgroundColor,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//
//                               child: TextFormField(
//                                 controller: proof_of_identity,
//                                 autofocus: false,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   focusedBorder:OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                                   ),
//                                   border: OutlineInputBorder(
//
//                                   ),
//                                   suffixIcon: IconButton(
//                                     onPressed: (){
//                                       _openIdentityExplorer();
//                                     },
//                                     icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                       ,) ,
//                                   )
//                                   ,
//                                 //  contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//
//                                   labelText: 'Identity *',
//                                   hintStyle: kBodyPlaceholder,
//                                 ),
//                                 style: kBodyText,
//                                 // keyboardType: inputType,
//                                 // textInputAction: inputAction,
//                               ),
//                             ),
//                           )
//
//                       )
//                   ),
//                 ),
//               SizedBox(height: 20,),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 1,
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 1),
//                       child: Container(
//                           height: 70,
//                           child: InkWell(
//                             onTap: (){
//
//                             },
//                             child: Container(
//                               height: 51,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).backgroundColor,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//
//                               child: DropDownComponent(items: identityArray,
//                                   onChange: (String item){
//                                     setState(() {
//
//                                       List<dynamic> selectID =   allIdentity.where((element) => element['name'] == item).toList();
//                                       print('this is select ID');
//                                       print(selectID[0]['id']);
//                                       identityInt = selectID[0]['id'];
//                                       print('end this is select ID');
//
//                                     });
//                                   },
//                                   label: "Document Type * ",
//                                   selectedItem: "----",
//                                   validator: (String item){
//
//                                   }
//                               ),
//                             ),
//                           )
//
//                       )
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Container(
//                   width: MediaQuery.of(context).size.width ,
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 1),
//                       child: Container(
//                           height: 60,
//                           child: InkWell(
//                             onTap: (){
//
//                             },
//                             child: Container(
//                               height: 51,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).backgroundColor,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//
//                               child:   TextFormField(
//
//                                 style: TextStyle(fontFamily: 'Nunito SansRegular'),
//
//                                 autofocus: false,
//                                 readOnly: true,
//                                 controller: dateController,
//
//                                 decoration: InputDecoration(
//                                     suffixIcon: IconButton(
//                                       onPressed: (){
//                                        showDatePicker();
//                                       },
//                                       icon:   Icon(Icons.date_range,color: Colors.blue
//                                         ,) ,
//                                     ),
//
//                                     focusedBorder:OutlineInputBorder(
//                                       borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                                     ),
//                                     border: OutlineInputBorder(
//
//                                     ),
//                                     labelText: 'Expiry Date',
//                                     floatingLabelStyle: TextStyle(color:Color(0xff205072)),
//                                     hintText: 'Expiry Date',
//                                     hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
//                                     labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)
//
//                                 ),
//                                 textInputAction: TextInputAction.done,
//                               ),
//
//                             ),
//                           )
//
//                       )
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//       ],
//     );
//   }
//
//
//   Widget proofOfEmployment(){
//     return Column(
//
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text('Proof Of Employment',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
//             Text('')
//           ],
//         ),
//         SizedBox(height: 10,),
//         Container(
//
//           child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
//               child: Container(
//                   height: 70,
//                   child: InkWell(
//                     onTap: (){
//
//                     },
//                     child: Container(
//                       height: 71,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).backgroundColor,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//
//                       child: TextFormField(
//                         controller: proof_of_employment,
//                         autofocus: false,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           focusedBorder:OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey, width: 0.6),
//
//                           ),
//                           border: OutlineInputBorder(
//
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: (){
//                               _openEmploymentExplorer();
//                             },
//                             icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                               ,) ,
//                           )
//                           ,
//                           // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//
//                           labelText: 'Employment *',
//                           hintStyle: kBodyPlaceholder,
//                         ),
//                         style: kBodyText,
//                         // keyboardType: inputType,
//                         // textInputAction: inputAction,
//                       ),
//                     ),
//                   )
//
//               )
//           ),
//         ),
//
//     SizedBox(height: 20,),
//         Container(
//
//           child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
//               child: Container(
//                   height: 70,
//                   child: InkWell(
//                     onTap: (){
//
//                     },
//                     child: Container(
//                       height: 51,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).backgroundColor,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//
//                       child: DropDownComponent(items: employmentArray,
//                           onChange: (String item){
//                             setState(() {
//
//                               List<dynamic> selectID =   allEmployment.where((element) => element['name'] == item).toList();
//                               print('this is select ID');
//                               print(selectID[0]['id']);
//                               employmentInt = selectID[0]['id'];
//                               print('end this is select ID');
//
//                             });
//                           },
//                           label: "Document Type * ",
//                           selectedItem: "-----",
//                           validator: (String item){
//
//                           }
//                       ),
//                     ),
//                   )
//
//               )
//           ),
//         ),
//
//         SizedBox(height: 30,),
//
//       ],
//     );
//   }
//
//
// }
//
