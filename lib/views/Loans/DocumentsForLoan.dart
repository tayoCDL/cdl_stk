import 'dart:async';
import 'dart:convert';

import 'dart:io' as Io;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addLoan.dart';
import 'package:sales_toolkit/view_models/bankAnalyser.dart';
import 'package:sales_toolkit/views/Loans/DocumentExtraScreen.dart';
import 'package:sales_toolkit/views/Loans/SingleLoanView.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/noEmployer.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;

import '../../util/enum/color_utils.dart';

class DocumentForLoan extends StatefulWidget {
  final int clientID;
  final int passLoanID;
  final String moreDocument;
  const DocumentForLoan(
      {Key key, this.clientID, this.moreDocument, this.passLoanID})
      : super(key: key);

  @override
  _DocumentForLoanState createState() => _DocumentForLoanState(
      clientID: this.clientID,
      moreDocument: this.moreDocument,
      passLoanID: this.passLoanID);
}

class _DocumentForLoanState extends State<DocumentForLoan> {
  int clientID;
  int passLoanID;
  String moreDocument;
  _DocumentForLoanState({this.clientID, this.moreDocument, this.passLoanID});
  TextEditingController nationalID = TextEditingController();
  TextEditingController bankStatement = TextEditingController();
  TextEditingController anyOtherId = TextEditingController();
  TextEditingController OTPCOntroller = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController clientPhoneNumber = TextEditingController();

  bool isSmsLafAccepted = false;
  String bankFileName, bankFileSize, bankFiletype, bankFileLocation;
  String nationalIDFileName,
      nationalIDFileSize,
      nationalIDFiletype,
      nationalIDFileLocation;
  String otherIDFileName, otherIDFileSize, otherIDFiletype, otherIDFileLocation;
  String lafFilePath;

  File uploadimage;
  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';
  String _path = '...';
  String _extension;
  String signatureBase64;
  bool _hasValidMime = false;
  FileType _pickingType;
  DateTime selectedDate = DateTime.now();
  TextEditingController _controller = new TextEditingController();
  Map<String, dynamic> laf_download_document;
  bool show_download_laf = false;
  File chosenImage;

  List<String> residenceArray = [];
  List<String> collectResidence = [];
  List<dynamic> allResidence = [];

  List<String> identityArray = [];
  List<String> collectIdentity = [];
  List<dynamic> allIdentity = [];

  List<String> LAFArray = [];
  List<String> collectLAF = [];
  List<dynamic> allLAF = [];
  bool _isLoading = false;

  int employmentInt, identityInt, residenceInt;
  String identityName;
  List<dynamic> objectFetched = [];
  bool _showDocUpload = true;
  bool _showOtpText = true;
  bool lafStatus = false;
  bool _isOTPSent = true;
  String lafArr = '';
  String documentType = '';
  Timer _timerForInter;
  AddLoanProvider addLoanProvider = AddLoanProvider();
  Map<String, dynamic> loanDetail = {};
  bool isLafSigned = false;

  bool loading = false;
  List pdfList;

  String progress = "0";
  final Dio dio = Dio();

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

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 120;

  int currentSeconds = 0;
  bool showTimer = false;

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    // getEmploymentList();
    print('document for loan ${clientID} more Document ${moreDocument}');
    getLoanConfigForDocument();
    getMobileNumber();
    //  _timerForInter = Timer.periodic(Duration(seconds: 1), (result) {
    getIsLafSigned();
    //  });

    // getIsLafSigned();
    // _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {
    //   getIsLafSigned();
    // });

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // final android = AndroidInitializationSettings('mipmap/ic_launcher');
    // final ios = IOSInitializationSettings();
    // final initSetting = InitializationSettings(android: android, iOS: ios);
    // flutterLocalNotificationsPlugin.initialize(initSetting,
    //     onSelectNotification: _onselectedNotification);
    //
    // _controller.addListener(() => _extension = _controller.text);
  }

  @override
  void dispose() {
    _timerForInter?.cancel();
    startTimeout();
    currentSeconds;
    super.dispose();
  }

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (mounted) {
        setState(() {
          print(timer.tick);
          print(timerMaxSeconds);
          showTimer = true;
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
            showTimer = false;
            print('set to false');
          }
          // else if(timer.tick == 10){
          //   print('set to ...');
          //   setState(() {
          //     showTimer = false;
          //   });
          // }
        });
      }
    });
  }

  getEmploymentList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('51');
    // respose.then((response) {
    //   print('marital array');
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allEmployment = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectEmployment.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectEmployment);
    //
    //   setState(() {
    //     employmentArray = collectEmployment;
    //   });
    // }
    // );

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
            allLAF = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectLAF.add(mtBool[i]['name']);
          }

          setState(() {
            LAFArray = collectLAF;
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
          allLAF = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          print(newEmp[i]['name']);
          collectLAF.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectLAF);

        setState(() {
          LAFArray = collectLAF;
        });
      }
    });
  }

  getIdentityList(String vals) {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes(vals);
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
            collectIdentity = [];
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
          collectIdentity = [];
          allIdentity = newEmp;
        });

        for (int i = 0; i < 2; i++) {
          print(newEmp[i]['name']);
          collectIdentity.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectIdentity);

        setState(() {
          identityArray = collectIdentity;

          List<dynamic> selectID = allIdentity
              .where((element) => element['name'] == 'SMS LAF')
              .toList();
          print('this is select ID');
          print(selectID[0]['id']);
          documentType = selectID[0]['name'];
        });
      }
    });
  }

  getIsLafSigned() async {
    // print('loanID ${loanID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int loanID = prefs.getInt('loanCreatedId');
    print('this is ir ${isLafSigned}');

    http.Response responsevv = await get(
      AppUrl.getLoanDetails +
          loanID.toString() +
          '?associations=all&exclude=guarantors,futureSchedule',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      loanDetail = newClientData;
      isLafSigned = loanDetail['isLafSigned'];
      //  isDocumentComplete = loanDetail['isDocumentComplete'];
      lafStatus = loanDetail['isLafSigned'];
    });
    print(
        'isAvailable for manual review ${prefs.getBool('sendForManualReview')}');
  }

  getLoanConfigForDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.getInt('loanCreatedId')
    var isAutoDisbursed = prefs.getBool('isAutoDisburse');
    print('is auto disbursed ${isAutoDisbursed}');
    final Future<Map<String, dynamic>> respose =
        RetCodes().getConfigForLoan(prefs.getInt('loanCreatedId'));
    // final Future<Map<String,dynamic>> respose =   RetCodes().getConfigForLoan(179);

    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLoanDocument'));

        //
        if (prefs.getString('prefsLoanDocument').isEmpty) {
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
            allLAF = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            print(mtBool[i]['name']);
            collectLAF.add(mtBool[i]['name']);
          }

          setState(() {
            collectLAF = [];
            LAFArray = collectLAF;
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

        prefs.setString('prefsLoanDocument', jsonEncode(newEmp));

        // bool lafStatus = response['lafStatus'];
// thompson said .. go to the next screen/
        setState(() {
          lafStatus = response['lafStatus'];
        });

        print('lafstatus ${lafStatus}');

        setState(() {
          collectLAF = [];
          allLAF = newEmp;
        });

        print('employmemrr ${newEmp}');
        for (int i = 0; i < 1; i++) {
          print('employmemrr ${newEmp}');
          print(newEmp[i]['name']);
          collectLAF.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectLAF);

        setState(() {
          LAFArray = collectLAF;

          List<dynamic> selectID = allLAF
              .where((element) => element['name'] == 'Loan Agreement Form OTP')
              .toList();
          print('this is select ID');
          print(selectID[0]['id']);
          employmentInt = selectID[0]['id'];
          lafArr = selectID[0]['name'];
          print('lafArr ${lafArr}');
          _showOtpText = true;
          _showDocUpload = false;
          getIdentityList(selectID[0]['id'].toString());
          // employmentInt = selectID[0]['name'];
        });
      }
    });
  }

  void openExplorerForBankStatement() async {
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
        allowedMimeTypes: [
          "application/pdf",
          "image/png",
          "image/jpeg",
          "image/jpg"
        ],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
      final file = File(result);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        setState(() {
          //  passport.text = '';
          bankFileName = '';
          bankFileLocation = '';
          _path = '-';
          // isPassportAdded = false;
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
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });

    // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
    try {
      //   _path = await FilePicker.getFilePath(type: FileType.ANY,);

      if (_path == '' || _path == null) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: "Unable to pick file",
          duration: Duration(seconds: 4),
        ).show(context);
      }

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
        bankFileLocation = img64;
        bankFileSize = filesizeAsString;
        bankFiletype = _path.split('.').last;
      });

      setState(() {
        _fileName = _path != null ? _path.split('/').last : '...';
        bankStatement.text = _fileName;
        bankFileName = _fileName;
      });

      objectFetched.add({
        "id": random(1, 50),
        "name": identityName,
        "fileName": identityName,
        //  "size": bankFileSize,
        "type": bankFiletype == 'pdf'
            ? "application/pdf"
            : bankFiletype == 'png'
                ? 'image/png'
                : bankFiletype == 'jpg' || bankFiletype == 'jpeg'
                    ? 'image/jpeg'
                    : '',
        "location": bankFileLocation,
        "description": identityName
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: e.toString(),
        duration: Duration(seconds: 10),
      ).show(context);
    }

    if (!mounted) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: "Unable to access file explorer",
        duration: Duration(seconds: 4),
      ).show(context);
    }

    // }

    print('objectFetched' + objectFetched.toString());
  }

  void takePhotoForDocument(ImageSource source) async {
    MyRouter.popPage(context);
    var choosedimage = await ImagePicker.pickImage(source: source);
    //  print('this ${choosedimage.toString()}');
    File imagefile = choosedimage; //convert Path to File

    print('image File ${imagefile}');
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string
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
      bankStatement.text = _fileName;
      // isPassportAdded = true;
    });

    // final kb = byeInLength / 1024;
    // final mb = kb / 1024;
    // print('this is the MB ${mb}');
    // String filesizeAsString  = mb.toString();
    // print('this is file sizelenght ${filesizeAsString}');
    //  print('image base64 ${img64}');

    setState(() {
      bankFileLocation = base64string;
      //  passportFileSize = '';
      bankFiletype = _fileName.split('.').last;
    });

    // print('passport file location ${passportFiletype} ');

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

    // newFileLocation = appendBase64 + documentFileLocation;

    if (!mounted) return;

    setState(() {
      // _fileName = _path != null ? _path.split('/').last : '...';
      bankStatement.text = _fileName;
      //  documentFileName = _fileName;
    });

    objectFetched.add({
      "id": random(1, 50),
      "name": identityName,
      "fileName": identityName,
      //  "size": bankFileSize,
      "type": bankFiletype == 'pdf'
          ? "application/pdf"
          : bankFiletype == 'png'
              ? 'image/png'
              : bankFiletype == 'jpg' || bankFiletype == 'jpeg'
                  ? 'image/jpeg'
                  : '',
      "location": bankFileLocation,
      "description": identityName
    });
  }

  int random(min, max) {
    return min + Random.secure().nextInt(max - min);
  }

  sendOTPLaf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int tempLoanID = prefs.getInt('loanCreatedId');
    // print('this is tempLoan ID ${tempLoanID}');

    setState(() {
      _isOTPSent = true;
      _isLoading = true;
    });

    final Future<Map<String, dynamic>> respose =
        RetCodes().requestLafOTP(tempLoanID, 'email');

    respose.then((response) {
      print(' LAF OTP ${response['data']}');
      setState(() {
        _isLoading = false;
      });
      if (response['status'] == true) {
        // setState(() {
        //   showTimer = true;
        // });

        startTimeout();

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: response['data']['defaultUserMessage'],
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        setState(() {
          _isOTPSent = false;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: response['message'],
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
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
                openExplorerForBankStatement();
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

  verifyOTPLaf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (OTPCOntroller.text.isEmpty || OTPCOntroller.text.length < 3) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'OTP too short',
        duration: Duration(seconds: 3),
      ).show(context);
    }

    int tempLoanID = prefs.getInt('loanCreatedId');
    print('this is tempLoan ID ${tempLoanID}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().verifyLafOTP(tempLoanID, OTPCOntroller.text);
    // setState(() {
    //   _isOTPSent = true;
    // });
    setState(() {
      _isLoading = false;
    });
    respose.then((response) {
      print(response['data']);
      if (response['status'] == true) {
        setState(() {
          isSmsLafAccepted = true;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: 'LAF Verified',
          duration: Duration(seconds: 10),
        ).show(context);
      } else {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to validate OTP',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  _preparingProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    /// show the state of preparation first.
    pd.show(
      max: 100,
      msg: 'Preparing Download...',
      progressType: ProgressType.valuable,
    );

    /// Added to test late loading starts
    await Future.delayed(Duration(milliseconds: 3000));
    for (int i = 0; i <= 100; i++) {
      /// You can indicate here that the download has started.
      pd.update(value: i, msg: 'File Downloading...');
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  errorMessage(context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
      title: 'Permission accepted',
      message: 'LAF download permission accepted ',
      duration: Duration(seconds: 6),
    ).show(context);
  }

  _completedProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'LAF Downloading...',
      completed: Completed(),
      // Completed values can be customized
      // Completed(completedMsg: "Downloading Done !", completedImage: AssetImage("assets/completed.png"), closedDelay: 2500,),
      progressBgColor: Colors.transparent,
    );
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i);
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  downloadLaf() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int tempLoanID = prefs.getInt('loanCreatedId');
    //  _completedProgress(context);
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().lafDownoad(tempLoanID);
    respose.then((response) {
      print(response['message']);
    });
  }

  // Future<bool> reguestPermission() async {
  //   final persmission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   if (persmission != PermissionStatus.granted) {
  //     await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   }
  //   return PermissionStatus.granted;
  // }

  // download directory
  Future<Directory> getDonwloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    print('application document directory ${getApplicationDocumentsDirectory}');
    return getApplicationDocumentsDirectory();
  }

//
  Future startDownload(String savePath, String urlPath) async {
    print('url path ${urlPath}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    Map<String, dynamic> result = {
      "isSuccess": false,
      "filePath": null,
      "error": null
    };

    try {
      var response = await dio.download(urlPath, savePath,
          onReceiveProgress: _onReceiveProgress,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
              'Authorization': 'Basic ${token}',
              'Fineract-Platform-TFA-Token': '${tfaToken}',
            },
          ));

      print('response from general download ${response.data.toString()}');

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (e) {
      print('response from download ${e.toString()}');
      result['error'] = e.toString();
    } finally {
      setState(() {
        laf_download_document = result;
        show_download_laf = true;
      });
      //  _showNotification(result);
    }
  }

  _onReceiveProgress(int receive, int total) {
    if (total != -1) {
      setState(() {
        progress = (receive / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  // Future _showNotification(Map<String, dynamic> downloadStatus) async {
  //   print('this is the download status ${downloadStatus}');
  //   final andorid = AndroidNotificationDetails(
  //       "channelId", 'SalesToolkit', 'channelDescription',
  //       priority: Priority.high, importance: Importance.max);
  //   final ios = IOSNotificationDetails();
  //   final notificationDetails = NotificationDetails(android: andorid, iOS: ios);
  //   final json = jsonEncode(downloadStatus);
  //   final isSuccess = downloadStatus['isSuccess'];
  //   await FlutterLocalNotificationsPlugin().show(
  //       0,
  //       isSuccess ? "Sucess" : "error",
  //       isSuccess ? "File Download Successful,click to view & download" : "File Download Failed",
  //       notificationDetails,
  //       payload: json);
  // }

  Future _onselectedNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(obj['error']),
              ));
    }
  }

  Future download(String fileUrl, String fileName) async {
    // await getApplicationDocumentsDirectory()

    // DownloadsPathProvider.downloadsDirectory
    final dir = await getApplicationDocumentsDirectory();
    // final permissionStatus = await reguestPermission();
    if (true) {
      //  _completedProgress(context);
      setState(() {
        _isLoading = true;
      });
      final savePath = path.join(dir.path, fileName);
      await startDownload(savePath, fileUrl);
      print('savePath ${savePath}');
      setState(() {
        lafFilePath = savePath;
        _isLoading = false;
      });
    } else {
      errorMessage(context);
      print("Permission Denied!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future saveAndShare() async {
  // final image  = File(lafFilePath);
  //   //  await Share.share('');
  // }

  Future<void> shareFile() async {
    //  List<dynamic> docs = await DocumentsPicker.pickDocuments;
    //  if (docs == null || docs.isEmpty) return null;

    // await FlutterShare.shareFile(
    //   title: 'Example share',
    //   text: 'Example share text',
    //   filePath: lafFilePath,
    // );
  }

  uploadDocsForLoan() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        addLoanProvider.addDocumentForLoan(objectFetched);

    print('start response from login');

    print(respose.toString());

    respose.then((response) {
      AppTracker().trackActivity('DOCUMENT UPLPOADED',
          payLoad: {"response": response.toString(), "clientId": clientID});
      setState(() {
        _isLoading = false;
      });
      print('response from provider ${response['data']}');
      if (response['status'] == false) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: response['message'],
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        int tempLoanID = prefs.getInt('loanCreatedId');
        bool sendForManual = prefs.getBool('sendForManualReview');

        //print('passed document  ${isAutoDisbursed}');

        // int tempLoanID =  prefs.getInt('loanCreatedId');

        // if(sendForManual == true && lafStatus == true){
        //   sendForAppro();
        //
        // }
        // else {
        //   if(moreDocument == null ){
        //     MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));
        //
        //   }
        //   else {
        //     MyRouter.pushPageReplacement(context, DocumentExtraScreen(loanID: tempLoanID,));
        //
        //   }
        // }

        //  if(moreDocument == null ){
        //    MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));
        //
        //  }
        //  else {
        //    MyRouter.pushPageReplacement(context, DocumentExtraScreen(loanID: tempLoanID,));
        //
        //  }

        //   MyRouter.pushPage(context, LoanBankStatement(clientId: clientID,passedMoreDocument: moreDocument,));
        //   MyRouter.pushPage(context, LoanBankStatement(clientId: clientID,passedMoreDocument: moreDocument,));

        setState(() {
          _showDocUpload = false;
          objectFetched = [];
        });

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: "Success",
          message: 'LAF Uploaded successfully',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  getMobileNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int passedLoanID = prefs.getInt('loanCreatedId');

    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };
    http.Response responsevv = await get(
        AppUrl.getLoanDetails +
            passedLoanID.toString() +
            '?associations=all&exclude=guarantors,futureSchedule',
        headers: bHeader);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;

    try {
      http.Response responsevvPersonal = await get(
          AppUrl.getSingleClient + newClientData['clientId'].toString(),
          headers: bHeader);
      final Map<String, dynamic> responseData2Personal =
          json.decode(responsevvPersonal.body);
      String phonenumber = responseData2Personal['mobileNo'];
      setState(() {
        clientPhoneNumber.text = phonenumber;
      });
    } catch (e) {}
  }

  Future<Map<String, dynamic>> completeBankAnalyser() async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int passedLoanID = prefs.getInt('loanCreatedId');

    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };
    setState(() {
      _isLoading = true;
    });
    // come back to this..

    // Pass or fail..don't return any toast
    bool checkBankStatement = prefs.getBool('isBankStatement');

    if (checkBankStatement) {
      MyRouter.popPage(context);
    }
    //

    http.Response responsevv = await get(
        AppUrl.getLoanDetails +
            passedLoanID.toString() +
            '?associations=all&exclude=guarantors,futureSchedule',
        headers: bHeader);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;
    Map<String, dynamic> loanDetail = {
      "amount_requested": newClientData['principal'],
      "productId": newClientData['loanProductId'],
      "tenure": newClientData['numberOfRepayments'],
      "id": newClientData['id'],
      "clientID": newClientData['clientId']
    };

    print('loan details ${loanDetail.toString()}');
    // return loanDetail;

    http.Response responsevvBank = await get(
      AppUrl.getSingleClient + newClientData['clientId'].toString() + '/banks',
      headers: bHeader,
    );
    print(responsevv.body);

    final List<dynamic> responseData2Bank = json.decode(responsevvBank.body);
    print('responseData2Bank ${responseData2Bank}');
    var newClientDatabank = responseData2Bank;

    var bankStatment = {
      "bankSortCode": newClientDatabank[0]['bank']['bankSortCode'].toString(),
      "accountName": newClientDatabank[0]['accountname'],
      "accountNumber": newClientDatabank[0]['accountnumber'],
      "bankname": newClientDatabank[0]['bank']['name']
    };

    // mbs analysis

    http.Response responsevvMbs = await get(
      AppUrl.getMBSBank,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': APP_TOKEN,
      },
    );
    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevvMbs.body);
      var fetchDoe = responseData;
      var bankResult = fetchDoe['data']['result'];

      List<dynamic> selectSortCode = bankResult
          .where(
              (element) => element['sortCode'] == bankStatment['bankSortCode'])
          .toList();

      //print('this is Clientx code ${selectSortCode}');
      int mbsSortCode = selectSortCode[0]['id'];

      // get mobile number
      http.Response responsevvPersonal = await get(
          AppUrl.getSingleClient + newClientData['clientId'].toString(),
          headers: bHeader);
      final Map<String, dynamic> responseData2Personal =
          json.decode(responsevvPersonal.body);
      String phonenumber = responseData2Personal['mobileNo'];
      var loandData = {
        "amount_requested": newClientData['principal'],
        "productId": newClientData['loanProductId'],
        "tenure": newClientData['numberOfRepayments'],
        "id": newClientData['id'],
        "clientID": newClientData['clientId'],
        "externalBankId": mbsSortCode
      };

      bool checkBankStatement = prefs.getBool('isBankStatement');

      Map<String, dynamic> bankAnalyser = {
        "externalBankId": mbsSortCode,
        "amountRequested": newClientData['principal'],
        "productId": newClientData['loanProductId'],
        "tenure": newClientData['numberOfRepayments'],
        "phone": clientPhoneNumber.text,
        "loanId": newClientData['id'],
        "clientId": newClientData['clientId'],
        "statementTypeId": 1,
      };

      Map<String, dynamic> bankAnalyserForBS = {
        "productId": newClientData['loanProductId'],
        "tenure": newClientData['numberOfRepayments'],
        "loanId": newClientData['id'],
        "clientId": newClientData['clientId'],
      };

      int clientId = newClientData['clientId'];
      int passLoanID = newClientData['id'];

      // run bank analyser

      // end run bank analyser

      // start
      /////

      http.Response Analysisresponse = await post(
          // AppUrl.getLoanDetails + loanId.toString() + '/analyse/bankstatement/6',
          AppUrl.getLoanDetails + clientId.toString() + '/decide',
          body: json
              .encode(checkBankStatement ? bankAnalyser : bankAnalyserForBS),
          headers: bHeader);

      print(
          'this is analysisBody ${Analysisresponse.body} ${checkBankStatement ? bankAnalyser : bankAnalyserForBS}');
      // final Map<String, dynamic> VresponseData = json.decode(Analysisresponse.body);
      if (Analysisresponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(Analysisresponse.body);
        var fetchDoe = responseData;
        setState(() {
          _isLoading = false;
        });
        result = {
          'status': true,
          'message': 'Successful',
          'data': fetchDoe,
        };
        MyRouter.pushPageReplacement(
            context,
            SingleLoanView(
                loanID: passLoanID,
                comingFrom: 'loanBankStatement',
                clientID: clientID));
        setState(() {
          _timerForInter.cancel();
        });
        if (responseData['status'] != 'fail') {
          //       Flushbar(
          //              flushbarPosition: FlushbarPosition.TOP,
          //              flushbarStyle: FlushbarStyle.GROUNDED,
          //   backgroundColor: Colors.green,
          //   title: 'Success',
          //   message: 'Bank Statement analysis successful',
          //   duration: Duration(seconds: 3),
          // ).show(context);

        } else {
          //       Flushbar(
          //              flushbarPosition: FlushbarPosition.TOP,
          //              flushbarStyle: FlushbarStyle.GROUNDED,
          //   backgroundColor: Colors.red,
          //   title: 'Error',
          //   message: 'Bank Analysis failed',
          //   duration: Duration(seconds: 3),
          // ).show(context);
        }
      } else {
        setState(() {
          _isLoading = false;
        });

        MyRouter.pushPageReplacement(
            context,
            SingleLoanView(
                loanID: passLoanID,
                comingFrom: 'loanBankStatement',
                clientID: clientID));
        setState(() {
          _timerForInter.cancel();
        });
        //       Flushbar(
        //              flushbarPosition: FlushbarPosition.TOP,
        //              flushbarStyle: FlushbarStyle.GROUNDED,
        //   backgroundColor: Colors.red,
        //   title: 'Failed',
        //   message: 'Bank Analysis failed ',
        //   duration: Duration(seconds: 6),
        // ).show(context);

        if (Analysisresponse.statusCode == 500) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Failed',
            message: 'Unknown server error',
            duration: Duration(seconds: 6),
          ).show(context);

          result = {
            'status': false,
            'message': 'Server error, please try again'
          };
        }
      }

      /////
      final Future<Map<String, dynamic>> respose =
          RetCodes().bankStatementAnalyser(bankAnalyser, passLoanID, clientId);
      respose.then((response) async {
        print('response from analyser ${response}');

        if (response['status'] == false) {
          return result = {"status": false, "message": "Unable to analyse"};
        } else {
          if (response['data']['status'] == 'FAIL') {
            return result = {
              "status": false,
              "message": "Auto analysis failed, please try the manual route"
            };
          } else if (response['data']['status'] == 'COUNTER_OFFER') {
            result = {"status": true, "message": response['data']['reason']};
          } else {
            result = {"status": true, "message": response['data']['reason']};
          }
          int tempLoanID = prefs.getInt('loanCreatedId');
          bool isAutoDisbursed = prefs.getBool('isAutoDisburse');
        }
      });

      // end
      // return loandData;
    } else {}
  }

  Widget build(BuildContext context) {
    sendForAnalysis() {
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Analyse Bank Statement',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Make changes to your phone number \n if it is not associated with your \n account number',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],
        ),
        content: EntryField(context, clientPhoneNumber, 'Phone number',
            'Phone Number', TextInputType.number, () {},
            isSuffix: false),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: RoundedButton(
            buttonText: 'Proceed',
            onbuttonPressed: () {
              //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));
              completeBankAnalyser();
            },
          ),
        ),
      );
    }

    var sendLoanForApproval = () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (note.text.isEmpty || note.text.length < 5) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'please add note ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      int tempLoanID = prefs.getInt('loanCreatedId');

      Map<String, dynamic> noteData = {
        'note': note.text,
      };

      MyRouter.popPage(context);
      setState(() {
        _isLoading = true;
      });

      final Future<Map<String, dynamic>> respose =
          RetCodes().SendLoanForApproval(noteData, tempLoanID, 'manual_review');

      setState(() {
        _isLoading = false;
      });

      respose.then((response) {
        print('response got here for approval ${response}');
        if (response['status'] == true) {
          note.text = '';
          MyRouter.popPage(context);
          prefs.remove('sendForManualReview');
          bool checkBankStatement = prefs.getBool('isBankStatement');

          if (moreDocument == null) {
            checkBankStatement ? sendForAnalysis() : completeBankAnalyser();
            // completeBankAnalyser
            //
            // sendForAnalysis();

            //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));

          } else {
            // MyRouter.pushPageReplacement(
            //     context,
            //     DocumentExtraScreen(
            //       loanID: tempLoanID,
            //     ));
            MyRouter.pushPageReplacement(
                context,
                SingleLoanView(
                  loanID: tempLoanID,
                  comingFrom: 'loanBankStatement',
                  clientID: clientID,
                ));
            setState(() {
              _timerForInter.cancel();
            });
          }

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Loan successfully sent for approval',
            duration: Duration(seconds: 5),
          ).show(context);
        } else {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.redAccent,
            title: 'Failed',
            message: response['message'],
            duration: Duration(seconds: 5),
          ).show(context);
        }
      });
    };

    sendForAppro() {
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add Note'),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],
        ),
        content: EntryField(
            context, note, 'Add Note', 'Enter Note', TextInputType.name, () {},
            isSuffix: false),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: RoundedButton(
            buttonText: 'Send',
            onbuttonPressed: () {
              sendLoanForApproval();
            },
          ),
        ),
      );
    }

    var sendOTPForLaf = () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int tempLoanID = prefs.getInt('loanCreatedId');

      final Future<Map<String, dynamic>> respose =
          RetCodes().requestLafOTP(tempLoanID, 'email');
      respose.then((response) {
        print(response['data']);
      });
    };

    return LoadingOverlay(
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
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                children: [
                  ProgressStepper(
                    stepper: 0.6,
                    title: 'Loan Agreement',
                    subtitle: 'Bank Statement',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: LoopDocumentForLoan()),
                        isSmsLafAccepted == true
                            ? Center(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Loan Agreement Form Accepted ',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: 'Nunito SansRegular',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                  ),
                                ],
                              ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: show_download_laf == true &&
                                  laf_download_document['isSuccess']
                              ? lafDownloadStatus(onTap: () {
                                  print(
                                      'laf download ${laf_download_document}');
                                  // final obj = jsonDecode(json);
                                  OpenFile.open(
                                      laf_download_document['filePath']);
                                })
                              : show_download_laf == true &&
                                      laf_download_document['isSuccess'] ==
                                          false
                                  ? lafDownloadFailed()
                                  : SizedBox(),
                        ),
                        preveiewDocsPicked(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:

            // DoubleBottomNavComponent(
            //     text1: 'Previous',
            //   text2: 'Next',
            //   callAction1: (){
            //       MyRouter.popPage(context);
            //   },
            //   callAction2: (){
            //     uploadDocsForLoan();
            //   },
            // )
            BottomNavComponent(
          text: 'Next',
          callAction: () async {
            // if(_showDocUpload){
            //   return uploadDocsForLoan();
            // }
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            int tempLoanID = prefs.getInt('loanCreatedId');
            bool sendForManual = prefs.getBool('sendForManualReview');
            bool checkBankStatement = prefs.getBool('isBankStatement');

            print(
                'passed document ${moreDocument} ${sendForManual} client ID ${clientID}');

            if (sendForManual == true && lafStatus == true) {
              sendForAppro();
            } else {
              if (moreDocument == null) {
                // add Analyser here
                //  checkBankStatement ? sendForAnalysis() : completeBankAnalyser();
                MyRouter.pushPageReplacement(
                    context,
                    SingleLoanView(
                        loanID: passLoanID,
                        comingFrom: 'loanBankStatement',
                        clientID: clientID));
                // sendForAnalysis();
                //end Add Analysis
                //    MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));

              } else {
                // MyRouter.pushPageReplacement(
                //     context,
                //     DocumentExtraScreen(
                //       loanID: tempLoanID,
                //     ));
                MyRouter.pushPageReplacement(
                    context,
                    SingleLoanView(
                      loanID: tempLoanID,
                      comingFrom: 'loanBankStatement',
                      clientID: clientID,
                    ));
                setState(() {
                  _timerForInter.cancel();
                });
              }
            }

            //MyRouter.pushPage(context, LoanBankStatement(clientId: clientID,passedMoreDocument: moreDocument,));

            // uploadDocsForLoan();
            //  MyRouter.pushPage(context, SecondNewLoan(clientID: clientID,productID: productInt,TheloanOfficer: loanOfficer.text,));
          },
        ),
      ),
    );
  }

  Widget LoanStepper() {
    return Material(
      elevation: 10,
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        padding: EdgeInsets.only(left: 35, right: 5),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Color(0xff3ECB98),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 3,
                ),
                SizedBox(
                  width: 4,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Color(0xff3ECB98),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Terms',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 4,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: Color(0xff177EB9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))),
                SizedBox(
                  width: 3,
                ),
                SizedBox(
                  width: 6,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Text(
                  'Offer',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 4,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                      '4',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Statement',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: 6,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                      '5',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ))),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Document',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget LoopDocumentForLoan() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropDownComponent(
                items: LAFArray,
                onChange: (String item) {
                  setState(() {
                    List<dynamic> selectID = allLAF
                        .where((element) => element['name'] == item)
                        .toList();
                    print('this is select ID');
                    print(selectID[0]['id']);
                    employmentInt = selectID[0]['id'];
                    print('end this is select ID');
                    getIdentityList(employmentInt.toString());
                    //   getIdentityList('55');
                  });
                },
                label: "Document * ",
                selectedItem: lafArr,
                popUpDisabled: (String s) {
                  if (lafStatus) {
                    return s.startsWith('L');
                  } else {}
                },
                validator: (String item) {})),
        SizedBox(
          height: 20,
        ),
        lafStatus
            ? SizedBox()
            : Container(
                //  width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    child: DropDownComponent(
                        items: identityArray,
                        onChange: (String item) {
                          setState(() {
                            List<dynamic> selectID = allIdentity
                                .where((element) => element['name'] == item)
                                .toList();
                            print('this is select ID');
                            print(selectID[0]['id']);
                            identityInt = selectID[0]['id'];
                            identityName = selectID[0]['name'];
                            print('end this is select ID. ${identityName}');

                            // refactor

                            if (selectID[0]['name'] == 'SMS LAF' ||
                                selectID[0]['name'] == 'Online LAF') {
                              setState(() {
                                _showDocUpload = false;
                              });
                            } else {
                              setState(() {
                                _showDocUpload = true;
                              });
                            }

                            if (selectID[0]['name'] == 'Document LAF' ||
                                selectID[0]['name'] == 'Others LAF') {
                              setState(() {
                                _showOtpText = false;
                              });
                            } else {
                              setState(() {
                                _showOtpText = true;
                              });
                            }
                          });
                        },
                        label: "Document Type* ",
                        selectedItem: documentType,
                        validator: (String item) {})),
              ),
        SizedBox(
          height: 20,
        ),
        _showDocUpload
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            int tempLoanID = prefs.getInt('loanCreatedId');
                            print('tempLoan ${tempLoanID}');
                            String appBaseUrl = AppUrl.getLoanDetails +
                                '${tempLoanID}/laf/download/pdf';
                            //http://40.113.169.208:9192/api/v1/laf/
                            //http://192.168.88.64:9192/api/v1/laf/13193/download
                            download(appBaseUrl, "laf_download.pdf");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff729e09),
                              borderRadius: BorderRadius.circular(6),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FeatherIcons.download,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            //   Icon(FeatherIcons.download,size: 30,color: Colors.white,),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            disabledForegroundColor: Colors.orange,
                            //   disabledTextColor: Colors.white,
                          ),
                          onPressed: () {
                            // proceedToSendLafOtp();
                            uploadLafWarning();

                            // showModalBottomSheet(
                            //   context: context,
                            //   builder: ((builder) => DocumentbottomSheet()),
                            // );

                            //  openExplorerForBankStatement();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffc43429),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FeatherIcons.upload,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.55,
                  //   child: Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
                  //       child: Container(
                  //           height: 50,
                  //           child: InkWell(
                  //             onTap: (){
                  //
                  //             },
                  //             child: Container(
                  //               height: 71,
                  //               decoration: BoxDecoration(
                  //                 color: Theme.of(context).backgroundColor,
                  //                 borderRadius: BorderRadius.circular(5),
                  //               ),
                  //
                  //               child: TextFormField(
                  //                 controller: bankStatement,
                  //                 autofocus: false,
                  //                 readOnly: true,
                  //                 decoration: InputDecoration(
                  //                   focusedBorder:OutlineInputBorder(
                  //                     borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                  //
                  //                   ),
                  //                   border: OutlineInputBorder(
                  //
                  //                   ),
                  //                   suffixIcon: IconButton(
                  //                     onPressed: (){
                  //                       openExplorerForBankStatement();
                  //                     },
                  //                     icon:   Icon(Icons.attachment_outlined,color: Color(0xff177EB9)
                  //                       ,) ,
                  //                   )
                  //                   ,
                  //                   contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
                  //
                  //                   labelText: 'Choose file *',
                  //                   hintStyle: kBodyPlaceholder,
                  //                 ),
                  //                 style: kBodyText,
                  //                 // keyboardType: inputType,
                  //                 // textInputAction: inputAction,
                  //               ),
                  //             ),
                  //           )
                  //
                  //       )
                  //   ),
                  // ),
                ],
              )
            : Text(''),
        lafStatus
            ? SizedBox()
            : _showOtpText
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: EntryField(
                        context,
                        OTPCOntroller,
                        'Kindly Enter OTP',
                        'Verify OTP',
                        TextInputType.text, () {
                      _isOTPSent ? verifyOTPLaf() : sendOTPLaf();
                    }),
                  )
                : Text(''),
        !_showOtpText || isLafSigned
            ? SizedBox()
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.43,
                  margin: EdgeInsets.symmetric(horizontal: 20),

                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xffCDE5F1),
                    borderRadius: BorderRadius.circular(1),
                    //   border: Border.all(width: 1, color: Colors.blue
                    //  )
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      // sendOTPLaf();
                      showTimer == true ? null : proceedToSendLafOtp();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        showTimer == true
                            ? 'Resend in ${timerText} mins'
                            : 'Tap to send LAF OTP',
                        style: TextStyle(
                            color: Color(0xff077DBB),
                            fontFamily: 'Nunito SansRegular'),
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        SizedBox(
          height: 30,
        ),
        progress == '0'
            ? Container()
            : !_showOtpText || isLafSigned
                ?
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text("LAF successfully downloaded : ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15),),
                //     IconButton(onPressed: () async{
                //       shareFile();
                //       //Share.shareFiles(['${directory.path}/image.jpg'], text: 'Great picture');
                //       //  await Share.shareFiles(['${ss}/image.jpg'], text: 'Great picture');
                //     }, icon: Icon(Icons.share)),
                //     //SizedBox(height: 10,),
                //   ],
                // )
                SizedBox()
                : SizedBox(),
        SizedBox(
          height: 4,
        ),
        showTimer == true ? isLafsentDialog() : SizedBox(),
      ],
    );
  }

  uploadLafWarning() {
    return alert(
      context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '⚠️ Warning',
            style: TextStyle(
                fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          InkWell(
              onTap: () {
                MyRouter.popPage(context);
              },
              child: Icon(Icons.clear))
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('::: Please confirm If :::'),
            SizedBox(
              height: 10,
            ),
            Text(
              "By proceeding, you are confirming you didn't process your client's loan request using the digital Online LAF options, and your Supervisor has physically verified the client's KYC details and physically attested to the physical LAF document.Please be informed this LAF document might be subjected to further review and validation",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      textOK: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: RoundedButton(
          buttonText: 'Upload LAF',
          onbuttonPressed: () {
            //  sendLoanForApproval();
            MyRouter.popPage(context);
            showModalBottomSheet(
              context: context,
              builder: ((builder) => DocumentbottomSheet()),
            );
          },
        ),
      ),
    );
  }

  proceedToSendLafOtp() {
    return alert(
      context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '⚠️ Warning',
            style: TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          InkWell(
              onTap: () {
                MyRouter.popPage(context);
              },
              child: Icon(Icons.clear))
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('::: Please confirm If :::'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please be informed resending the OTP LAF to your client before the expiration of 24 Hours will invalidate the previous OTP received by your client.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      textOK: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: RoundedButton(
          buttonText: 'Send OTP',
          onbuttonPressed: () {
            //  sendLoanForApproval();
            MyRouter.popPage(context);
            sendOTPLaf();
          },
        ),
      ),
    );
  }

  Widget preveiewDocsPicked() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: objectFetched.isEmpty
          ? null
          : Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: objectFetched.length,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, position) {
                      // print('objectFetched lenght ${objectFetched.length}');
                      print('object fetched ${objectFetched[position]}');
                      return ListTile(
                        leading: Text(
                          objectFetched[position]['name'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: InkWell(
                            onTap: () {
                              //   objectFetched.removeAt(objectFetched[position]['id']);

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
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: RoundedButton(
                      buttonText: 'Upload',
                      onbuttonPressed: () {
                        return uploadDocsForLoan();
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText, var keyBoard, Function onBtnPressed,
      {bool isPassword = false,
      var maxLenghtAllow,
      bool isRead = false,
      bool isSuffix = true}) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
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
            readOnly: isRead,
            maxLength: maxLenghtAllow,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,

            controller: editController,

            validator: (value) {
              //print('this is value ${value}');
              // _isOTPSent && value.isEmpty ? 'Field cannot be empty': '';
              // if(value.isEmpty){
              //   return 'Field cannot be empty';
              // }
            },

            // onSaved: (value) => vals = value,

            decoration: InputDecoration(
                suffixIcon: isSuffix
                    ? TextButton(
                        // disabledColor: Colors.blueGrey,
                        onPressed: onBtnPressed,
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSmsLafAccepted == true
                                  ? Color(0xffECFDF3)
                                  : Color(0xff077DBB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              // _isOTPSent ? 'Verify OTP' : 'Send LAF OTP',
                              isSmsLafAccepted == true
                                  ? 'Verified'
                                  : 'Verify OTP',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: isSmsLafAccepted == true
                                      ? Color(0xff079455)
                                      : Colors.white),
                            )),
                      )
                    : SizedBox(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.grey, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color),
                counter: SizedBox.shrink()),
            textInputAction: TextInputAction.next,
          ),
        ),
      ),
    );
  }

  Widget clientStatus(Color statusColor, String status) {
    return Container(
      width: 80,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(
          child: Text(
        status,
        style: TextStyle(color: Colors.white, fontSize: 12),
      )),
    );
  }

  Widget isLafsentDialog() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Is the customer still having issue getting the OTP?\nKindly inform the customer to retrieve the OTP by dialling the code below from their registered phone number\n",
            style: TextStyle(
                fontFamily: 'Nunito SansRegular', color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "*5120*11#",
            style: TextStyle(
                fontFamily: 'Nunito ExtraBold',
                color: Colors.white,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

// most of he features here are hard coded.. needs proper refactoring

