// import 'dart:convert';
// import 'dart:io' as Io;
// import 'dart:typed_data';
// import 'dart:io';
// import 'dart:math';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sales_toolkit/util/app_url.dart';
// import 'package:sales_toolkit/util/router.dart';
// import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
// import 'package:sales_toolkit/view_models/addClient.dart';
// import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
// import 'package:sales_toolkit/views/draft/ClientDraft.dart';
// import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
// import 'package:sales_toolkit/widgets/Stepper.dart';
// import 'package:sales_toolkit/widgets/constants.dart';
// import 'package:sales_toolkit/widgets/dropdown.dart';
// import 'package:sales_toolkit/widgets/rounded-button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
//
// import '../../palatte.dart';
//
//
// class EditLoanDocument extends StatefulWidget {
//   final int ClientInt,documentID;
//
//   const EditLoanDocument({Key key,this.ClientInt,this.documentID}) : super(key: key);
//
//   @override
//   _EditLoanDocumentState createState() => _EditLoanDocumentState(
//     ClientInt:this.ClientInt,
//     documentID:this.documentID,
//   );
// }
//
// class _EditLoanDocumentState extends State<EditLoanDocument> {
//   int ClientInt,documentID;
//
//   _EditLoanDocumentState({this.ClientInt,this.documentID});
//   @override
//   TextEditingController passport = TextEditingController();
//   TextEditingController esignature = TextEditingController();
//   TextEditingController proof_of_residence = TextEditingController();
//   TextEditingController proof_of_identity = TextEditingController();
//   TextEditingController proof_of_employment = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//
//   String fileName ='';
//   // final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
//
//   // void _handleClearButtonPressed() {
//   //   signatureGlobalKey.currentState.clear();
//   // }
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
//   bool value = false;
//   FileType _pickingType;
//   DateTime selectedDate = DateTime.now();
//   DateTime CupertinoSelectedDate = DateTime.now();
//
//
//   TextEditingController _controller = new TextEditingController();
//   File chosenImage;
//
//   List<String> DocumentTypeArray = [];
//   List<String> collectDocumentType = [];
//   List<dynamic> allDocumentType = [];
//
//   List<String> UpdateDocumentTypeArray = [];
//   List<String> UpdatecollectDocumentType = [];
//   List<dynamic> UpdateallDocumentType = [];
//
//
//   List<String> identityArray = [];
//   List<String> collectIdentity = [];
//   List<dynamic> allIdentity = [];
//
//   List<String> documentCategoryArray = [];
//   List<String> collectDocumentCategory = [];
//   List<dynamic> allDocumentCategory = [];
//
//   List<String> UpdatedocumentCategoryArray = [];
//   List<String> UpdatecollectDocumentCategory = [];
//   List<dynamic> UpdateallDocumentCategory = [];
//
//   int employmentInt,identityInt,documentTypeInt,updateDocumentInt;
//
//   String passportFileName,passportFileSize,passportFiletype,passportFileLocation,newFileLocation;
//   String documentFileName,residenceFileSize,documentFiletype,documentFileLocation;
//   String identityFileName,identityFileSize,identityFiletype,identityFileLocation;
//   String employmentFileName,employmentFileSize,employmentFiletype,employmentFileLocation;
//
//   bool _isLoading = false;
//   List<dynamic> objectFetched = [];
//
//   AddClientProvider addClientProvider = AddClientProvider();
//
//   void _handleSaveButtonPressed() async {
//     // final data =
//     // await signatureGlobalKey.currentState.toImage(pixelRatio: 3.0);
//     // final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
//     // final encoded = base64.encode(bytes.buffer.asUint8List());
//     //
//     // debugPrint("onPressed " + encoded);
//     // print(bytes.elementSizeInBytes);
//
//     setState(() {
//       // signatureBase64 = encoded;
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
//     //  getEmploymentList();
//     getIdentityList();
//     getDocumentUploadInformation();
//
//     print('client ID ${ClientInt}');
//     _controller.addListener(() => _extension = _controller.text);
//   }
//
//   List<dynamic> docsLists= [];
//
//   getResidentialList(){
//     final Future<Map<String,dynamic>> respose =   RetCodes().DocumentConfiguration();
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
//             allDocumentType = mtBool;
//             UpdateallDocumentType = mtBool;
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectDocumentType.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             DocumentTypeArray = collectDocumentType;
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
//       }
//       else {
//         List<dynamic> newEmp = response['data'];
//
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         prefs.setString('prefsProofOfResidence', jsonEncode(newEmp));
//
//
//         setState(() {
//           allDocumentType = newEmp;
//           UpdateallDocumentType = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           collectDocumentType.add(newEmp[i]['name']);
//           UpdatecollectDocumentType.add(newEmp[i]['name']);
//
//         }
//         print('vis alali');
//         print(UpdatecollectDocumentType);
//
//         setState(() {
//           DocumentTypeArray = collectDocumentType;
//           UpdateDocumentTypeArray = UpdatecollectDocumentType;
//         });
//       }
//
//     }
//     );
//   }
//
//   getSubCategoryForCOnfig(String codeID){
//     final Future<Map<String,dynamic>> respose =   RetCodes().getCodes(codeID);
//
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
//             allDocumentCategory = mtBool;
//
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectDocumentCategory.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             documentCategoryArray = collectDocumentCategory;
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
//           collectDocumentCategory = [];
//           allDocumentCategory = newEmp;
//           UpdateallDocumentCategory = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           collectDocumentCategory.add(newEmp[i]['name']);
//           UpdatecollectDocumentCategory.add(newEmp[i]['name']);
//         }
//         print('vis alali');
//         print(collectDocumentCategory);
//
//         setState(() {
//
//           documentCategoryArray = collectDocumentCategory;
//           UpdatedocumentCategoryArray = UpdatecollectDocumentCategory;
//           //
//         });
//       }
//
//     }
//     );
//   }
//
//
//   getSubCategoryForCOnfigUpdate(String codeID){
//     final Future<Map<String,dynamic>> respose =   RetCodes().getCodes(codeID);
//
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
//             allDocumentCategory = mtBool;
//
//           });
//
//           for(int i = 0; i < mtBool.length;i++){
//             print(mtBool[i]['name']);
//             collectDocumentCategory.add(mtBool[i]['name']);
//           }
//
//           setState(() {
//             documentCategoryArray = collectDocumentCategory;
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
//           UpdateallDocumentCategory = [];
//
//           UpdateallDocumentCategory = newEmp;
//         });
//
//         for(int i = 0; i < newEmp.length;i++){
//           print(newEmp[i]['name']);
//           //  collectDocumentCategory.add(newEmp[i]['name']);
//           UpdatecollectDocumentCategory.add(newEmp[i]['name']);
//         }
//         print('vis alali from update');
//         print(UpdatecollectDocumentCategory);
//
//         setState(() {
//
//           // documentCategoryArray = collectDocumentCategory;
//           UpdatedocumentCategoryArray = UpdatecollectDocumentCategory;
//           //
//         });
//
//         print('collect Category ${UpdatedocumentCategoryArray}');
//       }
//
//     }
//     );
//   }
//
//
//   getIdentityList(){
//     final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('1');
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
//   void _openFileExplorer() async {
//     if (_pickingType != FileType.CUSTOM || _hasValidMime) {
//       try {
//         _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//         print('this is Path ${_path}');
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
//         print('passport file location ${passportFiletype} ');
//
//         setState(() {
//           if(passportFiletype == 'png'){
//             appendBase64 ='data:image/png;base64,';
//           }
//           else if(passportFiletype == 'jpg'){
//             appendBase64 = 'data:image/jpeg;base64,';
//           } else if(passportFiletype == 'jpeg'){
//             appendBase64 ='data:image/jpeg;base64,';
//           }
//
//         });
//
//         newFileLocation = appendBase64 + passportFileLocation;
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
//
//     }
//   }
//
//   getDocumentUploadInformation() async{
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;
//
//     print('localInt ${localclientID}');
//
//     var token = prefs.getString('base64EncodedAuthenticationKey');
//     var tfaToken = prefs.getString('tfa-token');
//     print(tfaToken);
//     print(token);
//     Response responsevv = await get(
//       AppUrl.getSingleClientPersonalInfo + localclientID.toString() + '/identifiers/attachment',
//       headers: {
//         'Content-Type': 'application/json',
//         'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
//         'Authorization': 'Basic ${token}',
//         'Fineract-Platform-TFA-Token': '${tfaToken}',
//       },
//     );
//     print(responsevv.body);
//
//     final List<dynamic> responseData2 = json.decode(responsevv.body);
//     print(responseData2);
//     var newClientData = responseData2;
//     print('newClient Data');
//     setState(() {
//       docsLists  = newClientData;
//     });
//
//     print('docsList ${docsLists}');
//     //  year_at_residence = ResidentialNoOfYears.toString();
//
//   }
//
//
//
//
//   void _openDocumentsExplorer() async {
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
//           documentFileLocation = img64;
//           residenceFileSize = filesizeAsString;
//           documentFiletype = _path.split('.').last;
//         });
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
//         // documentFileName = _fileName;
//
//       });
//
//       // objectFetched.add({
//       //   "id": random(1,50),
//       //   "name": identityName,
//       //   "fileName": bankFileName,
//       //   //  "size": bankFileSize,
//       //   "type": bankFiletype == 'pdf' ? "application/pdf" : bankFiletype == 'png' ? 'image/png' :  bankFiletype == 'jpg' ? 'image/jpeg' : '',
//       //   "location": bankFileLocation,
//       //   "description": identityName
//       // });
//
//       objectFetched.add(
//         {
//           // "id":0,
//           "documentTypeId": documentTypeInt,
//           "status" : "ACTIVE",
//           "documentKey": random(1000000, 9000000),
//           "attachment" : {
//             "name" : documentFileName,
//             "location" : documentFileLocation,
//             "description" : "Proof Of Residence",
//             "fileName" : documentFileName,
//             // "size" : int.parse(residenceFileSize),
//             "type" : documentFiletype == 'png' ? "image/png" : documentFiletype == 'jpg' ? "image/jpeg" : documentFiletype == 'pdf' ? 'application/pdf' : ''
//           }
//         },
//       );
//
//
//
//
//     }
//
//     print('objectFetched' + objectFetched.toString());
//
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
//     // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
//
//     //4a
//     var choosedimage = await ImagePicker.pickImage(source: source);
//     print('this ${choosedimage.toString()}');
//     File imagefile = choosedimage;//convert Path to File
//
//     Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
//     String base64string = base64.encode(imagebytes); //convert bytes to base64 string
//     print('base64string ${base64string}');
//
//     String _finalPath =   choosedimage.toString();
//     // final bytes = Io.File(_finalPath).readAsBytesSync();
//     //   final byeInLength = Io.File(_finalPath).readAsBytesSync().lengthInBytes;
//     // String img64 = base64Encode(bytes);
//
//     // print(img64);
//
//     setState(() {
//       // uploadimage = choosedimage;
//       // String getPath  = choosedimage.toString();
//       // _fileName = getPath != null ? getPath.split('/').last : '...';
//       // _openFileExplorer(getPath);
//
//
//       File file = choosedimage;
//       fileName = file.path.split('/').last;
//       print('filename ${fileName}');
//       passport.text = fileName;
//     });
//
//     // final kb = byeInLength / 1024;
//     // final mb = kb / 1024;
//     // print('this is the MB ${mb}');
//     //  String filesizeAsString  = mb.toString();
//     // print('this is file sizelenght ${filesizeAsString}');
//     // print('image base64 ${img64}');
//
//
//     setState(() {
//       passportFileLocation = base64string;
//       passportFileSize = '';
//       passportFiletype = fileName.split('.').last;
//
//     });
//
//
//
//     print('passport file location ${passportFiletype} ');
//
//     setState(() {
//       if(passportFiletype == 'png'){
//         appendBase64 ='data:image/png;base64,';
//       }
//       else if(passportFiletype == 'jpg'){
//         appendBase64 = 'data:image/jpeg;base64,';
//       } else if(passportFiletype == 'jpeg'){
//         appendBase64 ='data:image/jpeg;base64,';
//       }
//
//     });
//
//     newFileLocation = appendBase64 + passportFileLocation;
//
//     if (!mounted) return;
//
//     setState(() {
//       // _fileName = _path != null ? _path.split('/').last : '...';
//       // passport.text = _fileName;
//       // passportFileName = _fileName;
//
//     });
//
//   }
//
//   void doDocumentAction(String value){
//
//     if(value == 'Edit_Documenta'){
//       MyRouter.pushPage(context,EditLoanDocument());
//
//     }
//     // else if(value == 'view'){
//     //   MyRouter.pushPage(context, DocumentPreview(passedDocument: docsLists[position]['attachment']['location'],));
//     //
//     // }
//
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
//             "Choose...",
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
//
//   Widget signatureBottomSheet() {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//
//
//             ],
//           ),
//         ),
//         backgroundColor: Colors.white,
//         title: Text('Update Document',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
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
//         height:  MediaQuery.of(context).size.height * 0.91,
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 20,
//         ),
//         child: Column(
//           children: <Widget>[
//
//             Container(
//                 height:  MediaQuery.of(context).size.height * 0.50,
//                 child: DocumentConfiguration(),
//
//                 decoration:
//                 BoxDecoration(border: Border.all(color: Colors.grey))),
//
//           ],
//         ),
//       ),
//       bottomNavigationBar:  DoubleBottomNavComponent(text1: 'Clear',text2: 'Done',callAction2: (){
//         _handleSaveButtonPressed();
//
//       },callAction1: (){
//         // _handleClearButtonPressed();
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
//
//       // if(dateController.text.isEmpty){
//  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
//       //     backgroundColor: Colors.red,
//       //     title: "Validation error",
//       //     message: 'Fill all fields before submitting',
//       //     duration: Duration(seconds: 3),
//       //   ).show(context);
//       // }
//       print('passport Location ${passportFileLocation}' );
//
//       String passportLocation =  passportFileLocation;
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
//           "documentTypeId": documentTypeInt,
//           "status" : "ACTIVE",
//           "documentKey": random(1000000, 9000000),
//           "attachment" : {
//
//             "location" : documentFileLocation,
//             "name" : documentFileName,
//             "description" : "Proof Of Residence",
//             "fileName" : documentFileName,
//             // "size" : int.parse(residenceFileSize),
//             "type" : documentFiletype == 'png' ? "image/png" : documentFiletype == 'jpg' ? "image/jpeg" : documentFiletype == 'pdf' ? 'application/pdf' : ''
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
//             "type" : employmentFiletype == 'png' ? "image/png" : employmentFiletype == 'jpg' ? "image/jpeg" : employmentFiletype == 'pdf' ? 'application/pdf' : ''
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
//             "type" : identityFiletype == 'png' ? "image/png" : identityFiletype == 'jpg' ? "image/jpeg" : identityFiletype == 'pdf' ? 'application/pdf' : ''
//           }
//         }
//       ];
//
//
//       print('this is loan doc ${loanDocumentData}');
//
//       final Future<Map<String,dynamic>> respose =  addClientProvider.addDocumentUpload(objectFetched,newFileLocation,passportFiletype,ClientInt);
//
//
//       respose.then((response) {
//
//         //  return print('response from backend ${response}');
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
//             return MyRouter.pushPage(context, ClientDraftLists());
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
//
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
//       isLoading: _isLoading,
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
//                 ProgressStepper(stepper: 0.09,title: 'Edit Document',subtitle: '',),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 1.5,
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//                         child: Container(
//                             padding: EdgeInsets.only(top: 10,left: 10,right: 10),
//                             height: MediaQuery.of(context).size.height * 0.075,
//                             decoration: BoxDecoration(
//                               color: Color(0xffFC2E83).withOpacity(0.2),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                             ),
//                             child: Text('Ensure all documents are uploaded and tagged properly. Files should be in .jpg, .png or .pdf formats.',style: TextStyle(fontSize: 11,color: Color(0xffFC2E83)),)),
//                       ),
//
//                       SizedBox(height: 10,),
//
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       //   children: [
//                       //     Text('Document',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
//                       //     Text('')
//                       //   ],
//                       // ),
//
//                       SizedBox(height: 20,),
//                       SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             DocumentConfiguration(),
//                             SizedBox(height: 10,),
//
//                           ],
//                         ),
//                       )
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
//           //  MyRouter.pushPage(context, MainScreen());
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
//   Widget DocumentConfiguration(){
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text('Documents',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
//             Text('')
//           ],
//         ),
//         SizedBox(height: 40,),
//         Container(
//           height: MediaQuery.of(context).size.height * 1.5,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//
//                 Container(
//                   height: 70,
//                   child: DropDownComponent(items: DocumentTypeArray,
//                       onChange: (String item){
//                         setState(() {
//
//                           List<dynamic> selectID =   allDocumentType.where((element) => element['name'] == item).toList();
//                           print('this is select ID');
//                           print(selectID[0]['id']);
//                           documentTypeInt = selectID[0]['id'];
//                           getSubCategoryForCOnfig(documentTypeInt.toString());
//                           print('end this is select ID');
//
//                         });
//                       },
//                       label: "Select Document Type * ",
//                       selectedItem: "",
//                       validator: (String item){
//
//                       }
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Container(
//                   height: 70,
//                   child: DropDownComponent(items: documentCategoryArray,
//                       onChange: (String item){
//                         setState(() {
//
//                           List<dynamic> selectID =   allDocumentCategory.where((element) => element['name'] == item).toList();
//                           print('this is select ID');
//                           print(selectID[0]['id']);
//                           documentTypeInt = selectID[0]['id'];
//                           documentFileName = selectID[0]['name'];
//                           getSubCategoryForCOnfig(documentTypeInt.toString());
//                           print('end this is select ID');
//
//                         });
//                       },
//                       label: "Select category * ",
//                       selectedItem: "-----",
//                       validator: (String item){
//
//                       }
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 1.7,
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
//                                       _openDocumentsExplorer();
//                                     },
//                                     icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                       ,) ,
//                                   )
//                                   ,
//                                   // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//
//                                   labelText: 'Select Document *',
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
//                 SizedBox(height: 10,),
//
//
//
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
//   Widget showDocumentUpdate(int documentID,String documentKey){
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text('Documents',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
//             Text('')
//           ],
//         ),
//         SizedBox(height: 40,),
//         Container(
//           height: MediaQuery.of(context).size.height * 0.5,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//
//                 Container(
//                   height: 70,
//                   child: DropDownComponent(items: UpdateDocumentTypeArray,
//                       onChange: (String item){
//                         setState(() {
//
//                           List<dynamic> selectID =   UpdateallDocumentType.where((element) => element['name'] == item).toList();
//                           print('this is select ID for Update');
//                           print(selectID[0]['id']);
//                           updateDocumentInt = selectID[0]['id'];
//                           getSubCategoryForCOnfigUpdate(updateDocumentInt.toString());
//                           print('end this is select ID');
//
//                         });
//                       },
//                       label: "Select Document Type * ",
//                       selectedItem: "",
//                       validator: (String item){
//
//                       }
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Container(
//                   height: 70,
//                   child: DropDownComponent(items: UpdatedocumentCategoryArray,
//                       onChange: (String item){
//                         setState(() {
//
//                           List<dynamic> selectID =   UpdateallDocumentCategory.where((element) => element['name'] == item).toList();
//                           print('this is select ID');
//                           print(selectID[0]['id']);
//                           //  documentTypeInt = selectID[0]['id'];
//                           //   documentFileName = selectID[0]['name'];
//                           // getSubCategoryForCOnfig(documentTypeInt.toString());
//                           print('end this is select ID');
//
//                         });
//                       },
//                       label: "Select category * ",
//                       selectedItem: "-----",
//                       validator: (String item){
//
//                       }
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 1.0,
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
//                                       _openDocumentsExplorer();
//                                     },
//                                     icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
//                                       ,) ,
//                                   )
//                                   ,
//                                   // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
//
//                                   labelText: 'Select Document *',
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
//                 SizedBox(height: 10,),
//                 Container(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     child: RoundedButton(buttonText: 'Update Document', onbuttonPressed: (){
//
//                       //  UpdateDoc(documentID);
//
//                     }))
//                 // SizedBox(height: 50,),
//
//
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
//
//
// }
//
