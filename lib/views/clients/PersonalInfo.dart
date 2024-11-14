import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/view_models/post_put_method.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/EmploymentInfo.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  // const PersonalInfo({Key key}) : super(key: key);
  //
  // @override
  // _PersonalInfoState createState() => _PersonalInfoState();

  //title,gender,noOfDeps
  //passedNin
  final int ClientInt,PassedtitleInt,PassedgenderInt,PassednoOfdepsInt,PassededucationInt,passedEmployerSector,passedEmployerCategory;
  final String bvnFirstName,bvnMiddleName,bvnLastName,bvnEmail,bvnPhone1,bvnPhone2,comingFrom,dateOfBirth,Passedgender,PassedAccountNumber,PassedBankCode,PassedAccountName,passedBVN ;
  const PersonalInfo({Key key,this.ClientInt,this.bvnFirstName,
    this.bvnMiddleName,this.bvnLastName,this.bvnEmail,
    this.bvnPhone1,this.bvnPhone2,
    this.comingFrom,this.PassedtitleInt,this.PassedgenderInt,
    this.PassednoOfdepsInt,this.PassededucationInt,
    this.PassedAccountName,
    this.PassedAccountNumber,
    this.PassedBankCode,
    this.passedBVN,
    // this.passedNin,
    this.passedEmployerCategory,
    this.passedEmployerSector,
    this.dateOfBirth,this.Passedgender}) : super(key: key);
  @override
  _PersonalInfoState createState() => _PersonalInfoState(
      ClientInt: this.ClientInt,
      bvnFirstName: this.bvnFirstName,
      bvnMiddleName: this.bvnMiddleName,
      bvnLastName: this.bvnLastName,
      bvnEmail: this.bvnEmail,
      bvnPhone1: this.bvnPhone1,
      bvnPhone2: this.bvnPhone2,
      comingFrom: this.comingFrom,
      PassedtitleInt:this.PassedtitleInt,
      PassedgenderInt:this.PassedgenderInt,
      PassednoOfdepsInt:this.PassednoOfdepsInt,
      PassededucationInt: this.PassededucationInt,
      PassedAccountName: this.PassedAccountName,
      PassedAccountNumber: this.PassedAccountNumber,
      PassedBankCode:this.PassedBankCode,
      dateOfBirth:this.dateOfBirth,
      Passedgender:this.Passedgender,
      passedBVN:this.passedBVN,
      // passedNin: this.passedNin,
      passedEmployerCategory:this.passedEmployerCategory,
      passedEmployerSector: this.passedEmployerSector
  );
}

class _PersonalInfoState extends State<PersonalInfo> {
  // passedNin
  int ClientInt,PassedtitleInt,PassedgenderInt,PassednoOfdepsInt,PassededucationInt,passedEmployerCategory,passedEmployerSector;
  String bvnFirstName,bvnMiddleName,bvnLastName,bvnEmail,bvnPhone1,bvnPhone2,comingFrom,dateOfBirth,Passedgender,PassedAccountNumber,PassedBankCode,PassedAccountName,passedBVN ;
  _PersonalInfoState({this.ClientInt,this.bvnFirstName,
    this.bvnMiddleName,this.bvnLastName,
    this.bvnEmail,this.bvnPhone1,this.bvnPhone2,
    this.comingFrom,this.PassednoOfdepsInt,
    this.PassedgenderInt,this.PassedtitleInt,
    this.PassededucationInt,this.dateOfBirth,
    this.Passedgender,
    this.PassedAccountName,
    this.PassedAccountNumber,
    this.PassedBankCode,
    this.passedBVN,
    // this.passedNin,
    this.passedEmployerCategory,
    this.passedEmployerSector
  });

  final _form = GlobalKey<FormState>(); //for storing form state.


  @override

  List<String> titleArray = [];
  List<String> collectTitle = [];
  List<dynamic> allTitle = [];

  List<String> genderArray = [];
  List<String> collectGender = [];
  List<dynamic> allGender = [];

  List<String> maritalArray = [];
  List<String> collectMarital = [];
  List<dynamic> allMarital = [];

  List<String> educationArray = [];
  List<String> collectEducation = [];
  List<dynamic> allEducation = [];
  bool _isLoading = false;
  String bvnGender = '';
  String realMonth ='';
  String _title = '';
  String educationLevel = '';
  var personalInfo = {};
  int localInt,newLocalClient;
  void initState() {
    // TODO: implement initState
    if(ClientInt != null){
      getPersonalInformation();
    }
     getTitleList();
    getGenderList();
    getMaritalList();
    getEducationLevelList();
    //   print('ClientInt ${ClientInt} passedAccountnumber ${PassedAccountNumber} passedAccountName ${PassedAccountName}');
    firstname.text = bvnFirstName;
    lastname.text = bvnLastName;
    middlename.text = bvnMiddleName;
    emailaddress.text = bvnEmail;
    phoneNumber.text = bvnPhone1;
    dateController.text = dateOfBirth == null ? '' : retsNx360dates(DateTime.parse(dateOfBirth));
    titleInt = PassedtitleInt;
    genderInt = PassedgenderInt;
    educationInt = PassededucationInt;
    no_of_dependents = PassednoOfdepsInt.toString();

    bvnGender = Passedgender;
    final now = new DateTime.now();

    getTemClientID();

    super.initState();
  }

  getTemClientID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int VlocalclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;
    // print('localInt ${localclientID}');

      if(comingFrom == ''){
        prefs.remove('clientId');

      }

    setState(() {
      localInt = prefs.getInt('clientId');
      newLocalClient = ClientInt;
    });
  }

  getPersonalInformation() async{

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
      personalInfo = newClientData;
      titleInt = newClientData['title']['id'];
      _title = newClientData['title']['name'];
      genderInt = newClientData['gender']['id'];
      marital_status = newClientData['maritalStatus']['name'];
      educationInt = newClientData['educationLevel']['id'];
      educationLevel = newClientData['educationLevel']['name'];
      alt_phoneNumber.text = newClientData['alternateMobileNo'];
      client_dependent_number = newClientData['numberOfDependent'] == null ? 0 : newClientData['numberOfDependent'];
      client_status = newClientData['status']['value'];
      dateController.text = retDOBfromBVN('${newClientData['dateOfBirth'][0]}-${newClientData['dateOfBirth'][1]}-${newClientData['dateOfBirth'][2]}');

    });

    print('maritalInt ${maritalInt}');
    prefs.setInt('tempClientInt', personalInfo.isEmpty ? null :  personalInfo['id']);
    if(prefs.getString('inputBvn') == null){
      print('is true ${prefs.getString('inputBvn') }');
    }
    else {
      print('is false ${prefs.getString('inputBvn') }');
    }
    if(prefs.getString('inputBvn') == null){
      var newBvn =  prefs.setString('inputBvn', newClientData['bvn']);
      print('new Input Bvn ${newBvn}');
    }
    // if(prefs.getInt('employment_type') == null){
    //   prefs.setString('employment_type', newClientData['employmentSector']['id']);
    // }

    var getNewBvn  = prefs.getString('inputBvn');
    print('newBvn ${getNewBvn} ${newClientData['bvn']}');

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

      }
      else {
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
          List<dynamic> selectID =   allTitle.where((element) => element['name'] == _title).toList();
          titleInt = selectID[0]['id'];

        });
      }

    }
    );
  }

  getGenderList(){
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
          List<dynamic> selectID =   allGender.where((element) => element['name'] == bvnGender).toList();
          genderInt = selectID[0]['id'];
          print('gender In from Init ${genderInt}');
        });
      }


    }
    );

  }

  getMaritalList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('30');
    // respose.then((response) {
    //   print('marital array');
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
      print(response['message']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsMarital'));

        if(prefs.getString('prefsMarital').isEmpty){

          print('this is isConnected = ${isConnected}');
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

          if(response['message'] == 'Network error'){
            setState(() {
              isConnected = false;
            });
          }

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

        prefs.setString('prefsMarital', jsonEncode(newEmp));


        setState(() {
          allMarital = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectMarital.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectGender);

        setState(() {
          maritalArray = collectMarital;
          print('marital Int ${maritalInt}');
          //  List<dynamic> selectID =   allMarital.where((element) => element['name'] == marital_status).toList();
          //  maritalInt = selectID[0]['id'];
        });
      }


    }
    );

  }

  getEducationLevelList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('38');
    // respose.then((response) {
    //   print('marital array');
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

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEducation'));

        if(prefs.getString('prefsEducation').isEmpty){
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
            allEducation = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectEducation.add(mtBool[i]['name']);
          }

          setState(() {
            educationArray = collectEducation;
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

        prefs.setString('prefsEducation', jsonEncode(newEmp));


        setState(() {
          allEducation = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectEducation.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectEducation);

        setState(() {
          educationArray = collectEducation;
          List<dynamic> selectID =   allEducation.where((element) => element['name'] == educationLevel).toList();
          //   educationInt = selectID[0]['id'];

        });
      }


    }
    );

  }


  @override
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController alt_phoneNumber = TextEditingController();
  // TextEditingController EmailAddress = TextEditingController();
  TextEditingController emailaddress = TextEditingController();
  TextEditingController dateController = TextEditingController();


  String date = "";
  String title = '';
  String gender ='';

  int dateInt,titleInt,genderInt,maritalInt,educationInt ;

  bool isConnected = true;
  String no_of_dependents = '';
  String marital_status = '';
  int client_dependent_number = 0;
  String client_status='';
  DateTime selectedDate = DateTime.now();
  DateTime CupertinoSelectedDate = DateTime.now();
  AddClientProvider addClientProvider = AddClientProvider();
  Map<String,dynamic> mergedOfflineClient = {};


  File uploadimage;


  Widget build(BuildContext context) {

    var submitPersonalInfo = () async{
      //  return  MyRouter.pushPage(context, EmploymentInfo());
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String personals =   prefs.getString('prefsPersonalData');

      int getClientID = prefs.getInt('tempClientInt');
      int newClientID = prefs.getInt('clientId');


      String getBVN = prefs.getString('inputBvn');
      int emptType = prefs.getInt('employment_type');
      int getEmploymentsector = prefs.getInt('emp_category');

      print('real tempCLient ID ${newClientID} ${getClientID} ${getBVN} ${emptType} ${getEmploymentsector}');
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      setState(() {
        _isLoading = true;
      });


      //  personalData['middlename'].toUpperCase()+personalData['middlename'].substring(1)
      Map<String,dynamic> personalData= {
        //'id':ClientInt == null ? newClientID: getClientID : ClientInt,
        'id': ClientInt == null ? newClientID: newClientID == null ? getClientID : ClientInt,
        'firstname': firstname.text.toUpperCase().substring(0,1)+firstname.text.toLowerCase().substring(1),
        'lastname':lastname.text.toUpperCase().substring(0,1)+lastname.text.toLowerCase().substring(1),
        'middlename': middlename.text,
        'phoneNumber': phoneNumber.text,
        //'phoneNumber': '09011294224',
        'alt_phoneNumber': alt_phoneNumber.text,
        'emailAddress': emailaddress.text,
        'dateController': dateController.text,
        'title':titleInt,
        'gender':genderInt,
        'no_of_dependents': int.tryParse(no_of_dependents),
        'marital_status': maritalInt,
        'bvn': passedBVN,
        // 'nin': passedNin,
        'clientTypeId': passedEmployerCategory,
        'employmentSectorId': passedEmployerSector,
        'educationLevel': educationInt,
        // 'employmentSectorId': prefs.getInt('employment_type')
      };


      final Future<Map<String,dynamic>> respose =  addClientProvider.addPersonal(personalData,client_status);
      print('start response from login');

      print(respose.toString());

      respose.then((response) {
        AppTracker().trackActivity('ADD/UPDATE CLIENT',payLoad:
        {
          ...personalData,
          "response": response.toString()
        });
        if(response == null || response['status'] == null ||  response['status'] == false){
          setState(() {
            _isLoading = false;
          });
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Network Error',
            message: 'Unknown error occured',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        if(response['status'] == false){
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

            return MyRouter.pushPage(context, EmploymentInfo());
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
          print('account numhweh ${PassedAccountName} ${PassedAccountNumber}');
          if(PassedAccountName != null && PassedAccountNumber != ''){

            Map<String,dynamic> colBankData= {
              'id':null,
              'clientId':   prefs.getInt('clientId') ,
              'account_number': PassedAccountNumber,
              "accountName": PassedAccountName,
              'bankId':PassedBankCode
            };

            final Future<Map<String,dynamic>> respose =  addClientProvider.addBankDetails(colBankData,client_status);
            respose.then((response) async{
              print('from bankIDcode ${response['message']}');
            });
          }


          setState(() {
            _isLoading = false;
          });
          if(comingFrom == 'CustomerPreview'){
            return  MyRouter.pushPage(context, CustomerPreview());
          }
          if(comingFrom == 'SingleCustomerScreen'){
            return  MyRouter.pushPage(context, SingleCustomerScreen(clientID: ClientInt,));
          }


          MyRouter.pushPage(context, EmploymentInfo());

          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: response['data']['defaultUserMessage'],
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
      //  isLoading: codePan.length == 0 ? true : false,
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      // isLoading: addClientProvider.addStatus == Status.Sending ? true : false,
      child: Scaffold(

        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProgressStepper(stepper: 0.1,title: 'Personal Details',subtitle: 'Employment Details',),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text('Ensure you enter correct information, some of the information provided will later be matched with your BVN details.',style: TextStyle(fontSize: 11),),
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
                                        title = item;
                                        List<dynamic> selectID =   allTitle.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        titleInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Title",
                                    selectedItem: _title,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              // Padding(
                              //     padding: EdgeInsets.
                              //
                              // ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, firstname, 'First Name*','First name',TextInputType.name,maxLenghtAllow: 11,isRead: isConnected)
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, middlename, 'Middle Name (optional)','Middle name',TextInputType.name,maxLenghtAllow: 11,isRead: false,needsValidation: false)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, lastname, 'Last Name*','Last name',TextInputType.name,maxLenghtAllow: 11,isRead: isConnected)
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child:
                                DropDownComponent(items: genderArray,
                                    popUpDisabled: (String s) {
                                      if(isConnected == true){
                                        return  s.startsWith('Male') || s.startsWith('Female');
                                      }
                                      else {

                                      }

                                    } ,
                                    onChange: (String item){
                                      setState(() {

                                        String realGender =  bvnGender == '' ? item : bvnGender;

                                        List<dynamic> selectID =   allGender.where((element) => element['name'] == realGender).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        genderInt = selectID[0]['id'];
                                        print('end this is select ID');
                                      });
                                    },
                                    label: "Gender",
                                    selectedItem: bvnGender == '' ? "Select Gender" : bvnGender,
                                    validator: (String item){

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
                                        controller: dateController,

                                        //comingFrom == 'CustomerPreview'
                                        // true and comingfrom customer preview is true
                                        decoration: InputDecoration(
                                            suffixIcon: isConnected  ? null :
                                            IconButton(
                                              onPressed: (){
                                               // showDatePicker();
                                                DatePicker.showDatePicker(context,
                                                    showTitleActions: true,
                                                    minTime: DateTime(1955, 3, 5),
                                                    maxTime:  DateTime.now().add(Duration(days: 0,hours: 2)),
                                                    onChanged: (date) {
                                                      print('change $date');
                                                      setState(() {
                                                        String retDate = retsNx360dates(date);
                                                        dateController.text = retDate;
                                                      });
                                                    }, onConfirm: (date) {
                                                      print('confirm $date');
                                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                                              },
                                              icon:   Icon(Icons.date_range,color: Colors.blue
                                                ,) ,
                                            ) ,

                                            focusedBorder:OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                                            ),
                                            border: OutlineInputBorder(

                                            ),
                                            labelText: 'Date Of Birth',
                                            //   floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                            hintText: 'Date Of Birth',
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
                                child: DropDownComponent(items: educationArray,
                                    onChange: (String item) async{
                                      setState(() {
                                        title = item;
                                        List<dynamic> selectID =   allEducation.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        educationInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Education level",
                                    selectedItem: educationLevel,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: maritalArray,
                                    onChange: (String item){
                                      setState(() {

                                        List<dynamic> selectID =   allMarital.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        maritalInt = selectID[0]['id'];
                                        print('end this is select ID');

                                      });
                                    },
                                    label: "Marital Status",
                                    selectedItem: marital_status,
                                    validator: (String item){

                                    }
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: ["0","1","2",'3','4','5','6','7','8','9','10'],
                                    onChange: (String item){
                                      setState(() {
                                        no_of_dependents = item;
                                      });
                                    },
                                    label: "No. Of dependents",
                                    selectedItem: client_dependent_number.toString(),
                                    validator: (String item){

                                    }
                                ),
                              ),



                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

                                    child: Text('Contact Information',style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold,fontFamily: 'Nunito Bold'),),
                                  ),
                                  Text('')
                                ],
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, phoneNumber, 'Phone Number*','Phone number',TextInputType.phone,maxLenghtAllow: 11,isRead: isConnected)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, alt_phoneNumber, 'Alt. Phone number*','Phone number',TextInputType.phone,maxLenghtAllow: 11,needsValidation: false)
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, emailaddress, 'Email Address*','Enter email address',TextInputType.emailAddress,needsValidation: false)
                              ),
                              SizedBox(height: 50,),
                            ],
                          )),




                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center, //content alignment to center
                      //   children: <Widget>[
                      //     Container(  //show image here after choosing image
                      //         child:uploadimage == null?
                      //         Container(): //if uploadimage is null then show empty container
                      //         Container(   //elese show image here
                      //             child: SizedBox(
                      //                 height:150,
                      //                 child:Image.file(uploadimage) //load image from file
                      //             )
                      //         )
                      //     ),
                      //
                      //     Container(
                      //       //show upload button after choosing image
                      //         child:uploadimage == null?
                      //         Container(): //if uploadimage is null then show empty container
                      //         Container(   //elese show uplaod button
                      //             child:RaisedButton.icon(
                      //               onPressed: (){
                      //                 uploadImage();
                      //                 //start uploading image
                      //               },
                      //               icon: Icon(Icons.file_upload),
                      //               label: Text("UPLOAD IMAGE"),
                      //               color: Colors.deepOrangeAccent,
                      //               colorBrightness: Brightness.dark,
                      //               //set brghtness to dark, because deepOrangeAccent is darker coler
                      //               //so that its text color is light
                      //             )
                      //         )
                      //     ),
                      //
                      //     Container(
                      //       child: RaisedButton.icon(
                      //         onPressed: (){
                      //           chooseImage(); // call choose image function
                      //         },
                      //         icon:Icon(Icons.folder_open),
                      //         label: Text("CHOOSE IMAGE"),
                      //         color: Colors.deepOrangeAccent,
                      //         colorBrightness: Brightness.dark,
                      //       ),
                      //     )
                      //   ],),

                    ],
                  ),
                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: addClientProvider.addStatus == Status.Sending ? 'Processing' : 'Next',callAction2: (){
          // MyRouter.pushPage(context, EmploymentInfo());
          submitPersonalInfo();
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
                  suffixIcon: isPassword == true ? Icon(Icons.remove_red_eye,color: Colors.black38
                    ,) : null,
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
  //     firstDate: DateTime(1967),
  //     lastDate: DateTime(2025),
  //   );
  //   if (selected != null && selected != selectedDate)
  //     setState(() {
  //       selectedDate = selected;
  //      print(selected);
  //       //  date = selected.toString();
  //
  //       String vasCoddd = retsNx360dates(selected);
  //
  //       dateController.text = vasCoddd;
  //
  //
  //     });
  // }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          color: Colors.grey,
          width: 1
      ),

    );
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
                          print(CupertinoSelectedDate);
                          String retDate = retsNx360dates(CupertinoSelectedDate);
                          print('ret Date ${retDate}');

                          //  retDOBfromBVN('2018-6-23');

                          dateController.text = retDate;
                        });

                    },
                    initialDateTime: DateTime.now().add(Duration(days: 0,hours: 1)),
                    minimumYear: 1960,
                    maximumDate: DateTime.now().add(Duration(days: 0,hours: 2)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        }
    );
  }



  retDOBfromBVN(String getDate){
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

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

    print('newOO ${newOO}');

    String concatss =  newOO + " " + realMonth + " " + o1   ;

    print("concatss new Date from edit ${concatss}");

    return concatss;


  }


  retsNx360dates(DateTime selected){

    print(selected);
    String newdate = selectedDate.toString().substring(0,10);
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

    String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;

    print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;

    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

}


