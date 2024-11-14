import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/NextofKin.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/post_put_method.dart';


class ResidentialDetails extends StatefulWidget {
  // const ResidentialDetails({Key key}) : super(key: key);
  //
  // @override
  // _ResidentialDetailsState createState() => _ResidentialDetailsState();

  final   int ClientInt,ResidentialPermanentResidentialState,ResidentialPermanentLGA,ResidentialStatus,ResidentialNoOfYears;
  final  String permanentAddress,nearestLandmark,ComingFrom;
  const ResidentialDetails({Key key,this.ResidentialPermanentResidentialState,this.ResidentialPermanentLGA,this.ResidentialStatus,this.ResidentialNoOfYears,this.permanentAddress,this.nearestLandmark,this.ComingFrom,this.ClientInt}) : super(key: key);
  @override
  _ResidentialDetailsState createState() => _ResidentialDetailsState(
      ResidentialPermanentResidentialState:this.ResidentialPermanentResidentialState,
      ResidentialPermanentLGA:this.ResidentialPermanentLGA,
      ResidentialStatus:this.ResidentialStatus,
      ResidentialNoOfYears:this.ResidentialNoOfYears,
      permanentAddress:this.permanentAddress,
      nearestLandmark:this.nearestLandmark,
      ComingFrom:this.ComingFrom,
      ClientInt:this.ClientInt
  );

}

class _ResidentialDetailsState extends State<ResidentialDetails> {

  int ClientInt,ResidentialPermanentResidentialState,ResidentialPermanentLGA,ResidentialStatus,ResidentialNoOfYears;
  String permanentAddress,nearestLandmark,ComingFrom;
  _ResidentialDetailsState({this.ResidentialPermanentResidentialState,this.ResidentialPermanentLGA,this.ResidentialStatus,this.ResidentialNoOfYears,this.permanentAddress,this.nearestLandmark,this.ComingFrom,this.ClientInt});


  @override

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


  DateTime CupertinoSelectedDate = DateTime.now();

  Map<String,dynamic> mergedOfflineClient = {};

  DateTime selectedDate = DateTime.now();

  final _form = GlobalKey<FormState>(); //for storing form state.


  void initState() {
    // TODO: implement initState


    getResidentialList();
    getStateList();
    // if(ClientInt != null){
      getResidentialInformation();
    // }

    stateInt = ResidentialPermanentResidentialState;
    lgaInt = ResidentialPermanentLGA;
    permanent_address.text = permanentAddress;
    residentialInt = ResidentialStatus;
    nearest_landmark.text = nearestLandmark;
    year_at_residence = ResidentialNoOfYears.toString();

    super.initState();
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

    setState(() {
      _isLoading = true;
    });
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
      setState(() {
        _isLoading = false;
      });

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

  getStateList(){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('27');
    setState(() {
      _isLoading = false;
    });
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
      setState(() {
        _isLoading = false;
      });
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
          _isLoading = false;
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

  getResidentialInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    print('localInt ${localclientID} ${prefs.getInt('clientId')}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print('${ AppUrl.getResidentialClient + localclientID.toString() + '/addresses'}');
    Response responsevv = await get(
        AppUrl.getResidentialClient + localclientID.toString() + '/addresses',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print('responsevv.body ${responsevv.statusCode}');

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
    prefs.setInt('tempResidentialInt', residentialProfile.isEmpty ? null :  residentialProfile[0]['addressId']);

    print('residentialProfile ${residentialProfile}');

    permanent_address.text = residentialProfile[0]['addressLine1'];

    nearest_landmark.text = residentialProfile[0]['nearestLandMark'];



    dateMovedIn.text = retDOBfromBVN('${residentialProfile[0]['dateMovedIn'][0]}-${residentialProfile[0]['dateMovedIn'][1]}-${residentialProfile[0]['dateMovedIn'][2]}');



    //  year_at_residence = ResidentialNoOfYears.toString();

  }



  @override

  int residentialInt;

  TextEditingController permanent_address = TextEditingController();
  TextEditingController nearest_landmark = TextEditingController();
  TextEditingController dateMovedIn = TextEditingController();

  bool _isLoading = false;


  AddClientProvider addClientProvider = AddClientProvider();

  Widget build(BuildContext context) {



    var saveResidential = () async{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // prefs.setInt('tempResidentialInt', residentialProfile.isEmpty ? null :  residentialProfile[0]['addressId']);


      int getResidential = prefs.getInt('tempResidentialInt');
      //    print('this is client residential ${getResidential}   ${residentialProfile[0]['addressId']} ');
      //  Map<String,dynamic> personals =  jsonDecode(prefs.getString('prefsPersonalData'));
      //  String employer =   prefs.getString('prefsEmploymentData');
      //   print('personal Data ${personals} ${employer}');
      //  //
      //  mergedOfflineClient.addAll(jsonDecode(personals));
      // // mergedOfflineClient.addAll(jsonDecode(employer));

      //     print('this is mergedData updated ${personals}');


      //   return  MyRouter.pushPage(context, NextOfKinDetails());

      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      if(dateMovedIn.text == null || dateMovedIn.text.isEmpty){
        return   Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Validation Error',
          message: 'Date moved in cannot be empty',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      setState(() {
        _isLoading = true;
      });

      // print('residential Profile ${residentialProfile}');

      int localclientID =   ClientInt == null ? prefs.getInt('clientId') : ClientInt;

      PostAndPut postAndPut = new PostAndPut();

      postAndPut.isClientActive(localclientID).then((value)  {

        String client_status = value.toString();
        Map<String,dynamic> residentialData= {
          'clientId':   ClientInt == null ? prefs.getInt('clientId') : ClientInt,
          'id': getResidential == null ? null : getResidential,
          'residential_state': stateInt,
          'lga':lgaInt,
          'address_type_id':36,
          'permanent_address': permanent_address.text  == 0 ? 'N/A' : permanent_address.text,
          "nearest_landmark": nearest_landmark.text == 0 ? 'N/A' : nearest_landmark.text,
          'residential_status': residentialInt,
          "year_at_residence": year_at_residence,
          'dateMovedIn': dateMovedIn.text
        };
        final Future<Map<String,dynamic>> respose =  addClientProvider.addResidential(residentialData,client_status);

        print('start response from login');

        print(respose.toString());

        respose.then((response) {

          AppTracker().trackActivity('ADD/UPDATE RESIDENTIAL',payLoad:
          {
            ...residentialData,
            "response": response.toString()
          });

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

              return MyRouter.pushPage(context, NextOfKinDetails());
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
            getResidentialInformation();

            if(ComingFrom == 'CustomerPreview'){
              return  MyRouter.pushPage(context, CustomerPreview());
            }
            if(ComingFrom == 'SingleCustomerScreen'){
              return  MyRouter.pushPage(context, SingleCustomerScreen(clientID: ClientInt,));
            }

            MyRouter.pushPage(context, NextOfKinDetails());
            Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "Success",
              message: 'Client updated successfully',
              duration: Duration(seconds: 3),
            ).show(context);

          }
          setState(() {
            _isLoading = false;
          });
        }
        );

      });



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
                ProgressStepper(stepper: 0.5,title: 'Residential Details',subtitle: 'Next Of Kin',),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        child: Text('Fill the information below.',style: TextStyle(fontSize: 11),),
                      ),
                      Form(
                          key: _form,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: stateArray,
                                    onChange: (String item){
                                      setState(() {
                                        List<dynamic> selectID =   allStates.where((element) => element['name'] == item).toList();
                                        stateInt = selectID[0]['id'];
                                        getSubAccount(27, stateInt);
                                        residentialLga = ' ';
                                        print(stateInt);
                                        lgaInt = 0;
                                        residentialInt = 0;
                                        //residentialStatus = '';

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
                                        residentialLga = selectID[0]['name'];
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
                                  child: EntryField(context, permanent_address, 'Permanent Address *','Enter permanent address',TextInputType.name,needsValidation: true)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, nearest_landmark, 'Nearest Landmark *','Enter landmark',TextInputType.name,needsValidation: true)
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: DropDownComponent(items: residentialArray,
                                    onChange: (String item) async{
                                      setState(() {
                                        List<dynamic> selectID =   allResidential.where((element) => element['name'] == item).toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        residentialInt = selectID[0]['id'];
                                        print('end this is select ID');
                                      });
                                    },
                                    label: "Residential Status *",
                                    selectedItem: residentialStatus,
                                    validator: (String item){

                                    }
                                ),
                              ),


                            ],
                          )
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
                                controller: dateMovedIn,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: (){
                                     //   showDatePicker();
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1955, 3, 5),
                                            maxTime:  DateTime.now().add(Duration(days: 0,hours: 2)),
                                            onChanged: (date) {
                                              print('change $date');
                                              setState(() {
                                                String retDate = retsNx360dates(date);
                                                dateMovedIn.text = retDate;
                                              });
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                            }, currentTime: DateTime.now().add(Duration(days: 0,hours: 1)), locale: LocaleType.en);
                                      },
                                      icon:   Icon(Icons.date_range,color: Colors.blue
                                        ,) ,
                                    ),

                                    focusedBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                                    ),
                                    border: OutlineInputBorder(

                                    ),
                                    labelText: 'Date Moved In',
                                    //    floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                                    hintText: 'Date Moved In',
                                    hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                                    labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

                                ),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 50,)
                    ],
                  ),
                )





              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction2: (){
          saveResidential();
          //  MyRouter.pushPage(context, NextOfKinDetails());
        },callAction1: (){
          MyRouter.popPage(context);
        },),
      ),
    );
  }

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool needsValidation = false}){
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

                if(needsValidation) {
                  if (value.isEmpty) {
                    return 'Field cannot be empty';
                  }
                }

                // if(value.isEmpty){
                //   return 'Field cannot be empty';
                //
                // }



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
                  hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              textInputAction: TextInputAction.done,
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
  //       print(selected);
  //       //  date = selected.toString();
  //
  //       String newdate = selectedDate.toString().substring(0,10);
  //       print(newdate);
  //
  //       String formattedDate = DateFormat.yMMMMd().format(selected);
  //
  //       print(formattedDate);
  //
  //       String removeComma = formattedDate.replaceAll(",", "");
  //
  //       List<String> wordList = removeComma.split(" ");
  //
  //       String o1 = wordList[0];
  //       String o2 = wordList[1];
  //       String o3 = wordList[2];
  //
  //
  //       print('the first ii ${o2}');
  //
  //        String newOO = o2.length == 1 ? '0' + '' + o2 :  o2;
  //
  //          print('newOO ${newOO}');
  //
  //       String concatss = newOO + " " + o1 + " " + o3;
  //       print("concatss");
  //       print(concatss);
  //
  //       print(wordList);
  //
  //       dateMovedIn.text = concatss;
  //
  //     });
  // }


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
                          dateMovedIn.text = retDate;
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
                    print('ret Date ${retDate}');
                    dateMovedIn.text = retDate;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        }
    );
  }

  retsNx360dates(DateTime selected){
    print(selected);


    DateTime todayZdate = DateTime.now();

    Duration diffs = todayZdate.difference(selected);

    print('diff in days ${diffs.inDays}' );
    setState(() {
      year_at_residence =  (diffs.inDays ~/ 365 ).toString();
    });
    print('years at residence ${year_at_residence}');
    String newdate = selectedDate.toString().substring(0,10);

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

