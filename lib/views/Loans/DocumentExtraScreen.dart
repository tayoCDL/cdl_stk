import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'package:sales_toolkit/palatte.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/DocumentsForLoan.dart';
import 'package:sales_toolkit/views/Loans/LoanBankStatement.dart';
import 'package:sales_toolkit/views/Loans/SingleLoanView.dart';
import 'package:sales_toolkit/views/clients/DocumentPreview.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../../util/helper_class.dart';
import '../../view_models/bankAnalyser.dart';

class DocumentExtraScreen extends StatefulWidget {
  final int loanID;
  final int passedclientID;
  final String moreDocument;
  const DocumentExtraScreen(
      {Key key, this.loanID, this.passedclientID, this.moreDocument})
      : super(key: key);

  @override
  _DocumentExtraScreenState createState() => _DocumentExtraScreenState(
      loanID: this.loanID,
      passedclientID: this.passedclientID,
      moreDocument: this.moreDocument);
}

class _DocumentExtraScreenState extends State<DocumentExtraScreen> {
  List<String> identityArray = [];
  List<String> collectIdentity = [];
  List<dynamic> allIdentity = [];

  List<String> LAFArray = [];
  List<String> collectLAF = [];
  List<dynamic> allLAF = [];
  Timer _timerForInter;

  String documentFileName,
      residenceFileSize,
      documentFiletype,
      documentFileLocation;
  int clientID;
  int documentTypeInt;
  bool _isLoading = false;
  bool showBankstatementDropDown = false;
  String lafArr = '';

  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  bool isAttachSuccessful = false;
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );

  Map<String, DateTime> calculateStartAndEndDates() {
    DateTime today = DateTime.now();
    DateTime endDate =
        DateTime(today.year, today.month, 1).subtract(Duration(days: 1));

    DateTime startDate = endDate.subtract(Duration(days: 6 * 30));
    startDate = DateTime(startDate.year, startDate.month, 1);

    return {'startDate': startDate, 'endDate': endDate};
  }

  // String formatDateForDisplay(DateTime date) {
  //   final monthName = DateFormat.MMMM().format(date).toUpperCase();
  //   final day = DateFormat('dd').format(date); // Ensure two-digit day
  //   final year = DateFormat.y().format(date);
  //
  //   return '$year-$monthName-$day';
  // }
  String formatDateForDisplay(DateTime date) {
    final monthAbbreviation = DateFormat.MMM().format(date).toUpperCase();
    final day = DateFormat('dd').format(date); // Ensure two-digit day
    final year = DateFormat.y().format(date);

    return '$year-$monthAbbreviation-$day';
  }

  // String formatDateForDisplay(DateTime date) {
  //   final monthName = DateFormat.MMMM().format(date).toUpperCase();
  //   final day = DateFormat.d().format(date);
  //   final year = DateFormat.y().format(date);
  //
  //   return '$year-$monthName-$day';
  // }

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
    Response responsevv = await get(
        AppUrl.getLoanDetails +
            passedLoanID.toString() +
            '?associations=all&exclude=guarantors,futureSchedule',
        headers: bHeader);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;

    try {
      Response responsevvPersonal = await get(
          AppUrl.getSingleClient + newClientData['clientId'].toString(),
          headers: bHeader);
      final Map<String, dynamic> responseData2Personal =
          json.decode(responsevvPersonal.body);
      String phonenumber = responseData2Personal['mobileNo'];
      setState(() {
        clientPhoneNumber.text = phonenumber;
        clientID = newClientData['clientId'];
      });
    } catch (e) {}
  }

  // Call the retry function

  @override
  void initState() {
    // TODO: implement initState

    getDocumentsForLoan();

    print('this is loanID ${loanID}');
    getMobileNumber();
    getLoanDetails();

    getIsBankStatementAvailable();
    //  _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {

    //  });
    super.initState();
  }

  @override
  void dispose() {
    _timerForInter?.cancel();
    super.dispose();
  }

  getIsBankStatementAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      canGoToStatementScreen = prefs.getBool('isBankStatement');
    });

    print('can use for statement ${canGoToStatementScreen}');
  }

  Map<String, dynamic> loanDetail = {};
  String settlementBalance = '';
  String method = '';

  int employmentInt, identityInt, residenceInt;
  String identityName;
  String documentType = '';
  List<dynamic> objectFetched = [];
  List<dynamic> notesArray = [];

  List<String> DocumentTypeArray = [];
  List<String> collectDocumentType = [];
  List<dynamic> allDocumentType = [];

  List<dynamic> documentsArray = [];

  final ImagePicker _picker = ImagePicker();

  String _fileName = '...';
  String _path = '...';
  String _extension;
  String signatureBase64;
  bool _hasValidMime = false;
  String appendBase64 = '';
  bool value = false;
  FileType _pickingType;
  File uploadimage;
  bool canGoToStatementScreen = false;
  bool showFetchBankStatement = true;
  int random(min, max) {
    return min + Random.secure().nextInt(max - min);
  }

  TextEditingController note = TextEditingController();
  TextEditingController proof_of_residence = TextEditingController();
  TextEditingController clientPhoneNumber = TextEditingController();

  getDocumentsForLoan() {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().getDocumentNote(loanID);

    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print('note response ${response}');
      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: ' ',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        setState(() {
          documentsArray = response['data'];
        });

        print('documents array ${documentsArray}');
      }
    });
  }

  getSingleDocument(int documentId) async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().get_SingleDocument(loanID, documentId);

    respose.then((response) async {
      AppTracker().trackActivity('SINGLE DOCUMENT LOADED',
          payLoad: {"response": response.toString(), "clientId": clientID});
      setState(() {
        _isLoading = false;
      });
      //  print('single document response ${response}');
      var singleDoc = response['data'];
      var docType = singleDoc['type'];
      print('single doc >> ${singleDoc}');
      if (docType == 'application/pdf') {
        // String pdf = singleDoc['location'];
        // String fileName = singleDoc['name'];
        // var Velo = pdf.split(',').first;
        // int chopOut = Velo.length + 1;
        // var bytes = base64Decode(pdf
        //     .substring(chopOut)
        //     .replaceAll("\n", "")
        //     .replaceAll("\r", ""));
        // final output = await getTemporaryDirectory();
        // final file = File("${output.path}/${fileName}.pdf");
        // await file.writeAsBytes(bytes.buffer.asUint8List());
        // print("${output.path}/${fileName}.pdf");
        // await OpenFile.open("${output.path}/${fileName}.pdf");
        //
        AppHelper().processPdfDocument(singleDoc);

        setState(() {});
      } else {
        MyRouter.pushPage(
            context,
            DocumentPreview(
              passedDocument: singleDoc['location'],
              passedFileName: singleDoc['name'],
            ));
        // setState(() {
        //   _timerForInter.cancel();
        // });
      }
    });
  }

  getLoanDetails() async {
    print('loanID ${loanID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print(
        'this is ir ${AppUrl.getLoanDetails + loanID.toString() + '?associations=all&exclude=guarantors,futureSchedule'}');

    Response responsevv = await get(
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

      if (loanDetail['configs'] != null) {
        int docConfigData = loanDetail['configs'][0]['id'];
        if (docConfigData != null) {
          geSingleLoanConfig(docConfigData);
        }
      }
    });
    print('Loan detail ${loanDetail}');
  }

  geSingleLoanConfig(int configID) {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().SingleLoanDocumentConfiguration(configID);

    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);

      List<dynamic> newEmp = response['data'];

      print('collect Docs ${newEmp}');

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //  prefs.setString('prefsProofOfResidence', jsonEncode(newEmp));

      setState(() {
        allDocumentType = newEmp;
      });

      List<dynamic> modifiedEmp =
          newEmp.where((element) => element['systemDefined']).toList();

      print('modifed emp ${modifiedEmp}');
      for (int i = 0; i < modifiedEmp.length; i++) {
        collectDocumentType.add(modifiedEmp[i]['name']);
      }

      print('vis alali ${collectDocumentType}');

      // if(collectDocumentType.contains('Statement')){
      //   setState(() {
      //     canGoToStatementScreen = true;
      //   });
      // }

      setState(() {
        DocumentTypeArray = collectDocumentType;
      });
    });
  }

  getSubCategoryList(String categoryID) {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().getCodes(categoryID);
    setState(() {
      _isLoading = false;
    });
    respose.then((response) async {
      print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
          collectLAF = [];
          allLAF = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          print(newEmp[i]['name']);
          collectLAF.add(newEmp[i]['name']);
        }
        print('vis alali lafArray ${collectLAF}');
        print(collectLAF);

        setState(() {
          LAFArray = collectLAF;
        });
      }
    });
  }

  getIdentityList(String vals) {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes(vals);

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

        for (int i = 0; i < newEmp.length; i++) {
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

  void _openDocumentsExplorer() async {
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
          // passport.text = '';
          // passportFileLocation ='';
          documentFileLocation = '';
          documentFileName = '';
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
      // setState(() {
      //   _pickFileInProgress = false;
      // });
    }

    setState(() {
      _path = result;
    });

    // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
    try {
      // _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
      //var _newpath = await FilePicker.getFile(type: FileType.ANY,fileExtension: _extension);

      // List<int> imageBytes = _path.readAsBytesSync();
      // String baseimage = base64Encode(imageBytes);

      //  print('file extension ${_path.split('.').last}');

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
      //documentFileName = _fileName;
      value = true;
    });

    objectFetched.add({
      "id": random(1, 50),
      "name": documentFileName,
      "fileName": documentFileName,
      //  "size": bankFileSize,
      "type": documentFiletype == 'png'
          ? "image/png"
          : documentFiletype == 'jpg' || documentFiletype == 'jpeg'
              ? "image/jpeg"
              : documentFiletype == 'pdf'
                  ? 'application/pdf'
                  : '',
      "location": documentFileLocation,
      "description": documentFileName
    });

    addDocument();

    setState(() {
      objectFetched = [];
      proof_of_residence.text = '';
    });
    // objectFetched.add(
    //   {
    //     // "id":0,
    //     "documentTypeId": documentTypeInt,
    //     "status" : "ACTIVE",
    //     "documentKey": random(1000000, 9000000),
    //     "attachment" : {
    //       "name" : documentFileName,
    //        "location" : documentFileLocation,
    //       "fileName" : documentFileName,
    //       "type" : documentFiletype == 'png' ? "image/png" : documentFiletype == 'jpg' || documentFiletype == 'jpeg' ? "image/jpeg" : documentFiletype == 'pdf' ? 'application/pdf' : ''
    //     }
    //   },
    // );

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

    setState(() {
      uploadimage = choosedimage;
      String getPath = choosedimage.toString();
      _fileName = getPath != null ? getPath.split('/').last : '...';

      File file = choosedimage;
      _fileName = file.path.split('/').last;
      print('filename ${_fileName}');
      proof_of_residence.text = _fileName;
      // isPassportAdded = true;
    });

    setState(() {
      documentFileLocation = base64string;
      //  passportFileSize = '';
      documentFiletype = _fileName.split('.').last;
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
      proof_of_residence.text = _fileName;
      //  documentFileName = _fileName;
    });

    objectFetched.add({
      "id": random(1, 50),
      "name": documentFileName,
      "fileName": documentFileName,
      //  "size": bankFileSize,
      "type": documentFiletype == 'png'
          ? "image/png"
          : documentFiletype == 'jpg' || documentFiletype == 'jpeg'
              ? "image/jpeg"
              : documentFiletype == 'pdf'
                  ? 'application/pdf'
                  : '',
      "location": documentFileLocation,
      "description": documentFileName
    });

    addDocument();

    setState(() {
      objectFetched = [];
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

  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

  int loanID;
  int passedclientID;
  String moreDocument;
  _DocumentExtraScreenState(
      {this.loanID, this.passedclientID, this.moreDocument});

  fetchBankStatementDialog() {
    return alert(
      context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Fetch Bank Statement',
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
          'Phone Number', TextInputType.number,
          isSuffix: false),
      textOK: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RoundedButton(
          buttonText: 'Proceed',
          onbuttonPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            int tempLoanID = prefs.getInt('loanCreatedId');
            //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));

            fetchBankstatement();
          },
        ),
      ),
    );
  }

  addDocument() async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().addDocument(loanID, objectFetched);

    respose.then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: ' Error',
          message: 'Unable to add document',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        //   MyRouter.pushPageReplacement(context, SingleLoanView(loanID: loanID,comingFrom: 'documentExtraScreen'));
        getDocumentsForLoan();
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: 'Document added successfully',
          duration: Duration(seconds: 5),
        ).show(context);
      }
    });
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

    bool checkBankStatement = prefs.getBool('isBankStatement');

    if (checkBankStatement) {
      MyRouter.popPage(context);
    }

    Response responsevv = await get(
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

    // //print('loan details ${loanDetail.toString()}');
    // return loanDetail;

    Response responsevvBank = await get(
      AppUrl.getSingleClient + newClientData['clientId'].toString() + '/banks',
      headers: bHeader,
    );
    //print(responsevv.body);

    final List<dynamic> responseData2Bank = json.decode(responsevvBank.body);
    //print('responseData2Bank ${responseData2Bank}');
    var newClientDatabank = responseData2Bank;

    var bankStatment = {
      "bankSortCode": newClientDatabank[0]['bank']['bankSortCode'].toString(),
      "accountName": newClientDatabank[0]['accountname'],
      "accountNumber": newClientDatabank[0]['accountnumber'],
      "bankname": newClientDatabank[0]['bank']['name']
    };

    // mbs analysis

    try {
      Response responsevvMbs = await get(
        AppUrl.getMBSBank,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      );
      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(responsevvMbs.body);

        try {
          var fetchDoe = responseData;
          var bankResult = fetchDoe['data']['result'];

          List<dynamic> selectSortCode = bankResult
              .where((element) =>
                  element['sortCode'] == bankStatment['bankSortCode'])
              .toList();

          //print('this is Clientx code ${selectSortCode}');
          int mbsSortCode = selectSortCode[0]['id'];

          // get mobile number
          Response responsevvPersonal = await get(
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

          Response Analysisresponse = await post(
              // AppUrl.getLoanDetails + loanId.toString() + '/analyse/bankstatement/6',
              AppUrl.getLoanDetails + clientId.toString() + '/decide',
              body: json.encode(
                  checkBankStatement ? bankAnalyser : bankAnalyserForBS),
              headers: bHeader);

          print('this is analysisBody ${Analysisresponse.body}');

          if (Analysisresponse.statusCode == 200) {
            print(responsevv);
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
            // MyRouter.pushPageReplacement(
            //     context,
            //     SingleLoanView(
            //       loanID: passLoanID,
            //       comingFrom: 'loanBankStatement',
            //       clientID: clientID,
            //     ));

            MyRouter.pushPageReplacement(
                context,
                DocumentForLoan(
                  passLoanID: passLoanID,
                  //  comingFrom: 'loanBankStatement',
                  clientID: clientID,
                ));

            //       Flushbar(
            //              flushbarPosition: FlushbarPosition.TOP,
            //              flushbarStyle: FlushbarStyle.GROUNDED,
            //   backgroundColor: Colors.green,
            //   title: 'Success',
            //   message: 'Bank Statement analysis successful',
            //   duration: Duration(seconds: 3),
            // ).show(context);d

          } else {
            setState(() {
              _isLoading = false;
            });

            // MyRouter.pushPageReplacement(
            //     context,
            //     SingleLoanView(
            //       loanID: passLoanID,
            //       comingFrom: 'loanBankStatement',
            //       clientID: clientID,
            //     ));

            MyRouter.pushPageReplacement(
                context,
                DocumentForLoan(
                  passLoanID: passLoanID,
                  //  comingFrom: 'loanBankStatement',
                  clientID: clientID,
                ));

            //       Flushbar(
            //              flushbarPosition: FlushbarPosition.TOP,
            //              flushbarStyle: FlushbarStyle.GROUNDED,
            //   backgroundColor: Colors.red,
            //   title: 'Failed',
            //   message: 'Bank Analysis failed ',
            //   duration: Duration(seconds: 6),
            // ).show(context);

            if (Analysisresponse.statusCode == 500) {
              //       Flushbar(
              //              flushbarPosition: FlushbarPosition.TOP,
              //              flushbarStyle: FlushbarStyle.GROUNDED,
              //   backgroundColor: Colors.red,
              //   title: 'Failed',
              //   message: 'Unknown server error',
              //   duration: Duration(seconds: 6),
              // ).show(context);

              result = {
                'status': false,
                'message': 'Server error, please try again'
              };
            }
            //  result = {
            //   'status': false,
            //   'message': json.decode(responsevv.body)
            // };

          }

          /////
          final Future<Map<String, dynamic>> respose = RetCodes()
              .bankStatementAnalyser(bankAnalyser, passLoanID, clientId);
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
                result = {
                  "status": true,
                  "message": response['data']['reason']
                };
              } else {
                result = {
                  "status": true,
                  "message": response['data']['reason']
                };
              }
              int tempLoanID = prefs.getInt('loanCreatedId');
              bool isAutoDisbursed = prefs.getBool('isAutoDisburse');
            }
          });
        } catch (e) {
          if (e.toString().contains('SocketException') ||
              e.toString().contains('HandshakeException')) {
            print('got here');
            return result = {
              'status': false,
              'message': 'Network error',
              'data': 'No Internet connection'
            };
          }
        }

        // end
        // return loandData;
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> fetchBankstatement() async {
    MyRouter.popPage(context);
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int passedLoanID = prefs.getInt('loanCreatedId');

    Map<String, DateTime> dateRange = calculateStartAndEndDates();

    DateTime startDate = dateRange['startDate'];
    DateTime endDate = dateRange['endDate'];

    final formattedStartDate = formatDateForDisplay(startDate);
    final formattedEndDate = formatDateForDisplay(endDate);

    print('Start Date: $formattedStartDate');
    print('End Date: $formattedEndDate');

    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };
    setState(() {
      _isLoading = true;
    });

    Response responsevv = await get(
        AppUrl.getLoanDetails +
            passedLoanID.toString() +
            '?associations=all&exclude=guarantors,futureSchedule',
        headers: bHeader);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;
    // Map<String, dynamic> loanDetail = {
    //   "amount_requested": newClientData['principal'],
    //   "productId": newClientData['loanProductId'],
    //   "tenure": newClientData['numberOfRepayments'],
    //   "id": newClientData['id'],
    //   "clientID": newClientData['clientId']
    // };

    // //print('loan details ${loanDetail.toString()}');
    // return loanDetail;

    Response responsevvBank = await get(
      AppUrl.getSingleClient + newClientData['clientId'].toString() + '/banks',
      headers: bHeader,
    );
    //print(responsevv.body);

    final List<dynamic> responseData2Bank = json.decode(responsevvBank.body);
    //print('responseData2Bank ${responseData2Bank}');
    var newClientDatabank = responseData2Bank;

    var bankStatment = {
      "bankSortCode": newClientDatabank[0]['bank']['bankSortCode'].toString(),
      "accountName": newClientDatabank[0]['accountname'],
      "accountNumber": newClientDatabank[0]['accountnumber'],
      "bankname": newClientDatabank[0]['bank']['name']
    };

    // mbs analysis

    //  print('start mbs check');
    try {
      Response responsevvMbs = await get(
        AppUrl.getMBSBank,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      );
      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(responsevvMbs.body);

        print('fetchReqs bank data >> ${responseData}');

        try {
          var fetchDoe = responseData;
          var bankResult = fetchDoe['data']['result'];

          List<dynamic> selectSortCode = bankResult
              .where((element) =>
                  element['sortCode'] == bankStatment['bankSortCode'])
              .toList();

          //print('this is Clientx code ${selectSortCode}');
          int mbsSortCode = selectSortCode[0]['id'];

          // get mobile number
          Response responsevvPersonal = await get(
              AppUrl.getSingleClient + newClientData['clientId'].toString(),
              headers: bHeader);
          final Map<String, dynamic> responseData2Personal =
              json.decode(responsevvPersonal.body);
          String phonenumber = responseData2Personal['mobileNo'];

          Map<String, dynamic> fetchBankStatementRequest = {
            "accountNo": bankStatment['accountNumber'],
            "bankId": mbsSortCode,
            "startDate": formattedStartDate,
            "endDate": formattedEndDate,
            "phone": clientPhoneNumber.text,
            "retryCount": 0

            // "accountNo": "8249989011",
            // "bankId": 5,
            // "startDate": "09-SEP-2023",
            // "endDate": "12-DEC-2023",
            // "phone": "08102033246",
            // "retryCount": 0
          };

          print('fetchReqs >> ${fetchBankStatementRequest}');

          int clientId = newClientData['clientId'];
          int passLoanID = newClientData['id'];

          try {
            Response BankStatementresponse = await post(
                AppUrl.fetchBankStatement,
                body: json.encode(fetchBankStatementRequest),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': APP_TOKEN,
                }).timeout(
              Duration(seconds: 90),
              onTimeout: () {
                // result = {
                //   'status': false,
                //   'message': 'Connection timed out',
                // };
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.blue,
                  title: 'Failed to fetch bank statement',
                  message: 'Bank Statement Extraction failed',
                  duration: Duration(seconds: 4),
                ).show(context);
                return;
              },
            );

            setState(() {
              _isLoading = false;
            });
            print('app url >> ${AppUrl.fetchBankStatement}');
            print('this is bankStatement request ${fetchBankStatementRequest}');
            print('this is bankStatement ${BankStatementresponse.body}');
            print(
                'this is bankStatement response ${BankStatementresponse.statusCode}');

            if (BankStatementresponse.statusCode == 200) {
              Map<String, dynamic> responseBank_Statement =
                  json.decode(BankStatementresponse.body);

              if (responseBank_Statement['data'] == null) {
                setState(() {
                  objectFetched = [];
                  isAttachSuccessful = false;
                });

                return Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.blue,
                  title: 'Failed to fetch bank statement',
                  message: responseBank_Statement['message'],
                  duration: Duration(seconds: 4),
                ).show(context);
              }

              print('the data');
              var statusCode = responseBank_Statement['statusCode'];
              if (statusCode == 97 || statusCode == 98 || statusCode == 99) {
                Map<String, dynamic> retryBankStatementrequest = {
                  "accountNo": bankStatment['accountNumber'],
                  "bankId": mbsSortCode,
                  "startDate": formattedStartDate,
                  "endDate": formattedEndDate,
                  "phone": clientPhoneNumber.text,
                  "retryCount": 0
                };

                setState(() {
                  _isLoading = true;
                });
                Response retry_bankStatementresponse = await post(
                    AppUrl.retryFetchbankStatement,
                    body: json.encode(retryBankStatementrequest),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': APP_TOKEN,
                    });

                setState(() {
                  _isLoading = false;
                });

                Map<String, dynamic> ret_responseBank_Statement =
                    json.decode(retry_bankStatementresponse.body);
                print('the data');

                objectFetched.add({
                  "id": random(1, 50),
                  "name": 'Bank Statement (MBS)',
                  "fileName": 'Bank Statement (MBS)',
                  "type": 'application/pdf',
                  "location": ret_responseBank_Statement['data'],
                  "description": 'Bank Statement (MBS)'
                });

                addDocument();

                setState(() {
                  objectFetched = [];
                  isAttachSuccessful = true;
                });
              }

              print(responseBank_Statement['data']);

              objectFetched.add({
                "id": random(1, 50),
                "name": 'Bank Statement (MBS)',
                "fileName": 'Bank Statement (MBS)',
                "type": 'application/pdf',
                "location": responseBank_Statement['data'],
                "description": 'Bank Statement (MBS)'
              });

              addDocument();

              setState(() {
                objectFetched = [];
                isAttachSuccessful = true;
              });
            }
          } catch (e) {
            if (e.toString().contains('SocketException') ||
                e.toString().contains('HandshakeException')) {
              print('got here');
              // return result = {
              //   'status': false,
              //   'message': 'Network error',
              //   'data': 'No Internet connection'
              // };
              setState(() {
                _isLoading = false;
              });
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                title: 'Failed',
                message: 'Bank Statement Extraction failed',
                duration: Duration(seconds: 4),
              ).show(context);
            }
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          if (e.toString().contains('SocketException') ||
              e.toString().contains('HandshakeException')) {
            print('got here');
            return result = {
              'status': false,
              'message': 'Network error',
              'data': 'No Internet connection'
            };
          }
        }

        // end
        // return loandData;
      } else {}
    } catch (e) {
      print('exception from mbs >> ${e}');
      setState(() {
        _isLoading = false;
      });
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Failed',
        message: 'Failed to get MBS banks list',
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  @override
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
            'Phone Number', TextInputType.number,
            isSuffix: false),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: RoundedButton(
            buttonText: 'Proceed',
            onbuttonPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              int tempLoanID = prefs.getInt('loanCreatedId');
              //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: tempLoanID,comingFrom: 'loanBankStatement',));
              completeBankAnalyser();
            },
          ),
        ),
      );
    }

    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //
        //   leading: IconButton(
        //     onPressed: (){
        //       MyRouter.popPage(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        //   ),
        //   actions: [
        //
        //   ],
        // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: loanDetail.isEmpty
                ? Container(height: 300, child: ShimmerListLoading())
                : RefreshIndicator(
                    onRefresh: () => getDocumentsForLoan(),
                    child: Container(
                      child: Column(
                        children: [
                          ProgressStepper(
                            stepper: 0.8,
                            title: 'Extra Document',
                            subtitle: 'View Loan',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          loanDocument(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        bottomNavigationBar: BottomNavComponent(
          text: 'Next',
          callAction: () async {
            //    MyRouter.pushPage(context, DocumentForLoan());
            // if(canGoToStatementScreen){
            //   MyRouter.pushPageReplacement(context, LoanBankStatement(clientId: loanDetail['clientId'],loanId: loanDetail['id'],));
            //  MyRouter.pushPageReplacement(context, SingleLoanView(loanID: loanDetail['id'],comingFrom: 'loanBankStatement',));

            // }
            // else {
            // run bank statement here
            // setState(() {
            //   _isLoading = true;
            // });
            // BankAnalyser bankAnalyser = BankAnalyser();
            // var finalResult =  bankAnalyser.completeBankAnalyser();
            // finalResult.then((value) {
            //   setState(() {
            //     _isLoading = false  ;
            //   });
            //       Flushbar(
            //              flushbarPosition: FlushbarPosition.TOP,
            //              flushbarStyle: FlushbarStyle.GROUNDED,
            //     backgroundColor: Colors.blue,
            //     title: 'Analysis Status',
            //     message: value['message'],
            //     duration: Duration(seconds: 3),
            //   ).show(context);
            //
            // });
            // MyRouter.pushPageReplacement(context, SingleLoanView(loanID: loanID,comingFrom: 'documentExtraScreen'));

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            bool checkBankStatement = prefs.getBool('isBankStatement');

            print('checkbankStatement ${checkBankStatement}');
            //   checkBankStatement ? sendForAnalysis() : completeBankAnalyser();
            MyRouter.pushPageReplacement(
                context,
                DocumentForLoan(
                  passLoanID: loanID,
                  //  comingFrom: 'loanBankStatement',
                  clientID: clientID,
                ));
            // }
          },
        ),
      ),
    );
  }

  Widget loanDocument() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            LoopDocumentForLoan(),
            // SizedBox(height: 10,),
            // preveiewDocsPicked(),

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   '${!value ? 'Documents on Nx360' : 'Documents about to be uploaded'} ',
                  //   style: TextStyle(color: Colors.black, fontSize: 19),
                  // ),
                  // Checkbox(
                  //   value: this.value,
                  //   onChanged: (bool value) {
                  //     setState(() {
                  //       this.value = value;
                  //     });
                  //     //  value == true ? OldDocsPreview() : preveiewDocsPicked();
                  //   },
                  // ),

                  // CupertinoSwitch(
                  //   value: this.value,
                  //   activeColor: Color(0xff077DBB),
                  //   onChanged: (bool value) async{
                  //     //  SharedPreferences prefs = await SharedPreferences.getInstance();
                  //
                  //     setState(() {
                  //       // _lights = value;
                  //       // print(_lights);
                  //       this.value = value;
                  //     });
                  //     // var setLight =   prefs.setBool('isLight', _lights);
                  //     // bool getLight = prefs.getBool('isLight');
                  //     // print('mewLight ${getLight}');
                  //   },
                  // ),
                ],
              ),
            ),

            existingDocument()
          ],
        ));
  }

  Widget existingDocument() {
    return ListView.builder(
        itemCount: documentsArray.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return ListTile(
            title: Text(
              '${documentsArray[index]['fileName']}',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            leading: Text(
              '${index + 1}',
              style: TextStyle(color: Colors.black),
            ),
            // subtitle: Text('${notesArray[index]['type']}'),
            trailing: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.blue,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: InkWell(
                    onTap: () async {
                      var documentId = documentsArray[index]['id'];
                      getSingleDocument(documentId);

                      // var documentLocation = documentsArray[index]['location'];
                      // var documentType = documentsArray[index]['type'];
                      // var documentName = documentsArray[index]['fileName'];
                      //
                      // if (documentType == 'application/pdf') {
                      //   String pdf = documentsArray[index]['location'];
                      //   String fileName = documentsArray[index]['fileName'];
                      //   var Velo = pdf.split(',').first;
                      //   int chopOut = Velo.length + 1;
                      //   var bytes = base64Decode(pdf
                      //       .substring(chopOut)
                      //       .replaceAll("\n", "")
                      //       .replaceAll("\r", ""));
                      //   final output = await getTemporaryDirectory();
                      //   final file = File("${output.path}/${documentName}.pdf");
                      //   await file.writeAsBytes(bytes.buffer.asUint8List());
                      //   //print("${output.path}/${documentName}.pdf");
                      //   await OpenFile.open(
                      //       "${output.path}/${documentName}.pdf");
                      //   setState(() {});
                      // } else {
                      //   MyRouter.pushPage(
                      //       context,
                      //       DocumentPreview(
                      //         passedDocument: documentsArray[index]['location'],
                      //       ));
                      // }
                    },
                    child: Text('View Document'),
                  ))
                ];
              },
            ),
          );
        });
  }

  retsNx360dates(DateTime selected) {
    String newdate = selected.toString().substring(0, 10);
    print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(selected);

    String removeComma = formattedDate.replaceAll(",", "");

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String concatss = o2 + " " + o1 + " " + o3;
    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText, var keyBoard,
      {bool isValidateEmployer = false,
      bool isSendOTP = true,
      var maxLenghtAllow,
      Function onBtnPressed,
      bool isSuffix = false,
      String extension,
      bool needsValidation = true,
      Function changeValidator}) {
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
            maxLength: maxLenghtAllow,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,
            controller: editController,
            maxLines: 4,
            validator: changeValidator,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                suffixStyle: TextStyle(backgroundColor: Colors.transparent),
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

  Widget preveiewDocsPicked() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: objectFetched.isEmpty
          ? Text(
              'No Document here,',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )
          : Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: objectFetched.length,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, position) {
                      print('objectFetched lenght ${objectFetched.length}');
                      return Column(
                        children: [
                          ListTile(
                            leading: Text(
                              objectFetched[position]['name'],
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
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: RoundedButton(
                        buttonText: 'Add Document',
                        onbuttonPressed: () {
                          addDocument();
                        }))
              ],
            ),
    );
  }

  Widget LoopDocumentForLoan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          DropDownComponent(
              items: DocumentTypeArray,
              popUpDisabled: (String s) {
                return s.startsWith('Loan Agreement Form') ||
                    s.startsWith('Statement');
              },
              onChange: (String item) {
                setState(() {
                  List<dynamic> selectID = allDocumentType
                      .where((element) => element['name'] == item)
                      .where((element) => element['systemDefined'] == true)
                      .toList();
                  print('this is select ID');
                  print(selectID[0]['id']);
                  documentTypeInt = selectID[0]['id'];

                  getSubCategoryList(documentTypeInt.toString());
                  print('end this is select ID');
                  documentFileName = ' ';
                });
              },
              label: "Select Document Type * ",
              selectedItem: "",
              validator: (String item) {}),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              child: DropDownComponent(
                  items: LAFArray,
                  onChange: (String item) {
                    setState(() {
                      List<dynamic> selectID = allLAF
                          .where((element) => element['name'] == item)
                          .toList();
                      print('this is select ID');
                      print(selectID[0]['id']);
                      documentFileName = selectID[0]['name'];
                      showFetchBankStatement = true;
                      documentFileName == 'Bank Statement'
                          ? showBankstatementDropDown = true
                          : showBankstatementDropDown = false;
                      //   getIdentityList('55');
                    });
                  },
                  label: "Document * ",
                  selectedItem: documentFileName,
                  validator: (String item) {})),
          SizedBox(
            height: 20,
          ),
          showBankstatementDropDown == true
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                  child: DropDownComponent(
                      items: ['Fetch Bank Statement', 'Attach Bank Statement'],
                      onChange: (String item) {
                        // if(item == 'Fetch Bank Statement'){
                        //   showFetchBankStatement = true
                        // }
                        item == 'Fetch Bank Statement'
                            ? showFetchBankStatement = false
                            : showFetchBankStatement = true;

                        if (item == 'Fetch Bank Statement') {
                          // sendForAnalysis();
                          fetchBankStatementDialog();
                        }
                      },
                      popUpDisabled: (String s) {
                        if (isAttachSuccessful == true) {
                          return s.startsWith('Fetch Bank');
                        }
                      },
                      label: "Bank Statement * ",
                      selectedItem: 'Select an Option',
                      validator: (String item) {}))
              : SizedBox(),
          SizedBox(
            height: 20,
          ),
          showFetchBankStatement == true
              ? Container(
                  width: MediaQuery.of(context).size.width * 1.7,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
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
                              //   _openDocumentsExplorer();
                              if (documentFileName == null) {
                                errorMessage('Document name cannot be empty');
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => DocumentbottomSheet()),
                                );
                                //  _openDocumentsExplorer();
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
                      )),
                )
              : SizedBox(),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              InkWell(
                onTap: () {
                  getDocumentsForLoan();
                },
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Refresh',
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
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
