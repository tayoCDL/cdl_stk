import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addLead.dart';
import 'package:sales_toolkit/views/leads/EmploymentInfo.dart';
import 'package:sales_toolkit/views/leads/singleLeadView.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LeadPersonalInfo extends StatefulWidget {
  // const PersonalInfo({Key key}) : super(key: key);
  //
  // @override
  // _PersonalInfoState createState() => _PersonalInfoState();

  //title,gender,noOfDeps
  final int leadInt,PassedtitleInt,PassedgenderInt,
      leadCategory,leadRating,leadSource,empInt,
      PassednoOfdepsInt,PassededucationInt;
  final String bvnFirstName,bvnMiddleName,bvnLastName,bvnEmail,bvnPhone1,bvnPhone2,comingFrom,projectedInflow,bvn,leadType;
  const LeadPersonalInfo({Key key,this.leadInt,this.bvnFirstName,this.bvnMiddleName,this.bvnLastName,this.bvnEmail,this.bvnPhone1,this.bvnPhone2,this.comingFrom,this.PassedtitleInt,
    this.PassedgenderInt,this.PassednoOfdepsInt,this.PassededucationInt,
  this.leadCategory,this.leadRating,this.leadType,this.leadSource,this.projectedInflow,this.bvn,this.empInt
  }) : super(key: key);
  @override
  _LeadPersonalInfoState createState() => _LeadPersonalInfoState(
      leadInt: this.leadInt,
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


      leadCategory: this.leadCategory,
      leadRating: this.leadRating,
      leadType: this.leadType,
      leadSource: this.leadSource,
      projectedInflow: this.projectedInflow,
      bvn: this.bvn,
      empInt:this.empInt
  );
}

class _LeadPersonalInfoState extends State<LeadPersonalInfo> {
  int leadInt,PassedtitleInt,PassedgenderInt,PassednoOfdepsInt,PassededucationInt,leadCategory,leadRating,leadSource,empInt;
  String bvnFirstName,bvnMiddleName,bvnLastName,bvnEmail,bvnPhone1,bvnPhone2,comingFrom,projectedInflow,bvn,leadType;
  _LeadPersonalInfoState({this.leadInt,this.bvnFirstName,this.bvnMiddleName,
    this.bvnLastName,this.bvnEmail,
    this.bvnPhone1,this.bvnPhone2,this.comingFrom,this.PassednoOfdepsInt,
    this.PassedgenderInt,this.PassedtitleInt,this.PassededucationInt,
    this.leadCategory,this.leadRating,this.leadType,this.leadSource,
    this.projectedInflow,this.bvn,this.empInt});

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
  String realMonth = '';
  String educationLevel = '';
  String maritalStatus = '';
  var leadInfo = {};
  int tempClientID = null;

  void initState() {
    // TODO: implement initState
      getTitleList();
      getGenderList();
      getMaritalList();
      getEducationLevelList();
      getLeadInformation();
      firstname.text = bvnFirstName;
      lastname.text = bvnLastName;
      middlename.text = bvnMiddleName;
      emailaddress.text = bvnEmail;
       phoneNumber.text = bvnPhone1;
       titleInt = PassedtitleInt;
       genderInt = PassedgenderInt;
       educationInt = PassededucationInt;
       no_of_dependents = PassednoOfdepsInt.toString();

       print('All Data ${firstname.text} ${no_of_dependents} ${middlename.text} ${no_of_dependents} ${titleInt} ${genderInt}');

      final now = new DateTime.now();
     //   print('this is nwo ${now}');

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

    setState(() {
      _isLoading = true;
    });
    respose.then((response) async {
      setState(() {
        _isLoading = false;
      });
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
      print(response['data']);

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsMarital'));

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

        prefs.setString('prefsMarital', jsonEncode(newEmp));


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
        });
      }


    }
    );

  }

  getLeadInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    int localclientID =   leadInt == null ? prefs.getInt('leadId') : leadInt;
    print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    ///clients/{clientId}/familymembers
    Response responsevv = await get(
      AppUrl.getSingleLead + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);
    // if(response.body.isNotEmpty) {
    //   json.decode(response.body);
    // }
    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);

    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      leadInfo = newClientData;

if(!leadInfo.isEmpty){
  var PreleadInfo  = newClientData['moreInfo']['clients'];
  // leadRating = leadInfo['leadRating']['id'];
  // leadType = int.tryParse(leadInfo['leadTypeId']);
   tempClientID = PreleadInfo['id'];
  // leadCategory = leadInfo['leadCategory']['id'];
  // leadSource =leadInfo['leadSource']['id'];
  titleInt = PreleadInfo['title']['id'];
  title = PreleadInfo['title']['name'];
  genderInt = PreleadInfo['gender']['id'];
  gender = PreleadInfo['gender']['name'];
  maritalInt = PreleadInfo['maritalStatus']['id'];
  marital_status = PreleadInfo['maritalStatus']['name'];
  educationInt = PreleadInfo['educationLevel']['id'];
  educationLevel =  PreleadInfo['educationLevel']['name'];

  client_dependent_number = PreleadInfo['numberOfDependent'] == null ? 0 : PreleadInfo['numberOfDependent'];


  // projectedInflow = (leadInfo['expectedRevenueIncome']).toString();

  firstname.text = PreleadInfo['firstname'];
  middlename.text = PreleadInfo['middlename'];
  lastname.text = PreleadInfo['lastname'];
  phoneNumber.text = PreleadInfo['mobileNo'];
  emailaddress.text = PreleadInfo['emailAddress'];



  dateController.text = retDOBfromBVN('${PreleadInfo['dateOfBirth'][0]}-${PreleadInfo['dateOfBirth'][1]}-${PreleadInfo['dateOfBirth'][2]}');
}


    });

   // prefs.setInt('tempLeadInt', leadInfo.isEmpty ? null :  leadInfo['id'] ? );
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
    if(prefs.getInt('employment_type') == null){
      prefs.setString('employment_type', newClientData['employmentSector']['id']);
    }

    var getNewBvn  = prefs.getString('inputBvn');
    print('newBvn ${getNewBvn} ${newClientData['bvn']}');

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


  String no_of_dependents = '';
  String marital_status = '';
  int client_dependent_number = 0;
  DateTime selectedDate = DateTime.now();
  DateTime CupertinoSelectedDate = DateTime.now();
  AddLeadProvider addLeadProvider = AddLeadProvider();
  Map<String,dynamic> mergedOfflineClient = {};


  File uploadimage;


  Widget build(BuildContext context) {

    var submitPersonalInfo = () async{
    //  return  MyRouter.pushPage(context, EmploymentInfo());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
        int PassedInt = prefs.getInt('leadId');
        int passedCLientInt = prefs.getInt('clientId');
    String personals =   prefs.getString('prefsPersonalData');

     // print('date Of Birth ${dateController.text}');
        dateController.text.isEmpty ? print("hi") : print('jddj');
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

        setState(() {
          _isLoading = true;
        });


      Map<String,dynamic> personalData= {
        "leadSourceId" : leadSource,
        "leadCategoryId" : leadCategory,
        "leadTypeId" : leadType,
        "locale": "en",
        "expectedRevenueIncome" : projectedInflow,
        "leadRatingId" : leadRating,
        'id':leadInt == null ? PassedInt : leadInt,
        'clientId':tempClientID == null ? passedCLientInt : tempClientID,
        'firstname': firstname.text.toUpperCase().substring(0,1)+firstname.text.toLowerCase().substring(1),
        'lastname':lastname.text.toUpperCase().substring(0,1)+lastname.text.toLowerCase().substring(1),
        'middlename': middlename.text,
        'phoneNumber': phoneNumber.text,
        // 'alt_phoneNumber': alt_phoneNumber.text,
        'emailAddress': emailaddress.text,
        'dateController': dateController.text,
        'title':titleInt,
        'gender':genderInt,
        'no_of_dependents': int.tryParse(no_of_dependents),
        'marital_status': maritalInt,
        // 'bvn': prefs.getString('inputBvn'),
        'educationLevel': educationInt,
        // 'employmentSectorId': prefs.getInt('employment_type')
      };
      final Future<Map<String,dynamic>> respose =  addLeadProvider.addPersonal(personalData);
      print('start response from login');

      print(respose.toString());

      respose.then((response) {

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

            return MyRouter.pushPage(context, LeadEmploymentInfo());
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
          if(comingFrom == 'LeadSingleView'){
            return  MyRouter.pushPage(context, ViewLead(leadID: leadInt,));
          }

          MyRouter.pushPage(context, LeadEmploymentInfo());

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
                        child: Text('All fields are optional except first name ,last name and phone number',style: TextStyle(fontSize: 11),),
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
                                selectedItem: title,
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
                              child: EntryField(context, firstname, 'First Name*','First name',TextInputType.name,maxLenghtAllow: 11,isRead: false,)
                          ),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: EntryField(context, middlename, 'Middle Name (optional)','Middle name',TextInputType.name,maxLenghtAllow: 11,isRead: false,needsValidation: false)
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: EntryField(context, lastname, 'Last Name*','Last name',TextInputType.name,maxLenghtAllow: 11,isRead: false)
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child:
                            DropDownComponent(items: genderArray,
                                onChange: (String item){
                                  setState(() {

                                    List<dynamic> selectID =   allGender.where((element) => element['name'] == item).toList();
                                    print('this is select ID');
                                    print(selectID[0]['id']);
                                    genderInt = selectID[0]['id'];
                                    print('end this is select ID');

                                  });
                                },
                                label: "Gender",
                                selectedItem: gender,
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

                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
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
                                        ),

                                        focusedBorder:OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                                        ),
                                        border: OutlineInputBorder(

                                        ),
                                        labelText: 'Date Of Birth',
                                    //    floatingLabelStyle: TextStyle(color:Color(0xff205072)),
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
                                    educationLevel = item;
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
                                label: "No. Of dependednts",
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
                              child: EntryField(context, phoneNumber, 'Phone Number*','Phone number',TextInputType.phone,maxLenghtAllow: 11,needsValidation: false)
                          ),
                          // Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          //     child: EntryField(context, alt_phoneNumber, 'Alt. Phone number*','223345667',TextInputType.phone,maxLenghtAllow: 11)
                          // ),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: EntryField(context, emailaddress, 'Email Address*','Enter email address',TextInputType.emailAddress,needsValidation: false)
                          ),
                          SizedBox(height: 50,),
                        ],
                      )),


                    ],
                  ),
                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction2: (){
          // MyRouter.pushPage(context, EmploymentInfo());
          submitPersonalInfo();
        },callAction1: (){
          MyRouter.popPage(context);
        },),
      ),
    );
  }

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool isRead = false,needsValidation = true}){
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
                     // else if(EmailValidator.validate(emailaddress.text)){
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
                  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
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

}


