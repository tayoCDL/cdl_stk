import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/BankDetails.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/DocumentUpload.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/post_put_method.dart';


class NextOfKinDetails extends StatefulWidget {
  final int ClientInt;
  final String comingFrom;
  const NextOfKinDetails({Key key,this.ClientInt,this.comingFrom}) : super(key: key);

  @override
  _NextOfKinDetailsState createState() => _NextOfKinDetailsState(
    ClientInt:this.ClientInt,
    comingFrom:this.comingFrom,
  );
}

class _NextOfKinDetailsState extends State<NextOfKinDetails> {

  int ClientInt;
  String comingFrom;
  _NextOfKinDetailsState({this.ClientInt,this.comingFrom});

  @override

  List<String> titleArray = [];
  List<String> collectTitle = [];
  List<dynamic> allTitle = [];

  List<String> relationshipArray = [];
  List<String> collectRelationship= [];
  List<dynamic> allRelationship = [];

  List<String> maritalArray = [];
  List<String> collectMarital= [];
  List<dynamic> allMarital = [];

  List<String> genderArray = [];
  List<String> collectGender = [];
  List<dynamic> allGender = [];

  List<String> professionArray = [];
  List<String> collectProfession = [];
  List<dynamic> allProfession = [];

  // residential Details

  List<String> residentialArray = [];
  List<String> collectResidential = [];
  List<dynamic> allResidential = [];

  List<String> stateArray = [];
  List<String> collectState = [];
  List<dynamic> allStates = [];

  var residentialProfile = [];

  List<String> lgaArray = [];
  List<String> collectLga = [];
  List<dynamic> allLga = [];


  String realMonth = '';
  bool _isConnected = true;
  String year_at_residence;
  int stateInt,lgaInt;

  String residentialState,residentialLga,residentialStatus = '';


  // end residential Details

  var nextOfKin = [];
  String nextOfKinTitle = '';
  String nextOfKinrelationship = '';
  String nextOfKinMaritalStatus = '';
  String nextOfKinGender = '';

  void initState() {
    // TODO: implement initState

    getTitleList();
    relationshipList();
    maritalSList();
    genderList();
    getNextOfKinInformation();
    professionList();
    getStateList();
    // getNextOfKinResidentialInformation();
    getNextOfKinResidentialInformation();
    getResidentialList();


    super.initState();
  }

  getTitleList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('37');
    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsTitle'));


        //
        if(prefs.getString('prefsTitle').isEmpty){
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
            allTitle = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectTitle.add(mtBool[i]['name']);
          }

          setState(() {
            titleArray = collectTitle;
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

        prefs.setString('prefsTitle', jsonEncode(newEmp));


        setState(() {
          allTitle = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectTitle.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectTitle);

        setState(() {
          titleArray = collectTitle;
        });
      }


    }
    );
  }

  relationshipList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('6');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allRelationship = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectRelationship.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectRelationship);
    //
    //   setState(() {
    //     relationshipArray = collectRelationship;
    //   });
    // }
    // );

    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsRelationship'));


        //
        if(prefs.getString('prefsRelationship').isEmpty){
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
            allRelationship = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectRelationship.add(mtBool[i]['name']);
          }

          setState(() {
            relationshipArray = collectRelationship;
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

        prefs.setString('prefsRelationship', jsonEncode(newEmp));


        setState(() {
          allRelationship = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectRelationship.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectRelationship);

        setState(() {
          relationshipArray = collectRelationship;
        });
      }


    }
    );

  }

  maritalSList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('30');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allMarital = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectMarital.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectMarital);
    //
    //   setState(() {
    //     maritalArray = collectMarital;
    //   });
    // }
    // );


    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsMaritalStatus'));


        //
        if(prefs.getString('prefsMaritalStatus').isEmpty){
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
            allMarital = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectMarital.add(mtBool[i]['name']);
          }

          setState(() {
            maritalArray = collectMarital;
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

        prefs.setString('prefsMaritalStatus', jsonEncode(newEmp));


        setState(() {
          allMarital = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectMarital.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectMarital);

        setState(() {
          maritalArray = collectMarital;
        });
      }


    }
    );

  }

  genderList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('4');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allGender = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectGender.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectGender);
    //
    //   setState(() {
    //     genderArray = collectGender;
    //   });
    // }
    // );

    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsGender'));


        //
        if(prefs.getString('prefsGender').isEmpty){
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
            allGender = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectGender.add(mtBool[i]['name']);
          }

          setState(() {
            genderArray = collectGender;
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

        prefs.setString('prefsGender', jsonEncode(newEmp));


        setState(() {
          allGender = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectGender.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectGender);

        setState(() {
          genderArray = collectGender;
        });
      }

    }
    );


  }

  professionList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('32');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allProfession = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectProfession.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectProfession);
    //
    //   setState(() {
    //     professionArray = collectProfession;
    //   });
    // }
    // );


    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsProfession'));


        //
        if(prefs.getString('prefsProfession').isEmpty){
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
            allProfession = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectProfession.add(mtBool[i]['name']);
          }

          setState(() {
            professionArray = collectProfession;
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

        prefs.setString('prefsProfession', jsonEncode(newEmp));


        setState(() {
          allProfession = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectProfession.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectProfession);

        setState(() {
          professionArray = collectProfession;
        });
      }

    }
    );

  }

  getNextOfKinInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print('${  AppUrl.getSingleClient + localclientID.toString() + '/familymembers'}');
    ///clients/{clientId}/familymembers
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString() + '/familymembers',
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
    if(newClientData != null) {
      setState(() {
        nextOfKin = newClientData;
        relationshipInt = nextOfKin[0]['relationshipId'];
        maritalInt = nextOfKin[0]['maritalStatusId'];
        genderInt = nextOfKin[0]['genderId'];
        titleInt = nextOfKin[0]['titleId'];
        nextOfKinTitle = nextOfKin[0]['title'];
        nextOfKinGender = nextOfKin[0]['gender'];
        nextOfKinMaritalStatus = nextOfKin[0]['maritalStatus'];
        nextOfKinrelationship = nextOfKin[0]['relationship'];
      });

    }

    firstname.text = nextOfKin[0]['firstName'];
    middlename.text = nextOfKin[0]['middleName'];
    lastname.text = nextOfKin[0]['lastName'];
    phonenumber.text = nextOfKin[0]['mobileNumber'];
    age.text = nextOfKin[0]['age'].toString();
    bsc.text = nextOfKin[0]['qualification'];

    prefs.setInt('tempNextOfKinInt', nextOfKin.isEmpty ? null :  nextOfKin[0]['id']);


    print('nextOfKin ${nextOfKin}');
  }

  getStateList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('27');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allStates = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectState.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectState);
    //
    //   setState(() {
    //     stateArray = collectState;
    //   });
    // }
    // );


    respose.then((response) async {
      print(response['data']);

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
            print(mtBool[i]['name']);
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
          print(newEmp[i]['name']);
          collectState.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectState);

        setState(() {
          stateArray = collectState;
        });
      }


    }
    );

  }

  getResidentialList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('45');
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allResidential = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectResidential.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectResidential);
    //
    //   setState(() {
    //     residentialArray = collectResidential;
    //   });
    // }
    // );


    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsResidential'));

        if(prefs.getString('prefsResidential').isEmpty){
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
            allResidential = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectResidential.add(mtBool[i]['name']);
          }

          setState(() {
            residentialArray = collectResidential;
            _isConnected = false;
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

        prefs.setString('prefsResidential', jsonEncode(newEmp));


        setState(() {
          allResidential = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectResidential.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectResidential);

        setState(() {
          residentialArray = collectResidential;
        });
      }


    }
    );






  }

  getSubAccount(int FirstValue,int SecondValue){

    final Future<Map<String,dynamic>> respose =   RetCodes().getSubValues(FirstValue,SecondValue);
    // respose.then((response) {
    //   print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //   print(newEmp);
    //   setState(() {
    //     allLga = newEmp;
    //   });
    //   setState(() {
    //     collectLga = [];
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     print(newEmp[i]['name']);
    //     collectLga.add(newEmp[i]['name']);
    //   }
    //   print('vis alali');
    //   print(collectLga);
    //
    //
    //   setState(() {
    //     lgaArray = collectLga;
    //   });
    // }
    // );

    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsResidentialLga'));

        if(prefs.getString('prefsResidentialLga').isEmpty){
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
            print(mtBool[i]['name']);
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

        prefs.setString('prefsResidentialLga', jsonEncode(newEmp));
        setState(() {
          collectLga = [];
        });

        setState(() {
          allLga = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectLga.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectLga);

        setState(() {
          lgaArray = collectLga;
        });
      }


    }
    );


  }

  getClientResidentialInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getResidentialClient + localclientID.toString() + '/addresses',
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


    setState(() {
      residentialProfile = newClientData;
      stateInt = residentialProfile[0]['stateProvinceId'];
      lgaInt = residentialProfile[0]['lgaId'];
      residentialInt = residentialProfile[0]['residentStatusId'];
      residentialStatus = residentialProfile[0]['residentStatus'];
      residentialLga = residentialProfile[0]['lga'];
      residentialState = residentialProfile[0]['stateName'];

    });

    print('residentialProfile ${residentialProfile}');

    permanent_address.text = residentialProfile[0]['addressLine1'];

    nearest_landmark.text = residentialProfile[0]['nearestLandMark'];

    //  prefs.setInt('tempResidentialInt', residentialProfile.isEmpty ? null :  residentialProfile[0]['addressId']);



    //  year_at_residence = ResidentialNoOfYears.toString();

  }

  getNextOfKinResidentialInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    print('${AppUrl.getResidentialClient + localclientID.toString() + '/addresses'}');
    Response responsevv = await get(
      AppUrl.getResidentialClient + localclientID.toString() + '/addresses',
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


    if(newClientData != null || newClientData[1] != null)
    {
      setState(() {
        residentialProfile = newClientData;
        // print('residential Profile ${residentialProfile[1]}');
        stateInt = residentialProfile[1]['stateProvinceId'];
        lgaInt = residentialProfile[1]['lgaId'];
        residentialInt = residentialProfile[1]['residentStatusId'];
        residentialStatus = residentialProfile[1]['residentStatus'];
        residentialLga = residentialProfile[1]['lga'];
        residentialState = residentialProfile[1]['stateName'];

      });
    }


    print('residentialProfile address ID ${residentialProfile}');

    permanent_address.text = residentialProfile[1]['addressLine1'];

    nearest_landmark.text = residentialProfile[1]['nearestLandMark'];





    prefs.setInt('tempResidentialNextOfKinInt', residentialProfile[1].isEmpty || residentialProfile[1] == null ? null :  residentialProfile[1]['addressId']);



    //  year_at_residence = ResidentialNoOfYears.toString();

  }


  undoResidential(){
    setState(() {
      // residentialProfile = newClientData;
      stateInt;
      lgaInt;
      residentialInt ;
      residentialStatus = '';
      residentialLga ='';
      residentialState ='';
      permanent_address.text = '';
      nearest_landmark.text = '';

    });
  }


  @override
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController bsc = TextEditingController();

  int residentialInt;
  bool value = false;

  TextEditingController permanent_address = TextEditingController();
  TextEditingController nearest_landmark = TextEditingController();
  TextEditingController dateMovedIn = TextEditingController();

  bool _isLoading = false;

  final _form = GlobalKey<FormState>(); //for storing form state.

  int titleInt,relationshipInt,maritalInt,genderInt,professionInt;
  AddClientProvider addClientProvider = AddClientProvider();

  Widget build(BuildContext context) {

    var submitEmploymentInfo = () async{

      // return   MyRouter.pushPage(context, BankDetails());

      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();



      int getNextOfKin = prefs.getInt('tempNextOfKinInt');

      int getResidential = prefs.getInt('tempResidentialNextOfKinInt');
      print('residential Int ${getResidential}');
      setState(() {
        _isLoading = true;
      });
      Map<String,dynamic> addNextOfKin= {
        'clientId':   ClientInt == null ? prefs.getInt('clientId') : ClientInt,
        "id": getNextOfKin == null ? null : getNextOfKin,
        'title': titleInt,
        'firstname':firstname.text,
        'middlename': middlename.text,
        "lastname": lastname.text,
        'phonenumber': phonenumber.text,
        'age': 0,
        'qualification': '',
        'relationship_with_nok': relationshipInt,
        'maritalStatus':maritalInt,
        'gender': genderInt ,
        'profession': professionInt
      };

      Map<String,dynamic> nextOfKinResidence= {
        'clientId':   ClientInt == null ? prefs.getInt('clientId') : ClientInt,
        'id': getResidential == null ? null : getResidential,
        //  'id':null,
        'residential_state': stateInt,
        'lga':lgaInt,
        'address_type_id':38,
        'permanent_address': permanent_address.text,
        "nearest_landmark": nearest_landmark.text,

      };
      
      print('this is next Of kin residential ${nextOfKinResidence}');
      int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

      PostAndPut postAndPut = new PostAndPut();
      postAndPut.isClientActive(localclientID).then(
            (value)  {

              String client_status = value.toString();

              final Future<Map<String,dynamic>> respose2 =  addClientProvider.addResidential(nextOfKinResidence,client_status);

              final Future<Map<String,dynamic>> respose =  addClientProvider.addNextOfKin(addNextOfKin,client_status);


              print('start response from login');

              print(respose.toString());

              respose.then((response) {

                AppTracker().trackActivity('ADD/UPDATE NEXT OF KIN',payLoad:
                {
                  ...nextOfKinResidence,
                  "response": response.toString()
                });

                if( response == null || response['status'] == null || response['status'] == false ){
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


                    if( prefs.getBool('isLight') != null && !prefs.getBool('isLight') ){
                      return MyRouter.pushPage(context, DocumentUpload());
                    }

                    return MyRouter.pushPage(context, BankDetails());
                  }

                  Flushbar(
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
                  if(comingFrom == 'CustomerPreview'){
                    return  MyRouter.pushPage(context, CustomerPreview());
                  }
                  if(comingFrom == 'SingleCustomerScreen'){
                    return  MyRouter.pushPage(context, SingleCustomerScreen(clientID: ClientInt,));
                  }

                  getNextOfKinInformation();

                  MyRouter.pushPage(context, BankDetails());
                  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                    backgroundColor: Colors.green,
                    title: "Success",
                    message: 'Client profile updated successfully',
                    duration: Duration(seconds: 3),
                  ).show(context);

                }

              }
              );

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
                ProgressStepper(stepper: 0.65,title: 'Next of Kin',subtitle: 'Bank Details',),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        child: Text('Ensure Next of Kin’s information is entered correctly',style: TextStyle(fontSize: 11),),
                      ),


                      Form(
                          key: _form,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: titleArray,
                                    onChange: (String item) async{
                                      setState(() {

                                        List<dynamic> selectID =   allTitle.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        titleInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Title * ",
                                    selectedItem: nextOfKinTitle,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, firstname, 'First Name *','Enter first name',TextInputType.name)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, middlename, 'Middle Name (optional)','Enter middlename ',TextInputType.name,needsValidation: false)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, lastname, 'Last Name *','Enter lastname',TextInputType.name)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, phonenumber, 'Phone Number *','Enter phone number',TextInputType.phone,maxLenghtAllow: 11)
                              ),
                              // Padding(
                              //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //     child: EntryField(context, age, 'Age ','--',TextInputType.number)
                              // ),
                              // Padding(
                              //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //     child: EntryField(context, bsc, 'Qualification ','BSc',TextInputType.name)
                              // ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: relationshipArray,
                                    onChange: (String item) async{
                                      setState(() {

                                        List<dynamic> selectID =   allRelationship.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        relationshipInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Relationship",
                                    selectedItem: nextOfKinrelationship,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: maritalArray,
                                    onChange: (String item) async{
                                      setState(() {

                                        List<dynamic> selectID =   allMarital.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        maritalInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Marital Status",
                                    selectedItem: nextOfKinMaritalStatus,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: genderArray,
                                    onChange: (String item) async{
                                      setState(() {

                                        List<dynamic> selectID =   allGender.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        genderInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Gender",
                                    selectedItem: nextOfKinGender,
                                    validator: (String item){
                                      if(item == null){
                                        return 'Gender cannot be empty';

                                      }
                                    }
                                ),
                              ),


                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Next of Kin Residential information',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Nunito Bold'),),
                                    Row(
                                      children: [
                                        Text('Same as Client\'s Residential Address'),
                                        Checkbox(
                                          value: this.value,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.value = value;
                                            });
                                            value == true ? getClientResidentialInformation() : undoResidential();
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: stateArray,
                                    onChange: (String item){
                                      setState(() {
                                        List<dynamic> selectID =   allStates.where((element) => element['name'] == item).toList();
                                        stateInt = selectID[0]['id'];
                                        getSubAccount(27, stateInt);
                                        print(stateInt);
                                        lgaInt = 0;
                                        residentialInt = 0;
                                        //residentialStatus = '';
                                        residentialLga = '';
                                        permanent_address.text ='';
                                        nearest_landmark.text = '';
                                        // residentialState = '';
                                      });
                                    },
                                    label: "Permanent Residential State",
                                    selectedItem: residentialState,
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
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        lgaInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "LGA * ",
                                    selectedItem: residentialLga,
                                    validator: (String item){
                                      // true and true
                                      if(lgaInt == 0 || lgaInt == null && _isConnected){
                                        return 'LGA is required';
                                      }
                                    }
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, permanent_address, 'Permanent Address *','Enter permanent address',TextInputType.name)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, nearest_landmark, 'Nearest Landmark *','Enter landmark',TextInputType.name)
                              ),

                            ],
                          )),


                      SizedBox(height: 50,),
                    ],
                  ),
                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction2: (){
          submitEmploymentInfo();
          //  MyRouter.pushPage(context, BankDetails());
        },callAction1: (){
          MyRouter.popPage(context);
        },),
      ),
    );
  }

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool isRead = false,bool needsValidation = true}){
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

}

