import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/LoanView.dart';
import 'package:sales_toolkit/views/Loans/NewLoan.dart';
import 'package:sales_toolkit/views/clients/DocumentPreview.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/widgets/LocalTypeAhead.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:timelines/timelines.dart';

class SingleLoanView extends StatefulWidget {
  final int loanID, clientID;
  final String comingFrom;
  const SingleLoanView({Key key, this.loanID, this.clientID, this.comingFrom})
      : super(key: key);

  @override
  _SingleLoanViewState createState() => _SingleLoanViewState(
      loanID: this.loanID,
      comingFrom: this.comingFrom,
      clientID: this.clientID);
}

class _SingleLoanViewState extends State<SingleLoanView> {
  List<String> identityArray = [];
  List<String> collectIdentity = [];
  List<dynamic> allIdentity = [];

  List<String> empSector = [];
  List<String> collectData = [];
  List<dynamic> allEmp = [];

  String employerSector = '';
  String categorySector = '';

  List<String> LAFArray = [];
  List<String> collectLAF = [];
  List<dynamic> allLAF = [];
  String realMonth = '';
  Timer _timerForInter;
  File uploadimage;
  var clientType = {};
  var employmentProfile = [];
  String documentFileName,
      residenceFileSize,
      documentFiletype,
      documentFileLocation;

  int documentTypeInt, clientTypeInt;
  bool _isLoading = false;
  bool showApprovalButton = false;
  int approvalId ;
  bool isPendingOnMe = false ;

  int empInt;

  String lafArr = '';
  List<Status> statuses = [];


  List<Status> parseStatuses(List<dynamic> statusList) {
    return statusList.map((json) {
      IconData icon;
      Color color;
      bool showReassignButton = false;

      switch (json['status']) {
        case 'APPROVED':
          icon = Icons.check_circle;
          color = Colors.green;
          break;
        case 'PENDING':
          icon = Icons.camera_alt;
          color = Colors.orange;
          showReassignButton = false;  // Assuming you want to show "Re-Assign" for PENDING status
          break;
        case 'INQUEUE':
          icon = Icons.medical_services;
          color = Colors.grey;
          break;
        default:
          icon = Icons.help;
          color = Colors.grey;
          break;
      }

      return Status(
        date: json['date'] ?? '',
        status: json['status'] ?? '',
        assignee: json['staffName'] ?? '',
        statusIcon: icon,
        statusColor: color,
        showReassignButton: false,
      );
    }).toList();
  }


  @override
  void initState() {
    // TODO: implement initState
    print('this is loanID ${loanID}');
    getCodesList();
    getLoanDetails();
    getSettlementBalance();
    //getSubCategoryList();
    // getEmploymentProfile();
    getNotesForLoan();
    getDocumentsForLoan();

    // getEmploymentProfile();
    getClientType();
    getApprovals();
    // _timerForInter = Timer.periodic(Duration(seconds: 2), (result) {
    //   getIsLafSigned();
    // });

    super.initState();
  }

  @override
  void dispose() {
    if (_timerForInter != null) {
      _timerForInter.cancel();
      _timerForInter = null;
    }

    // _timerForInter?.cancel();
    super.dispose();
  }

  Map<String, dynamic> loanDetail = {};
  String settlementBalance = '';
  String method = '';
  String commandType = '';

  bool isLafSigned = false;
  bool isDocumentComplete = false;
  bool isRequestLoading = false;

  int employmentInt, identityInt, residenceInt;
  String identityName;
  String documentType = '';
  String branchEmployer = '';

  List<dynamic> objectFetched = [];
  List<dynamic> notesArray = [];

  List<String> DocumentTypeArray = [];
  List<String> collectDocumentType = [];
  List<dynamic> allDocumentType = [];

  List<String> employerArray = [];
  List<String> collectEmployer = [];
  List<int> collectEmployerID = [];

  List<dynamic> allEmployer = [];

  List<String> BranchEmployerArray = [];
  List<String> collectBranchEmployer = [];
  List<dynamic> allBranchEmployer = [];

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
  int employerID, sectorId, parentClient, employerInt;
  int branchEmployerInt = 0;
  String employerDomain = '';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  bool isLafFoundInDoc = false;
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );

  int random(min, max) {
    return min + Random.secure().nextInt(max - min);
  }

  TextEditingController note = TextEditingController();
  TextEditingController approvalNote = TextEditingController();
  TextEditingController proof_of_residence = TextEditingController();
  TextEditingController emp_note = TextEditingController();
  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController employeeID = TextEditingController();
  String parentEmployer = '';

  getCodesList() {
    setState(() {
      isRequestLoading = true;
    });
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('36');
    respose.then((response) async {
      setState(() {
        isRequestLoading = false;
      });
      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpSector'));

        //
        if (prefs.getString('prefsEmpSector').isEmpty) {
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
            allEmp = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectData.add(mtBool[i]['name']);
          }

          setState(() {
            empSector = collectData;
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
        setState(() {
          isRequestLoading = false;
        });

        //print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpSector', jsonEncode(newEmp));

        int leadToClient = prefs.getInt('leadToClientID');
        //print('lead To Client Id ${leadToClient}');

        setState(() {
          allEmp = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectData.add(newEmp[i]['name']);
        }

        setState(() {
          empSector = collectData;

          List<dynamic> selectID = allEmp
              .where((element) => element['name'] == employerSector)
              .toList();
          empInt = selectID == null ? 0 :  selectID[0]['id'];

          //print('gender In from Init ${empInt}');
        });
      }
    });
  }

  single_loan_view_employerProfile(int clientid) async {
    print('got here>>');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    setState(() {
      _isLoading = true;
    });
    Response responsevv = await get(
      AppUrl.getSingleClient + clientid.toString() + '/employers',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    //  print(responsevv.body);

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    print('responseData2 ${responseData2}');

    setState(() {
      employmentProfile = responseData2;

      employerID = responseData2[0]['employer']['id'];
      sectorId = responseData2[0]['employer']['sector']['id'];
      parentClient = responseData2[0]['employer']['parent']['clientType']['id'];


      print('client employer ID ${employerID}');

      branchEmployerInt = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['id'];

      //    empSector = employmentProfile.isEmpty ? '' : employmentProfile[0]['employer']['sector']['id'];
      branchEmployer = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['name'];
      employerDomain = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['emailExtension'];
      //  salary_range = employmentProfile.isEmpty ? '' : employmentProfile[0]['salaryRange']['name'];
      parentEmployer = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['parent']['name'];
      employerInt = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['parent']['id'];
      //   _isWorEmailVerified = employmentProfile.isEmpty ? false : employmentProfile[0]['workEmailVerified'];
      // salaryPayDayController.text =

      _isLoading = false;
    });


  }

  getLoanDetails() async {
    print('loanID ${loanID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');
    setState(() {
      _isLoading = true;
    });
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
    AppTracker().trackActivity('LOAN DETAILS LOADED',payLoad:
    {
      "response": newClientData.toString(),
      "clientId": clientID
    });

    setState(() {
      print('Loan employee Number ${loanDetail['employeeNumber']}');
      _isLoading = false;
      loanDetail = newClientData;
      isLafSigned = loanDetail['isLafSigned'];
      isDocumentComplete = loanDetail['isDocumentComplete'];

      if (loanDetail['configs'] != null) {
        int docConfigData = loanDetail['configs'][0]['id'];
        if (docConfigData != null) {
          //
          geSingleLoanConfig(docConfigData);
          single_loan_view_employerProfile(loanDetail['clientId']);
        }
      }

      employeeID.text = loanDetail['employeeNumber'];
      branchEmployerInt = loanDetail['employerData'].isEmpty
          ? ''
          : loanDetail['employerData']['id'];
      branchEmployer = loanDetail['employerData'].isEmpty
          ? ''
          : loanDetail['employerData']['name'];
      // employerDomain = loanDetail['employerData'].isEmpty ? '' : employmentProfile[0]['employer']['emailExtension'];
      parentEmployer = loanDetail['employerData'].isEmpty
          ? ''
          : loanDetail['employerData']['parent']['name'];
      employerInt = loanDetail['employerData'].isEmpty
          ? ''
          : loanDetail['employerData']['parent']['id'];

      _typeAheadController.text = loanDetail['employerData'].isEmpty
          ? ''
          : loanDetail['employerData']['parent']['name'];
    });
    print('Loan detail ${loanDetail}');
  }

  getIsLafSigned() async {
    print('loanID ${loanID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');

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
      isLafSigned = loanDetail['isLafSigned'];
      isDocumentComplete = loanDetail['isDocumentComplete'];
    });
  }


  getClientType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID = clientID;
    print('localClient ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    //print(tfaToken);
    //print(token);
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    //print(responsevv.body);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;
    setState(() {
      clientType = newClientData;
      //print('responseData2 client Type ${clientType}');
      employerSector = newClientData['employmentSector']['name'];
      clientTypeInt = clientType.isEmpty ? '' : clientType['clientType']['id'];
      sectorId = clientType.isEmpty ? '' : clientType['employmentSector']['id'];
      //print('sector ID ${sectorId}');
    });

    print('client Type ${clientTypeInt} ${clientType}');
  }

  Future<List> getSuggestions(String query) async {
    if (query.length > 3) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final Future<Map<String, dynamic>> result_response =
      RetCodes().employers(clientTypeInt, query);
      //
      result_response.then((response) async {
        List<dynamic> newEmp = response['data']['pageItems'];

        setState(() {
          allEmployer = newEmp;
          collectEmployer = [];
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectEmployer.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectEmployer);

        // setState(() {
        //   employerArray = collectEmployer;
        //   List<dynamic> selectID =   allEmployer.where((element) => element['name'] == branchEmployer).toList();
        //   //print('select value ${selectID}');
        //   //  branchEmployerInt = selectID[0]['id'];
        // });
      });
      //print('employer Array ${allEmployer}');
      return allEmployer;
    }
  }

  getEmployersBranch(int parentID) {
    //print('this is parent branch ${parentID}');
    final Future<Map<String, dynamic>> respose =
    RetCodes().getEmployersBranch(parentID);
    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allSalary = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectSalary.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectSalary);
    //
    //   setState(() {
    //     salaryArray = collectSalary;
    //   });
    // }
    // );

    setState(() {
      _isLoading = true;
    });
    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
      //print('${response['data']}');

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
        jsonDecode(prefs.getString('prefsBranchEmployer'));

        if (prefs.getString('prefsBranchEmployer').isEmpty) {
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
            BranchEmployerArray = [];
            allBranchEmployer = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            BranchEmployerArray.add(mtBool[i]['name']);
          }

          setState(() {
            BranchEmployerArray = collectBranchEmployer;
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

        //print('this is newEmps ${newEmp.toString()}');

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsBranchEmployer', jsonEncode(newEmp));

        setState(() {
          BranchEmployerArray = [];
          collectBranchEmployer = [];
        });

        setState(() {
          allBranchEmployer = newEmp;
        });

        //print('all Branch ${newEmp}');

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectBranchEmployer.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBranchEmployer);

        setState(() {
          _isLoading = false;
          BranchEmployerArray = collectBranchEmployer;
        });
      }
    });
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

      setState(() {
        DocumentTypeArray = collectDocumentType;
      });
    });
  }

  getSettlementBalance() async {
    DateTime todayZdate = DateTime.now();
    String convertedDate = retsNx360dates(todayZdate);
    final Future<Map<String, dynamic>> respose =
    RetCodes().getSttlement(loanID, convertedDate);
    respose.then((response) {
      print('response data for settlement ${response}');
      if (response['status'] == false) {
        setState(() {
          settlementBalance = 'N/A';
        });
      } else {
        setState(() {
          settlementBalance = 'NGN ' + response['data']['amount'].toString();
        });
      }
    });
  }



  resendLaf() async {

    final Future<Map<String, dynamic>> respose =
    RetCodes().lafDocument(loanID);
    setState(() {
      _isLoading = true;
    });
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      getDocumentsForLoan();
    //  print('response data for resend laf ${response}');
      if (response['status'] == false) {
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Failed',
          message: 'Failed to generate',
          duration: Duration(seconds: 3),
        ).show(context);

      } else {

        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Successful',
          message: response['message'],
          duration: Duration(seconds: 3),
        ).show(context);
      }
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
        var checkisLaf =
        newEmp.where((element) => element['name'] == 'SMS LAF').toString();

        print('checkisLaf ${checkisLaf.length}');
        if (checkisLaf.length < 4) {
          for (int i = 0; i < newEmp.length; i++) {
            print(newEmp[i]['name']);
            collectLAF.add(newEmp[i]['name']);
          }
        } else {
          for (int i = 0; i < 2; i++) {
            print(newEmp[i]['name']);
            collectLAF.add(newEmp[i]['name']);
          }
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

  getNotesForLoan() {
    final Future<Map<String, dynamic>> respose = RetCodes().getLoanNote(loanID);

    respose.then((response) {
      //  print('note response ${response}');
      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Note Empty ',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        notesArray = response['data'];
        print('notes array ${notesArray}');
      }
    });
  }


  // getApprovals() {
  //   final Future<Map<String, dynamic>> respose = RetCodes().getApprovals(loanID);
  //
  //   respose.then((response) {
  //     //  print('note response ${response}');
  //     if (response == null ||
  //         response['status'] == null ||
  //         response['status'] == false) {
  //       return Flushbar(
  //         flushbarPosition: FlushbarPosition.TOP,
  //         flushbarStyle: FlushbarStyle.GROUNDED,
  //         backgroundColor: Colors.red,
  //         title: 'Error',
  //         message: 'Unable to fetch loan timeline',
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     } else {
  //       // notesArray = response['data'];
  //       // print('notes array ${notesArray}');
  //     }
  //   });
  // }

  getApprovals() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Future<Map<String, dynamic>> response = RetCodes().getApprovals(loanID);

    response.then((response) {
      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to fetch loan timeline',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        setState(() {
          // Map the API response to Status model
          if(response['data'] != []){
            statuses = parseStatuses(response['data']);
            String Vusername = prefs.getString('username');
            for (var item in response['data']) {
              if (item['email'] == Vusername) {
                setState(() {
                  showApprovalButton = true;
                  approvalId = item['id'];
                  isPendingOnMe = item['status'] == 'PENDING' ? true : false;
                });

                break; // Exit loop once a match is found
              }
            }
          }

            print('approval Id ${approvalId} ${isPendingOnMe}');
        });
      }
    });
  }

  getEmploymentProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID = clientID;
    //print('localClient ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    //print(tfaToken);
    //print(token);
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString() + '/employers',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    //print('responsevv.body ${responsevv.body}');

    final List<dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;

    setState(() {
      employmentProfile = newClientData;
      print('responseData2 ${employmentProfile[0]}');
      prefs.setInt('tempEmployerInt',
          employmentProfile.isEmpty ? null : employmentProfile[0]['id']);

      branchEmployerInt = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['id'];
      branchEmployer = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['name'];
      employerDomain = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['emailExtension'];
      parentEmployer = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['parent']['name'];
      employerInt = employmentProfile.isEmpty
          ? ''
          : employmentProfile[0]['employer']['parent']['id'];
    });
    //print('employer Info first array ${employmentProfile}');
    var subEmployer = employmentProfile[0];

    _typeAheadController.text = employmentProfile.isEmpty
        ? ''
        : employmentProfile[0]['employer']['parent']['name'];
  }

  addEmployerInfo() {
    Map<String, dynamic> employmentData = {
      "employeeNumber": employeeID.text,
      "employerId": branchEmployerInt,
      "note": emp_note.text,
    };
    final Future<Map<String, dynamic>> respose =
    RetCodes().getEmployerInLoanView(loanID, employmentData);

    setState(() {
      _isLoading = false;
    });
    respose.then((response) {
      print('employee update response ${response}');
      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        setState(() {
          _isLoading = false;
        });
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to update employer ',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        // notesArray = response['data'];
        // print('notes array ${notesArray}');
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: 'Employer Updated successfully ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  getDocumentsForLoan() {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getDocumentNote(loanID);

    respose.then((response) {
      //  print('note response ${response}');
      if (response == null ||
          response['status'] == null ||
          response['status'] == false) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Note Empty ',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        documentsArray = response['data'];
        checkForLAF(documentsArray);

            print('documents array ${documentsArray}');
      }
    });
  }

  void checkForLAF(List<dynamic> data) {
    for (var item in data) {
      String name = item['name'].toString().toLowerCase();

      if (name.contains('laf')) {
        print('Found "LAF" in the name: ${item['name']}');
        setState(() {
          isLafFoundInDoc = true;
        });
        // Do something when "LAF" is found
      } else {
        print('No "LAF" in the name: ${item['name']}');
        // Do something when "LAF" is not found
      }
    }
  }



  getSingleDocument(int documentId) async{
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().get_SingleDocument(loanID,documentId);

    respose.then((response) async{
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
        // setState(() {});
        AppHelper().processPdfDocument(singleDoc);
      }
      else {
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
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });

    // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
    try {
      //  _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);

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

  singleGoBack(String value) {
    if (value == 'go_back') {
      // MyRouter.popPage(context);
      MyRouter.pushPageReplacement(context, LoanView(clientID: clientID,));
      // MyRouter.pushPageReplacement(context, ViewClient(clientID: clientID,));
      setState(() {
        _timerForInter.cancel();
      });
    } else if (value == 'go_home') {
      MyRouter.pushPageReplacement(context, MainScreen());
      setState(() {
        _timerForInter.cancel();
      });
    }
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

  int loanID, clientID;
  String comingFrom;
  _SingleLoanViewState({this.loanID, this.clientID, this.comingFrom});

  sendNoteForLoan(String methodType, int noteId) async {
    if (note.text.isEmpty || note.text.length < 5) {
      setState(() {
        _isLoading = false;
      });
      // addNote(methodType, passedNote, noteId)
      return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'Note length too short ',
        duration: Duration(seconds: 3),
      ).show(context);

      MyRouter.popPage(context);
    }

    Map<String, dynamic> noteData = {
      'note': note.text,
    };

    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().addNote(noteData, loanID, methodType, noteId);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print('response got here ${response}');
      if (response['status'] == true) {
        note.text = '';

        getNotesForLoan();
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: 'Operation successful',
          duration: Duration(seconds: 5),
        ).show(context);
      } else {
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Failed',
          message: 'Operation failed',
          duration: Duration(seconds: 5),
        ).show(context);
      }
    });
  }

  addNote(String methodType, String passedNote, int noteId) {
    note.text = passedNote;
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
      content:
      EntryField(context, note, 'Add Note', passedNote, TextInputType.name),
      textOK: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: RoundedButton(
          buttonText: 'Add Note',
          onbuttonPressed: () {
            sendNoteForLoan(methodType, noteId);
          },
        ),
      ),
    );
  }

  copyLinkForClient() async {
    String cp_text = AppUrl.paymentLinkUrl + loanDetail['payRef'];
    Clipboard.setData(ClipboardData(text: cp_text));
    Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
      title: 'Success',
      message: 'Link copied to clipboard',
      duration: Duration(seconds: 5),
    ).show(context);
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
        getDocumentsForLoan();
        setState(() {
          objectFetched = [];
        });
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

  @override
  Widget build(BuildContext context) {

    var sendLoanForApproval = () async {
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

      Map<String, dynamic> noteData = {
        'note': note.text,
      };

      setState(() {
        _isLoading = true;
      });
      MyRouter.popPage(context);
      if(isLafFoundInDoc == false){
        final Future<Map<String, dynamic>> respose =
        RetCodes().lafDocument(loanID);
      }
      final Future<Map<String, dynamic>> respose =
      RetCodes().SendLoanForApproval(noteData, loanID, 'auto_review');

      respose.then((response) {
        print('response got here ${response}');
        setState(() {
          _isLoading = false;
        });
        if (response['status'] == true) {
          note.text = '';
          //  MyRouter.popPage(context);
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Loan successfully sent for approval',
            duration: Duration(seconds: 5),
          ).show(context);
          getLoanDetails();
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


    var send_loan_for_re_approval = () async {
      if (approvalNote.text.isEmpty || approvalNote.text.length < 5) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'please add note ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      DateTime now = DateTime.now();
      String vasCoddd = retsNx360dates(now);


      Map<String, dynamic> noteData =  {
        "loanId": loanID,
        "approvedLoanAmount":loanDetail['approvedPrincipal'] ,
        "approvedOnDate": vasCoddd,
        "expectedDisbursementDate": retDOBfromBVN(
      '${loanDetail['timeline']['expectedDisbursementDate'][0]}-${loanDetail['timeline']['expectedDisbursementDate'][1]}-${loanDetail['timeline']['expectedDisbursementDate'][2]}'),
        "note": approvalNote.text,
        "locale": "en",
        "dateFormat": "dd MMMM yyyy"
      };

      setState(() {
        _isLoading = true;
      });
      MyRouter.popPage(context);
      if(isLafFoundInDoc == false){
        final Future<Map<String, dynamic>> respose =
        RetCodes().lafDocument(loanID);
      }
      final Future<Map<String, dynamic>> respose =
      RetCodes().sendForReApprove(noteData, approvalId, 'auto_review');
      setState(() {
        _isLoading = false;
      });
      respose.then((response) {
        print('response got here ${response}');
        if (response['status'] == true) {
          note.text = '';
          //  MyRouter.popPage(context);
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Loan successfully sent for approval',
            duration: Duration(seconds: 5),
          ).show(context);
          getLoanDetails();
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
            context, note, 'Add Note', 'Enter Note', TextInputType.name),
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


    sendForReApprove() {
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
            context, approvalNote, 'Add Note', 'Enter Note', TextInputType.name),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: RoundedButton(
            buttonText: 'Send',
            onbuttonPressed: () {
             // sendLoanForApproval();
              send_loan_for_re_approval();
            },
          ),
        ),
      );
    }

    var sendGenerationLink = (String mode, String commandType) async {
      print('this is mode ${mode}');
      //  String loanCommandType = loanDetail['status']['value'] == 'Active' ? 'repayment' : 'tokenization';
      final Future<Map<String, dynamic>> respose =
      RetCodes().sendLinkToCLient(loanID, mode, commandType);
      respose.then((response) {
        print('this is response ${response}');

        if (response['status'] == true) {
          note.text = '';
          MyRouter.popPage(context);
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: 'Payment Link sent to user',
            duration: Duration(seconds: 5),
          ).show(context);
        } else {
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Failed',
            message: 'Unable to send payment link,try again',
            duration: Duration(seconds: 5),
          ).show(context);
        }
      });
    };

    generateLink() {
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Generate Link'),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: loanDetail['status']['value'] == 'Active'
                    ? DropDownComponent(
                    items: ['Repayment','Tokenize'],
                    onChange: (String item) {
                      setState(() {
                        if(item == 'Tokenize'){
                          commandType = 'tokenization';
                        }
                        else {
                          commandType = 'repayment';
                        }
                      }
                      );
                    },
                    label: "Link Type *",
                    selectedItem: 'Tokenize or Repayment',
                    validator: (String item) {})
                    : DropDownComponent(
                    items: [
                      'Laf And Repayment Method',
                    ],
                    onChange: (String item) {
                      setState(() {
                        commandType = 'tokenization';
                      });
                    },
                    label: "Link Type *",
                    selectedItem: 'Laf And Repayment Method',
                    validator: (String item) {}),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: DropDownComponent(
                    items: ['Email', 'Mobile'],
                    onChange: (String item) {
                      setState(() {
                        method = item;
                      });
                    },
                    label: "Mode *",
                    selectedItem: "Email",
                    validator: (String item) {}),
              ),
            ],
          ),
        ),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: RoundedButton(
            buttonText: 'Generate',
            onbuttonPressed: () {
              if (method.isEmpty || method.length == 0) {
                setState(() {
                  method = 'Email';
                });
              }
              sendGenerationLink(method, commandType);
              //  sendGenerationLink(method, commandType = "tokenisation");
            },
          ),
        ),
      );
    }

    // addDocumentForLoan(){
    //   return alert(
    //     context,
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text('Add Document'),
    //         InkWell(
    //             onTap: (){
    //               MyRouter.popPage(context);
    //             },
    //             child: Icon(Icons.clear))
    //       ],  ),
    //     content: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           LoopDocumentForLoan(),
    //         ],
    //       ),
    //     ),
    //     textOK: Container(
    //       width: MediaQuery.of(context).size.width * 0.5,
    //       child: RoundedButton(buttonText: 'Add Document',onbuttonPressed: (){
    //       //  sendNoteForLoan();
    //       },
    //       ),
    //     ),
    //   );
    // }

    addDocumentForLoan() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int selectedRadio = 0; // Declare your variable outside the builder
          String contentText = "Content of Dialog";
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Document'),
                InkWell(
                    onTap: () {
                      MyRouter.popPage(context);
                    },
                    child: Icon(Icons.clear))
              ],
            ),
            // content: StatefulBuilder( // You need this, notice the parameters below:
            //   builder: (BuildContext context, StateSetter setState) {
            //
            //     return LoopDocumentForLoan();
            //
            //   },
            // ),
            content: Text(contentText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    contentText = "Changed Content of Dialog";
                  });
                },
                child: Text("Change"),
              ),
            ],
          );
        },
      );
    }

    needToComplete() {
      bool isAllowedToSend = (loanDetail['paymentMethod'] != null &&
          loanDetail['paymentMethod']['id'] > 1);
      print('is allowed to send ? ${isAllowedToSend}');
      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Requirements not met',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            InkWell(
                onTap: () {
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('::: Please confirm If :::'),
              SizedBox(
                height: 10,
              ),
              Text(
                loanDetail['isDocumentComplete']
                    ? ''
                    : 'Necessary Loan Document Not Uploaded',
                style: TextStyle(fontSize: 13),
              ),

              SizedBox(
                height: 10,
              ),
              Text(isAllowedToSend ? '' : ' Repayment Method Not set',
                  style: TextStyle(fontSize: 13)),
              SizedBox(
                height: 10,
              ),
              Text(
                  loanDetail['isLafSigned']
                      ? ''
                      : ' LAF Has Not Been Accepted By Customer',
                  style: TextStyle(fontSize: 13))
            ],
          ),
        ),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: RoundedButton(
            buttonText: 'OKAY',
            onbuttonPressed: () {
              //  sendLoanForApproval();
              MyRouter.popPage(context);
            },
          ),
        ),
      );
    }

    void actionPopUpItemSelected(String value) {
      if (value == 'send_loan_for_approval') {
        sendForAppro();
      } else if (value == 'add_note') {
        //      MyRouter.pushPage(context, ClientInteraction(clientID: clientID,));
        addNote('post', '', 0);
      } else if (value == 'add_document') {
        addDocumentForLoan();
      } else if (value == 'generate_link') {
        generateLink();
      } else if (value == 'copy_link') {
        copyLinkForClient();
      } else if (value == 'confirm_with_send') {
        needToComplete();
      } else {}
    }

    return RefreshIndicator(
     // onRefresh: () =>        getLoanDetails(),
      onRefresh: () async{
        getLoanDetails();
        getApprovals();
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: Container(
          height: 120,
          width: 120,
          child: Lottie.asset('assets/images/newLoader.json'),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,

            leading: PopupMenuButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.blue,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'go_back',
                    child: Row(
                      children: [
                        //  Icon(Icons.arrow_back_ios,color: ColorUtils.PRIMARY_COLOR,),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Previous Screen',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'go_home',
                    child: Row(
                      children: [
                        //  Icon(FeatherIcons.home,color: ColorUtils.PRIMARY_COLOR,),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Go To Dashboard'),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (String value) => singleGoBack(value),
            ),

            // IconButton(
            //   onPressed: (){
            //     comingFrom != null ? MyRouter.pushPageReplacement(context, ViewClient(clientID: loanDetail['clientId'],)) :  MyRouter.popPage(context);
            //   },
            //   icon:  Icon(Icons.arrow_back_ios,color: Colors.blue,),
            // ),

            //
            actions: [
              isLafSigned &&
                  isDocumentComplete &&
                  loanDetail['status']['value'] != 'Loan in draft' &&
                  loanDetail['status']['value'] != 'Rejected'
                  ?
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.blue,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'add_note',
                      child: Text('Add Note'),
                    ),
                    PopupMenuItem(
                      value: 'generate_link',
                      child: Text('Repayment Link'),
                    ),

                    PopupMenuItem(
                      value: 'copy_link',
                      child: Text('Copy Link'),
                    ),
                  ];
                },
                onSelected: (String value) =>
                    actionPopUpItemSelected(value),
              )
                  :
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.blue,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'add_note',
                      child: Text('Add Note'),
                    ),

                    PopupMenuItem(
                      value: 'generate_link',
                      child: Text('Repayment Link'),
                    ),

                    PopupMenuItem(
                      value: 'copy_link',
                      child: Text('Copy Link'),
                    ),
//   bool isAllowedToSend = (loanDetail['paymentMethod'] != null && loanDetail['paymentMethod']['id'] < 1);
//
//                           (loanDetail['paymentMethod'] != null &&
//                                       loanDetail['paymentMethod']['id'] > 0) &&
//                                   (isLafSigned || isLafFoundInDoc) &&
//                                   isDocumentComplete &&
//                                   loanDetail['status']['value'] ==
//                                       'Loan in draft'
                    (loanDetail['paymentMethod'] != null &&
                        loanDetail['paymentMethod']['id'] > 0) &&
                        isLafSigned  &&
                        (documentsArray.length > 0) &&
                        // isDocumentComplete &&
                        loanDetail['status']['value'] ==
                            'Loan in draft'
                        ? PopupMenuItem(
                      value: 'send_loan_for_approval',
                      child: Text(
                        'Send Loan For Approval',
                      ),
                    )
                        : loanDetail['status']['value'] != 'Loan in draft'
                        ? PopupMenuItem(
                      value: '',
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                        : PopupMenuItem(
                      value: 'confirm_with_send',
                      child: Text(
                        'Send For Approval',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ];
                },
                onSelected: (String value) =>
                    actionPopUpItemSelected(value),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: loanDetail.isEmpty
                  ? Container(height: 300, child: ShimmerListLoading())
                  : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    if(showApprovalButton && isPendingOnMe)
                        Column(
                          children: [
                            Container(
                              width: AppHelper().pageWidth(context) * 0.7,
                              child: RoundedButton(
                                onbuttonPressed: (){
                                 // doLogin();
                                  sendForReApprove();
                                },
                                buttonText: 'Approve',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),



                    LoanInDraftMode(),

                    SizedBox(
                      height: 20,
                    ),
                    //  newRepayment(),
                    // Text('Active loan'),
                    LoanInActiveStatus(),
                    SizedBox(
                      height: 20,
                    ),
                    //  SizedBox(height: 20,),
                    getEmployerInfoWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    loanNotes(),
                    SizedBox(
                      height: 20,
                    ),

                    loanDocument(),
                    SizedBox(
                      height: 20,
                    ),
                    //  Padding(
                    //    padding: const EdgeInsets.symmetric(horizontal: 25),
                    //    child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Text('Repayment Schedule',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                    //
                    //     ],
                    // ),
                    //  ),
                    // SizedBox(height: 10,),

                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        title: Row(
                          children: [
                            Text('Repayment Schedule',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        children: [
                          ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                              loanDetail['repaymentSchedule'] ==
                                  null ||
                                  loanDetail.isEmpty
                                  ? 0
                                  : loanDetail['repaymentSchedule']
                              ['periods']
                                  .length -
                                  1,
                              itemBuilder: (context, int index) {
                                var loanPeriod =
                                loanDetail['repaymentSchedule']
                                ['periods'][index + 1];
                                var loanPeriodDue =
                                loanDetail['repaymentSchedule']
                                ['periods'][index + 1]['dueDate'];
                                var paymentDate =
                                loanDetail['repaymentSchedule']
                                ['periods'][index + 1]
                                ['obligationsMetOnDate'];
                                //  print('loan Period ${loanPeriodDue}');

                                var compars = (a, b) {
                                  if (b == 0) {
                                    return 'not_paid';
                                  } else if (b == a) {
                                    return "paid";
                                  } else if (b < a) {
                                    return "partially_paid";
                                  }
                                };

                                //    return  ReapymentSchedule(index,'${loanDetail['repaymentSchedule']['periods'][index]['totalDueForPeriod']}',loanDetail['repaymentSchedule']['periods'][index]['complete'] == true ? 'Paid' : 'Not Paid' ,'${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][0]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][1]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][2]}',loanDetail['repaymentSchedule']['periods'][index]['principalLoanBalanceOutstanding']);
                                //return newRepayment('${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][0]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][1]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][2]}', '${loanDetail['repaymentSchedule']['periods'][index]['totalOutstandingForPeriod']}', '${loanDetail['repaymentSchedule']['periods'][index]['totalOriginalDueForPeriod']}', '${loanDetail['repaymentSchedule']['periods'][index]['totalOutstandingForPeriod']}', '${loanDetail['repaymentSchedule']['periods'][index]['totalOutstandingForPeriod']}');
                                //  print(retDOBfromBVN('${loanPeriodDue[0]}-${loanPeriodDue[1]}-${loanPeriodDue[2]}'));
                                return newRepayment(
                                    index + 1,
                                    ('${loanPeriodDue[0]}-${loanPeriodDue[1]}-${loanPeriodDue[2]}'),
                                    loanPeriod['complete'],
                                    loanPeriod['principalDue'],
                                    loanPeriod[
                                    'totalOutstandingForPeriod'],
                                    loanPeriod[
                                    'totalActualCostOfLoanForPeriod'],
                                    loanPeriod['totalDueForPeriod'],
                                    loanPeriod['totalPaidForPeriod'],
                                    compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'paid'
                                        ? Color(0xffa2e38f)
                                        : compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'partially_paid'
                                        ? Color(0xffe3cba3)
                                        : Color(0xfff7bdbc),
                                    compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'paid'
                                        ? Colors.green
                                        : compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'partially_paid'
                                        ? Colors.orange
                                        : Colors.red,
                                    compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'paid'
                                        ? 'Paid'
                                        : compars(
                                        loanPeriod[
                                        'totalInstallmentAmountForPeriod'],
                                        loanPeriod[
                                        'totalPaidForPeriod']) ==
                                        'partially_paid'
                                        ? 'Partially Paid'
                                        : 'Not Paid',
                                    paymentDate == null
                                        ? 'N/A'
                                        : '${paymentDate[0]}-${paymentDate[1]}-${paymentDate[2]}');
                              })
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),

            statuses.length == 0 ? SizedBox()
            :
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Text(
                          'Loan Timeline',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        // Remove fixed height to allow expansion of the timeline within the available space
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5, // Fix height in a more responsive way
                          child:

                          Timeline.tileBuilder(
                            theme: TimelineThemeData(
                              nodePosition: 0,
                              color: Colors.black,
                              connectorTheme: ConnectorThemeData(
                                color: Colors.grey,
                                thickness: 2.0,
                              ),
                            ),
                            builder: TimelineTileBuilder.connected(
                              itemCount: statuses.length,
                              connectionDirection: ConnectionDirection.before,
                              contentsBuilder: (context, index) {
                                final status = statuses[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: _buildStatusCard(status),
                                );
                              },
                              indicatorBuilder: (_, index) => DotIndicator(
                                color: statuses[index].statusColor,
                              ),
                              connectorBuilder: (_, index, __) => SolidLineConnector(),
                            ),
                          )


                          // Timeline.tileBuilder(
                          //   theme: TimelineThemeData(
                          //     nodePosition: 0,
                          //     color: Colors.black,
                          //     connectorTheme: ConnectorThemeData(
                          //       color: Colors.grey,
                          //       thickness: 2.0,
                          //     ),
                          //   ),
                          //   builder: TimelineTileBuilder.connected(
                          //     itemCount: statuses.length,
                          //     connectionDirection: ConnectionDirection.before,
                          //     contentsBuilder: (context, index) {
                          //       final status = statuses[index];
                          //       return Padding(
                          //         padding: const EdgeInsets.only(left: 8.0),
                          //         child: _buildStatusCard(status),
                          //       );
                          //     },
                          //     indicatorBuilder: (_, index) => DotIndicator(
                          //       color: statuses[index].statusColor,
                          //     ),
                          //     connectorBuilder: (_, index, __) => SolidLineConnector(),
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                )

                //
                    // Container(
                    //     height: MediaQuery.of(context).size.height * 0.7,
                    //     child:

                    //
                    //
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget LoanInDraftMode() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: ExpansionTile(
        initiallyExpanded: true,
        backgroundColor: Colors.white,
        title: Text('Loan Information',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product Name: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        '${loanDetail['loanProductName']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Approved Principal: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        '₦ ${formatCurrency.format(loanDetail['approvedPrincipal'])}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loan Status: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail['status'] == null
                            ? '---'
                            : '${loanDetail['status']['value']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sales Associate: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail == null
                            ? '---'
                            : '${loanDetail['loanOfficerName']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loan Type: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        // loanDetail['loanType'] == null
                        //     ? '---'
                        //     : loanDetail['isTopup'] == false
                        //     ? 'New Loan'
                        //     : 'Top Up',

                        loanDetail['loanType'] == null
                            ? '---'
                            : loanDetail['buyOverLoanDetail'] != null && loanDetail['isTopup'] == false
                            ? 'Buy Over Loan'
                            : loanDetail['buyOverLoanDetail'] != null && loanDetail['isTopup'] == true
                            ? 'Buy Over TopUp Loan'
                            : loanDetail['buyOverLoanDetail'] == null && loanDetail['isTopup'] == true
                            ? 'Top Up Loan'
                            : 'New Loan',
                        // loanDetail['loanType'] == null
                        //     ? '---'
                        //     : loanDetail['loanType'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date Submitted: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail['timeline'] == null
                            ? '---'
                            : retDOBfromBVN(
                            '${loanDetail['timeline']['submittedOnDate'][0]}-${loanDetail['timeline']['submittedOnDate'][1]}-${loanDetail['timeline']['submittedOnDate'][2]}'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loan Tenor: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail['repaymentSchedule'] == null
                            ? '---'
                            : '${loanDetail['repaymentSchedule']['periods'].length - 1}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Net Pay: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail == null || loanDetail['netPay'] == null
                            ? '---'
                            : '₦ ${formatCurrency.format(loanDetail['netPay'])}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Interest Rate: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail['interestRatePerPeriod'] == null
                            ? '---'
                            : '${loanDetail['interestRatePerPeriod']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Repayment Method: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16)),
                      Text(
                        loanDetail['paymentMethod'] == null ||
                            loanDetail['paymentMethod'].isEmpty ||
                            loanDetail['paymentMethod']['valueRef'] ==
                                null ||
                            loanDetail['paymentMethod']['valueRef'].isEmpty
                            ? 'N/A'
                            : '${loanDetail['paymentMethod']['valueRef']} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: loanDetail['paymentMethod'] == null ||
                                loanDetail['paymentMethod'].isEmpty
                                ? Colors.black
                                : loanDetail['paymentMethod']['active'] == true
                                ? Colors.green
                                : Colors.red,
                            fontFamily: 'Nunito SansRegular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // loanDetail['status']['value'] == 'Loan in draft' ||
                  //         loanDetail['status']['value'] == 'Rejected'
                  //     ?
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: RoundedButton(
                        buttonText: 'Edit',
                        onbuttonPressed: () {
                          print('employer ID >> ${employerID}');
                          if (employerID == null) {
                            return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                              backgroundColor: Colors.blueAccent,
                              title: 'Hold ✊',
                              message:
                              'Please hold, validating client employer ',
                              duration: Duration(seconds: 3),
                            ).show(context);
                          } else {
                            MyRouter.pushPage(
                                context,
                                NewLoan(
                                    loanId: loanDetail['id'],
                                    clientID: loanDetail['clientId'],
                                    employerId: employerID,
                                    sectorID: sectorId,
                                    parentClientType: parentClient));
                            setState(() {
                              _timerForInter.cancel();
                            });
                          }
                        }),
                  )
                  // : SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget LoanInActiveStatus() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Text('Repayment Information',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Account No: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail == null
                              ? '---'
                              : '${loanDetail['accountNo']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Expected Maturity: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['timeline'] == null
                              ? '---'
                              : '${loanDetail['timeline']['expectedMaturityDate'][0]} / ${loanDetail['timeline']['expectedMaturityDate'][1]}  / ${loanDetail['timeline']['expectedMaturityDate'][2]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    loanDetail['status']['value'] == 'Active' ||
                        loanDetail['status']['value'] == 'Approved'
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Loan Balance: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          'NGN ${formatCurrency.format(loanDetail['repaymentSchedule']['totalOutstanding'])}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                        // loanDetail['status']['value'] == 'Active' || loanDetail['status']['value'] == 'Approved' ? '---':
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Loan Balance: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          '---',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                        // loanDetail['status']['value'] == 'Active' || loanDetail['status']['value'] == 'Approved' ? '---':
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Loan Tenor: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['repaymentSchedule'] == null
                              ? '---'
                              : '${loanDetail['repaymentSchedule']['periods'].length - 1}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Settlement Balance: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['status']['value'] != 'Active'
                              ? '---'
                              : settlementBalance,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Disbursement Amount: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['summary'] == null ||
                              loanDetail['summary']['principalDisbursed'] ==
                                  null
                              ? '---'
                              : 'NGN ${loanDetail['summary']['principalDisbursed']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Disbursement Date: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['timeline'] == null ||
                              loanDetail['timeline']
                              ['actualDisbursementDate'] ==
                                  null
                              ? '---'
                              : '${loanDetail['timeline']['actualDisbursementDate'][0]} / ${loanDetail['timeline']['actualDisbursementDate'][1]}  / ${loanDetail['timeline']['actualDisbursementDate'][2]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Arrears: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail == null || loanDetail['summary'] == null
                              ? '---'
                              : '${loanDetail['summary']['totalOverdue']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    // SizedBox(height: 15,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('Repayment Expected: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                    //     Text(loanDetail['repaymentMethod'] == null ? '---':  '₦ ${formatCurrency.format(loanDetail['repaymentSchedule']['totalOutstanding'] - loanDetail['repaymentSchedule']['totalFeeChargesCharged'])}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                    //
                    //   ],
                    // ),

                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Fees Charged : ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['repaymentMethod'] == null
                              ? '---'
                              : '₦ ${formatCurrency.format(loanDetail['repaymentSchedule']['totalFeeChargesCharged'])}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Paid : ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 16)),
                        Text(
                          loanDetail['repaymentMethod'] == null
                              ? '---'
                              : '₦ ${formatCurrency.format(loanDetail['repaymentSchedule']['totalRepayment'])}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito SansRegular',
                              fontSize: 16),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget loanNotes() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Text('Notes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          children: [
            notesArray.length == 0
                ? Text(
              'No notes added',
              style: TextStyle(color: Colors.black, fontSize: 16),
            )
                : ListView.builder(
                itemCount: notesArray.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  return ListTile(
                    title: Text(
                      '${notesArray[index]['note']}',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Created By: ${notesArray[index]['createdByUsername']}'),
                        Text(
                            'Creaation Date: ${notesArray[index]['createdDate']}'),
                      ],
                    ),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.edit,color: Colors.blue ,),
                    //      onPressed: (){
                    //      addNote(
                    //        'put',
                    //          notesArray[index]['note'],
                    //          notesArray[index]['id']
                    //      );
                    //      },
                    // ),
                  );
                }),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: RoundedButton(
                  buttonText: 'Add Note',
                  onbuttonPressed: () {
                    // addNote('POST', note.text,);
                    addNote('post', '', 0);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget getEmployerInfoWidget() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Text('Employer Information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropDownComponent(
                  items: empSector,
                  onChange: (String item) {
                    setState(() {
                      List<dynamic> selectID = allEmp
                          .where((element) => element['name'] == item)
                          .toList();
                      //print('this is select ID');
                      //print(selectID[0]['id']);
                      empInt = selectID[0]['id'];
                      // catInt =null;
                      categorySector = ' ';
                      print('end this is select ID ${empInt}');
                      // categorySector = '';
                      // catInt = 0;
                    });
                  },
                  label: "Select Sector",
                  selectedItem: employerSector,
                  validator: (String item) {}),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TypeAheadField(
                  debounceDuration: const Duration(seconds: 1),
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: parentEmployer == ''
                              ? 'Search Employer '
                              : parentEmployer)),

                  // suggestionsBoxController: parentEmployerController,
                  transitionBuilder:
                      (context, suggestionsBox, animationController) =>
                      FadeTransition(
                        child: suggestionsBox,
                        opacity: CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn),
                      ),
                  suggestionsCallback: (pattern) async {
                    return await getSuggestions(pattern);
                    //getEmployersList(realEmployerSector,value);
                  },

                  itemBuilder: (context, suggestion) {
                    //  //print('user suggestion ${suggestion}');
                    return ListTile(
                      leading: Icon(Icons.work_outlined),
                      title: Text(suggestion['name']),
                      // subtitle: Text('${suggestion['mobileNo']}'),
                    );
                  },
                  noItemsFoundBuilder: (context) => Container(
                    height: 100,
                    child: Center(
                      child: Text('No Employer Found'),
                    ),
                  ),
                  onSuggestionSelected: (suggestion) {
                    //print('suggesttion ${suggestion}');
                    this._typeAheadController.text = suggestion['name'];
                    employerInt = suggestion['id'];
                    employerDomain = suggestion['emailExtension'];
                    getEmployersBranch(employerInt);
                    branchEmployerInt = 0;
                    setState(() {
                      employerInt = suggestion['id'];
                      // employerState = '';
                      // //    branchEmployer = '';
                      // employerLga = '';
                      // address.text = '';
                      // employer_phone_number.text = '';
                      // //  _isOTPSent = false;
                      // employerArray = [];
                    });

                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ProductPage(product: suggestion)
                    // ));
                  },
                )

              // TextFieldSearch(
              //   label: 'Parent Employer',
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     //  hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
              //   ),
              //   controller: _typeAheadController,
              //   future: () {
              //     return fetchSimpleData();
              //   },
              //   scrollbarDecoration: ScrollbarDecoration(
              //       controller: ScrollController(),
              //       theme: ScrollbarThemeData(
              //           radius: Radius.circular(30.0),
              //           thickness: MaterialStateProperty.all(20.0),
              //           isAlwaysShown: true,
              //           trackColor: MaterialStateProperty.all(Colors.red))
              //   ),
              //   minStringLength: 5,
              //   getSelectedValue: (item){
              //     //print('item ${item.label} ${item.value}');
              //     this._typeAheadController.text = item.label;
              //     // //print('suggesttion ${suggestion}');
              //     employerInt = item.value;
              //
              //     List<dynamic> selectID =   allEmployer.where((element) => element['id'] == item.value).toList();
              //     employerDomain = selectID.isEmpty || selectID[0]['emailExtension'] == null ? '' : selectID[0]['emailExtension'];
              //      //   //print('selectID ${selectID}' );
              //
              //     //employerDomain = suggestion['emailExtension'];
              //
              //     getEmployersBranch(employerInt);
              //     branchEmployerInt = 0;
              //     setState(() {
              //       employerState = '';
              //     //  branchEmployer = '';
              //       employerLga = '';
              //       address.text = '';
              //       employer_phone_number.text = '';
              //      // _isOTPSent = false;
              //       employerArray = [];
              //     });
              //   },
              // ),

            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropDownComponent(
                  items: BranchEmployerArray,
                  onChange: (String item) {
                    setState(() {
                      List<dynamic> selectID = allBranchEmployer
                          .where((element) => element['name'] == item)
                          .toList();
                      // List<dynamic> selectExtension =   allBranchEmployer.where((element) => element['name'] == item).toList();

                      //print('selectId ${selectID}');
                      branchEmployerInt = selectID[0]['id'];
                      branchEmployer = selectID[0]['name'];
                      employerDomain = selectID[0]['emailExtension'];
                      // //print( '${employerDomain}');
                    });
                  },
                  label: "Organization Branch * ",
                  selectedItem: branchEmployer,
                  validator: (String item) {
                    if (branchEmployerInt == 0) {
                      return 'Employer branch cannot be empty';
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EntryField(context, employeeID, 'Employee ID',
                  'Employee ID', TextInputType.name,
                  maxlines: 1),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EntryField(context, emp_note, 'Enter Note', 'Enter Note',
                  TextInputType.name),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: RoundedButton(
                  buttonText: 'Update Employer',
                  onbuttonPressed: () {
                    addEmployerInfo();
                  }),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget loanDocument() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Text('Documents',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          children: [
            LoopDocumentForLoan(),
            SizedBox(
              height: 10,
            ),


            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //         '${!value ? 'Documents on Nx360' : 'Documents about to be uploaded'} '),
            //     Checkbox(
            //       value: this.value,
            //       onChanged: (bool value) {
            //         setState(() {
            //           this.value = value;
            //         });
            //         //  value == true ? OldDocsPreview() : preveiewDocsPicked();
            //       },
            //     ),
            //   ],
            // ),
            existingDocument() ,
            // : preveiewDocsPicked(),
            SizedBox(
              height: 10,
            ),
            // isLafSigned == true ? SizedBox() :
            Container(
              width: MediaQuery.of(context).size.width * 0.64,
              child: RoundedButton(
                buttonText: 'Re-Attach Online LAF',
                onbuttonPressed: (){
                  resendLaf();
                },
              ),
            ),
            SizedBox(height: 10,)
          ],
        ));
  }

  Widget existingDocument() {
    return ListView.builder(
        itemCount: documentsArray.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return

            ListTile(
              title: Text(
                '${documentsArray[index]['fileName']}',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              leading: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.black),
              ),
              // subtitle: Text('${notesArray[index]['type']}'),
              trailing: IconButton(
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  var documentId =  documentsArray[index]['id'];
                  getSingleDocument(documentId);

                  // var documentLocation = documentsArray[index]['location'];
                  // var documentType = documentsArray[index]['type'];
                  // var documentName = documentsArray[index]['fileName'];

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
                  //   print("${output.path}/${documentName}.pdf");
                  //   await OpenFile.open("${output.path}/${documentName}.pdf");
                  //   setState(() {});
                  // }
                  // else {
                  //   MyRouter.pushPage(
                  //       context,
                  //       DocumentPreview(
                  //         passedDocument: documentsArray[index]['location'],
                  //       ));
                  //   setState(() {
                  //     _timerForInter.cancel();
                  //   });
                  // }


                },
              ),
            );
        });
  }

  Widget ReapymentSchedule(int numbers, String title, String status,
      String duedate, double dueAmount) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.169,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' Due Date: ${retDOBfromBVN(duedate)}',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Nunito SansRegular',
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 65,
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff9c9595).withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff9c9595), spreadRadius: 0.1),
                        ],
                      ),
                      child: Center(
                          child: Text(
                            status,
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  title: Text(
                    'Due Amount: NGN ${dueAmount}',
                    style: TextStyle(fontSize: 13),
                  ),
                  // trailing: Text('Paid date: 12/10/1000',),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget newRepayment(
      int periodNumber,
      String dueDate,
      bool isComplete,
      double principalDue,
      double totalOutstandingForPeriod,
      double totalActualCostOfLoanForPeriod,
      double totalInstallmentAmountForPeriod,
      var totalPaidForPeriod,
      Color statusColor,
      Color textStatus,
      String paidStatus,
      String paymentDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Month #(${periodNumber})',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 20,
                    ),
                    paymentStatus(statusColor, textStatus, paidStatus)
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Due Date: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 14)),
                              Text(
                                dueDate,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Is Complete: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 16)),
                              Text(
                                '${isComplete}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Principal Due: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                          //     Text('₦ ${formatCurrency.format(principalDue)}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                          //
                          //   ],
                          // ),
                          // SizedBox(height: 15,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Interest Paid: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                          //     Text('₦ ${formatCurrency.format(interestPaid)}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                          //
                          //   ],
                          // ),
                          // SizedBox(height: 15,),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Interest Outstanding: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                          //     Text('${formatCurrency.format(interestOutstanding)}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                          //
                          //   ],
                          // ),
                          // SizedBox(height: 15,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Outstanding For Period: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 16)),
                              Text(
                                '₦ ${formatCurrency.format(totalOutstandingForPeriod)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          // SizedBox(height: 15,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Cost Of Loan For Period: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                          //     Text('₦ ${formatCurrency.format(totalActualCostOfLoanForPeriod)}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                          //
                          //   ],
                          // ),
                          //
                          // SizedBox(height: 15,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Total Repayment Expected ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                          //     Text('₦ ${formatCurrency.format(totalActualCostOfLoanForPeriod)}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),
                          //
                          //   ],
                          // ),

                          SizedBox(
                            height: 15,
                          ),

                          // As advised by Thompson on Friday 7 July
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Installment for Period ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 16)),
                              Text(
                                '₦ ${formatCurrency.format(totalInstallmentAmountForPeriod)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Paid for Period ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 16)),
                              Text(
                                '₦ ${formatCurrency.format(totalPaidForPeriod)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment Date: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Nunito SansRegular',
                                      fontSize: 16)),
                              Text(
                                '${paymentDate}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito SansRegular',
                                    fontSize: 16),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
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
        int maxlines,
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
            maxLines: maxlines ?? 4,
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
          Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RoundedButton(
                  buttonText: 'Add Document',
                  onbuttonPressed: () {
                    addDocument();
                  })),
          SizedBox(
            height: 10,
          ),
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
          // Container(
          //   height: 70,
          //   child: DropDownComponent(
          //       items: DocumentTypeArray,
          //       onChange: (String item) {
          //         setState(() {
          //           List<dynamic> selectID = allDocumentType
          //               .where((element) => element['name'] == item)
          //               .where((element) => element['systemDefined'] == true)
          //               .toList();
          //           print('this is select ID');
          //           print(selectID[0]['id']);
          //           documentTypeInt = selectID[0]['id'];
          //
          //           getSubCategoryList(documentTypeInt.toString());
          //           print('end this is select ID');
          //         });
          //       },
          //       label: "Select Document Type * ",
          //       selectedItem: "",
          //       validator: (String item) {}),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   // width: MediaQuery.of(context).size.width * 0.5,
          //   child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          //       child: DropDownComponent(
          //           items: LAFArray,
          //           onChange: (String item) {
          //             setState(() {
          //               List<dynamic> selectID = allLAF
          //                   .where((element) => element['name'] == item)
          //                   .toList();
          //               print('this is select ID');
          //               print(selectID[0]['id']);
          //               documentFileName = selectID[0]['name'];
          //               //   getIdentityList('55');
          //             });
          //           },
          //           label: "Document * ",
          //           selectedItem: '',
          //           validator: (String item) {})),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width * 1.7,
          //   child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          //       child: TextFormField(
          //         controller: proof_of_residence,
          //         autofocus: false,
          //         readOnly: true,
          //         decoration: InputDecoration(
          //           focusedBorder: OutlineInputBorder(
          //             borderSide:
          //                 const BorderSide(color: Colors.grey, width: 0.6),
          //           ),
          //           isDense: true,
          //           border: OutlineInputBorder(),
          //           suffixIcon: IconButton(
          //             onPressed: () {
          //               if (documentFileName == null) {
          //                 errorMessage('Document name cannot be empty');
          //               } else {
          //                 showModalBottomSheet(
          //                   context: context,
          //                   builder: ((builder) => DocumentbottomSheet()),
          //                 );
          //                 // _openDocumentsExplorer();
          //               }
          //             },
          //             icon: Icon(
          //               Icons.attachment_outlined,
          //               color: Color(0xff177EB9),
          //             ),
          //           ),
          //           // contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 15),
          //
          //           labelText: 'Select Document *',
          //           hintStyle: kBodyPlaceholder,
          //         ),
          //         style: kBodyText,
          //         // keyboardType: inputType,
          //         // textInputAction: inputAction,
          //       )),
          // ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget paymentStatus(Color statusColor, Color TextColor, String status) {
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(
          child: Text(
            status,
            style: TextStyle(color: TextColor),
          )),
    );
  }

  retDOBfromBVN(String getDate) {
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

    if (wordList[1] == '1') {
      setState(() {
        realMonth = 'January';
      });
    }
    if (wordList[1] == '2') {
      setState(() {
        realMonth = 'February';
      });
    }
    if (wordList[1] == '3') {
      setState(() {
        realMonth = 'March';
      });
    }
    if (wordList[1] == '4') {
      setState(() {
        realMonth = 'April';
      });
    }
    if (wordList[1] == '5') {
      setState(() {
        realMonth = 'May';
      });
    }
    if (wordList[1] == '6') {
      setState(() {
        realMonth = 'June';
      });
    }
    if (wordList[1] == '7') {
      setState(() {
        realMonth = 'July';
      });
    }
    if (wordList[1] == '8') {
      setState(() {
        realMonth = 'August';
      });
    }
    if (wordList[1] == '9') {
      setState(() {
        realMonth = 'September';
      });
    }
    if (wordList[1] == '10') {
      setState(() {
        realMonth = 'October';
      });
    }
    if (wordList[1] == '11') {
      setState(() {
        realMonth = 'November';
      });
    }
    if (wordList[1] == '12') {
      setState(() {
        realMonth = 'December';
      });
    }

    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o3.length == 1 ? '0' + '' + o3 : o3;

    print('newOO ${newOO}');

    String concatss = newOO + " " + realMonth + " " + o1;

    print("concatss new Date from edit ${concatss}");

    return concatss;
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

  String subStr(String subs) {
    subs.substring(0, 10);
  }

  Widget _buildStatusCard(Status status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status.date,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(status.statusIcon, color: status.statusColor),
                SizedBox(width: 8),
                Text(
                  status.status,
                  style: TextStyle(
                      color: status.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(status.assignee, style: TextStyle(fontSize: 14)),
            // if (status.showReassignButton)
            //   TextButton(
            //     onPressed: () {},
            //     child: Text('Re-Assign', style: TextStyle(color: Colors.blue)),
            //   ),
          ],
        ),
      ),
    );
  }

}

class Status {
  final String date;
  final String status;
  final String assignee;
  final IconData statusIcon;
  final Color statusColor;
  final bool showReassignButton;

  Status({
     this.date,
     this.status,
     this.assignee,
     this.statusIcon,
     this.statusColor,
    this.showReassignButton = false,
  });
}