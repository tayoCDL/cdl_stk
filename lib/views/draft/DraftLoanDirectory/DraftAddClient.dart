import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';

import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/clients/PersonalInfo.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraftAddClient extends StatefulWidget {
  const DraftAddClient({Key key}) : super(key: key);

  @override
  _DraftAddClientState createState() => _DraftAddClientState();
}

class _DraftAddClientState extends State<DraftAddClient> {
  @override
  List<String> empSector = [];
  List<String> collectData = [];
  List<dynamic> allEmp = [];
  bool isBVNLoading = false;
  bool isRequestLoading = false;
  bool isAllowedToProceed = false;
  String tempEmail,tempFirstName,tempMiddleName,tempLastName,tempPhone1,tempPhone2;

  void initState() {
    // TODO: implement initState

    getCodesList();

    super.initState();
  }

  getCodesList()  {
    final Future<Map<String,dynamic>> respose =   RetCodes().getCodes('36');
    respose.then((response) async{
      if(response['status'] == false){

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpSector'));


        //
        if(prefs.getString('prefsEmpSector').isEmpty){
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

          for(int i = 0; i < mtBool.length;i++){
            print(mtBool[i]['name']);
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


      }

      else {

        print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpSector', jsonEncode(newEmp));


        setState(() {
          allEmp = newEmp;
        });

        for(int i = 0; i < newEmp.length;i++){
          print(newEmp[i]['name']);
          collectData.add(newEmp[i]['name']);
        }



        setState(() {
          empSector = collectData;
        });

      }


    }


    );
  }

  fetchBvn(String text) {
    final Future<Map<String,dynamic>> respose =   RetCodes().verifyBVN(text);
    setState(() {
      isRequestLoading = true;
    });
    respose.then((response) {
      // print('heelo here' + response['data']);

      if(response['status'] == false){
        setState(() {
          isRequestLoading = false;
        });
        return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: response['message'],
          duration: Duration(seconds: 3),
        ).show(context);

      }

      if(response['data']['status'] == true){

        //  print('this is a test' + response['data']['email']);
        setState(() {
          isAllowedToProceed = true;
          tempEmail = response['data']['data']['email'];
          tempFirstName = response['data']['data']['firstName'];
          tempMiddleName = response['data']['data']['middleName'];
          tempLastName = response['data']['data']['lastName'];
          tempPhone1= response['data']['data']['phoneNumber1'];
          tempPhone2= response['data']['data']['phoneNumber2'];

        });
        setState(() {
          isRequestLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.lightGreen,
          title: "Success",
          message: 'BVN Validation Successful',
          duration: Duration(seconds: 3),
        ).show(context);
      }
      else {
        setState(() {
          isRequestLoading = false;
        });
        Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: "Error!",
          message: 'validation failed ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }
    );
  }

  @override
  var _lights = true;
  String employment_type = '';
  int empInt;



  TextEditingController bvn = TextEditingController();


  Widget build(BuildContext context) {

    var startProcess = () async{

    //    return MyRouter.pushPage(context, TestDraft());

      print(bvn.text);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.remove('clientId');
      prefs.remove('employerResourceId');
      // if bvn is on and bvn lenght is not 11
      if(_lights && bvn.text.length != 11){
        return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Validation error",
          message: 'BVN lenght must be 11',
          duration: Duration(seconds: 3),
        ).show(context);

      }

      else {
        var bvnData = prefs.setString('inputBvn',_lights ? bvn.text : '');
        var emplyment = prefs.setInt('employment_type', empInt);



        MyRouter.pushPage(context, PersonalInfo(
          bvnEmail: tempEmail,
          bvnFirstName: tempFirstName,
          bvnLastName: tempLastName,
          bvnMiddleName: tempMiddleName,
          bvnPhone1: tempPhone1,
          bvnPhone2: tempPhone2,
        ));

      }





    };


    return LoadingOverlay(
      isLoading: isRequestLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/ballLoader.json'),
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

                  Text('Add New Client', style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontFamily: 'Nunito Bold')),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Client\'s BVN',style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 15,fontWeight: FontWeight.w600),),



                          // Text('If turned on, you will be required to the client\'s \n BVN',style: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular',fontSize: 14),),

                        ],
                      ),
                      // Container(
                      //   height: 20,
                      //   child: CupertinoSwitch(
                      //     value: _lights,
                      //     activeColor: Color(0xff077DBB),
                      //     onChanged: (bool value) {
                      //       setState(() {
                      //         _lights = value;
                      //         print(_lights);
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text('If turned on, you will be required to enter the client\'s \nBVN',style: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular',fontSize: 13),),
                  SizedBox(height: 30,),
                  _lights == true ?
                  EntryField(context, bvn, 'BVN','Enter BVN',maxLenghtAllow: 11) : Text('You chose to continue without client\'s bvn'),
                  //  TextInputWithFLoating(hint: '11111111111', label: 'BVN',username),
                  _smallInfo(),
                  SizedBox(height: 20,),
                  Text('What Employment Sector do you work in ?  ',style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 16,fontWeight: FontWeight.w600),),


                  SizedBox(height: 20,),
                  DropDownComponent(items: empSector,
                      onChange: (String item){
                        setState(() {

                          List<dynamic> selectID =   allEmp.where((element) => element['name'] == item).toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          empInt = selectID[0]['id'];
                          print('end this is select ID');

                        });
                      },
                      label: "Select Sector",
                      selectedItem: "Select Sector",
                      validator: (String item){

                      }

                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar:
          // BottomNavComponent(text:'Start',callAction: (){},)
          // DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction1: (){},callAction2: (){},)
          BottomNavComponent(text: isBVNLoading == true ? 'Loading..' : 'Start',callAction: (){
            // MyRouter.pushPage(context, PersonalInfo());
            // MyRouter.pushPage(context, PersonalInfo());
            startProcess();
          },)
      ),
    );
  }

  _smallInfo(){
    return   Visibility(
      visible: isBVNLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
        child: Text('BVN must be 11-digits',
          style: TextStyle(color: Color(0xff1A9EF4),
              fontFamily: 'Nunito SansRegular',
              fontSize: 12,
              fontWeight: FontWeight.bold

          ),
        ),
      ),
    );

  }


  Widget EntryField(BuildContext context,var editController,String labelText,String hintText,{var maxLenghtAllow,} ){
    var MediaSize = MediaQuery.of(context).size;

    return   Container(

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
            autofocus: false,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: TextInputType.number,

            controller: editController,
            onChanged: (String value){
              if(value.isEmpty){
                setState(() {
                  isBVNLoading = false;
                });
                // print('isLoading is ${isBVNLoading}');

              }
              else if(value.length != 11){
                setState(() {
                  isBVNLoading = true;
                });
                print('isloading  ${isBVNLoading}');
              }
              else{

                fetchBvn(bvn.text);
                setState(() {
                  isBVNLoading = false;
                });
                print('re isloading  ${isBVNLoading}');
              }
            },
            validator: (String value){

            },
            decoration: InputDecoration(

              // suffixIcon:  Visibility(
              //   visible: isBVNLoading,
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: CircularProgressIndicator(color: Colors.lightBlue,),
              //   ),
              // ),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),

                ),
                border: OutlineInputBorder(

                ),
                labelText: labelText,
                hintText: hintText,
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
