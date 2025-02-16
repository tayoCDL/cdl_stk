import 'dart:async';
import 'dart:convert';
import 'dart:math';

// import 'package:advanced_search/advanced_search.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/view_models/post_put_method.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/ResidentialDetails.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:sales_toolkit/widgets/LocalTypeAhead.dart';

class EmploymentInfo extends StatefulWidget {
  // const EmploymentInfo({Key key}) : super(key: key);
  //
  // @override
  // _EmploymentInfoState createState() => _EmploymentInfoState();

  final int ClientInt, employerSector;
  final String Employmentaddress,
      EmploymentNeareastLandmark,
      EmploymentStaffId,
      EmploymentJobRole,
      EmploymentWorkEmail,
      EmploymentSalaryRange,
      EmploymentSalaryPayday,
      EmploymentPhoneNumber,
      comingFrom;
  const EmploymentInfo(
      {Key key,
      this.Employmentaddress,
      this.EmploymentNeareastLandmark,
      this.EmploymentStaffId,
      this.EmploymentJobRole,
      this.EmploymentWorkEmail,
      this.EmploymentSalaryRange,
      this.EmploymentSalaryPayday,
      this.EmploymentPhoneNumber,
      this.comingFrom,
      this.ClientInt,
      this.employerSector})
      : super(key: key);
  @override
  _EmploymentInfoState createState() => _EmploymentInfoState(
      Employmentaddress: this.Employmentaddress,
      EmploymentNeareastLandmark: this.EmploymentNeareastLandmark,
      EmploymentStaffId: this.EmploymentStaffId,
      EmploymentJobRole: this.EmploymentJobRole,
      EmploymentWorkEmail: this.EmploymentWorkEmail,
      EmploymentSalaryRange: this.EmploymentSalaryRange,
      EmploymentSalaryPayday: this.EmploymentSalaryPayday,
      EmploymentPhoneNumber: this.EmploymentPhoneNumber,
      ClientInt: this.ClientInt,
      comingFrom: this.comingFrom,
      employerSector: this.employerSector);
}

class _EmploymentInfoState extends State<EmploymentInfo> {
  int ClientInt, employerSector;
  String Employmentaddress,
      EmploymentNeareastLandmark,
      EmploymentStaffId,
      EmploymentJobRole,
      EmploymentWorkEmail,
      EmploymentSalaryRange,
      EmploymentSalaryPayday,
      EmploymentPhoneNumber,
      comingFrom;

  _EmploymentInfoState(
      {this.Employmentaddress,
      this.EmploymentNeareastLandmark,
      this.EmploymentStaffId,
      this.EmploymentJobRole,
      this.EmploymentWorkEmail,
      this.EmploymentSalaryRange,
      this.EmploymentSalaryPayday,
      this.EmploymentPhoneNumber,
      this.comingFrom,
      this.ClientInt,
      this.employerSector});

  @override
  List<String> stateArray = [];
  List<String> collectState = [];
  List<dynamic> allStates = [];

  var employmentProfile = [];
  var clientType = {};

  List<String> lgaArray = [];
  List<String> collectLga = [];
  List<dynamic> allLga = [];

  List _jsonList = [];

  List<String> salaryArray = [];
  List<String> collectSalary = [];
  List<dynamic> allSalary = [];

  List<String> employerArray = [];
  List<String> collectEmployer = [];
  List<int> collectEmployerID = [];

  List<dynamic> allEmployer = [];

  List<String> BranchEmployerArray = [];
  List<String> collectBranchEmployer = [];
  List<dynamic> allBranchEmployer = [];
  String realMonth = '';

  String branchEmployer = '';
  String employerState = '';
  String employerLga = '';
  String errorText = '';
  int empSector = null;
  String parentEmployer = '';
  String isPersonalEmailVerified = '';
  Map<String,dynamic> emailGetter;
  bool _isWorkOTPSent = false;
  bool _isPersonalOTPSent = false;
  int sectorId = 17;
  bool isNewWorkEmailVerified = false;
  int stateInt, salaryInt, lgaInt, employerInt, clientTypeInt;
  int branchEmployerInt = 0;
  String employerDomain = '';
  bool _isWorEmailVerified = false;
  bool showLoading = false;
  Timer _debounce;

  TextEditingController myController2 = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // TODO: implement initState

    //print('employment profile ');

    getStateList();
    getSalaryList();
    getEmploymentProfile();
    getEmailValStatus();
    getClientType();
    getPersonalInformationJustForEmailAddress();
    address.text = Employmentaddress;
    nearest_landmark.text = EmploymentNeareastLandmark;
    staffId.text = EmploymentStaffId;
    job_role.text = EmploymentJobRole;
    work_email.text = EmploymentWorkEmail;
    salary_payday = EmploymentSalaryPayday;
    salary_range = EmploymentSalaryRange;
    employer_phone_number.text = EmploymentPhoneNumber;

    myController2.addListener(_printLatestValue);

    super.initState();
  }

  _printLatestValue() {
    //print("text field2: ${myController2.text}");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _typeAheadController.dispose();
    // myController2.dispose();
    super.dispose();
  }

  // personal email impl

  getEmailValStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int tempClientID =
    prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId');

    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().getEmailValidationStatus(tempClientID,);

    setState(() {
      _isLoading = false;
    });
    respose.then((response) {
      print('otp statusqq >> ${response['data']}');
      print(response);
      if (response['status'] == true) {
        setState(() {
          if(response['data'] == null){
            isPersonalEmailVerified =  'false' ;
            emailGetter = null;
          }
           else {
            isPersonalEmailVerified =  response['data']['is_email_validated'] ;
            emailGetter = response['data'];
          }

        });

      } else {

      }
    });
  }

  postEmailValStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int tempClientID =
    prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId');

    // setState(() {
    //   _isLoading = true;
    // });
    Map<String,dynamic> emailValRequest = {
      "is_email_validated": "true",
      "locale": "en",
      "dateFormat": "dd MMMM yyyy"
    };


    final Future<Map<String, dynamic>> respose =
    emailGetter == null ?
    RetCodes().postEmailValidationStatus(tempClientID,emailValRequest):
    RetCodes().putEmailValidationStatus(tempClientID,emailValRequest);

    setState(() {
      _isLoading = false;
    });
    respose.then((response) {
      print('otp status!! >>');
      print(response);
      if (response['status'] == true) {
        getEmailValStatus();

      } else {
        // setState(() {
        //   _isOTPSent = false;
        // });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to verify OTP ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  // end personal email impl


  //  Future<List> getSuggestions(String query) async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String query = _typeAheadController.text;
  //   final Future<Map<String,dynamic>> respose =   RetCodes().employers(clientTypeInt,query);
  //
  //   respose.then((response) async {
  //     List<dynamic> newEmp = response['data']['pageItems'];
  //
  //     setState(() {
  //       allEmployer = newEmp;
  //       collectEmployer = [];
  //       collectBranchEmployer = [];
  //       allBranchEmployer = [];
  //     });
  //
  //     for(int i = 0; i < newEmp.length;i++){
  //       //print(newEmp[i]['name']);
  //       collectEmployer.add(newEmp[i]['name']);
  //     }
  //     //print('vis alali');
  //     //print(collectEmployer);
  //
  //     // setState(() {
  //     //   employerArray = collectEmployer;
  //     //   List<dynamic> selectID =   allEmployer.where((element) => element['name'] == branchEmployer).toList();
  //     // //  //print('select value ${selectID}');
  //     //   //  branchEmployerInt = selectID[0]['id'];
  //     // });
  //
  //
  //   });
  //   //print('employer Array ${allEmployer}');
  //   return collectEmployer;
  //
  //   await Future.delayed(Duration(seconds: 1));
  //   return List.generate(3, (index) {
  //     return {'name': query + index.toString(), 'price': Random().nextInt(100)};
  //   });
  //
  // }

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

  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    List _list = <dynamic>[];

    String query = _typeAheadController.text;
    final Future<Map<String, dynamic>> respose =
        RetCodes().employers(clientTypeInt, query);

    respose.then((response) async {
      List<dynamic> newEmp = response['data']['pageItems'];
      //print('new emps ${newEmp}');
      setState(() {
        allEmployer = newEmp;
        collectEmployer = [];
        // collectBranchEmployer = [];
        // allBranchEmployer = [];
        branchEmployer = ' ';
        // collectBranchEmployer = [];
        // allBranchEmployer = [];
      });

      for (int i = 0; i < newEmp.length; i++) {
        //print(newEmp[i]['name']);
        collectEmployer.add(newEmp[i]['name']);
        collectEmployerID.add(newEmp[i]['id']);

        // setState(() {
        //   _jsonList = [
        //     {'label':  collectEmployer[i], 'value': 30},
        //   ];
        // });

        // _list.add(newEmp[i]['name']);
      }
    });

    //print('collectEmployer ${collectEmployer}');

    //print('json List Grow ${_jsonList}');

    //  _jsonList = [
    //
    //
    //
    //
    //   {'label': collectEmployer[0] + ' Item 1', 'value': 30},
    //   {'label': 'Text' + ' Item 2', 'value': 31},
    //   {'label': 'Text' + ' Item 3', 'value': 32},
    // ];

    for (int i = 0; i < collectEmployer.length; i++) {
      _list.add(new TestItem.fromJson(
          {'label': collectEmployer[i], 'value': collectEmployerID[i]}));
    }

    // _list.add(new TestItem.fromJson(_jsonList[1]));
    // _list.add(new TestItem.fromJson(_jsonList[2]));

    return _list;

    return collectEmployer;
  }

  getStateList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('27');

    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allStates = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectState.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectState);
    //
    //   setState(() {
    //     stateArray = collectState;
    //   });
    // }
    // );

    setState(() {
      _isLoading = true;
    });
    respose.then((response) async {
      //print(response['data']);
      setState(() {
        _isLoading = false;
      });
      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsState'));

        //
        if (prefs.getString('prefsState').isEmpty) {
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
            allStates = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectState.add(mtBool[i]['name']);
          }

          setState(() {
            stateArray = collectState;
            lgaArray = [];
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

        prefs.setString('prefsState', jsonEncode(newEmp));

        setState(() {
          allStates = newEmp;
          _isLoading = false;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectState.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectState);

        setState(() {
          stateArray = collectState;
          employerLga = '';
          List<dynamic> selectID = allStates
              .where((element) => element['name'] == employerState)
              .toList();
          //   employerInt = selectID[0]['id'];
        });
      }
    });
  }

  getSalaryList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('43');
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

    respose.then((response) async {
      //print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsSalary'));

        if (prefs.getString('prefsMarital').isEmpty) {
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
            allSalary = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectSalary.add(mtBool[i]['name']);
          }

          setState(() {
            salaryArray = collectSalary;
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

        prefs.setString('prefsSalary', jsonEncode(newEmp));

        setState(() {
          allSalary = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectSalary.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectSalary);

        setState(() {
          salaryArray = collectSalary;
        });
      }
    });
  }

  getEmployersList(int SearchemployerSector, String searchemployerName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //  int _sector = prefs.getInt('employment_type');
    // // int realEmployerSector = employerSector == null  ? empSector: empSector == null ? _sector : _sector == null ? 0 : employerSector;
    //
    //  int realEmployerSector = employerSector == null ? _sector : employerSector;
    //
    // // _sector == null ? empSector : empSector == null ? employerSector : _sector;
    //  //print('sectorId ${realEmployerSector}');
    // setState(() {
    //   _isLoading = true;
    // });
    final Future<Map<String, dynamic>> respose =
        RetCodes().employers(clientTypeInt, searchemployerName);
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
    // setState(() {
    //   _isLoading = true;
    // });

    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
      //print('response data ${response['data']}');

      if (response['status'] == false) {
        // final SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
          _isLoading = false;
        });
        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmployer'));

        if (prefs.getString('prefsEmployer').isEmpty) {
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
            _isLoading = false;
            allSalary = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectEmployer.add(mtBool[i]['name']);
          }

          setState(() {
            employerArray = [];
            employerArray = collectEmployer;
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
        List<dynamic> newEmp = response['data']['pageItems'];

        //print('this is newEmps ${newEmp.toString()}');

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmployer', jsonEncode(newEmp));

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

        setState(() {
          employerArray = collectEmployer;
          List<dynamic> selectID = allEmployer
              .where((element) => element['name'] == branchEmployer)
              .toList();
          //print('select value ${selectID}');
          //  branchEmployerInt = selectID[0]['id'];
        });
      }
    });
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

  getEmploymentProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID = ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString() + '/employers',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print('responsevv.body ${responsevv.body}');

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;

    setState(() {
      employmentProfile = newClientData;
      print('responseData2 ${employmentProfile}');

      prefs.setInt('tempEmployerInt', employmentProfile.isEmpty ? null : employmentProfile[0]['id']);

      branchEmployerInt = employmentProfile.isNotEmpty &&
          employmentProfile[0]['employer'] != null &&
          employmentProfile[0]['employer']['id'] != null
          ? employmentProfile[0]['employer']['id']
          : 0;

      branchEmployer = employmentProfile.isNotEmpty &&
          employmentProfile[0]['employer'] != null &&
          employmentProfile[0]['employer']['name'] != null
          ? employmentProfile[0]['employer']['name']
          : '';

      salaryInt = employmentProfile.isNotEmpty && employmentProfile[0]['salaryRange'] != null
          ? employmentProfile[0]['salaryRange']['id']
          : '';

      employerState = employmentProfile.isNotEmpty && employmentProfile[0]['state'] != null &&
          employmentProfile[0]['state']['name'] != null
          ? employmentProfile[0]['state']['name']
          : '';

      employerLga = employmentProfile.isNotEmpty && employmentProfile[0]['lga'] != null &&
          employmentProfile[0]['lga']['name'] != null
          ? employmentProfile[0]['lga']['name']
          : '';

      employerDomain = employmentProfile.isNotEmpty &&
          employmentProfile[0]['employer'] != null
          ? employmentProfile[0]['employer']['emailExtension']
          : '';

      salary_range = employmentProfile.isNotEmpty && employmentProfile[0]['salaryRange'] != null
          ? employmentProfile[0]['salaryRange']['name']
          : '';

      parentEmployer = employmentProfile.isNotEmpty &&
          employmentProfile[0]['employer'] != null &&
          employmentProfile[0]['employer']['parent'] != null
          ? employmentProfile[0]['employer']['parent']['name']
          : '';

      lgaInt = employmentProfile.isNotEmpty && employmentProfile[0]['lga'] != null
          ? employmentProfile[0]['lga']['id']
          : '';

      stateInt = employmentProfile.isNotEmpty && employmentProfile[0]['state'] != null
          ? employmentProfile[0]['state']['id']
          : '';

      employerInt = employmentProfile.isNotEmpty &&
          employmentProfile[0]['employer'] != null &&
          employmentProfile[0]['employer']['parent'] != null &&
          employmentProfile[0]['employer']['parent']['id'] != null
          ? employmentProfile[0]['employer']['parent']['id']
          : 0;

      _isWorEmailVerified = employmentProfile.isNotEmpty && employmentProfile[0]['workEmailVerified'] != null
          ? employmentProfile[0]['workEmailVerified']
          : false;
    });

    var subEmployer = employmentProfile.isNotEmpty ? employmentProfile[0] : null;

    address.text = subEmployer != null ? subEmployer['officeAddress'] ?? '' : '';
    nearest_landmark.text = subEmployer != null ? subEmployer['nearestLandMark'] ?? '' : '';
    staffId.text = subEmployer != null ? subEmployer['staffId'] ?? '' : '';
    work_email.text = subEmployer != null ? subEmployer['emailAddress'] ?? '' : '';
    employer_phone_number.text = subEmployer != null ? subEmployer['mobileNo'] ?? '' : '';
    job_role.text = subEmployer != null ? subEmployer['jobGrade'] ?? '' : '';

    _typeAheadController.text = subEmployer != null &&
        subEmployer['employer'] != null &&
        subEmployer['employer']['parent'] != null &&
        subEmployer['employer']['parent']['name'] != null
        ? subEmployer['employer']['parent']['name']
        : '';

    dateOfEmployment.text = subEmployer != null
        ? retDOBfromBVN(
        '${subEmployer['employmentDate'][0]}-${subEmployer['employmentDate'][1]}-${subEmployer['employmentDate'][2]}')
        : '';

    salaryPayDayController.text = subEmployer != null
        ? retDOBfromBVN(
        '${subEmployer['nextMonthSalaryPaymentDate'][0]}-${subEmployer['nextMonthSalaryPaymentDate'][1]}-${subEmployer['nextMonthSalaryPaymentDate'][2]}')
        : '';

    var newEmpInt = prefs.getInt('tempEmployerInt');
    payrollDob.text = subEmployer != null
        ? retDOBfromBVN(
        '${subEmployer['payrollDob'][0]}-${subEmployer['payrollDob'][1]}-${subEmployer['payrollDob'][2]}')
        : '';

    salary_payday = '';
  }




  // getEmploymentProfile() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int localclientID =
  //       ClientInt == null ? prefs.getInt('clientId') : ClientInt;
  //   //print('localClient ${localclientID}');
  //
  //   var token = prefs.getString('base64EncodedAuthenticationKey');
  //   var tfaToken = prefs.getString('tfa-token');
  //   //print(tfaToken);
  //   //print(token);
  //   Response responsevv = await get(
  //     AppUrl.getSingleClient + localclientID.toString() + '/employers',
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
  //       'Authorization': 'Basic ${token}',
  //       'Fineract-Platform-TFA-Token': '${tfaToken}',
  //     },
  //   );
  //   print('responsevv.body ${responsevv.body}');
  //
  //   final List<dynamic> responseData2 = json.decode(responsevv.body);
  //
  //   var newClientData = responseData2;
  //
  //   setState(() {
  //     employmentProfile = newClientData;
  //     print('responseData2 ${employmentProfile}');
  //     prefs.setInt('tempEmployerInt',
  //         employmentProfile.isEmpty ? null : employmentProfile[0]['id']);
  //
  //     branchEmployerInt = employmentProfile.isEmpty
  //         ? ''
  //         :
  //     employmentProfile[0]['employer'] == null  ||
  //       employmentProfile[0]['employer']['id'] == null
  //      ?
  //      0
  //         : employmentProfile[0]['employer']['id'];
  //
  //     //    empSector = employmentProfile.isEmpty ? '' : employmentProfile[0]['employer']['sector']['id'];
  //     branchEmployer = employmentProfile.isEmpty
  //         ? ''
  //     :
  //     employmentProfile[0]['employer'] == null ||
  //         employmentProfile[0]['employer']['name']  == null
  //         ?
  //     ''
  //         : employmentProfile[0]['employer']['name'];
  //
  //     salaryInt = employmentProfile.isEmpty
  //         ||
  //         employmentProfile[0]['salaryRange'] == null
  //         ? ''
  //         : employmentProfile[0]['salaryRange']['id'];
  //
  //     employerState = employmentProfile.isEmpty
  //         ? ''
  //         :
  //         employmentProfile[0]['state'] == null ||
  //                 employmentProfile[0]['state']['name'] == null
  //             ?
  //         ''
  //         : employmentProfile[0]['state']['name'];
  //     employerLga =
  //         employmentProfile.isEmpty ? ''
  //             :
  //             employmentProfile[0]['lga'] == null ||
  //                     employmentProfile[0]['lga']['name'] == null
  //                 ? ''
  //             : employmentProfile[0]['lga']['name'];
  //
  //
  //     employerDomain = employmentProfile.isEmpty
  //         ? ''
  //     :
  //
  //     employmentProfile[0]['employer']['emailExtension'];
  //
  //     salary_range = employmentProfile.isEmpty
  //         ? ''
  //         : employmentProfile[0]['salaryRange']['name'];
  //     // parentEmployer = employmentProfile.isEmpty
  //     //     ? ''
  //     //     : employmentProfile[0]['employer']['parent']['name'];
  //     parentEmployer = employmentProfile.isEmpty ||
  //         employmentProfile[0]['employer'] == null ||
  //         employmentProfile[0]['employer']['parent'] == null
  //         ? ''
  //         : employmentProfile[0]['employer']['parent']['name'];
  //     lgaInt =
  //         employmentProfile.isEmpty ? ''
  //
  //             : employmentProfile[0]['lga']['id'];
  //     stateInt =
  //         employmentProfile.isEmpty ? '' : employmentProfile[0]['state']['id'];
  //
  //     // employerInt = employmentProfile.isEmpty
  //     //     ? ''
  //     //     : employmentProfile[0]['employer']['parent']['id'];
  //     employerInt = employmentProfile.isEmpty ||
  //         employmentProfile[0]['employer'] == null ||
  //         employmentProfile[0]['employer']['parent'] == null ||
  //         employmentProfile[0]['employer']['parent']['id'] == null
  //         ? 0
  //         : employmentProfile[0]['employer']['parent']['id'];
  //
  //     _isWorEmailVerified = employmentProfile.isEmpty
  //         ? false
  //         : employmentProfile[0]['workEmailVerified'];
  //     // salaryPayDayController.text =
  //   });
  //   //print('employer Info first array ${employmentProfile}');
  //   var subEmployer = employmentProfile[0];
  //
  //   address.text =
  //       employmentProfile.isEmpty ? '' : employmentProfile[0]['officeAddress'];
  //   nearest_landmark.text = employmentProfile.isEmpty
  //       ? ''
  //       : employmentProfile[0]['nearestLandMark'];
  //   staffId.text =
  //       employmentProfile.isEmpty ? '' : employmentProfile[0]['staffId'];
  //   work_email.text =
  //       employmentProfile.isEmpty ? '' : employmentProfile[0]['emailAddress'];
  //   employer_phone_number.text =
  //       employmentProfile.isEmpty ? '' : employmentProfile[0]['mobileNo'];
  //   job_role.text =
  //       employmentProfile.isEmpty ? '' : employmentProfile[0]['jobGrade'];
  //   // _typeAheadController.text = employmentProfile.isEmpty
  //   //     ? ''
  //   //     : employmentProfile[0]['employer']['parent']['name'];
  //
  //   _typeAheadController.text = employmentProfile.isEmpty ||
  //       employmentProfile[0]['employer'] == null ||
  //       employmentProfile[0]['employer']['parent'] == null ||
  //       employmentProfile[0]['employer']['parent']['name'] == null
  //       ? ''
  //       : employmentProfile[0]['employer']['parent']['name'];
  //
  //
  //   dateOfEmployment.text = retDOBfromBVN(
  //       '${subEmployer['employmentDate'][0]}-${subEmployer['employmentDate'][1]}-${subEmployer['employmentDate'][2]}');
  //   salaryPayDayController.text = retDOBfromBVN(
  //       '${subEmployer['nextMonthSalaryPaymentDate'][0]}-${subEmployer['nextMonthSalaryPaymentDate'][1]}-${subEmployer['nextMonthSalaryPaymentDate'][2]}');
  //
  //   var newEmpInt = prefs.getInt('tempEmployerInt');
  //   payrollDob.text = retDOBfromBVN(
  //       '${subEmployer['payrollDob'][0]}-${subEmployer['payrollDob'][1]}-${subEmployer['payrollDob'][2]}');
  //
  //   //print('newempInt ${newEmpInt}');
  //   salary_payday = '';
  //   //salary_range = employmentProfile[0]['salaryRange']['id'];
  // }




  // getEmploymentProfile() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     int localclientID = ClientInt ?? prefs.getInt('clientId');
  //
  //     var token = prefs.getString('base64EncodedAuthenticationKey');
  //     var tfaToken = prefs.getString('tfa-token');
  //
  //     Response responsevv = await get(
  //       AppUrl.getSingleClient + '$localclientID/employers',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
  //         'Authorization': 'Basic $token',
  //         'Fineract-Platform-TFA-Token': '$tfaToken',
  //       },
  //     );
  //
  //     if (responsevv.statusCode != 200) {
  //       print('Error: ${responsevv.statusCode}');
  //       return;
  //     }
  //
  //     final List<dynamic> responseData2 = json.decode(responsevv.body);
  //     if (responseData2.isEmpty) {
  //       print('Empty response');
  //       return;
  //     }
  //
  //     var newClientData = responseData2;
  //     setState(() {
  //       employmentProfile = newClientData;
  //       prefs.setInt('tempEmployerInt', employmentProfile.isEmpty ? null : employmentProfile[0]['id']);
  //
  //       // Use the helper method to extract nested values with default values
  //       branchEmployerInt = _getNestedValue<int>(employmentProfile, 0, 'employer', subKey: 'id', defaultValue: 0);
  //       branchEmployer = _getNestedValue<String>(employmentProfile, 0, 'employer', subKey: 'name', defaultValue: '');
  //       salaryInt = _getNestedValue<int>(employmentProfile, 0, 'salaryRange',subKey: 'id', defaultValue: 0);
  //       employerState = _getNestedValue<String>(employmentProfile, 0, 'state',subKey: 'name', defaultValue: '');
  //       employerLga = _getNestedValue<String>(employmentProfile, 0, 'lga',subKey: 'name', defaultValue: '');
  //       employerDomain = _getNestedValue<String>(employmentProfile, 0, 'employer',subKey: 'emailExtension', defaultValue: '');
  //       salary_range = _getNestedValue<String>(employmentProfile, 0, 'salaryRange',subKey: 'name', defaultValue: '');
  //     //  parentEmployer = _getNestedValue<String>(employmentProfile, 0, 'employer', 'parent', subKey: 'name', defaultValue: '');
  //       parentEmployer = _getNestedListValue<String>(employmentProfile, 0, 'employer', subKey: 'names').first ?? '';
  //       lgaInt = _getNestedValue<int>(employmentProfile, 0, 'lga', subKey:'id', defaultValue: 0);
  //       stateInt = _getNestedValue<int>(employmentProfile, 0, 'state',subKey: 'id', defaultValue: 0);
  //     //  employerInt = _getNestedListValue<int>(employmentProfile, 0, 'employer', 'parent',subKey: 'id', defaultValue: 0).first ?? 0;
  //       employerInt = _getNestedListValue<int>(employmentProfile, 0, 'parent', subKey: 'id').first ?? '';
  //
  //       _isWorEmailVerified = _getNestedValue<bool>(employmentProfile, 0, 'workEmailVerified', defaultValue: false);
  //     });
  //
  //     var subEmployer = employmentProfile.isEmpty ? null : employmentProfile[0];
  //
  //     // Text field assignments with safe null checks
  //     _updateTextField(address, subEmployer, 'officeAddress');
  //     _updateTextField(nearest_landmark, subEmployer, 'nearestLandMark');
  //     _updateTextField(staffId, subEmployer, 'staffId');
  //     _updateTextField(work_email, subEmployer, 'emailAddress');
  //     _updateTextField(employer_phone_number, subEmployer, 'mobileNo');
  //     _updateTextField(job_role, subEmployer, 'jobGrade');
  //
  //     _typeAheadController.text = subEmployer == null || subEmployer['employer'] == null ||
  //         subEmployer['employer']['parent'] == null || subEmployer['employer']['parent']['name'] == null
  //         ? '' : subEmployer['employer']['parent']['name'] ?? '';
  //
  //     // Date formatting helper
  //     dateOfEmployment.text = _formatDateFromSubEmployer(subEmployer, 'employmentDate');
  //     salaryPayDayController.text = _formatDateFromSubEmployer(subEmployer, 'nextMonthSalaryPaymentDate');
  //     payrollDob.text = _formatDateFromSubEmployer(subEmployer, 'payrollDob');
  //   } catch (e) {
  //     print('Error fetching employment profile: $e');
  //   }
  // }

// Helper function for text field updates
  void _updateTextField(TextEditingController controller, var subEmployer, String key) {
    controller.text = subEmployer == null ? '' : subEmployer[key] ?? '';
  }




  T _getNestedValue<T>(List<dynamic> data, int index, String key, {String subKey, T defaultValue}) {
    try {
      // If the data is empty or the expected value doesn't exist, return the default value
      if (data.isEmpty || data[index] == null) return defaultValue;

      if (subKey != null && data[index][key] != null) {
        return data[index][key][subKey] ?? defaultValue;
      }

      return data[index][key] ?? defaultValue;
    } catch (e) {
      // Return the default value in case of any error
      return defaultValue;
    }
  }

  List<T> _getNestedListValue<T>(List<dynamic> data, int index, String key, {String subKey, List<T> defaultValue}) {
    try {
      // If the data is empty or the expected value doesn't exist, return the default value
      if (data.isEmpty || data[index] == null) return defaultValue ?? [];

      if (subKey != null && data[index][key] != null) {
        // Try to extract a list from the subkey
        return List<T>.from(data[index][key][subKey] ?? defaultValue ?? []);
      }

      // Return the list if it's directly under the key
      return List<T>.from(data[index][key] ?? defaultValue ?? []);
    } catch (e) {
      // Return the default value in case of any error
      return defaultValue ?? [];
    }
  }



// Helper method to safely format dates from the subEmployer data
  String _formatDateFromSubEmployer(var subEmployer, String dateKey) {
  if (subEmployer == null || subEmployer[dateKey] == null || subEmployer[dateKey].length < 3) {
  return '';
  }
  return retDOBfromBVN('${subEmployer[dateKey][0]}-${subEmployer[dateKey][1]}-${subEmployer[dateKey][2]}');
  }




  getClientType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =
        ClientInt == null ? prefs.getInt('clientId') : ClientInt;
    //print('localClient ${localclientID}');

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
      clientTypeInt = clientType.isEmpty ? '' : clientType['clientType']['id'];
      sectorId = clientType.isEmpty ? '' : clientType['employmentSector']['id'];
      //print('sector ID ${sectorId}');
    });

    //print('client Type ${clientTypeInt} ${clientType}');
  }

  getSubAccount(int FirstValue, int SecondValue) {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
        RetCodes().getSubValues(FirstValue, SecondValue);

    setState(() {
      _isLoading = false;
    });

    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //     //print(newEmp);
    //   setState(() {
    //     allLga = newEmp;
    //   });
    //   setState(() {
    //     collectLga = [];
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectLga.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectLga);
    //
    //
    //   setState(() {
    //     lgaArray = collectLga;
    //   });
    // }
    // );

    respose.then((response) async {
      //print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLga'));

        if (prefs.getString('prefsMarital').isEmpty) {
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
            collectLga = [];
          });
          setState(() {
            allLga = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectLga.add(mtBool[i]['name']);
          }

          setState(() {
            lgaArray = collectLga;
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

        prefs.setString('prefsLga', jsonEncode(newEmp));

        setState(() {
          collectLga = [];
        });
        setState(() {
          allLga = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectLga.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectLga);

        setState(() {
          lgaArray = collectLga;
        });
      }
    });
  }

  getPersonalInformationJustForEmailAddress() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;
    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    ///clients/{clientId}/familymembers
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      emailaddress.text = newClientData['emailAddress'];
    });


  }


  @override
  TextEditingController address = TextEditingController();
  TextEditingController nearest_landmark = TextEditingController();
  TextEditingController employer_phone_number = TextEditingController();
  TextEditingController staffId = TextEditingController();
  // TextEditingController EmailAddress = TextEditingController();
  TextEditingController job_role = TextEditingController();
  TextEditingController work_email = TextEditingController();
  TextEditingController dateOfEmployment = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController workotpController = TextEditingController();
  TextEditingController salaryPayDayController = TextEditingController();
  TextEditingController parentEmployerController = TextEditingController();
  TextEditingController payrollDob = TextEditingController();
  TextEditingController emailaddress = TextEditingController();

  TextEditingController _typeAheadController = TextEditingController();

  List<Map<String, dynamic>> mergedOfflineClient = [];

  String organization = "";
  String state_ofposting = '';
  String lga = '';
  String salary_range = '';
  String salary_payday = '';

  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();
  DateTime CupertinoSelectedDate = DateTime.now();
  DateTime PayDayCupertinoSelectedDate = DateTime.now();
  final _form = GlobalKey<FormState>(); //for storing form state.

  AddClientProvider addClientProvider = AddClientProvider();

  sendOTPForEmployer({bool isPersonalEmail}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        otpController.text = '';
      });

    int tempClientID =
        prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId');
    //print('this is tempLoan ID ${tempClientID}');

    // if(work_email.text.isEmpty || work_email.text.length < 6){
    //       Flushbar(
    //              flushbarPosition: FlushbarPosition.TOP,
    //              flushbarStyle: FlushbarStyle.GROUNDED,
    //     backgroundColor: Colors.red,
    //     title: 'Error',
    //     message: 'work email too short',
    //     duration: Duration(seconds: 3),
    //   ).show(context);
    // }
 String passthisemail =   isPersonalEmail == true ? emailaddress.text : work_email.text;
    if (passthisemail.isEmpty || passthisemail.length < 5) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: '${isPersonalEmail == true ? 'Personal' : 'Work'}  email too short',
        duration: Duration(seconds: 3),
      ).show(context);
    }

    if (!AppHelper().isValidAppEmail(passthisemail)) {

      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'Invalid email address',
        duration: Duration(seconds: 3),
      ).show(context);

    }

    if(isPersonalEmail == false)
      {
        if (passthisemail.contains('@gmail') ||
            passthisemail.contains('@yahoo') ||
            passthisemail.contains('@ymail') ||
            passthisemail.contains('@outlook') ||
            passthisemail.contains('@qa.team')) {
          return Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: 'Kindly enter a valid work email',
            duration: Duration(seconds: 3),
          ).show(context);
        }

      }

    //print('work email');
    //print(work_email.text.split('@').first);
    // String real_workEmail = work_email.text.split('@').first;
    String real_workEmail = passthisemail;

    // final Future<Map<String,dynamic>> respose =   RetCodes().requestemployerValidation(tempClientID, real_workEmail + employerDomain);
    final Future<Map<String, dynamic>> respose =
        RetCodes().requestemployerValidation(tempClientID, real_workEmail);

    setState(() {
      if(isPersonalEmail == true) {
        _isPersonalOTPSent = true;
        _isWorkOTPSent = false;
      }
      else {
        _isWorkOTPSent = true;
        _isPersonalOTPSent = false;
      }

     // isPersonalEmail ? _isPersonalOTPSent = true : _isWorkOTPSent = true;

    });
    respose.then((response) {
      //print(response);
      if (response['status'] == true) {
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
         // _isWorkOTPSent = false;
          isPersonalEmail ? _isPersonalOTPSent = false : _isWorkOTPSent = false;

        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to send OTP',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  verifyOTPForEmployer({bool isPersonalEmail}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // validateOTP() async {
    if (otpController.text.isEmpty || otpController.text.length < 6) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'OTP too short',
        duration: Duration(seconds: 3),
      ).show(context);
    }
    // setState(() {
    //   _isLoading = true;
    // });
    int tempClientID =
        prefs.getInt('clientId') == null ? ClientInt : prefs.getInt('clientId');
    // //print('this is tempLoan ID ${tempClientID}');
    final Future<Map<String, dynamic>> respose =
        RetCodes().employerValidation(tempClientID, otpController.text);
    // setState(() {
    //   _isOTPSent = true;
    // });
    respose.then((response) {
      // setState(() {
      //   _isLoading = true;
      // });
      //print(response['data']);
      if (response['status'] == true) {
        otpController.text = '';


          if(isPersonalEmail == false){
            setState(() {
              _isWorEmailVerified = true;
              _isWorkOTPSent = false;
              isNewWorkEmailVerified = true;
            });
          }
          print('>> pers ${isPersonalEmail} >> personal email ${isPersonalEmailVerified} >> ${isPersonalEmail == true && isPersonalEmailVerified == 'false'}');
        if( isPersonalEmail == true && (isPersonalEmailVerified == 'false' || isPersonalEmailVerified == '') ){

     //    if(isPersonalEmail == true){
          debugPrint('fired in');
          postEmailValStatus();
          _isPersonalOTPSent = false;
        }

        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: 'Success',
          message: 'OTP Verified',
          duration: Duration(seconds: 3),
        ).show(context);
        MyRouter.popPage(context);
      } else {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to validate OTP',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
    // }

    // return alert(
    //   context,
    //   title: Text('Enter OTP'),
    //   content: EntryField(context, otpController, 'Validate OTP', 'Enter OTP', TextInputType.text),
    //   textOK: Container(
    //     width: MediaQuery.of(context).size.width * 0.3,
    //     child: RoundedButton(buttonText: 'Validate',onbuttonPressed: (){
    //       validateOTP();
    //     },),
    //   ),
    // );
  }

  Widget build(BuildContext context) {
    var submitEmploymentInfo = () async {
      //return   MyRouter.pushPage(context, ResidentialDetails());
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      if (dateOfEmployment.text == null ||
          dateOfEmployment.text.isEmpty ||
          salaryPayDayController.text == null ||
          salaryPayDayController.text.isEmpty) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Validation Error',
          message: 'Payday/Employment date cannot be empty',
          duration: Duration(seconds: 3),
        ).show(context);
      }

    //  String fetchWorkMail =  employmentProfile.isEmpty || employmentProfile[0]['emailAddress'] == null ? '' : employmentProfile[0]['emailAddress'];

      String fetchWorkMail = (employmentProfile.isNotEmpty && employmentProfile[0]['emailAddress'] is String)
          ? employmentProfile[0]['emailAddress']
          : '';
      print('fetch work mail >> ${fetchWorkMail}');
      print('fetch mail > > ${isNewWorkEmailVerified == false && (work_email.text != fetchWorkMail)}> ${fetchWorkMail != work_email.text}  ${isNewWorkEmailVerified}');
        // true && true

      if(isNewWorkEmailVerified == false && ( fetchWorkMail != work_email.text)){

        // if is work email is verified and

        return  Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Verify Work Email',
          message: 'Verify your updated email to proceed.',
          duration: Duration(seconds: 3),
        ).show(context);

      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //  prefs.setInt('tempEmployerInt',employmentProfile.isEmpty ? null : employmentProfile[0]['id']);
      int getEmpInt = prefs.getInt('tempEmployerInt');
      setState(() {
        _isLoading = true;
      });

      ////print(' salary payday ${salary_payday.isEmpty}');
      int localclientID =
          ClientInt == null ? prefs.getInt('clientId') : ClientInt;

      PostAndPut postAndPut = new PostAndPut();

      postAndPut.isClientActive(localclientID).then((value) {
        String client_status = value.toString();
        Map<String, dynamic> employmentData = {
          'clientId': ClientInt == null ? prefs.getInt('clientId') : ClientInt,
          'id': getEmpInt == null ? null : getEmpInt,
          'address': address.text,
          'nearest_landmark': nearest_landmark.text,
          'employer_phone_number': employer_phone_number.text,
          "lga": lgaInt,
          'staffId': staffId.text,
          'job_role': job_role.text,
          'work_email': work_email.text,
          'organization': branchEmployerInt,
          'state_ofposting': stateInt,
          'salary_payday': salaryPayDayController.text,
          'salary_range': salaryInt,
          'payrollDob': payrollDob.text,
          'employmentDate': dateOfEmployment.text,
          'workEmailVerified': _isWorEmailVerified
        };

        final Future<Map<String, dynamic>> respose =
            addClientProvider.addEmployment(employmentData, client_status);

        respose.then((response) {
          if (response == null || response['status'] == false) {
            AppTracker().trackActivity('ADD/UPDATE EMPLOYER',
                payLoad: {...employmentData, "response": response.toString()});

            setState(() {
              _isLoading = false;
            });

            if (response['message'] == 'Network_error') {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.orangeAccent,
                title: 'Network Error',
                message: 'Proceed, data has been saved to draft',
                duration: Duration(seconds: 3),
              ).show(context);

              return MyRouter.pushPage(context, ResidentialDetails());
            }

            return Flushbar(
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

            getEmploymentProfile();
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

            MyRouter.pushPage(context, ResidentialDetails());

            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "Success",
              message: 'Client profile updated successfully',
              duration: Duration(seconds: 3),
            ).show(context);
          }

          setState(() {
            _isLoading = false;
          });
        });
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
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProgressStepper(
                  stepper: 0.34,
                  title: 'Employment Details',
                  subtitle: 'Residential Information',
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        searchEmployer(),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            'Fill the information below to help us identify you as an employed worker of a company.',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        //   child: DropDownComponent(items: employerArray,
                        //       onChange: (String item){
                        //         setState(() {
                        //           List<dynamic> selectID =   allEmployer.where((element) => element['name'] == item).toList();
                        //           List<dynamic> selectExtension =   allEmployer.where((element) => element['name'] == item).toList();
                        //
                        //           //print('selectId ${selectID}');
                        //           employerInt = selectID[0]['id'];
                        //           employerDomain = selectID[0]['emailExtension'];
                        //           getEmployersBranch(employerInt);
                        //           //print( '${employerDomain}');
                        //         });
                        //       },
                        //       label: "Organization Head Office* ",
                        //       selectedItem: "Select Employer",
                        //       validator: (String item){
                        //
                        //       }
                        //   ),
                        // ),

                        //   Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        //     child:   AdvancedSearch(
                        //       data: employerArray,
                        //       maxElementsToDisplay: 10,
                        //       singleItemHeight: 50,
                        //       borderColor: Colors.grey,
                        //       minLettersForSearch: 0,
                        //       selectedTextColor: Color(0xFF3363D9),
                        //       fontSize: 14,
                        //       borderRadius: 5.0,
                        //       hintText: parentEmployer == '' ? 'Search Employer' : parentEmployer,
                        //       cursorColor: Colors.blueGrey,
                        //       autoCorrect: true,
                        //       focusedBorderColor: Colors.blue,
                        //       searchResultsBgColor: Color(0xFAFAFA),
                        //       disabledBorderColor: Colors.cyan,
                        //       enabledBorderColor: Colors.grey,
                        //       enabled: true,
                        //       caseSensitive: false,
                        //       inputTextFieldBgColor: Colors.white10,
                        //       clearSearchEnabled: true,
                        //       itemsShownAtStart: 10,
                        //       searchMode: SearchMode.CONTAINS,
                        //       showListOfResults: true,
                        //       unSelectedTextColor: Colors.black54,
                        //       verticalPadding: 10,
                        //       horizontalPadding: 10,
                        //       hideHintOnTextInputFocus: true,
                        //       hintTextColor: Colors.grey,
                        //       onItemTap: (index, value) {
                        //
                        //         //print("selected item Index is $index");
                        //       },
                        //       onSearchClear: () {
                        //         //print("Cleared Search");
                        //       },
                        //       onSubmitted: (value, value2) {
                        //         //print("Submitted: " + value);
                        //         List<dynamic> selectID =   allEmployer.where((element) => element['name'] == value).toList();
                        //         List<dynamic> selectExtension =   allEmployer.where((element) => element['name'] == value).toList();
                        //
                        //         //print('selectId ${selectID}');
                        //         employerInt = selectID[0]['id'];
                        //
                        //         employerDomain = selectID[0]['emailExtension'];
                        //         getEmployersBranch(employerInt);
                        //         //print( '${employerDomain}');
                        //         branchEmployerInt = 0;
                        //       },
                        //       onEditingProgress: (value, value2) async{
                        //
                        //         final SharedPreferences prefs = await SharedPreferences.getInstance();
                        //
                        //         int _sector = prefs.getInt('employment_type');
                        //         // int realEmployerSector = employerSector == null  ? empSector: empSector == null ? _sector : _sector == null ? 0 : employerSector;
                        //
                        //         int realEmployerSector = employerSector == null ? _sector : employerSector;
                        //
                        //
                        //           if (_debounce?.isActive ?? false) _debounce.cancel();
                        //           _debounce = Timer(const Duration(seconds: 1), () {
                        //             // do something with query
                        //             if(value.length > 3){
                        //               getEmployersList(realEmployerSector,value);
                        //             }
                        //           }
                        //           );
                        //
                        //
                        //           employerArray.length == 0 ?
                        //               setState((){
                        //                 showLoading = true;
                        //               })
                        //               :   setState((){
                        //             showLoading = false;
                        //           });
                        //
                        //
                        //         List<dynamic> selectID =   allEmployer.where((element) => element['name'] == value).toList();
                        //         List<dynamic> selectExtension =   allEmployer.where((element) => element['name'] == value).toList();
                        //
                        //         //print('selectId ${selectID}');
                        //         if(!selectID.isEmpty){
                        //           employerInt = selectID[0]['id'];
                        //           employerDomain = selectID[0]['emailExtension'];
                        //           getEmployersBranch(employerInt);
                        //         }
                        //
                        //
                        //         branchEmployerInt = 0;
                        //               setState(() {
                        //                 employerState = '';
                        //                 branchEmployer = '';
                        //                 employerLga = '';
                        //                 address.text = '';
                        //                 employer_phone_number.text = '';
                        //                 _isOTPSent = false;
                        //                 employerArray = [];
                        //               });
                        //
                        //         //print( '${employerDomain}');
                        //       },
                        //     ),
                        //
                        //   ),
                        //
                        // showLoading ? Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                        //     child: Column(
                        //       children: [
                        //         CircularProgressIndicator(),
                        //         Text('searching for employer..ENTER MIN OF 5 CHARACTERS',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w300),),
                        //       ],
                        //     ),
                        //   ) : SizedBox(),

                        // Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                        //   child:
                        //   TypeAheadField(
                        //
                        //     textFieldConfiguration: TextFieldConfiguration(
                        //         // autofocus: true,
                        //         // // style: DefaultTextStyle.of(context).style.copyWith(
                        //         // //     fontStyle: FontStyle.italic
                        //         // // ),
                        //         // style: TextStyle(
                        //         //   height: 10,
                        //         // ),
                        //         controller: this._typeAheadController,
                        //         decoration: InputDecoration(
                        //             border: OutlineInputBorder(),
                        //           hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
                        //         )
                        //     ),
                        //
                        //         // suggestionsBoxController: parentEmployerController,
                        //       transitionBuilder: (context, suggestionsBox, animationController) =>
                        //           FadeTransition(
                        //             child: suggestionsBox,
                        //             opacity: CurvedAnimation(
                        //                 parent: animationController,
                        //                 curve: Curves.fastOutSlowIn
                        //             ),
                        //           ),
                        //     suggestionsCallback: (pattern) async {
                        //       return await getSuggestions(pattern);
                        //       //getEmployersList(realEmployerSector,value);
                        //
                        //     },
                        //     debounceDuration: Duration(milliseconds: 500),
                        //     itemBuilder: (context, suggestion) {
                        //    //   //print('user suggestion ${suggestion}');
                        //       return ListTile(
                        //         leading: Icon(Icons.work_outlined),
                        //         title: Text(suggestion['name']),
                        //         subtitle: Text('${suggestion['mobileNo']}'),
                        //       );
                        //     },
                        //     noItemsFoundBuilder: (context) => Container(
                        //       height: 100,
                        //       child: Center(
                        //         child: Text('No Employer Found'),
                        //       ),
                        //     ),
                        //     onSuggestionSelected: (suggestion) {
                        //      this._typeAheadController.text = suggestion['name'];
                        //       //print('suggesttion ${suggestion}');
                        //       employerInt = suggestion['id'];
                        //       employerDomain = suggestion['emailExtension'];
                        //       getEmployersBranch(employerInt);
                        //       branchEmployerInt = 0;
                        //       setState(() {
                        //         employerState = '';
                        //         branchEmployer = '';
                        //         employerLga = '';
                        //         address.text = '';
                        //         employer_phone_number.text = '';
                        //         _isOTPSent = false;
                        //         employerArray = [];
                        //       });
                        //
                        //       // Navigator.of(context).push(MaterialPageRoute(
                        //       //     builder: (context) => ProductPage(product: suggestion)
                        //       // ));
                        //     },
                        //   ),
                        //
                        //   // TextFieldSearch(
                        //   //     label: 'Parent Employer',
                        //   //     decoration: InputDecoration(
                        //   //         border: OutlineInputBorder(),
                        //   //       //  hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
                        //   //     ),
                        //   //     controller: _typeAheadController,
                        //   //     future: () {
                        //   //       return fetchSimpleData();
                        //   //     },
                        //   //   minStringLength: 5,
                        //   //     getSelectedValue: (item){
                        //   //         //print('item ${item.label} ${item.value}');
                        //   //         // this._typeAheadController.text = item.label;
                        //   //           // //print('suggesttion ${suggestion}');
                        //   //           employerInt = item.value;
                        //   //
                        //   //         List<dynamic> selectID =   allEmployer.where((element) => element['id'] == item.value).toList();
                        //   //         // employerDomain = selectID[0]['emailExtension'];
                        //   //       //  employerDomain = selectID[0]['emailExtension'] == null ? '' : selectID[0]['emailExtension'];
                        //   //         employerDomain = selectID.isEmpty || selectID[0]['emailExtension'] == null ? '' : selectID[0]['emailExtension'];
                        //   //
                        //   //
                        //   //         //employerDomain = suggestion['emailExtension'];
                        //   //
                        //   //           getEmployersBranch(item.value);
                        //   //           branchEmployerInt = 0;
                        //   //           setState(() {
                        //   //             // collectBranchEmployer = [];
                        //   //             // allBranchEmployer = [];
                        //   //             employerState = '';
                        //   //             branchEmployer = '';
                        //   //             employerLga = '';
                        //   //             address.text = '';
                        //   //             employer_phone_number.text = '';
                        //   //             _isOTPSent = false;
                        //   //             employerArray = [];
                        //   //           });
                        //   //     },
                        //   // ),
                        //
                        // ),

                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
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
                              transitionBuilder: (context, suggestionsBox,
                                      animationController) =>
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
                                this._typeAheadController.text =
                                    suggestion['name'];
                                employerInt = suggestion['id'];
                                employerDomain = suggestion['emailExtension'];
                                getEmployersBranch(employerInt);
                                branchEmployerInt = 0;
                                setState(() {
                                  employerState = '';
                                  //    branchEmployer = '';
                                  employerLga = '';
                                  address.text = '';
                                  employer_phone_number.text = '';
                                  //  _isOTPSent = false;
                                  employerArray = [];
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: DropDownComponent(
                              items: BranchEmployerArray,
                              onChange: (String item) {
                                setState(() {
                                  List<dynamic> selectID = allBranchEmployer
                                      .where(
                                          (element) => element['name'] == item)
                                      .toList();
                                  // List<dynamic> selectExtension =   allBranchEmployer.where((element) => element['name'] == item).toList();

                                  //print('selectId ${selectID}');
                                  branchEmployerInt = selectID[0]['id'];
                                  branchEmployer = selectID[0]['name'];
                                  employerDomain =
                                      selectID[0]['emailExtension'];
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

                        branchEmployerInt == 0
                            ? Container()
                            : Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: DropDownComponent(
                                        items: stateArray,
                                        onChange: (String item) {
                                          setState(() {
                                            List<dynamic> selectID = allStates
                                                .where((element) =>
                                                    element['name'] == item)
                                                .toList();
                                            stateInt = selectID[0]['id'];
                                            employerState = selectID[0]['name'];
                                            getSubAccount(27, stateInt);
                                            lgaInt = 0;
                                            //print(stateInt);
                                            employerLga = '';
                                          });
                                        },
                                        label: "State Of Employment *",
                                        selectedItem: employerState,
                                        validator: (String item) {}),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: DropDownComponent(
                                        items: lgaArray,
                                        onChange: (String item) {
                                          setState(() {
                                            List<dynamic> selectID = allLga
                                                .where((element) =>
                                                    element['name'] == item)
                                                .toList();
                                            //print('this is select ID');
                                            //print(selectID[0]['id']);
                                            lgaInt = selectID[0]['id'];
                                            employerLga = selectID[0]['name'];
                                            //print('end this is select ID');
                                          });
                                        },
                                        label: "LGA * ",
                                        selectedItem: employerLga,
                                        validator: (String item) {
                                          if (lgaInt == 0 || lgaInt == null) {
                                            return 'LGA is required';
                                          }
                                        }),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          address,
                                          'Office Address *',
                                          'Enter address',
                                          TextInputType.name,
                                          isSendOTP: false,
                                          changeValidator: (value) {
                                        if (value.length == 0) {
                                          return "Office Address cannot be empty";
                                        }
                                      })),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          nearest_landmark,
                                          'Nearest Landmark (optional)',
                                          'Enter landmark',
                                          TextInputType.name,
                                          needsValidation: false,
                                          isSendOTP: false)),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          employer_phone_number,
                                          'Employer\'s phone number (optional)',
                                          '0000000000',
                                          TextInputType.phone,
                                          maxLenghtAllow: 11,
                                          needsValidation: false,
                                          isSendOTP: false)),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Personal Email (for verification only)',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito Bold'),

                                      ),
                                    ),
                                  ),

                                  // personal email

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: EntryFieldForPersonalMail(
                                        context,
                                        emailaddress,
                                        ' Email Address *',
                                        'Enter email address',
                                        TextInputType.text,
                                        isValidateEmployer: false,
                                        isSuffix: true,
                                        extension: employerDomain,
                                        needsValidation: false,
                                        isSendOTP: true,
                                        isRead: true,
                                        onBtnPressed: () {
                                          sendOTPForEmployer(isPersonalEmail: true);
                                        }, changeValidator: (value) {
                                      //print('real Value ${value}');
                                      // if (!(EmailValidator.validate(
                                      //     emailaddress.text))) {
                                      //   //   print('work email >> ${work_email.text}');
                                      //   return 'Invalid email address';
                                      //   // setState(() {
                                      //   // return   errorText = 'Invalid email address';
                                      //   // });
                                      // }
                                    }),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  _isPersonalOTPSent
                                      ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          otpController,
                                          'OTP Verification',
                                          'Enter OTP',
                                          TextInputType.name,
                                          isValidateEmployer: true,
                                          isSendOTP: false,
                                          onBtnPressed: () {
                                            verifyOTPForEmployer(isPersonalEmail: true);
                                          }))
                                      : SizedBox(),
                                  // end personal email

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Work Details',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito Bold'),

                                      ),
                                    ),
                                  ),

                                  Text(
                                    errorText,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.redAccent),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // sectorId == 17
                                  //     ?
                                  Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: EntryField(
                                              context,
                                              work_email,
                                              'Work Email *',
                                              'Enter work email',
                                              TextInputType.text,
                                              isValidateEmployer: false,
                                              isSuffix: true,
                                              extension: employerDomain,
                                              needsValidation: false,
                                              isSendOTP: true,
                                              onBtnPressed: () {
                                            sendOTPForEmployer(isPersonalEmail: false);
                                          }, changeValidator: (value) {
                                            //print('real Value ${value}');

                                            if (
                                            !(EmailValidator.validate(
                                                work_email.text)
                                            )
                                              &&
                                            sectorId == 17
                                            ) {
                                              //   print('work email >> ${work_email.text}');
                                              return 'Invalid email address';
                                              // setState(() {
                                              // return   errorText = 'Invalid email address';
                                              // });
                                            }
                                          }),
                                        )
                                      // : SizedBox()
                                  ,
                                  SizedBox(
                                    height: 10,
                                  ),

                                  _isWorkOTPSent
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: EntryField(
                                              context,
                                              otpController,
                                              'OTP Verification',
                                              'Enter OTP',
                                              TextInputType.name,
                                              isValidateEmployer: true,
                                              isSendOTP: false,
                                              onBtnPressed: () {
                                            verifyOTPForEmployer(isPersonalEmail: false);

                                          }))
                                      : SizedBox(),
                                  // SizedBox(height: 10,),

                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          staffId,
                                          'Staff/Employee ID*',
                                          'Staff ID',
                                          TextInputType.name,
                                          isSendOTP: false,
                                          changeValidator: (value) {
                                        if (value.length == 0) {
                                          return "Staff ID cannot be empty";
                                        }
                                      })),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: EntryField(
                                          context,
                                          job_role,
                                          'Job Role/Grade *',
                                          'Job grade',
                                          TextInputType.name,
                                          isSendOTP: false,
                                          changeValidator: (value) {
                                        if (value.length == 0) {
                                          return "Job Grade cannot be empty";
                                        }
                                      })),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.095,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .backgroundColor,

                                            // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0)), // set rounded corner radius
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontFamily:
                                                    'Nunito SansRegular'),
                                            autofocus: false,
                                            readOnly: true,
                                            controller: dateOfEmployment,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    // _selectDate(context);
                                                    // showDatePicker();

                                                    DatePicker.showDatePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            1955, 3, 5),
                                                        maxTime: DateTime.now()
                                                            .add(Duration(
                                                                days: 0,
                                                                hours: 2)),
                                                        onChanged: (date) {
                                                      print('change $date');
                                                      setState(() {
                                                        String retDate =
                                                            retsNx360dates(
                                                                date);
                                                        dateOfEmployment.text =
                                                            retDate;
                                                      });
                                                    }, onConfirm: (date) {
                                                      print('confirm $date');
                                                    },
                                                        currentTime:
                                                            DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                  icon: Icon(
                                                    Icons.date_range,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.6),
                                                ),
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'Date Of Employmennt',
                                                //      floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                                hintText: 'Date Of Employment',
                                                hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Nunito SansRegular'),
                                                labelStyle: TextStyle(
                                                    fontFamily:
                                                        'Nunito SansRegular',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline2
                                                        .color)),
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.095,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .backgroundColor,

                                            // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0)), // set rounded corner radius
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontFamily:
                                                    'Nunito SansRegular'),
                                            autofocus: false,
                                            readOnly: true,
                                            controller: payrollDob,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    // _selectDate(context);
                                                    // showDatePicker();

                                                    DatePicker.showDatePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            1955, 3, 5),
                                                        maxTime: DateTime.now()
                                                            .subtract(Duration(
                                                                days: 6575)),
                                                        onChanged: (date) {
                                                      print('change $date');
                                                      setState(() {
                                                        String retDate =
                                                            retsNx360dates(
                                                                date);
                                                        payrollDob.text =
                                                            retDate;
                                                      });
                                                    }, onConfirm: (date) {
                                                      print('confirm $date');
                                                    },
                                                        currentTime:
                                                            DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                  icon: Icon(
                                                    Icons.date_range,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.6),
                                                ),
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'PayRoll Date Of Birth',
                                                //      floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                                hintText:
                                                    'PayRoll Date Of Birth',
                                                hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Nunito SansRegular'),
                                                labelStyle: TextStyle(
                                                    fontFamily:
                                                        'Nunito SansRegular',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline2
                                                        .color)),
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: DropDownComponent(
                                        items: salaryArray,
                                        onChange: (String item) {
                                          setState(() {
                                            List<dynamic> selectID = allSalary
                                                .where((element) =>
                                                    element['name'] == item)
                                                .toList();
                                            //print('this is select ID');
                                            //print(selectID[0]['id']);
                                            salaryInt = selectID[0]['id'];
                                            salary_range = selectID[0]['name'];
                                            //print('end this is select ID');
                                          });
                                        },
                                        label: "Salary Range * ",
                                        selectedItem: salary_range,
                                        validator: (String item) {
                                          if (item == null || item.isEmpty) {
                                            return 'Enter salary range';
                                          }
                                        }),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.095,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .backgroundColor,

                                            // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0)), // set rounded corner radius
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontFamily:
                                                    'Nunito SansRegular'),
                                            autofocus: false,
                                            readOnly: true,
                                            controller: salaryPayDayController,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    // _selectDate(context);
                                                    // showPayDayPicker();
                                                    DatePicker.showDatePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        minTime: DateTime.now()
                                                            .add(Duration(
                                                                days: 0,
                                                                hours: 1)),
                                                        maxTime: DateTime.now()
                                                            .add(Duration(days: 30, hours: 0)),
                                                        onChanged: (date) {
                                                      print('change $date');
                                                      setState(() {
                                                        String retDate =
                                                            retsNx360dates(
                                                                date);
                                                        salaryPayDayController
                                                            .text = retDate;
                                                      });
                                                    }, onConfirm: (date) {
                                                      print('confirm $date');
                                                    },
                                                        currentTime:
                                                            DateTime.now().add(
                                                                Duration(
                                                                    days: 0,
                                                                    hours: 2)),
                                                        locale: LocaleType.en);
                                                  },
                                                  icon: Icon(
                                                    Icons.date_range,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.6),
                                                ),
                                                border: OutlineInputBorder(),
                                                labelText: 'Salary Payday',
                                                //   floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                                hintText: 'Salary Payday',
                                                hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Nunito SansRegular'),
                                                labelStyle: TextStyle(
                                                    fontFamily:
                                                        'Nunito SansRegular',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline2
                                                        .color)),
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(
          text1: 'Previous',
          text2: 'Next',
          callAction2: () {
            submitEmploymentInfo();
          },
          callAction1: () {
            MyRouter.popPage(context);
          },
        ),
      ),
    );
  }

  // Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false}){
  //   var MediaSize = MediaQuery.of(context).size;
  //   return
  //     Container(
  //       height: MediaSize.height * 0.095,
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
  //           child:
  //           TextFormField(
  //
  //             style: TextStyle(fontFamily: 'Nunito SansRegular'),
  //             keyboardType: keyBoard,
  //
  //             controller: editController,
  //
  //             decoration: InputDecoration(
  //
  //                 suffixIcon: isPassword == true ? Icon(Icons.remove_red_eye,color: Colors.black38
  //                   ,) : null,
  //                 focusedBorder:OutlineInputBorder(
  //                   borderSide: const BorderSide(color: Colors.grey, width: 0.6),
  //
  //                 ),
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
  //
  // }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText, var keyBoard,
      {bool isValidateEmployer = false,
      bool isSendOTP = true,
      var maxLenghtAllow,
      Function onBtnPressed,
      bool isSuffix = false,
      String extension,
      bool needsValidation = true,
      Function changeValidator}
      ) {
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
            validator: changeValidator,
            decoration: InputDecoration(
                prefixIcon:
                  isSendOTP == true
                ?
                    // _isWorEmailVerified == true
                    //     ? SizedBox()
                    // :
                    TextButton(
                        // disabledColor: Colors.blueGrey,
                        onPressed: onBtnPressed,
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xff077DBB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Verify work email',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            )),
                      )
                    : null,
                suffixIcon: isValidateEmployer == true
                    ? TextButton(
                        // disabledColor: Colors.blueGrey,
                        onPressed: onBtnPressed,
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xff077DBB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Verify OTP',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        // child: isSuffix
                        //     ? Text(extension == null ? '' : extension)
                        //     : Text(''),
                  child: isSuffix
                      ?
                  // Text(extension == null ? '' : extension)
                  verificationStatus()
                      : Text(''),
                      ),
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

  Widget EntryFieldForPersonalMail(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{
    bool isPassword = false,
    var maxLenghtAllow,
    bool isRead = false,
    bool needsValidation = true,
    // new
    bool isValidateEmployer = false,
    bool isSendOTP = false,

    Function onBtnPressed,
    bool isSuffix = false,
    String extension,

    Function changeValidator

  }){
    var MediaSize = MediaQuery.of(context).size;
    return
      Container(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,

              // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // set rounded corner radius
            ),
            child:
            TextFormField(
              readOnly: isRead,
              maxLength: maxLenghtAllow,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontFamily: 'Nunito SansRegular'),
              keyboardType: keyBoard,
              onChanged: (value) {
                editController.value =
                    TextEditingValue(
                        text: toBeginningOfSentenceCase(value),
                        selection: editController.selection);
              },
              controller: editController,

              validator: (value) {

                if(needsValidation){

                  if(value.isEmpty){
                    return 'Field cannot be empty';
                  }

                  // else if(!EmailValidator.validate(emailaddress.text)){
                  //   return 'Invalid email address';
                  // }

                }
                else {
                  // no need for validation
                }

              },


              // onSaved: (value) => vals = value,

              decoration: InputDecoration(
                  prefixIcon: isSendOTP == true
                      ?
                  // isPersonalEmailVerified == 'true'
                  //     ? SizedBox()
                  //     :
                  TextButton(
                    // disabledColor: Colors.blueGrey,
                    onPressed: onBtnPressed,
                    child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xff077DBB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Send Otp',
                          style:
                          TextStyle(fontSize: 10, color: Colors.white),
                        )),
                  )

                      : null,

                  suffixIcon: isValidateEmployer == true
                      ? TextButton(
                    // disabledColor: Colors.blueGrey,
                    onPressed: onBtnPressed,
                    child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xff077DBB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Verify OTP',
                          style:
                          TextStyle(fontSize: 15, color: Colors.white),
                        )),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(top: 10, right: 5),
                    child: isSuffix
                        ?
                    // Text(extension == null ? '' : extension)
               verificationStatusForPersonal()
                        : Text(''),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  border: OutlineInputBorder(

                  ),
                  labelText: labelText,
                  //  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      );
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
  //       //print(selected);
  //       //  date = selected.toString();
  //
  //       String newdate = selectedDate.toString().substring(0,10);
  //       //print(newdate);
  //
  //       String formattedDate = DateFormat.yMMMMd().format(selected);
  //
  //       //print(formattedDate);
  //
  //       String removeComma = formattedDate.replaceAll(",", "");
  //
  //       List<String> wordList = removeComma.split(" ");
  //
  //       String o1 = wordList[0];
  //       String o2 = wordList[1];
  //       String o3 = wordList[2];
  //
  //       String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;
  //
  //       //print('newOO ${newOO}');
  //
  //       String concatss = newOO + " " + o1 + " " + o3;
  //       //print("concatss");
  //       //print(concatss);
  //
  //       //print(wordList);
  //
  //       dateOfEmployment.text = concatss;
  //
  //     });
  // }

  retsNx360dates(DateTime selected) {
    //print(selected);
    String newdate = selectedDate.toString().substring(0, 10);
    //print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(selected);

    //print(formattedDate);

    String removeComma = formattedDate.replaceAll(",", "");
    //print('removeComma');
    //print(removeComma);

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o2.length == 1 ? '0' + '' + o2 : o2;

    //print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;

    //print("concatss");
    //print(concatss);

    //print(wordList);
    return concatss;
  }

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
                          //print(CupertinoSelectedDate);
                          String retDate =
                              retsNx360dates(CupertinoSelectedDate);
                          //print('ret Date ${retDate}');
                          dateOfEmployment.text = retDate;
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
                  onPressed: () {
                    String retDate = retsNx360dates(CupertinoSelectedDate);
                    //print('ret Date ${retDate}');
                    dateOfEmployment.text = retDate;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Widget verificationStatus() {
    final bool isWorkEmailVerStatus =  _isWorEmailVerified;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWorkEmailVerStatus ? Color(0xffECFDF3) : Color(0xffe5a9b5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWorkEmailVerStatus ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isWorkEmailVerStatus ? Color(0xff079455) : Color(0xffd93b59),
          ),
          SizedBox(width: 8),
          Text(
            isWorkEmailVerStatus ? 'Verified' : 'Not Verified',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isWorkEmailVerStatus ? Color(0xff079455) : Color(0xffd93b59),
            ),
          ),
        ],
      ),
    );
  }

  Widget verificationStatusForPersonal() {
    final bool isPersonalEmailVered =  isPersonalEmailVerified == 'true';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPersonalEmailVered ? Color(0xffECFDF3) : Color(0xffe5a9b5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPersonalEmailVered ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isPersonalEmailVered ? Color(0xff079455) : Color(0xffd93b59),
          ),
          SizedBox(width: 8),
          Text(
            isPersonalEmailVered ? 'Verified' : 'Not Verified',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isPersonalEmailVered ? Color(0xff079455) : Color(0xffd93b59),
            ),
          ),
        ],
      ),
    );
  }



  showPayDayPicker() {
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
                      if (value != null && value != PayDayCupertinoSelectedDate)
                        setState(() {
                          PayDayCupertinoSelectedDate = value;
                          print(PayDayCupertinoSelectedDate);
                          String retDate =
                              retsNx360dates(PayDayCupertinoSelectedDate);
                          //print('ret Date ${retDate}');

                          String newSalary;
                          salaryPayDayController.text = retDate;
                        });
                    },
                    // initialDateTime: DateTime.now(),
                    //
                    // minimumYear: 2022,
                    // maximumYear: 2022,
                    initialDateTime:
                        DateTime.now().add(Duration(days: 0, hours: 2)),
                    // minimumYear: 2022,
                    // maximumYear: 2022,
                    maximumDate:
                        DateTime.now().add(Duration(days: 30, hours: 0)),
                    minimumDate:
                        DateTime.now().add(Duration(days: 0, hours: 1)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () {
                    String retDate =
                        retsNx360dates(PayDayCupertinoSelectedDate);
                    print('ret Date ${retDate}');
                    salaryPayDayController.text = retDate;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  retDOBfromBVN(String getDate) {
    //print('getDate ${getDate}');

    // 2/18/2001
    String removeComma = getDate.replaceAll("-", " ");
    //print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    //print(wordList[1]);

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

    //print('newOO ${newOO}');

    String concatss = newOO + " " + realMonth + " " + o1;

    //print("concatss new Date from edit ${concatss}");

    return concatss;
  }

  Widget searchEmployer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Color(0xffDE914A).withOpacity(0.21),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.orangeAccent,
                      //       borderRadius: BorderRadius.all(Radius.circular(7)),
                      //     ),
                      //     child: Icon(Icons.warning_amber_outlined,color: Colors.white,)
                      // ),
                      // SizedBox(width: 6,),
                      //  Text('Warning',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                    ],
                  ),
                  // Icon(Icons.clear)
                ],
                //
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Type the first 3-5 character of the Employer\'s name,\n the system will suggest the employer for you to select',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestItem {
  final String label;
  dynamic value;

  TestItem({@required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}
