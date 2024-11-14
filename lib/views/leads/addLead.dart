import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addLead.dart';
import 'package:sales_toolkit/views/leads/PersonalInfo.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLead extends StatefulWidget {
  final int leadInt;
  final String comingFrom,PassedleadType;
  const AddLead({Key key,this.leadInt,this.comingFrom,this.PassedleadType}) : super(key: key);

  @override
  _AddLeadState createState() => _AddLeadState(
      leadInt:this.leadInt,
      comingFrom:this.comingFrom,
      PassedleadType: this.PassedleadType
  );
}

class _AddLeadState extends State<AddLead> {
  int leadInt;
  String comingFrom,PassedleadType;
  _AddLeadState({this.leadInt,this.comingFrom,this.PassedleadType});

  @override
  List<String> empSector = [];
  List<String> collectData = [];


  List<String> leadCategoryArray = [];
  List<String> collectLeadCategory = [];
  List<dynamic> allLeadCategory = [];

  List<String> leadSourceArray = [];
  List<String> collectLeadSource = [];
  List<dynamic> allLeadSource = [];


  List<String> leadRatingArray = [];
  List<String> collectLeadRating = [];
  List<dynamic> allLeadRating = [];

  List<String> leadProductArray = [];
  List<String> collectLeadProduct = [];
  List<dynamic> allLeadProduct = [];
  var leadInfo = {};
  bool _isLoading = false;


  int leadCategoryInt,leadRatintInt,leadSourceInt;
  String leadCategory,leadRating,leadType,leadSource,leadTypeInt;
  TextEditingController projectedInflow = TextEditingController();

  AddLeadProvider addLeadProvider = AddLeadProvider();

  void initState() {
    // TODO: implement initState
    print('leadID ${leadInt}');
    getCodesList();
    getLeadInformation();
    getleadCategoryList();
    getLeadRatingtList();
    getleadTypetList();
    getleadSourceList();

    super.initState();
  }

  getCodesList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('36');
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];
      for(int i = 0; i < newEmp.length;i++){
        print(newEmp[i]['name']);
        collectData.add(newEmp[i]['name']);
      }
      print('vis alali');
      print(collectData);

      setState(() {
        empSector = collectData;
      });
    }
    );
  }

  getleadCategoryList(){
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('16');
    respose.then((response) async{

      setState(() {
        _isLoading = false;
      });

      if(response['status'] == false)
      {

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLeadCategoryList'));


        //
        if(prefs.getString('prefsLeadCategoryList').isEmpty){
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
            allLeadCategory = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectLeadCategory.add(mtBool[i]['name']);
          }

          setState(() {
            leadCategoryArray = collectLeadCategory;
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
        print(response['data']);

        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsLeadCategoryList', jsonEncode(newEmp));

        setState(() {
          allLeadCategory = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectLeadCategory.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectLeadCategory);

        setState(() {
          leadCategoryArray = collectLeadCategory;
        });

      }

    }
    );

  }

  getLeadRatingtList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('49');
    respose.then((response) async{


      if(response['status'] == false)
      {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLeadRatingsList'));


        //
        if(prefs.getString('prefsLeadRatingsList').isEmpty){
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
            allLeadRating = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectLeadRating.add(mtBool[i]['name']);
          }

          setState(() {
            leadRatingArray = collectLeadRating;
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
      else{
        print(response['data']);
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsLeadRatingsList', jsonEncode(newEmp));


        setState(() {
          allLeadRating = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectLeadRating.add(newEmp[i]['name']);
        }
        print('vis alali');
        print(collectLeadRating);

        setState(() {
          leadRatingArray = collectLeadRating;
        });

      }




    }
    );

  }

  getleadTypetList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getLeadProduct();
    respose.then((response) async {

      if(response['status'] == false){
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLeadTypeList'));


        //
        if(prefs.getString('prefsLeadTypeList').isEmpty){
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
            allLeadProduct = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectLeadProduct.add(mtBool[i]['name']);
          }

          setState(() {
            leadProductArray = collectLeadProduct;
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

        List<dynamic> newEmp = response['data']['pageItems'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsLeadTypeList', jsonEncode(newEmp));


        setState(() {
          allLeadProduct = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectLeadProduct.add(newEmp[i]['name']);
        }

        setState(() {
          leadProductArray = collectLeadProduct;
        });


        if(!PassedleadType.isEmpty){
          List<dynamic> selectName =   allLeadProduct.where((element) => element['id'] == PassedleadType).toList();
          setState(() {
           leadType = selectName[0]['name'];
          });

        }
      }
    }
    );

  }


  getLeadInformation() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    int localclientID =   leadInt == null ? prefs.getInt('leadId') : leadInt;
    print('localInt ${localclientID} ${leadInt}');

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

    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      leadInfo = newClientData;
      print('leadInfo ${leadInfo}');
      if(!leadInfo.isEmpty){
        var PreleadInfo  = newClientData['moreInfo']['clients'];
        leadRatintInt = leadInfo['leadRating']['id'];
        leadTypeInt = leadInfo['leadTypeId'];
        leadCategoryInt = leadInfo['leadCategory']['id'];
        leadSourceInt =leadInfo['leadSource']['id'];
        projectedInflow.text = (leadInfo['expectedRevenueIncome']).toString();

        leadCategory = leadInfo['leadCategory']['name'];
        leadRating = leadInfo['leadRating']['name'];
      //  leadType = leadInfo['leadTypeId'];
        leadSource = leadInfo['leadSource']['name'];

      }


    });

    prefs.setInt('tempLeadInt', leadInfo.isEmpty ? null :  leadInfo['id']);


  }


  getleadSourceList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('46');
    respose.then((response) async{

      if(response['status'] == false)
      {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsLeadSourceList'));


        //
        if(prefs.getString('prefsLeadSourceList').isEmpty){
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
            allLeadSource = mtBool;
          });

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
            collectLeadSource.add(mtBool[i]['name']);
          }


          setState(() {
            leadSourceArray = collectLeadSource;
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

      }

      print(response['data']);
      List<dynamic> newEmp = response['data'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('prefsLeadSourceList', jsonEncode(newEmp));


      setState(() {
        allLeadSource = newEmp;
      });

      for(int i = 0; i < newEmp.length;i++){
        print(newEmp[i]['name']);
        collectLeadSource.add(newEmp[i]['name']);
      }
      print('vis alali lead source');
      print(collectLeadSource);

      setState(() {
        leadSourceArray = collectLeadSource;
      });


    }
    );

  }

  @override


  Widget build(BuildContext context) {

    var startProcess = () async{
      if(projectedInflow.text.isEmpty || projectedInflow.text.length < 2 || leadCategoryInt ==null || leadRatintInt == null || leadTypeInt == null || leadSourceInt == null ){
        return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Validation Error',
          message: 'All Fields are required',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.remove('leadId');
      prefs.remove('clientId');

      prefs.remove('employerResourceId');
      prefs.remove('tempEmployerInt');
      prefs.remove('tempResidentialInt');
      prefs.remove('tempBankInfoInt');

      print('${leadCategoryInt}  ${leadSourceInt} ${leadTypeInt} ${leadRatintInt} ');

      MyRouter.pushPage(context, LeadPersonalInfo(leadCategory: leadCategoryInt,
        leadSource: leadSourceInt,
        leadType: leadTypeInt,
        leadRating: leadRatintInt,
        projectedInflow: projectedInflow.text,
        leadInt: leadInt,
        comingFrom: comingFrom == 'LeadSingleView' ? 'LeadSingleView' : comingFrom ==  'customerPreview' ? 'customerPreview' : '',
      ));

    };


    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),

      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
              onPressed: (){
                MyRouter.popPage(context);
              },
              icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            ),
          ),
          body: GestureDetector(
            onTap: (){

              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ListView(
                children: [

                  Text('Add New Prospect', style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontFamily: 'Nunito Bold')),
                  SizedBox(height: 50,),
                  Text('Lead Classification',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontFamily: 'Nunito Bold')),
                  SizedBox(height: 40,),

                  DropDownComponent(items: leadCategoryArray,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allLeadCategory.where((element) => element['name'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          leadCategoryInt = selectID[0]['id'];
                          print('end this is select ID');

                        });
                      },
                      label: "Select Lead category",
                      selectedItem: leadCategory,
                      validator: (String item){
                        return "Lead category is required";
                      }

                  ),
                  SizedBox(height: 20,),
                  DropDownComponent(items: leadRatingArray,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allLeadRating.where((element) => element['name'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          leadRatintInt = selectID[0]['id'];
                          print('end this is select ID');

                        });
                      },
                      label: "Select Lead Rating",
                      selectedItem: leadRating,
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),
                  DropDownComponent(items: leadProductArray,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allLeadProduct.where((element) => element['name'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          leadTypeInt = selectID[0]['id'];
                          print('end this is select ID');

                        });
                      },
                      label: "Interested Products*",
                      selectedItem: leadType,
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),
                  DropDownComponent(items: leadSourceArray,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allLeadSource.where((element) => element['name'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          leadSourceInt = selectID[0]['id'];
                          print('end this is select ID');

                        });
                      },
                      label: "Select Lead Source",
                      selectedItem: leadSource,
                      validator: (String item){

                      }

                  ),
                  SizedBox(height: 20,),
                  EntryField(context, projectedInflow, 'Projected Inflow *','1,000,000',TextInputType.number),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
          // BottomNavComponent(text:'Start',callAction: (){},)
          // DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction1: (){},callAction2: (){},)
          BottomNavComponent(text: 'Start',callAction: (){
            // MyRouter.pushPage(context, PersonalInfo());
            // MyRouter.pushPage(context, PersonalInfo());
            startProcess();
          },)
      ),
    );
  }





  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,{bool isPassword = false}){
    var MediaSize = MediaQuery.of(context).size;
    return
      Container(
        height: MediaSize.height * 0.095,
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
              keyboardType: keyBoard,

              controller: editController,

              // validator: (value)=>value.isEmpty?'Please enter password':null,
              // onSaved: (value) => vals = value,
              validator: (value) {

                if(value.isEmpty || value.length < 3){
                  return 'Field cannot be empty';

                }
                // else if(!EmailValidator.validate(emailaddress.text)){


              },

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
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );




  }


}
