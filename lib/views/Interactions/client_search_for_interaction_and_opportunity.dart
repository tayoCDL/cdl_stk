import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/views/Interactions/addInteractionFromOverview.dart';
import 'package:sales_toolkit/views/Interactions/addOpportunityFromOverview.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';

import '../../util/router.dart';
import '../../view_models/CodesAndLogic.dart';
// import '../leads/ViewClient.dart';

class ClientSearchForInteraction extends StatefulWidget {
  final String comingFrom;
  const ClientSearchForInteraction({Key key,this.comingFrom}) : super(key: key);

  @override
  _ClientSearchForInteractionState createState() => _ClientSearchForInteractionState(
    comingFrom: this.comingFrom,
  );
}

class _ClientSearchForInteractionState extends State<ClientSearchForInteraction> {
  String comingFrom;
  _ClientSearchForInteractionState({
    this.comingFrom
});
  var allCLient = [];
  bool _isLoading = false;
  String searchStatus = '';

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
            List<dynamic> newEmp = response['data'];
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




  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
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
                    prefixIcon: PopupMenuButton(
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
                    )
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



  searchResultTile(String name,String mobile,var clientID){
    return InkWell(
      onTap: (){
          if(comingFrom == 'interaction'){
            MyRouter.pushPage(context, AddInteractionFromOverView(ClientID: clientID,clientName: name,));
          }
          else {
            MyRouter.pushPage(context, AddOpportunityFromOverview(ClientID: clientID,clientName: name,));
          }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          height: 80,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(name ?? ''),
            subtitle: Text(mobile ?? ''),
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
                  child: searchResultTile(allCLient[position]['entityName'],allCLient[position]['entityMobileNo'],allCLient[position]['entityId'])
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

