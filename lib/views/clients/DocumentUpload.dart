import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/DocumentPreview.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/testDiscovers.dart';
import 'package:sales_toolkit/views/draft/ClientDraft.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:sales_toolkit/widgets/shared/pickDocument.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../palatte.dart';
import '../../view_models/post_put_method.dart';

class DocumentUpload extends StatefulWidget {
  final int ClientInt;
  final String comingFrom;
  const DocumentUpload({Key key, this.ClientInt, this.comingFrom})
      : super(key: key);

  @override
  _DocumentUploadState createState() => _DocumentUploadState(
        ClientInt: this.ClientInt,
        comingFrom: this.comingFrom,
      );
}

class _DocumentUploadState extends State<DocumentUpload> {
  int ClientInt;
  String comingFrom;
  _DocumentUploadState({this.ClientInt, this.comingFrom});
  @override
  TextEditingController passport = TextEditingController();
  TextEditingController esignature = TextEditingController();
  TextEditingController proof_of_residence = TextEditingController();
  TextEditingController proof_of_identity = TextEditingController();
  TextEditingController proof_of_employment = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // String fileName ='';
  // final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  // void _handleClearButtonPressed() {
  //   signatureGlobalKey.currentState.clear();
  // }

  File uploadimage;
  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';
  String _path = '...';
  String _extension;
  String signatureBase64;
  bool _hasValidMime = false;
  String appendBase64 = '';
  bool value = false;
  FileType _pickingType;
  DateTime selectedDate = DateTime.now();
  DateTime CupertinoSelectedDate = DateTime.now();

  TextEditingController _controller = new TextEditingController();
  File chosenImage;

  List<String> DocumentTypeArray = [];
  List<String> collectDocumentType = [];
  List<dynamic> allDocumentType = [];

  List<String> UpdateDocumentTypeArray = [];
  List<String> UpdatecollectDocumentType = [];
  List<dynamic> UpdateallDocumentType = [];

  List<String> identityArray = [];
  List<String> collectIdentity = [];
  List<dynamic> allIdentity = [];

  List<String> documentCategoryArray = [];
  List<String> collectDocumentCategory = [];
  List<dynamic> allDocumentCategory = [];

  List<String> UpdatedocumentCategoryArray = [];
  List<String> UpdatecollectDocumentCategory = [];
  List<dynamic> UpdateallDocumentCategory = [];

  int employmentInt, identityInt, documentTypeInt, updateDocumentInt;

  String passportFileName,
      passportFileSize,
      passportFiletype,
      passportFileLocation,
      newFileLocation;
  String documentFileName,
      residenceFileSize,
      documentFiletype,
      documentFileLocation;
  String identityFileName,
      identityFileSize,
      identityFiletype,
      identityFileLocation;
  String employmentFileName,
      employmentFileSize,
      employmentFiletype,
      employmentFileLocation;
  String passportPhotoGraph = '';
  bool _isLoading = false;
  bool isPassportAdded = false;
  List<dynamic> objectFetched = [];
  var _copying = false;
  var _lastPick = 'No file picked';

  // String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );

  AddClientProvider addClientProvider = AddClientProvider();

  void _handleSaveButtonPressed() async {
    // final data =
    // await signatureGlobalKey.currentState.toImage(pixelRatio: 3.0);
    //  final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    //   final encoded = base64.encode(bytes.buffer.asUint8List());
    //
    //   debugPrint("onPressed " + encoded);
    //   print(bytes.elementSizeInBytes);

    setState(() {
      // signatureBase64 = encoded;
      esignature.text = 'Signature appended';
    });

    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         appBar: AppBar(),
    //         body: Center(
    //           child: Container(
    //             color: Colors.grey[300],
    //             child: Image.memory(bytes.buffer.asUint8List()),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getResidentialList();
    //  getEmploymentList();
    getIdentityList();
    getDocumentUploadInformation();
    getPassportPhotograph();
    print('client ID ${ClientInt}');
    _controller.addListener(() => _extension = _controller.text);
  }

  List<dynamic> docsLists = [];

  getResidentialList() {
    final Future<Map<String, dynamic>> respose =
        RetCodes().DocumentConfiguration();
    // respose.then((response) {
    //   print('marital array');
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allResidence = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectResidence.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectResidence);
    //
    //   setState(() {
    //     residenceArray = collectResidence;
    //   });
    // }
    // );

    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
            jsonDecode(prefs.getString('prefsProofOfResidence'));

        //
        if (prefs.getString('prefsProofOfResidence').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allDocumentType = mtBool;
            UpdateallDocumentType = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectDocumentType.add(mtBool[i]['name']);
          }

          setState(() {
            DocumentTypeArray = collectDocumentType;
            documentCategoryArray = [];
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsProofOfResidence', jsonEncode(newEmp));

        setState(() {
          allDocumentType = newEmp;
          // UpdateallDocumentType = newEmp;
        });

        List<dynamic> modifiedEmp =
            newEmp.where((element) => element['systemDefined']).toList();

        for (int i = 0; i < modifiedEmp.length; i++) {
          print(modifiedEmp[i]['name']);
          collectDocumentType.add(modifiedEmp[i]['name']);
        }

        //  print(UpdatecollectDocumentType);

        setState(() {
          DocumentTypeArray = collectDocumentType;
          //   UpdateDocumentTypeArray = UpdatecollectDocumentType;
        });
      }
    });
  }

  getSubCategoryForCOnfig(String codeID) {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes(codeID);

    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
            jsonDecode(prefs.getString('prefsProofOfEmployment'));

        //
        if (prefs.getString('prefsProofOfEmployment').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allDocumentCategory = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectDocumentCategory.add(mtBool[i]['name']);
          }

          setState(() {
            documentCategoryArray = collectDocumentCategory;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsProofOfEmployment', jsonEncode(newEmp));

        setState(() {
          collectDocumentCategory = [];
          allDocumentCategory = newEmp;
          UpdateallDocumentCategory = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          print(newEmp[i]['name']);
          collectDocumentCategory.add(newEmp[i]['name']);
          UpdatecollectDocumentCategory.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectDocumentCategory);

        setState(() {
          documentCategoryArray = collectDocumentCategory;
          UpdatedocumentCategoryArray = UpdatecollectDocumentCategory;
          //
        });
      }
    });
  }

  getSubCategoryForCOnfigUpdate(String codeID) {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes(codeID);

    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
            jsonDecode(prefs.getString('prefsProofOfEmployment'));

        //
        if (prefs.getString('prefsProofOfEmployment').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allDocumentCategory = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectDocumentCategory.add(mtBool[i]['name']);
          }

          setState(() {
            documentCategoryArray = collectDocumentCategory;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsProofOfEmployment', jsonEncode(newEmp));

        setState(() {
          UpdateallDocumentCategory = [];

          UpdateallDocumentCategory = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          print(newEmp[i]['name']);
          //  collectDocumentCategory.add(newEmp[i]['name']);
          UpdatecollectDocumentCategory.add(newEmp[i]['name']);
        }
        print('vis alali from update');
        print(UpdatecollectDocumentCategory);

        setState(() {
          // documentCategoryArray = collectDocumentCategory;
          UpdatedocumentCategoryArray = UpdatecollectDocumentCategory;
          //
        });

        print('collect Category ${UpdatedocumentCategoryArray}');
      }
    });
  }

  getIdentityList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('1');
    // respose.then((response) {
    //   print('marital array');
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allIdentity = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectIdentity.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectIdentity);
    //
    //   setState(() {
    //     identityArray = collectIdentity;
    //   });
    // }
    // );

    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
            jsonDecode(prefs.getString('prefsProofOfIdentity'));

        //
        if (prefs.getString('prefsProofOfIdentity').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allIdentity = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectIdentity.add(mtBool[i]['name']);
          }

          setState(() {
            identityArray = collectIdentity;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsProofOfIdentity', jsonEncode(newEmp));

        setState(() {
          allIdentity = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          print(newEmp[i]['name']);
          collectIdentity.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectIdentity);

        setState(() {
          identityArray = collectIdentity;
        });
      }
    });
  }

  void _openFileExplorer() async {
    MyRouter.popPage(context);

    String result;
    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeTypes: ["image/png", "image/jpeg", "image/jpg"],
      );

      // result = await FlutterDocumentPicker.openDocument(params: params);
      result = await FlutterDocumentPicker.openDocument(params: params);

      final file = File(result);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        setState(() {
          passport.text = '';
          passportFileLocation = '';
          _path = '-';
          isPassportAdded = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('File Size Exceeded'),
              content: Text('Please select a file with a maximum size of 2MB.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      // setState(() {
      //   _pickFileInProgress = false;
      // });
    }

    setState(() {
      _path = result;
    });

    try {
      //  var newPath  = await FilePicker.getFile(type: _pickingType,fileExtension: _extension);
      //  print('this is new Path ${newPath}');
      // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);

      // print('this is Path ${_path}');

      print('file extension ${_path.split('.').last}');

      String filePath = _path.split('.').last;

      var result;

      bool extensionChecker =
          filePath == 'png' || filePath == 'jpg' || filePath == 'jpeg'
              ? true
              : false;

      if (extensionChecker) {
        result = await FlutterImageCompress.compressWithFile(
          _path,
          minWidth: 330,
          minHeight: 250,
          quality: 90,
          //  rotate: 180,
        );
        //    print('this is file sixe');

      }

      final bytes = Io.File(_path).readAsBytesSync();
      final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
      String img64 = base64Encode(extensionChecker ? result : bytes);

      // get file size
      final kb = byeInLength / 1024;
      final mb = kb / 1024;
      print('this is the MB ${mb}');
      String filesizeAsString = mb.toString();
      print('this is file sizelenght ${filesizeAsString}');
      print('image base64 ${img64}');

      setState(() {
        passportFileLocation = img64;
        passportFileSize = filesizeAsString;
        passportFiletype = _path.split('.').last;
      });

      print('passport file location ${passportFiletype} ');

      setState(() {
        if (passportFiletype == 'png') {
          appendBase64 = 'data:image/png;base64,';
        } else if (passportFiletype == 'jpg') {
          appendBase64 = 'data:image/jpeg;base64,';
        } else if (passportFiletype == 'jpeg') {
          appendBase64 = 'data:image/jpeg;base64,';
        }
      });

      newFileLocation = appendBase64 + passportFileLocation;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
      passport.text = _fileName;
      passportFileName = _fileName;
      isPassportAdded = true;
    });

    // }
  }

  getDocumentUploadInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =
        ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleClientPersonalInfo +
          localclientID.toString() +
          '/identifiers/attachment',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    print('newClient Data');
    setState(() {
      docsLists = newClientData;
    });

    print('docsList ${docsLists}');
    //  year_at_residence = ResidentialNoOfYears.toString();
  }

  getPassportPhotograph() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =
        ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleClientPersonalInfo + localclientID.toString() + '/images',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    if (responsevv.statusCode == 404) {
      passportPhotoGraph = '';
      setState(() {
        isPassportAdded = false;
      });
    } else if (responsevv.statusCode != 200) {
      passportPhotoGraph = '';
      setState(() {
        isPassportAdded = false;
      });
    } else {
      passport.text = 'Passport Photograph';
      setState(() {
        isPassportAdded = true;
      });

      final String responseData2 = responsevv.body;
      print('newClient Data ${responseData2}');
      print(responseData2);
      var newClientData = responseData2;

      setState(() {
        newFileLocation = newClientData;
      });

      print('docsList passport ${newFileLocation}');
    }

    //  year_at_residence = ResidentialNoOfYears.toString();
  }

  // Future<Uint8List> testComporessList(Uint8List list) async {
  //   var result = await FlutterImageCompress.compressWithList(
  //     list,
  //     minHeight: 1920,
  //     minWidth: 1080,
  //     quality: 16,
  //     rotate: 135,
  //   );
  //   print('this is lenght result ''::');
  //   print(list.length);
  //   print(result.length);
  //   return result;
  // }

  pickDocument() async {
    String result;

//  final filePath = await FlutterDocumentPicker.openDocument();

//     final file = File(filePath);
//     final fileSize = await file.length();
//     if (fileSize > 5 * 1024 * 1024) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('File Size Exceeded'),
//             content: Text('Please select a file with a maximum size of 2MB.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }

    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeTypes: [
          "application/pdf",
          "image/png",
          "image/jpeg",
          "image/jpg"
        ],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
      //  final filePath = await FlutterDocumentPicker.openDocument();

      final file = File(result);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('File Size Exceeded'),
              content: Text('Please select a file with a maximum size of 2MB.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });

    try {
      String filePath = _path.split('.').last;

      var result;

      bool extensionChecker =
          filePath == 'png' || filePath == 'jpg' || filePath == 'jpeg'
              ? true
              : false;

      if (extensionChecker) {
        result = await FlutterImageCompress.compressWithFile(
          _path,
          minWidth: 330,
          minHeight: 250,
          quality: 90,
          //  rotate: 180,
        );
        //    print('this is file sixe');

      }

      final bytes = Io.File(_path).readAsBytesSync();

      final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
      String img64 = base64Encode(extensionChecker ? result : bytes);

      // get file size
      final kb = byeInLength / 1024;
      final mb = kb / 1024;
      print('this is the MB ${mb} ${kb}');
      String filesizeAsString = mb.toString();
      print('this is file sizelenght ${filesizeAsString}');
      print('image base64 ${img64}');

      // return;
      setState(() {
        documentFileLocation = img64;
        residenceFileSize = filesizeAsString;
        documentFiletype = _path.split('.').last;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
      proof_of_residence.text = _fileName;
      // documentFileName = _fileName;
    });

    objectFetched.add(
      {
        // "id":0,
        "documentTypeId": documentTypeInt,
        "status": "ACTIVE",
        "documentKey": random(1000000, 9000000),
        "attachment": {
          "name": documentFileName,
          "location": documentFileLocation,
          //  "description" : "Proof Of Residence",
          "fileName": documentFileName,
          // "size" : int.parse(residenceFileSize),
          "type": documentFiletype == 'png'
              ? "image/png"
              : documentFiletype == 'jpg'
                  ? "image/jpeg"
                  : documentFiletype == 'pdf'
                      ? 'application/pdf'
                      : ''
        }
      },
    );

    // }
  }

  void _openDocumentsExplorer() async {
    MyRouter.popPage(context);
    pickDocument();

    // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
    //   try {
    //
    //     DocumentPick documentPick = new DocumentPick();
    //    // var new_path = await FilePicker.getFile(type: _pickingType, fileExtension: _extension,);
    //
    //      var _newpath = documentPick.pickDocument();
    //      print('newPath ${_newpath}');
    //       //_path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension,);
    //
    //       String filePath = _path.split('.').last;
    //
    //       var result;
    //
    //       bool extensionChecker = filePath == 'png' || filePath == 'jpg' || filePath == 'jpeg' ? true : false;
    //
    //       if(extensionChecker) {
    //         result = await FlutterImageCompress.compressWithFile(
    //           _path,
    //           minWidth: 230,
    //           minHeight: 150,
    //           quality: 40,
    //         //  rotate: 180,
    //         );
    //         //    print('this is file sixe');
    //
    //       }
    //
    //
    //
    //       final bytes = Io.File(_path).readAsBytesSync();
    //
    //       final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
    //       String img64 = base64Encode(extensionChecker ? result  : bytes);
    //
    //
    //
    //       // get file size
    //       final kb = byeInLength / 1024;
    //       final mb = kb / 1024;
    //       print('this is the MB ${mb} ${kb}');
    //       String filesizeAsString  = mb.toString();
    //       print('this is file sizelenght ${filesizeAsString}');
    //       print('image base64 ${img64}');
    //
    //
    //      // return;
    //       setState(() {
    //         documentFileLocation = img64;
    //         residenceFileSize = filesizeAsString;
    //         documentFiletype = _path.split('.').last;
    //       });
    //
    //     } on PlatformException catch (e) {
    //       print("Unsupported operation" + e.toString());
    //     }
    //
    //     if (!mounted) return;
    //
    //     setState(() {
    //       _fileName = _path != null ? _path.split('/').last : '...';
    //       proof_of_residence.text = _fileName;
    //      // documentFileName = _fileName;
    //
    //     });
    //
    //
    //     objectFetched.add(
    //       {
    //         // "id":0,
    //         "documentTypeId": documentTypeInt,
    //         "status" : "ACTIVE",
    //         "documentKey": random(1000000, 9000000),
    //         "attachment" : {
    //           "name" : documentFileName,
    //           "location" : documentFileLocation,
    //         //  "description" : "Proof Of Residence",
    //           "fileName" : documentFileName,
    //           // "size" : int.parse(residenceFileSize),
    //           "type" : documentFiletype == 'png' ? "image/png" : documentFiletype == 'jpg' ? "image/jpeg" : documentFiletype == 'pdf' ? 'application/pdf' : ''
    //         }
    //       },
    //     );
    //
    //
    //
    //
    //   }
    //
    //   print('objectFetched' + objectFetched.toString());
  }

  void _UpdateDocumentsExplorer(
      int ID,
      int documentTypeID,
      String documentKey,
      String attachmentName,
      String attachmentLocation,
      String description,
      String filename,
      String documentType,
      int attachmentID) async {
    String result;

    final filePath = await FlutterDocumentPicker.openDocument();

    final file = File(filePath);
    final fileSize = await file.length();
    if (fileSize > 5 * 1024 * 1024) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('File Size Exceeded'),
            content: Text('Please select a file with a maximum size of 2MB.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeTypes: [
          "application/pdf",
          "image/png",
          "image/jpeg",
          "image/jpg"
        ],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });

    // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
    try {
      //   _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);

      final bytes = Io.File(_path).readAsBytesSync();
      final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
      String img64 = base64Encode(bytes);

      // get file size
      final kb = byeInLength / 1024;
      final mb = kb / 1024;
      print('this is the MB ${mb}');
      String filesizeAsString = mb.toString();
      print('this is file sizelenght ${filesizeAsString}');
      print('image base64 ${img64}');

      setState(() {
        documentFileLocation = img64;
        residenceFileSize = filesizeAsString;
        documentFiletype = _path.split('.').last;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    if (!mounted) return;

    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
      proof_of_residence.text = _fileName;
      // documentFileName = _fileName;
    });

    objectFetched.add(
      {
        "id": ID,
        "documentTypeId": documentTypeID,
        "status": "ACTIVE",
        "documentKey": random(1000000, 9000000),
        "attachment": {
          "id": attachmentID,
          "name": attachmentName,
          //  "description" : "Proof Of Residence",
          "fileName": documentFileName,
          // "size" : int.parse(residenceFileSize),
          "type": documentFiletype == 'png'
              ? "image/png"
              : documentFiletype == 'jpg'
                  ? "image/jpeg"
                  : documentFiletype == 'pdf'
                      ? 'application/pdf'
                      : '',
          "location": documentFileLocation,
        }
      },
    );

    // }

    print('objectFetched' + objectFetched.toString());
  }

  void _openIdentityExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(
            type: _pickingType, fileExtension: _extension);

        // List<int> imageBytes = _path.readAsBytesSync();
        // String baseimage = base64Encode(imageBytes);

        print('file extension ${_path.split('.').last}');

        final bytes = Io.File(_path).readAsBytesSync();
        final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
        String img64 = base64Encode(bytes);

        // get file size
        final kb = byeInLength / 1024;
        final mb = kb / 1024;
        print('this is the MB ${mb}');
        String filesizeAsString = mb.toString();
        print('this is file sizelenght ${filesizeAsString}');
        print('image base64 ${img64}');

        setState(() {
          identityFileLocation = img64;
          identityFileSize = filesizeAsString;
          identityFiletype = _path.split('.').last;
        });
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path.split('/').last : '...';
        proof_of_identity.text = _fileName;
        identityFileName = _fileName;
      });
    }
  }

  void _openEmploymentExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(
            type: _pickingType, fileExtension: _extension);

        // List<int> imageBytes = _path.readAsBytesSync();
        // String baseimage = base64Encode(imageBytes);

        print('file extension ${_path.split('.').last}');

        final bytes = Io.File(_path).readAsBytesSync();
        final byeInLength = Io.File(_path).readAsBytesSync().lengthInBytes;
        String img64 = base64Encode(bytes);

        // get file size
        final kb = byeInLength / 1024;
        final mb = kb / 1024;
        print('this is the MB ${mb}');
        String filesizeAsString = mb.toString();
        print('this is file sizelenght ${filesizeAsString}');
        print('image base64 ${img64}');

        setState(() {
          employmentFileLocation = img64;
          employmentFileSize = filesizeAsString;
          employmentFiletype = _path.split('.').last;
        });
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path.split('/').last : '...';
        proof_of_employment.text = _fileName;
        employmentFileName = _fileName;
      });
    }
  }

  void takePhoto(ImageSource source) async {
    MyRouter.popPage(context);
    var choosedimage = await ImagePicker.pickImage(source: source);
    //  print('this ${choosedimage.toString()}');
    File imagefile = choosedimage; //convert Path to File

    var result = await FlutterImageCompress.compressWithFile(
      imagefile.absolute.path,
      minWidth: 330,
      minHeight: 250,
      quality: 90,
      // rotate: 90,
    );

    print('this is file sixe');
    print(imagefile.lengthSync());
    print(result);
    //return result;

    // image compressor

    print('image File ${imagefile}');
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(result); //convert bytes to base64 string
    print('base64string ${base64string}');

    String _finalPath = choosedimage.toString();
    // final bytes = Io.File(_finalPath).readAsBytesSync();
    //   final byeInLength = Io.File(_finalPath).readAsBytesSync().lengthInBytes;
    // String img64 = base64Encode(bytes);

    // print(img64);

    setState(() {
      uploadimage = choosedimage;
      String getPath = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';
      // _openFileExplorer(getPath);

      File file = choosedimage;
      _fileName = file.path.split('/').last;
      print('filename ${_fileName}');
      passport.text = _fileName;
      isPassportAdded = true;
    });
    // final kb = byeInLength / 1024;
    // final mb = kb / 1024;
    // print('this is the MB ${mb}');
    // String filesizeAsString  = mb.toString();
    // print('this is file sizelenght ${filesizeAsString}');
    //  print('image base64 ${img64}');

    setState(() {
      passportFileLocation = base64string;
      passportFileSize = '';
      passportFiletype = _fileName.split('.').last;
    });

    print('passport file location ${passportFiletype} ');

    setState(() {
      if (passportFiletype == 'png') {
        appendBase64 = 'data:image/png;base64,';
      } else if (passportFiletype == 'jpg') {
        appendBase64 = 'data:image/jpeg;base64,';
      } else if (passportFiletype == 'jpeg') {
        appendBase64 = 'data:image/jpeg;base64,';
      }
    });

    newFileLocation = appendBase64 + passportFileLocation;

    if (!mounted) return;

    setState(() {
      // _fileName = _path != null ? _path.split('/').last : '...';
      passport.text = _fileName;
      passportFileName = _fileName;
    });
  }

  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 330,
      minHeight: 250,
      quality: 90,
      // rotate: 90,
    );
    print('this is file sixe');
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  // Future<File> compressFile(File file) async{
  //   File compressedFile = await FlutterNativeImage.compressImage(file.path,
  //     quality: 5,);
  //   print('this temp ${compressedFile}');
  //   return compressedFile;
  // }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 90,
    );

    print('this is new result');
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  void takePhotoForDocument(ImageSource source) async {
    MyRouter.popPage(context);
    var choosedimage = await ImagePicker.pickImage(
      source: source,
    );
    //  print('this ${choosedimage.toString()}');
    File imagefile = choosedimage; //convert Path to File
    // var newimagebytes =  testCompressFile(imagefile);

    //  File newFileM =    compressFile(imagefile);
    print('image File ${imagefile}');

    // image compressor

    var result = await FlutterImageCompress.compressWithFile(
      imagefile.absolute.path,
      minWidth: 330,
      minHeight: 350,
      quality: 90,
      // rotate: 90,
    );
    print('this is file sixe');
    print(imagefile.lengthSync());
    print(result);
    //return result;

    // image compressor

    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(result); //convert bytes to base64 string
    print('base64string ${base64string}');

    String _finalPath = choosedimage.toString();
    // final bytes = Io.File(_finalPath).readAsBytesSync();
    //   final byeInLength = Io.File(_finalPath).readAsBytesSync().lengthInBytes;
    // String img64 = base64Encode(bytes);

    // print(img64);

    setState(() {
      uploadimage = choosedimage;
      String getPath = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';
      // _openFileExplorer(getPath);

      File file = choosedimage;
      _fileName = file.path.split('/').last;
      print('filename ${_fileName}');
      proof_of_residence.text = _fileName;
      // isPassportAdded = true;
    });

    // final kb = byeInLength / 1024;
    // final mb = kb / 1024;
    // print('this is the MB ${mb}');
    // String filesizeAsString  = mb.toString();
    // print('this is file sizelenght ${filesizeAsString}');
    //  print('image base64 ${img64}');

    setState(() {
      documentFileLocation = base64string;
      // passportFileSize = '';
      documentFiletype = _fileName.split('.').last;
    });

    //  print('passport file location ${passportFiletype} ');

    // setState(() {
    //   if(documentFiletype == 'png'){
    //     appendBase64 ='data:image/png;base64,';
    //   }
    //   else if(documentFiletype == 'jpg'){
    //     appendBase64 = 'data:image/jpeg;base64,';
    //   } else if(documentFiletype == 'jpeg'){
    //     appendBase64 ='data:image/jpeg;base64,';
    //   }
    //   else if(documentFiletype == 'pdf'){
    //     appendBase64 ='data:application/pdf;base64,';
    //   }
    //
    //
    // });

    //   documentFileLocation = appendBase64 + documentFileLocation;

    if (!mounted) return;

    setState(() {
      // _fileName = _path != null ? _path.split('/').last : '...';
      proof_of_residence.text = _fileName;
      //  documentFileName = _fileName;
    });

    objectFetched.add(
      {
        // "id":0,
        "documentTypeId": documentTypeInt,
        "status": "ACTIVE",
        "documentKey": random(1000000, 9000000),
        "attachment": {
          "name": documentFileName,
          "location": documentFileLocation,
          //  "description" : "Proof Of Residence",
          "fileName": documentFileName,
          // "size" : int.parse(residenceFileSize),
          "type": documentFiletype == 'png'
              ? "image/png"
              : documentFiletype == 'jpg'
                  ? "image/jpeg"
                  : documentFiletype == 'pdf'
                      ? 'application/pdf'
                      : ''
        }
      },
    );
  }

  void doDocumentAction(String value) {
    if (value == 'Edit_Documenta') {
      //  MyRouter.pushPage(context,EditDocumentUpload());

    }
    // else if(value == 'view'){
    //   MyRouter.pushPage(context, DocumentPreview(passedDocument: docsLists[position]['attachment']['location'],));
    //
    // }
  }

  int random(min, max) {
    return min + Random.secure().nextInt(max - min);
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose...",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                _openFileExplorer();
              },
              label: Text("Gallery"),
            ),
            // FlatButton.icon(
            //   icon: Icon(Icons.remove_red_eye_outlined),
            //   onPressed: () {
            //     takePhoto(ImageSource.camera);
            //   },
            //   label: Text("Preview"),
            // ),
          ])
        ],
      ),
    );
  }

  Widget DocumentbottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose...",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhotoForDocument(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.file_copy_rounded),
              onPressed: () {
                _openDocumentsExplorer();
              },
              label: Text("File"),
            ),
            // FlatButton.icon(
            //   icon: Icon(Icons.remove_red_eye_outlined),
            //   onPressed: () {
            //     takePhoto(ImageSource.camera);
            //   },
            //   label: Text("Preview"),
            // ),
          ])
        ],
      ),
    );
  }

  Widget signatureBottomSheet() {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Update Document',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              MyRouter.popPage(context);
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.black,
            ),
          ),
        ],
        elevation: 6,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.91,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.50,
                child: DocumentConfiguration(),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey))),
          ],
        ),
      ),
      bottomNavigationBar: DoubleBottomNavComponent(
        text1: 'Clear',
        text2: 'Done',
        callAction2: () {
          _handleSaveButtonPressed();
        },
        callAction1: () {
          //_handleClearButtonPressed();
        },
      ),
    );

    //   Container(
    //   height:  MediaQuery.of(context).size.height * 0.51,
    //   width: MediaQuery.of(context).size.width,
    //   margin: EdgeInsets.symmetric(
    //     horizontal: 20,
    //     vertical: 20,
    //   ),
    //   child: Column(
    //     children: <Widget>[
    //       Text(
    //         "Append Signature",
    //         style: TextStyle(
    //           fontSize: 20.0,
    //           fontWeight: FontWeight.bold,
    //           fontFamily: 'Nunito SansRegular'
    //         ),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //     Container(
    //         child: SfSignaturePad(
    //             key: signatureGlobalKey,
    //             backgroundColor: Colors.white,
    //             strokeColor: Colors.black,
    //             minimumStrokeWidth: 1.0,
    //             maximumStrokeWidth: 4.0),
    //         decoration:
    //         BoxDecoration(border: Border.all(color: Colors.grey))),
    //
    //     ],
    //   ),
    // );
  }

  Widget build(BuildContext context) {
    var submitLoandocumentInfo = () async {
      setState(() {
        _isLoading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // if(dateController.text.isEmpty){
      //       Flushbar(
      //              flushbarPosition: FlushbarPosition.TOP,
      //              flushbarStyle: FlushbarStyle.GROUNDED,
      //     backgroundColor: Colors.red,
      //     title: "Validation error",
      //     message: 'Fill all fields before submitting',
      //     duration: Duration(seconds: 3),
      //   ).show(context);
      // }
      print('passport Location ${passportFileLocation}');

      String passportLocation = passportFileLocation;

      int localclientID =
          ClientInt == null ? prefs.getInt('clientId') : ClientInt;
      PostAndPut postAndPut = new PostAndPut();
      postAndPut.isClientActive(localclientID).then((value) {
        String client_status = value.toString();

        final Future<Map<String, dynamic>> respose =
            addClientProvider.addDocumentUpload(client_status,
                docData: objectFetched,
                passportLocation: newFileLocation,
                passportFileType: passportFiletype,
                ClientInt: ClientInt);

        respose.then((response) {
          //  return print('response from backend ${response}');
          if (response == null || response['status'] == false) {
            setState(() {
              _isLoading = false;
            });

            AppTracker().trackActivity(
                'ADD/UPDATE DOCUMENT INFORMATION FOR CLIENT',
                payLoad: response);

            if (response['message'] == 'Network_error') {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.orangeAccent,
                title: 'Network Error',
                message: 'Proceed, data has been saved to draft',
                duration: Duration(seconds: 3),
              ).show(context);

              return MyRouter.pushPage(context, ClientDraftLists());
            }

            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Error',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          } else {
            setState(() {
              _isLoading = false;
            });
            if (comingFrom == 'CustomerPreview') {
              return MyRouter.pushPage(context, CustomerPreview());
            }
            if (comingFrom == 'SingleCustomerScreen') {
              return MyRouter.pushPage(
                  context,
                  SingleCustomerScreen(
                    clientID: ClientInt,
                  ));
            }

            MyRouter.pushPage(context, CustomerPreview());
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "Success",
              message: 'Client profile creation successful',
              duration: Duration(seconds: 3),
            ).show(context);
          }
          setState(() {
            _isLoading = false;
          });
        });
      });
    };

    actionPopUpItemSelected(String value) {
      if (value == 'update_photo') {
        print('update photo');
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );

        // return bottomSheet();
      }
      if (value == 'preview') {
        setState(() {
          if (passportFiletype == 'png') {
            appendBase64 = 'data:image/png;base64,';
          } else if (passportFiletype == 'jpg') {
            appendBase64 = 'data:image/jpeg;base64,';
          } else if (passportFiletype == 'jpeg') {
            appendBase64 = 'data:image/jpeg;base64,';
          }
        });

        if (passportFiletype != null) {
          newFileLocation = appendBase64 + passportFileLocation;
        }

        print('passed sales ${newFileLocation}');

        print('${passportFiletype} ${passportFileLocation}');
        MyRouter.pushPage(
            context,
            DocumentPreview(
              passedDocument: newFileLocation,
              passedType: passportFiletype,
              passedFileName: 'Passport ',
            ));
      }
    }

    return RefreshIndicator(
      onRefresh: () => getDocumentUploadInformation(),
      child: LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: Container(
          height: 120,
          width: 120,
          child: Lottie.asset('assets/images/newLoader.json'),
        ),
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProgressStepper(
                    stepper: 0.99,
                    title: 'Document Upload',
                    subtitle: 'Client Preview',
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 1.5,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              decoration: BoxDecoration(
                                color: Color(0xffFC2E83).withOpacity(0.2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Ensure all documents are uploaded and tagged properly. Files should be in .jpg, .png or .pdf formats.',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xffFC2E83)),
                              )),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 1),
                            child: Container(
                                height: 70,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextFormField(
                                      controller: passport,
                                      autofocus: false,
                                      readOnly: true,

                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 0.6),
                                        ),

                                        border: OutlineInputBorder(),
                                        suffixIcon: isPassportAdded == true
                                            ? PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.blue,
                                                ),
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                      value: 'update_photo',
                                                      child: Text(
                                                        'Change Passport',
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'preview',
                                                      child: Text('preview'),
                                                    ),
                                                  ];
                                                },
                                                onSelected: (String value) =>
                                                    actionPopUpItemSelected(
                                                        value),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  //MyRouter.pushPage(context, Demo());
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: ((builder) =>
                                                        bottomSheet()),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.attachment_outlined,
                                                  color: Color(0xff177EB9),
                                                ),
                                              ),
                                        //  contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),

                                        labelText: 'Passport photograph *',
                                        hintStyle: kBodyPlaceholder,
                                      ),
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                      // keyboardType: inputType,
                                      // textInputAction: inputAction,
                                    ),
                                  ),
                                ))),
                        _smallInfo(
                            'Upload a clear passport photograph with white background'),
                        SizedBox(
                          height: 20,
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text('Document',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                        //     Text('')
                        //   ],
                        // ),

                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              DocumentConfiguration(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: DoubleBottomNavComponent(
            text1: 'Previous',
            text2: 'Complete',
            callAction2: () {
              submitLoandocumentInfo();
              //  MyRouter.pushPage(context, MainScreen());
            },
            callAction1: () {
              MyRouter.popPage(context);
            },
          ),
        ),
      ),
    );
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText,
      {bool isPassword = false}) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      height: MediaSize.height * 0.090,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: TextInputType.number,
            controller: editController,
            decoration: InputDecoration(
                suffixIcon: isPassword == true
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Colors.black38,
                      )
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color)),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  _smallInfo(String descriptions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Text(
        descriptions,
        style: TextStyle(
            color: Color(0xff354052),
            fontFamily: 'Nunito SansRegular',
            fontSize: 9),
      ),
    );
  }

  retsNx360dates(DateTime selected) {
    String newdate = selectedDate.toString().substring(0, 10);
    print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(selected);

    print(formattedDate);

    String removeComma = formattedDate.replaceAll(",", "");
    print('removeComma');
    print(removeComma);

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o2.length == 1 ? '0' + '' + o2 : o2;

    print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;
    print(concatss);

    print(wordList);
    return concatss;
  }

  // _selectDate(BuildContext context) async {
  //   final DateTime selected = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(1930),
  //     lastDate: DateTime(2025),
  //   );
  //   if (selected != null && selected != selectedDate)
  //     setState(() {
  //       selectedDate = selected;
  //       print(selected);
  //       //  date = selected.toString();
  //
  //       String vasCoddd = retsNx360dates(selected);
  //
  //       dateController.text = vasCoddd;
  //
  //       //    String newdate = selectedDate.toString().substring(0,10);
  //       //    print(newdate);
  //       //
  //       // String formattedDate = DateFormat.yMMMMd().format(selected);
  //       //
  //       // print(formattedDate);
  //       //
  //       //  String removeComma = formattedDate.replaceAll(",", "");
  //       //    print('removeComma');
  //       //    print(removeComma);
  //       //
  //       //  List<String> wordList = removeComma.split(" ");
  //       //  //14 December 2011
  //       //
  //       //  //[January, 18, 1991]
  //       //  String o1 = wordList[0];
  //       //  String o2 = wordList[1];
  //       //  String o3 = wordList[2];
  //       //
  //       //  String concatss = o2 + " " + o1 + " " + o3;
  //       //  print("concatss");
  //       //  print(concatss);
  //       //
  //       //  print(wordList);
  //       //
  //       //  dateController.text = concatss;
  //
  //     });
  // }

  showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      if (value != null && value != CupertinoSelectedDate)
                        setState(() {
                          CupertinoSelectedDate = value;
                          print(CupertinoSelectedDate);
                          String retDate =
                              retsNx360dates(CupertinoSelectedDate);
                          print('ret Date ${retDate}');
                          dateController.text = retDate;
                        });
                    },
                    initialDateTime:
                        DateTime.now().add(Duration(days: 0, hours: 1)),
                    minimumYear: 1960,
                    maximumDate:
                        DateTime.now().add(Duration(days: 0, hours: 2)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        });
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
    );
  }

  Widget DocumentConfiguration() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Documents',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
            Text('')
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 1.5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 70,
                  child: DropDownComponent(
                      items: DocumentTypeArray,
                      onChange: (String item) {
                        setState(() {
                          List<dynamic> selectID = allDocumentType
                              .where((element) => element['name'] == item)
                              .toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          documentTypeInt = selectID[0]['id'];
                          getSubCategoryForCOnfig(documentTypeInt.toString());
                          print('end this is select ID');
                        });
                      },
                      label: "Select Document Type * ",
                      selectedItem: "",
                      validator: (String item) {}),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  child: DropDownComponent(
                      items: documentCategoryArray,
                      onChange: (String item) {
                        setState(() {
                          List<dynamic> selectID = allDocumentCategory
                              .where((element) => element['name'] == item)
                              .toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          documentTypeInt = selectID[0]['id'];
                          documentFileName = selectID[0]['name'];
                          getSubCategoryForCOnfig(documentTypeInt.toString());
                          print('end this is select ID');
                        });
                      },
                      label: "Select category * ",
                      selectedItem: "-----",
                      validator: (String item) {}),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1.7,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                      child: Container(
                          height: 80,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: proof_of_residence,
                                autofocus: false,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 0.6),
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      // _openDocumentsExplorer();
                                      if (documentFileName == null) {
                                        errorMessage(
                                            'Document name cannot be empty');
                                      } else {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              DocumentbottomSheet()),
                                        );
                                        // _openDocumentsExplorer();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.attachment_outlined,
                                      color: Color(0xff177EB9),
                                    ),
                                  ),
                                  // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),

                                  labelText: 'Select Document *',
                                  hintStyle: kBodyPlaceholder,
                                ),
                                style: kBodyText,
                                // keyboardType: inputType,
                                // textInputAction: inputAction,
                              ),
                            ),
                          ))),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ${value ? 'View Existing Documents Only' : 'View Existing Documents Only'}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),

                    // Checkbox(
                    //   value: this.value,
                    //   onChanged: (bool value) {
                    //     setState(() {
                    //       this.value = value;
                    //     });
                    //  //  value == true ? OldDocsPreview() : preveiewDocsPicked();
                    //   },
                    // ),

                    CupertinoSwitch(
                      value: this.value,
                      activeColor: Color(0xff077DBB),
                      onChanged: (bool value) async {
                        //  SharedPreferences prefs = await SharedPreferences.getInstance();

                        setState(() {
                          // _lights = value;
                          // print(_lights);
                          this.value = value;
                        });
                        // var setLight =   prefs.setBool('isLight', _lights);
                        // bool getLight = prefs.getBool('isLight');
                        // print('mewLight ${getLight}');
                      },
                    ),
                  ],
                ),
                value ? OldDocsPreview() : preveiewDocsPicked(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget preveiewDocsPicked() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: objectFetched.isEmpty
          ? Text(
              'No new document added yet,',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: objectFetched.length,
              primary: false,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                print('objectFetched lenght ${objectFetched.length}');
                return ListTile(
                  leading: Text(
                    objectFetched[position]['attachment']['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: InkWell(
                      onTap: () {
                        //   objectFetched.removeAt(objectFetched[position]['id']);
                        print('docis');
                        var valTee = objectFetched.removeAt(position);
                        print('valTee ${valTee}');
                        setState(() {
                          objectFetched;
                        });
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      )),
                );
              }),
    );
  }

  Widget OldDocsPreview() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: docsLists.isEmpty
          ? Text(
              'No Document here,',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: docsLists.length,
              primary: false,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                // print('objectFetched lenght ${objectFetched.length}');
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        docsLists[position]['attachment']['name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.blue,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'Edit_Documxxent',
                              child: InkWell(
                                  onTap: () {
                                    _UpdateDocumentsExplorer(
                                      docsLists[position]['id'],
                                      docsLists[position]['documentType']['id'],
                                      docsLists[position]['documentKey'],
                                      docsLists[position]['attachment']['name'],
                                      docsLists[position]['attachment']
                                          ['location'],
                                      docsLists[position]['attachment']
                                          ['description'],
                                      docsLists[position]['attachment']
                                          ['fileName'],
                                      docsLists[position]['attachment']['type'],
                                      docsLists[position]['attachment']['id'],
                                    );
                                  },
                                  child: Text(
                                    'Edit Document',
                                  )),
                            ),
                            // PopupMenuItem(
                            //   value: 'Preview',
                            //   child: InkWell(
                            //       onTap: () async{
                            //
                            //         var documentName = docsLists[position]['attachment']['fileName'];
                            //
                            //
                            //         if(docsLists[position]['attachment']['type'] == 'application/pdf'){
                            //           String pdf = docsLists[position]['attachment']['location'];
                            //           String fileName = docsLists[position]['attachment']['fileName'];
                            //           var Velo =  pdf.split(',').first;
                            //           int chopOut = Velo.length + 1;
                            //           var bytes =  base64Decode(pdf.substring(chopOut).replaceAll("\n", "").replaceAll("\r", ""));
                            //           final output = await getTemporaryDirectory();
                            //           final file = File("${output.path}/${documentName}.pdf");
                            //           await file.writeAsBytes(bytes.buffer.asUint8List());
                            //           print("${output.path}/${documentName}.pdf");
                            //           await OpenFile.open("${output.path}/${documentName}.pdf");
                            //           setState(() {});
                            //         }
                            //         else {
                            //           MyRouter.pushPage(context, DocumentPreview(passedDocument: newFileLocation,passedType: passportFiletype,passedFileName: documentName,));
                            //
                            //
                            //         }
                            //
                            //
                            //       },
                            //       child: Text('Preview Document',)),
                            //
                            // ),
                            // PopupMenuItem(
                            //   value: 'view',
                            //   child: Text('View'),
                            // ),
                          ];
                        },
                        onSelected: (String value) => doDocumentAction(value),
                      ),
                    ),
                    Divider(),
                  ],
                );
              }),
    );
  }

  errorMessage(String message) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.orangeAccent,
      title: 'Error',
      message: message,
      duration: Duration(seconds: 6),
    ).show(context);
  }
}
