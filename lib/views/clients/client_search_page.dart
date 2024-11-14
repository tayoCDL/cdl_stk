import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';

import '../../util/router.dart';
import '../../view_models/CodesAndLogic.dart';
// import '../leads/ViewClient.dart';


class ClientSearchPage extends StatelessWidget {
//  final String comingFrom;
  const ClientSearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ClientSearchPages()
      // ShowCaseWidget(
      //   onStart: (index, key) {
      //     log('onStart: $index, $key');
      //   },
      //   onComplete: (index, key) {
      //     log('onComplete: $index, $key');
      //     if (index == 4) {
      //       // SystemChrome.setSystemUIOverlayStyle(
      //       //   SystemUiOverlayStyle.light.copyWith(
      //       //     statusBarIconBrightness: Brightness.dark,
      //       //     statusBarColor: Colors.white,
      //       //   ),
      //       // );
      //     }
      //   },
      //   blurValue: 1,
      //   builder: Builder(builder: (context) => const ClientSearchPages()),
      //   autoPlayDelay: const Duration(seconds: 3),
      // ),
    );
  }
}

class ClientSearchPages extends StatefulWidget {
  const ClientSearchPages({Key key}) : super(key: key);

  @override
  _ClientSearchPagesState createState() => _ClientSearchPagesState();
}

class _ClientSearchPagesState extends State<ClientSearchPages> {

  // checkTour() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ActiveTour =   prefs.getBool('isTourActive12351');
  //
  //   if(ActiveTour == null){
  //     WidgetsBinding.instance.addPostFrameCallback(
  //           (_) => ShowCaseWidget.of(context)
  //           .startShowCase([_one]),
  //     );
  //     prefs.setBool('isTourActive12351', true);
  //   }
  //
  // }

  final GlobalKey _one = GlobalKey();
  // final GlobalKey _two = GlobalKey();
  // final GlobalKey _three = GlobalKey();

  var allCLient = [];
  bool _isLoading = false;
  String searchStatus = '';


  Future<List> getSuggestions(String query) async{
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(query.length < 3){
      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.redAccent,
        title: 'Validation Error',
        message: 'text lenght too short ',
        duration: Duration(seconds: 3),
      ).show(context);
    }

    if(searchStatus.length < 2){
    return  Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Validation Error',
        message: 'Pick a search category with the three dots ',
        duration: Duration(seconds: 5),
      ).show(context);
    }


    if(mounted){

      if (query.length > 3){
        setState(() {
          _isLoading = true;
        });

        String sendQuery = searchStatus + '=${query}';

        final Future<Map<String,dynamic>> respose =   RetCodes().searchClient(sendQuery);
        respose.then((response) async {
          setState(() {
            _isLoading = false;
          });
          print('query ${query}');
          print('search response ${response}');

          if(response == null){
            allCLient = [];
          }
          else {
            List<dynamic> newEmp = response['data']['pageItems'];
            setState(() {
              allCLient =  newEmp;

            });
          }


        });

        return allCLient;

      }

    }





  }



  TextEditingController search_controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void initState() {
    super.initState();
   // checkTour();

  }



  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }



  @override

  Widget build(BuildContext context) {

    vchangeState(String newVals){
      setState(() {
        searchStatus = newVals;
      });
      print('newStat>> ${newVals}');
    }

    void searchValue(String value){
      if(value == 'displayName'){
        vchangeState('displayName');
      }
      if(value == 'externalId'){
        vchangeState('externalId');
      }
      if(value == 'mobileNo'){
        vchangeState('mobileNo');
      }
      if(value == 'staffId'){
        vchangeState('staffId');
      }
      if(value == 'bvn'){
        vchangeState('bvn');
      }
      if(value == 'clientId'){
        vchangeState('clientId');
      }
      if(value == 'officeId'){
        vchangeState('officeId');
      }


    }



    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Search Clients',style: TextStyle(color: Colors.black,fontSize: 21,fontWeight: FontWeight.w400),),
          //  leading: IconButton(icon: Icon(Icons.arrow_back_ios),),
          actions: [
            IconButton(
              onPressed: (){
                MyRouter.popPage(context);
              },
              icon: Icon(FeatherIcons.x,size: 25,color: Colors.black,),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              children: [
                EntryField(context,
                    search_controller,
                    'Search Existing Client',
                    'Search Existing ',
                    TextInputType.text,
                    onBtnPressed: (){
                      getSuggestions(search_controller.text);
                    },
                    prefixIcon:
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert,color: Colors.blue,),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'displayName',
                            child: Text('Display Name',),
                          ),
                          PopupMenuItem(
                            value: 'externalId',
                            child: Text('External ID'),
                          ),
                          PopupMenuItem(
                            value: 'mobileNo',
                            child: Text('Mobile Number'),
                          ),
                          PopupMenuItem(
                            value: 'staffId',
                            child: Text('Staff ID'),
                          ),
                          PopupMenuItem(
                            value: 'bvn',
                            child: Text('BVN'),
                          ),
                          PopupMenuItem(
                            value: 'clientId',
                            child: Text('Client ID'),
                          ),
                          PopupMenuItem(
                            value: 'officeId',
                            child: Text('Office ID'),
                          ),


                        ];
                      },
                      onSelected: (String value) => searchValue(value),
                    ),


                ),

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Search Result',style: TextStyle(color: Colors.black,fontSize: 25),),
                    Text('')
                  ],
                ),
                allCLient.length == 0 ? noClientFound() : searchResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  searchResultTile(String name,String mobile,var clientID,String status){
    return InkWell(
      onTap: (){
        MyRouter.pushPage(context, ViewClient(clientID: clientID));

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          height: 80,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(name ?? ''),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Client\'s Sector: ',style: TextStyle(color: Colors.black,fontSize:11),),
                Text(mobile ?? ''),
              ],
            ),
            trailing: clientStatus(colorChoser(status), status,fontSize: 11,containerSIze: 80,containerHeight: 20),
          ),
        ),
      ),
    );
  }

  Widget noClientFound(){
    return Container(
      height: 100,
      child: Center(
        child: Text('No Client Found',),
      ),
    );
  }

  Widget searchResults(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child:   ListView.builder(
        itemCount: allCLient.length,
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,position){
          print('allCLients ${allCLient[position]}');

          return Column(
            children: [
              Divider(color: Colors.grey,),
              InkWell(
                  onTap: (){
                    print('tapped :: >>');
                  },
                  child: searchResultTile(
                    allCLient[position]['displayName'],
                    allCLient[position]['employmentSector'] == null ? '' :  allCLient[position]['employmentSector']['name'],
                    allCLient[position]['id'],
                    allCLient[position]['status']['value'],
                  )
              ),
              // Divider(color: Colors.grey,)
            ],
          );




        },
      ),
    );
  }


  Widget EntryField(BuildContext context,var editController,String labelText,String hintText ,var keyBoard,
      {bool isValidateEmployer = false,bool isSendOTP = true,
        var maxLenghtAllow,
        Function onBtnPressed,bool isSuffix = false,
        String extension,bool needsValidation = true,Function changeValidator,Widget prefixIcon}){
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

              validator: changeValidator,

              decoration: InputDecoration(
                  suffixIcon:
                  TextButton(
                    // disabledColor: Colors.blueGrey,
                    onPressed: onBtnPressed,
                    child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xff077DBB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.search,color: Colors.white,)
                    ),
                  ),
                  prefixIcon: prefixIcon,
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  border: OutlineInputBorder(

                  ),
                  labelText: labelText,
                  suffixStyle: TextStyle(backgroundColor: Colors.transparent),
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


}

