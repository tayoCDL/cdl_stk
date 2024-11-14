import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/BankDetails.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LeadNextOfKinDetails extends StatefulWidget {
  final int ClientInt;
  const LeadNextOfKinDetails({Key key,this.ClientInt}) : super(key: key);

  @override
  _LeadNextOfKinDetailsState createState() => _LeadNextOfKinDetailsState(
      ClientInt:this.ClientInt
  );
}

class _LeadNextOfKinDetailsState extends State<LeadNextOfKinDetails> {

  int ClientInt;
  _LeadNextOfKinDetailsState({this.ClientInt});

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
  var nextOfKin = [];

  void initState() {
    // TODO: implement initState

    getTitleList();
    relationshipList();
    maritalSList();
    genderList();
    getNextOfKinInformation();
    professionList();
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
    print(token);
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
    setState(() {
      nextOfKin = newClientData;
    });



    print('nextOfKin ${nextOfKin}');
  }


  @override
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController bsc = TextEditingController();
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

      prefs.setInt('tempNextOfKinInt', nextOfKin.isEmpty ? null :  nextOfKin[0]['id']);


      int getNextOfKin = prefs.getInt('tempNextOfKinInt');



      setState(() {
        _isLoading = true;
      });
      Map<String,dynamic> employmentData= {
        "id": getNextOfKin == null ? null : getNextOfKin,
        'title': titleInt,
        'firstname':firstname.text,
        'middlename': middlename.text,
        "lastname": lastname.text,
        'phonenumber': phonenumber.text,
        'age': age.text,
        'qualification': bsc.text,
        'relationship_with_nok': relationshipInt,
        'maritalStatus':maritalInt,
        'gender': genderInt ,
        'profession': professionInt
      };
      final Future<Map<String,dynamic>> respose =  addClientProvider.addNextOfKin(employmentData,'');
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
          MyRouter.pushPage(context, BankDetails());
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Client updated successfully',
            duration: Duration(seconds: 3),
          ).show(context);

        }

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
                                    selectedItem: "Mr",
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
                                  child: EntryField(context, middlename, 'Middle Name *','Enter middlename ',TextInputType.name)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, lastname, 'Last Name *','Enter lastname',TextInputType.name)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, phonenumber, 'Phone Number *','Enter phone number',TextInputType.phone,maxLenghtAllow: 11)
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: EntryField(context, age, 'Age ','--',TextInputType.number)
                              ),
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
                                    selectedItem: "--",
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
                                    selectedItem: "--",
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
                                    selectedItem: "--",
                                    validator: (String item){

                                    }
                                ),
                              ),

                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              //   child: DropDownComponent(items: professionArray,
                              //       onChange: (String item) async{
                              //         setState(() {
                              //
                              //           List<dynamic> selectID =   allProfession.where((element) => element['name'] == item).toList();
                              //           print('this is select ID');
                              //           print(selectID[0]['id']);
                              //           professionInt = selectID[0]['id'];
                              //           print('end this is select ID');
                              //
                              //         });
                              //       },
                              //       label: "Profession",
                              //       selectedItem: "--",
                              //       validator: (String item){
                              //
                              //       }
                              //   ),
                              // ),
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

  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false,var maxLenghtAllow,bool isRead = false}){
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

                if(value.isEmpty){
                  return 'Field cannot be empty';

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

