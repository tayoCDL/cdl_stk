import 'dart:async';
import 'dart:convert';
import 'dart:math';

// import 'package:advanced_search/advanced_search.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addLead.dart';
import 'package:sales_toolkit/views/leads/ResidentialDetails.dart';
import 'package:sales_toolkit/views/leads/singleLeadView.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:sales_toolkit/widgets/LocalTypeAhead.dart';


class LeadEmploymentInfo extends StatefulWidget {
  // const EmploymentInfo({Key key}) : super(key: key);
  //
  // @override
  // _EmploymentInfoState createState() => _EmploymentInfoState();

  final int ClientInt,leadInt;
  final String Employmentaddress,EmploymentNeareastLandmark,EmploymentStaffId,EmploymentJobRole,EmploymentWorkEmail,EmploymentSalaryRange,EmploymentSalaryPayday,EmploymentPhoneNumber,comingFrom;
  const LeadEmploymentInfo({Key key,this.Employmentaddress,this.EmploymentNeareastLandmark,this.EmploymentStaffId,this.EmploymentJobRole,this.EmploymentWorkEmail,this.EmploymentSalaryRange,this.EmploymentSalaryPayday,this.EmploymentPhoneNumber,this.comingFrom,this.ClientInt,this.leadInt}) : super(key: key);
  @override
  _LeadEmploymentInfoState createState() => _LeadEmploymentInfoState(
      Employmentaddress: this.Employmentaddress,
      EmploymentNeareastLandmark: this.EmploymentNeareastLandmark,
      EmploymentStaffId: this.EmploymentStaffId,
      EmploymentJobRole: this.EmploymentJobRole,
      EmploymentWorkEmail: this.EmploymentWorkEmail,
      EmploymentSalaryRange: this.EmploymentSalaryRange,
      EmploymentSalaryPayday: this.EmploymentSalaryPayday,
      EmploymentPhoneNumber: this.EmploymentPhoneNumber,
      ClientInt:this.ClientInt,
      comingFrom: this.comingFrom,
      leadInt:this.leadInt
  );
}

class _LeadEmploymentInfoState extends State<LeadEmploymentInfo> {
  int ClientInt,leadInt;
  String Employmentaddress,EmploymentNeareastLandmark,
      EmploymentStaffId,EmploymentJobRole,
      EmploymentWorkEmail,EmploymentSalaryRange,
      EmploymentSalaryPayday,EmploymentPhoneNumber,
      comingFrom;

  _LeadEmploymentInfoState({this.Employmentaddress,
    this.EmploymentNeareastLandmark,this.EmploymentStaffId,
    this.EmploymentJobRole,this.EmploymentWorkEmail,
    this.EmploymentSalaryRange,this.EmploymentSalaryPayday,
    this.EmploymentPhoneNumber,this.comingFrom,
    this.ClientInt,
    this.leadInt});


  @override
  List<String> stateArray = [];
  List<String> collectState = [];
  List<dynamic> allStates = [];

  var employmentProfile = [];

  List<String> lgaArray = [];
  List<String> collectLga = [];
  List<dynamic> allLga = [];

  List _jsonList = [];

  var clientType = {};

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


  String employerName = '';
  String employerState = '';
  String employerLga = '';
  String realMonth = '';
  String parentEmployer = '';
  int empSector = 0;
  bool showLoading = false;
  Timer _debounce;

  int stateInt,salaryInt,lgaInt,employerInt,clientTypeInt;
  int branchEmployerInt = 0;
  String employerDomain ='';
  void initState() {
    // TODO: implement initState
    getStateList();
    getSalaryList();
    if(leadInt != null){
      getEmploymentProfile();
    }

    address.text = Employmentaddress;
    nearest_landmark.text = EmploymentNeareastLandmark;
    staffId.text = EmploymentStaffId;
    job_role.text = EmploymentJobRole;
    work_email.text = EmploymentWorkEmail;
    salary_payday = EmploymentSalaryPayday;
    salary_range = EmploymentSalaryRange;
    employer_phone_number.text = EmploymentPhoneNumber;

    getClientType();
    super.initState();

  }

  @override
  void dispose() {
    _debounce?.cancel();
    _typeAheadController.dispose();
    super.dispose();
  }









  Future<List> getSuggestions(String query) async{

    print('GET client type >> ${clientTypeInt}');

    if(query.length > 3){

      final SharedPreferences prefs = await SharedPreferences.getInstance();


      // final Future<Map<String,dynamic>> respose =   RetCodes().Leademployers(query);
      final Future<Map<String,dynamic>> result_response =   RetCodes().employers(clientTypeInt,query);


      result_response.then((response) async {
        List<dynamic> newEmp = response['data']['pageItems'];

        setState(() {
          allEmployer = newEmp;
          collectEmployer = [];
        });

        for(int i = 0; i < newEmp.length;i++){
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

      await Future.delayed(Duration(seconds: 1));
      return List.generate(3, (index) {
        return {'name': query + index.toString(), 'price': Random().nextInt(100)};
      });


    }


  }


  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List _list = <dynamic>[];

    String query = _typeAheadController.text;
    final Future<Map<String,dynamic>> respose =   RetCodes().Leademployers(query);

    respose.then((response) async {
      List<dynamic> newEmp = response['data']['pageItems'];
      //print('new emps ${newEmp}');
      setState(() {
        allEmployer = newEmp;
        collectEmployer = [];
      });

      for(int i = 0; i < newEmp.length;i++){
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



    for(int i=0;i < collectEmployer.length;i++){
      _list.add(new TestItem.fromJson(
          {'label': collectEmployer[i], 'value': collectEmployerID[i]}
      ));
    }

    // _list.add(new TestItem.fromJson(_jsonList[1]));
    // _list.add(new TestItem.fromJson(_jsonList[2]));

    return _list;

    return collectEmployer;
  }


  getClientType() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('leadId', responseData2['resourceId']);

    int localclientID =   leadInt == null ? prefs.getInt('leadId') : leadInt;
    //print('localClient ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleLead + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    //print(responsevv.body);

    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;
    setState(() {
      clientType = newClientData;
      //print('responseData2 client Type ${clientType}');
      clientTypeInt = clientType.isEmpty ? '' : clientType['leadCategory']['id'];
      //  sectorId = clientType.isEmpty ? '' : clientType['employmentSector']['id'];
      //print('sector ID ${sectorId}');
    });

    print('client Type ${clientTypeInt} ${clientType}');
  }



  getStateList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('27');

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

    respose.then((response) async {
      //print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsState'));


        //
        if(prefs.getString('prefsState').isEmpty){
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

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            collectState.add(mtBool[i]['name']);
          }

          setState(() {
            stateArray = collectState;
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
        });

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectState.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectState);

        setState(() {
          stateArray = collectState;
        });
      }


    }
    );

  }

  getSalaryList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('43');
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

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsSalary'));

        if(prefs.getString('prefsMarital').isEmpty){
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

          for(int i = 0; i < mtBool.length;i++){
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

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectSalary.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectSalary);

        setState(() {
          salaryArray = collectSalary;
        });
      }


    }
    );

  }

  getEmployersList(String EmployerName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState(() {
    //   _isLoading = true;
    // });
    final Future<Map<String,dynamic>> respose =   RetCodes().Leademployers(EmployerName);

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
      //print(response['data']);

      if(response['status'] == false){
        setState(() {
          _isLoading = false;
        });

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmployer'));

        if(prefs.getString('prefsEmployer').isEmpty){
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
            collectEmployer = [];
          });

          for(int i = 0; i < mtBool.length;i++){
            //print(mtBool[i]['name']);
            collectEmployer.add(mtBool[i]['name']);
          }

          setState(() {

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

        setState(() {
          _isLoading = false;
        });

        List<dynamic> newEmp = response['data']['pageItems'];

        //print('this is newEmps ${newEmp.toString()}');

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmployer', jsonEncode(newEmp));


        setState(() {
          employerArray =[];
          collectEmployer = [];
          allEmployer = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectEmployer.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectEmployer);

        setState(() {
          employerArray = collectEmployer;
        });
      }


    }
    );

  }

  getEmploymentProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;
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
    //print(responsevv.body);

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    //print(responseData2);
    var newClientData = responseData2;
    setState(() {
      employmentProfile = newClientData;
      prefs.setInt('tempEmployerInt',employmentProfile.isEmpty ? null : employmentProfile[0]['id']);
      lgaInt = employmentProfile.isEmpty ? '' : employmentProfile[0]['lga']['id'] ?? 0;
      stateInt = employmentProfile.isEmpty ? '' : employmentProfile[0]['state']['id'] ?? 0;
      employerInt = employmentProfile.isEmpty ? 0 : employmentProfile[0]['employer']['id'] ?? 0;
      branchEmployerInt  = employmentProfile.isEmpty ? 0 : employmentProfile[0]['employer']['id'] ?? 0;
      employerName = employmentProfile.isEmpty ? '' : employmentProfile[0]['employer']['name'] ?? '';

      employerState = employmentProfile.isEmpty ? '' : employmentProfile[0]['state']['name'] ?? '';
      employerLga =  employmentProfile.isEmpty ? '' : employmentProfile[0]['lga']['name'] ?? '';
      parentEmployer = employmentProfile.isEmpty ? '' : employmentProfile[0]['employer']['parent']['name'] ?? '';
      salary_range = employmentProfile.isEmpty  || employmentProfile[0]['salaryRange'] == null ? '' : employmentProfile[0]['salaryRange'] ['name'] ?? '';
      salaryInt = employmentProfile.isEmpty || employmentProfile[0]['salaryRange'] == null ? 0 : employmentProfile[0]['salaryRange']['id'] ?? 0;

    });
    //print('employer Info first array ${employmentProfile}');
    var subEmployer = employmentProfile[0];
    address.text = employmentProfile[0]['officeAddress'];
    nearest_landmark.text = employmentProfile[0]['nearestLandMark'];
    staffId.text = employmentProfile[0]['staffId'];
    work_email.text = employmentProfile[0]['emailAddress'];
    employer_phone_number.text = employmentProfile[0]['mobileNo'];
    job_role.text = employmentProfile[0]['jobGrade'];
    _typeAheadController.text = employmentProfile.isEmpty ? '' : employmentProfile[0]['employer']['parent']['name'];

    salary_payday = '';
    //salary_range = employmentProfile[0]['salaryRange']['id'];

    if(subEmployer['employmentDate'] != null){
      dateOfEmployment.text = retDOBfromBVN('${subEmployer['employmentDate'][0]}-${subEmployer['employmentDate'][1]}-${subEmployer['employmentDate'][2]}');

    }


    if(subEmployer['nextMonthSalaryPaymentDate'] != null){
      salaryPayDayController.text = retDOBfromBVN('${subEmployer['nextMonthSalaryPaymentDate'][0]}-${subEmployer['nextMonthSalaryPaymentDate'][1]}-${subEmployer['nextMonthSalaryPaymentDate'][2]}');

    }

  }

  getSubAccount(int FirstValue,int SecondValue){

    final Future<Map<String,dynamic>> respose =   RetCodes().getSubValues(FirstValue,SecondValue);
    setState(() {
      _isLoading = true;
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
      setState(() {
        _isLoading = false;
      });
      //print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLga'));

        if(prefs.getString('prefsMarital').isEmpty){
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

          for(int i = 0; i < mtBool.length;i++){
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

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectLga.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectLga);

        setState(() {
          lgaArray = collectLga;
        });
      }


    }
    );
  }

  getEmployersBranch(int parentID){
    //print('this is parent branch ${parentID}');

    final Future<Map<String,dynamic>> respose =   RetCodes().getEmployersBranch(parentID);

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
      //print('${response['data']}');

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBranchEmployer'));

        if(prefs.getString('prefsBranchEmployer').isEmpty){
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

          for(int i = 0; i < mtBool.length;i++){
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

      }
      else {
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

        for(int i = 0; i < newEmp.length;i++){
          //print(newEmp[i]['name']);
          collectBranchEmployer.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBranchEmployer);

        setState(() {
          BranchEmployerArray = collectBranchEmployer;
        });
      }


    }
    );

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

  TextEditingController salaryPayDayController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  List<Map<String,dynamic>> mergedOfflineClient = [];


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


  AddLeadProvider addClientProvider = AddLeadProvider();

  Widget build(BuildContext context) {

    var submitEmploymentInfo = () async{
      //return   MyRouter.pushPage(context, ResidentialDetails());
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }


      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int getEmpInt = prefs.getInt('tempEmployerInt');

      setState(() {
        _isLoading = true;
      });

      Map<String,dynamic> employmentData= {
        'leadId':leadInt,
        'clientId': ClientInt,
        'id': getEmpInt == null ? null : getEmpInt,
        'address': address.text,
        'nearest_landmark':nearest_landmark.text,
        'employer_phone_number': employer_phone_number.text,
        "lga": lgaInt,
        'staffId': staffId.text,
        'job_role': job_role.text,
        'work_email': work_email.text,
        'organization': branchEmployerInt,
        'state_ofposting':stateInt,
        'salary_payday': salaryPayDayController.text,
        'salary_range': salaryInt,
        'employmentDate': dateOfEmployment.text
      };
      final Future<Map<String,dynamic>> respose =  addClientProvider.addEmployment(employmentData);
      //print('start response from login');

      //print(respose.toString());

      respose.then((response) {

        if(response == null || response['status'] ==null || response['status'] == false){

          setState(() {
            _isLoading = false;
          });

          if(response['message'] == 'Network_error'){
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.orangeAccent,
              title: 'Network Error',
              message: 'Proceed, data has been saved to draft',
              duration: Duration(seconds: 3),
            ).show(context);

            if(comingFrom == 'LeadSingleView'){
              return  MyRouter.pushPage(context, ViewLead(leadID: leadInt,));
            }
            return MyRouter.pushPage(context, LeadResidentialDetails());
          }

          return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['message'],
            duration: Duration(seconds: 3),
          ).show(context);

        }
        else {
          setState(() {
            _isLoading = false;
          });
          getEmploymentProfile();
          if(comingFrom == 'LeadSingleView'){
            return  MyRouter.pushPage(context, ViewLead(leadID: leadInt,));
          }


          MyRouter.pushPage(context, LeadResidentialDetails());


          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Lead profile updated successfully',
            duration: Duration(seconds: 3),
          ).show(context);

        }

        setState(() {
          _isLoading = false;
        });

      }
      );

    };


    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(

        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProgressStepper(stepper: 0.54,title: 'Employment Details',subtitle: 'Residential Information',),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child:
                  Form(
                    key: _form,
                    child:  ListView(
                      children: [
                        searchEmployer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                          child: Text('All fields are optional',style: TextStyle(fontSize: 11),),
                        ),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        //   child:   AdvancedSearch(
                        //     data: employerArray,
                        //
                        //     maxElementsToDisplay: 10,
                        //     singleItemHeight: 50,
                        //     borderColor: Colors.black,
                        //     minLettersForSearch: 0,
                        //     selectedTextColor: Color(0xFF3363D9),
                        //     fontSize: 14,
                        //     borderRadius: 5.0,
                        //     hintText: parentEmployer == '' ? 'Search Employer' : parentEmployer,
                        //     cursorColor: Colors.blueGrey,
                        //     autoCorrect: true,
                        //     focusedBorderColor: Colors.blue,
                        //     searchResultsBgColor: Color(0xFAFAFA),
                        //     disabledBorderColor: Colors.cyan,
                        //     enabledBorderColor: Colors.grey,
                        //     enabled: true,
                        //     caseSensitive: false,
                        //     inputTextFieldBgColor: Colors.white10,
                        //     clearSearchEnabled: true,
                        //     itemsShownAtStart: 10,
                        //     searchMode: SearchMode.CONTAINS,
                        //     showListOfResults: true,
                        //     unSelectedTextColor: Colors.black54,
                        //     verticalPadding: 10,
                        //     horizontalPadding: 10,
                        //     hideHintOnTextInputFocus: true,
                        //     hintTextColor: Colors.grey,
                        //     onItemTap: (index, value) {
                        //
                        //       //print("selected item Index is $index");
                        //     },
                        //     onSearchClear: () {
                        //       //print("Cleared Search");
                        //     },
                        //     onSubmitted: (value, value2) {
                        //       //print("Submitted: " + value);
                        //       List<dynamic> selectID =   allEmployer.where((element) => element['name'] == value).toList();
                        //       List<dynamic> selectExtension =   allEmployer.where((element) => element['name'] == value).toList();
                        //
                        //       //print('selectId ${selectID}');
                        //       employerInt = selectID[0]['id'];
                        //       employerDomain = selectID[0]['emailExtension'];
                        //       getEmployersBranch(employerInt);
                        //       //print( '${employerDomain}');
                        //       branchEmployerInt = 0;
                        //     },
                        //     onEditingProgress: (value, value2) async{
                        //
                        //
                        //
                        //       if (_debounce?.isActive ?? false) _debounce.cancel();
                        //       _debounce = Timer(const Duration(seconds: 2), () {
                        //         // do something with query
                        //         if(value.length > 3){
                        //           getEmployersList(value);
                        //         }
                        //       });
                        //
                        //       employerArray.length == 0 ?
                        //       setState((){
                        //         showLoading = true;
                        //       })
                        //           :   setState((){
                        //         showLoading = false;
                        //       });
                        //
                        //
                        //       //print("TextEdited: " + value);
                        //       //print("LENGTH: " + value2.length.toString());
                        //
                        //
                        //
                        //       List<dynamic> selectID =   allEmployer.where((element) => element['name'] == value).toList();
                        //       List<dynamic> selectExtension =   allEmployer.where((element) => element['name'] == value).toList();
                        //
                        //       //print('selectId ${selectID}');
                        // if(!selectID.isEmpty){
                        //   employerInt = selectID[0]['id'];
                        //   employerDomain = selectID[0]['emailExtension'];
                        //   getEmployersBranch(employerInt);
                        //   branchEmployerInt = 0;
                        //   //print( '${employerDomain}');
                        // }
                        //
                        //
                        //
                        //     },
                        //   ),
                        //
                        // ),
                        //
                        // showLoading ? Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                        //   child: Text('searching for employer..ENTER MIN OF 5 CHARACTERS',style: TextStyle(color: Colors.red),),
                        // ) : SizedBox(),


                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                            child:
                            TypeAheadField(

                              textFieldConfiguration: TextFieldConfiguration(
                                // autofocus: true,
                                // // style: DefaultTextStyle.of(context).style.copyWith(
                                // //     fontStyle: FontStyle.italic
                                // // ),
                                // style: TextStyle(
                                //   height: 10,
                                // ),


                                  controller: this._typeAheadController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: parentEmployer == '' ? 'Search Employer ' : parentEmployer
                                  )
                              ),
                              // suggestionsBoxController: parentEmployerController,
                              transitionBuilder: (context, suggestionsBox, animationController) =>
                                  FadeTransition(
                                    child: suggestionsBox,
                                    opacity: CurvedAnimation(
                                        parent: animationController,
                                        curve: Curves.fastOutSlowIn
                                    ),
                                  ),
                              suggestionsCallback: (pattern) async {
                                return await getSuggestions(pattern);
                                //getEmployersList(realEmployerSector,value);

                              },
                              debounceDuration: Duration(milliseconds: 500),
                              itemBuilder: (context, suggestion) {
                                //  //print('user suggestion ${suggestion}');
                                return ListTile(
                                  leading: Icon(Icons.work_outlined),
                                  title: Text(suggestion['name']),
                                  subtitle: Text('${suggestion['mobileNo']}'),
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



                        SizedBox(height: 10,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: DropDownComponent(items: BranchEmployerArray,
                              onChange: (String item){
                                setState(() {
                                  List<dynamic> selectID =   allBranchEmployer.where((element) => element['name'] == item).toList();
                                  // List<dynamic> selectExtension =   allBranchEmployer.where((element) => element['name'] == item).toList();

                                  //print('selectId ${selectID}');
                                  branchEmployerInt = selectID[0]['id'];
                                  employerName = selectID[0]['name'];

                                  // employerDomain = selectID[0]['emailExtension'];
                                  // //print( '${employerDomain}');
                                });
                              },
                              label: "Select Organisation * ",
                              selectedItem: employerName,
                              validator: (String item){
                                // if(branchEmployerInt == 0){
                                //   return 'Employer branch cannot be empty';
                                // }
                              }
                          ),
                        ),

                        branchEmployerInt == 0 ? Container() : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: DropDownComponent(items: stateArray,
                                  onChange: (String item){
                                    setState(() {
                                      List<dynamic> selectID =   allStates.where((element) => element['name'] == item).toList();
                                      stateInt = selectID[0]['id'];
                                      getSubAccount(27, stateInt);
                                      //print(stateInt);
                                      employerLga =' ';
                                      lgaInt = 0;
                                    });
                                  },
                                  label: "State ",
                                  selectedItem: employerState,
                                  validator: (String item){

                                  }
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: DropDownComponent(items: lgaArray,
                                  onChange: (String item){
                                    setState(() {

                                      List<dynamic> selectID =   allLga.where((element) => element['name'] == item).toList();
                                      //print('this is select ID');
                                      //print(selectID[0]['id']);
                                      lgaInt = selectID[0]['id'];
                                      //print('end this is select ID');

                                    });
                                  },
                                  label: "LGA * ",
                                  selectedItem: employerLga,
                                  validator: (String item){
                                    // if(lgaInt == 0 || lgaInt == null){
                                    //   return 'LGA is required';
                                    // }
                                  }
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: EntryField(context, address, 'Address *','Enter address',TextInputType.name,needsValidation: false)
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: EntryField(context, nearest_landmark, 'Nearest Landmark*','Enter landmark',TextInputType.name,needsValidation: false)
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: EntryField(context, employer_phone_number, 'Employer\'s phone number*','0000000000',TextInputType.phone,maxLenghtAllow: 11,needsValidation: false)
                            ),
                            SizedBox(height: 40,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                              child: Text('Work Details',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Nunito Bold'),),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: EntryField(context, staffId, 'Staff ID*','Enter Staff ID',TextInputType.name,needsValidation: false)
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: EntryField(context, job_role, 'Job Role/Grade *','Job grade',TextInputType.name,needsValidation: false)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.095,
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

                                      style: TextStyle(fontFamily: 'Nunito SansRegular'),

                                      autofocus: false,
                                      readOnly: true,
                                      controller: dateOfEmployment,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: (){
                                              // _selectDate(context);
                                              // showDatePicker();
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(1955, 3, 5),
                                                  maxTime:  DateTime.now().add(Duration(days: 0,hours: 2)),
                                                  onChanged: (date) {
                                                    print('change $date');
                                                    setState(() {
                                                      String retDate = retsNx360dates(date);
                                                      dateOfEmployment.text = retDate;
                                                    });
                                                  }, onConfirm: (date) {
                                                    print('confirm $date');
                                                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                                            },
                                            icon:   Icon(Icons.date_range,color: Colors.blue
                                              ,) ,
                                          ),

                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                                          ),
                                          border: OutlineInputBorder(

                                          ),
                                          labelText: 'Date Of Employmennt',
                                          //    floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                          hintText: 'Date Of Employmennt',
                                          hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                                          labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

                                      ),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child:
                              Container(

                                  child: EntryField(context, work_email, 'Work Email *','Enter work email',TextInputType.text,needsValidation: false)),

                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: DropDownComponent(items: salaryArray,
                                  onChange: (String item){
                                    setState(() {
                                      List<dynamic> selectID =   allSalary.where((element) => element['name'] == item).toList();
                                      //print('this is select ID');
                                      //print(selectID[0]['id']);
                                      salaryInt = selectID[0]['id'];
                                      //print('end this is select ID');

                                    });
                                  },
                                  label: "Salary Range * ",
                                  selectedItem: salary_range,
                                  validator: (String item){
                                    // if(item.isEmpty || item == null){
                                    //   return 'Salary range is required';
                                    // }
                                  }
                              ),
                            ),


                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.095,
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

                                      style: TextStyle(fontFamily: 'Nunito SansRegular'),

                                      autofocus: false,
                                      readOnly: true,
                                      controller: salaryPayDayController,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: (){
                                              // _selectDate(context);
                                              // showPayDayPicker();

                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime.now().add(Duration( days: 0, hours: 1)),
                                                  maxTime:  DateTime.now().add(Duration(days: 30, hours: 0)),
                                                  onChanged: (date) {
                                                    print('change $date');
                                                    setState(() {
                                                      String retDate = retsNx360dates(date);
                                                      salaryPayDayController.text = retDate;
                                                    });
                                                  }, onConfirm: (date) {
                                                    print('confirm $date');
                                                  }, currentTime:  DateTime.now().add(Duration( days: 0, hours: 2)), locale: LocaleType.en);

                                            },
                                            icon:   Icon(Icons.date_range,color: Colors.blue
                                              ,) ,
                                          ),

                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                                          ),
                                          border: OutlineInputBorder(

                                          ),
                                          labelText: 'Salary Payday',
                                          // floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                          hintText: 'Date Of Employmennt',
                                          hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                                          labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

                                      ),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 40,),
                          ],
                        )




                      ],
                    ),
                  ),

                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction2: (){
          submitEmploymentInfo();
        },callAction1: (){
          MyRouter.popPage(context);
        },),
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



  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,needsValidation = true}){
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
              maxLength: maxLenghtAllow,
              style: TextStyle(fontFamily: 'Nunito SansRegular'),
              keyboardType: keyBoard,

              controller: editController,

              validator: (value) {

                if(needsValidation){
                  if(value.isEmpty){
                    return 'Field cannot be empty';

                  }


                }
                else {
                  // no need for validation
                }


              },



              // onSaved: (value) => vals = value,

              decoration: InputDecoration(
                  suffixIcon: isPassword == true ? Icon(Icons.remove_red_eye,color: Colors.black38
                    ,) : null,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                  ),
                  border: OutlineInputBorder(

                  ),
                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );




  }



  showPayDayPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height*0.40,
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
                          //print(CupertinoSelectedDate);
                          String retDate = retsNx360dates(PayDayCupertinoSelectedDate);
                          //print('ret Date ${retDate}');
                          salaryPayDayController.text = retDate;
                        });

                    },
                    initialDateTime: DateTime.now().add(Duration(days: 0,hours: 1)),
                    minimumYear: 1960,
                    maximumDate: DateTime.now().add(Duration(days: 0,hours: 2)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () {
                    String retDate = retsNx360dates(PayDayCupertinoSelectedDate);
                    //print('ret Date ${retDate}');
                    salaryPayDayController.text = retDate;
                    MyRouter.popPage(context);
                  },

                  // => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        }
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


  retsNx360dates(DateTime selected){
    //print(selected);
    String newdate = selectedDate.toString().substring(0,10);
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

    String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;

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
            height: MediaQuery.of(context).copyWith().size.height*0.40,
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
                          String retDate = retsNx360dates(CupertinoSelectedDate);
                          //print('ret Date ${retDate}');
                          dateOfEmployment.text = retDate;
                        });

                    },
                    initialDateTime: DateTime.now().add(Duration(days: 0,hours: 1)),
                    minimumYear: 1960,
                    maximumDate: DateTime.now().add(Duration(days: 0,hours: 2)),
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
        }
    );
  }


  retDOBfromBVN(String getDate){
    //print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    //print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    //print(wordList[1]);
    // 19 May 2021 ---> 500
    // [19,05,2021]

    if(wordList[1] == '1'){
      setState(() {
        realMonth = 'January';
      });
    }
    if(wordList[1] == '2'){
      setState(() {
        realMonth = 'February';
      });
    }
    if(wordList[1] == '3'){
      setState(() {
        realMonth = 'March';
      });
    }
    if(wordList[1] == '4'){
      setState(() {
        realMonth = 'April';
      });
    }
    if(wordList[1] == '5'){
      setState(() {
        realMonth = 'May';
      });
    }  if(wordList[1] == '6'){
      setState(() {
        realMonth = 'June';
      });
    }  if(wordList[1] == '7'){
      setState(() {
        realMonth = 'July';
      });
    }  if(wordList[1] == '8'){
      setState(() {
        realMonth = 'August';
      });
    }  if(wordList[1] == '9'){
      setState(() {
        realMonth = 'September';
      });
    }  if(wordList[1] == '10'){
      setState(() {
        realMonth = 'October';
      });
    }
    if(wordList[1] == '11'){
      setState(() {
        realMonth = 'November';
      });
    }
    if(wordList[1] == '12'){
      setState(() {
        realMonth = 'December';
      });
    }


    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o3.length == 1 ? '0' + '' + o3 :  o3;

    //print('newOO ${newOO}');

    String concatss =  newOO + " " + realMonth + " " + o1   ;

    //print("concatss new Date from edit ${concatss}");

    return concatss;


  }


  Widget searchEmployer(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
              SizedBox(height: 5,),
              Text('Type the first 3-5 character of the Employer\'s name,\n the system will suggest the employer for you to select',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w300),),
              SizedBox(height: 5,),

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