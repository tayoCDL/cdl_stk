import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/ColorReturn.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/encryptDecrypt.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:textfield_search/textfield_search.dart';
import 'package:sales_toolkit/widgets/LocalTypeAhead.dart';

import '../../widgets/shared/top_toastr.dart';
import 'client_search_page.dart';

class ClientList extends StatelessWidget {
  final String comingFrom;
  const ClientList({Key key,this.comingFrom}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      ClientLists()
      // ShowCaseWidget(
      //   onStart: (index, key) {
      //     log('onStart: $index, $key');
      //   },
      //   onComplete: (index, key) {
      //     log('onComplete: $index, $key');
      //     if (index == 4) {
      //       SystemChrome.setSystemUIOverlayStyle(
      //         SystemUiOverlayStyle.light.copyWith(
      //           statusBarIconBrightness: Brightness.dark,
      //           statusBarColor: Colors.white,
      //         ),
      //       );
      //     }
      //   },
      //   blurValue: 1,
      //   builder: Builder(builder: (context) => const ClientLists()),
      //   autoPlayDelay: const Duration(seconds: 3),
      // ),
    );
  }
}


class ClientLists extends StatefulWidget {
  const ClientLists({Key key}) : super(key: key);

  @override
  _ClientListsState createState() => _ClientListsState();
}

var clientsData = [];
var allCLient = [];
List<String> collectClientName = [];
List<int> collectClientId = [];



bool isScrolled = true;
bool isSearchLoading = false;
String _isLoading = 'not_loading';

var searchCLientData = [];

class _ClientListsState extends State<ClientLists> {
  // checkTour() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ActiveTour =   prefs.getBool('isTourActive1235');
  //
  //   if(ActiveTour == null){
  //     WidgetsBinding.instance.addPostFrameCallback(
  //           (_) => ShowCaseWidget.of(context)
  //           .startShowCase([_one,_two,_three]),
  //     );
  //     prefs.setBool('isTourActive1235', true);
  //   }
  //
  // }

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  TextEditingController _typeAheadController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription subscription;

  @override
  // void initState() {
  //   // TODO: implement initState
  //  getCLientsList();
  //   super.initState();
  // }


  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'You are connected to ${result.toString()}'
        : 'You have no internet';
    final color = hasInternet ? Colors.green : Colors.red;

    Utils.showTopSnackBar(context, message, color);
  }


  void initState() {
    super.initState();
    //checkTour();
   if( clientsData.isEmpty){
     getCLientsList();
   }

    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  //  getSearchCLientsList();
  }



  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    _typeAheadController.dispose();
    super.dispose();
  }


  Future<List> getSuggestions(String query) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(mounted){

      if (query.length > 3){
        // setState(() {
        //   isSearchLoading = true;
        // });
        final Future<Map<String,dynamic>> respose =   RetCodes().searchClient(query);
        respose.then((response) async {
          print('query ${query}');
              print('search response ${response}');
          setState(() {
            isSearchLoading = false;
          });
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

  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List _list = <dynamic>[];

    String query = _typeAheadController.text;
    final Future<Map<String,dynamic>> respose =   RetCodes().searchClient(query);

    respose.then((response) async {

      if(response == null){
       return _list = [];

      }
      else {
        List<dynamic> newEmp = response['data'];
        print('first search ${newEmp}');
        setState(() {
          allCLient =  newEmp;
        });


        print('allClient ${allCLient}');


        for(int i = 0; i < allCLient.length;i++){
          print(' new client ${allCLient[i]['entityName']}');
          collectClientName.add(allCLient[i]['entityName']);

          collectClientId.add(allCLient[i]['entityId']);

        }


      }


    });




    print('collect Client Name ${collectClientName}');


    for(int i=0;i < allCLient.length;i++){
      _list.add(new TestItem.fromJson(
          {'label': collectClientName[i], 'value': collectClientId[i]}
      ));
    }

    // _list.add(new TestItem.fromJson(_jsonList[1]));
    // _list.add(new TestItem.fromJson(_jsonList[2]));

    return _list;

    //return collectEmployer;
  }






  getCLientsList() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    String accessToken = prefs.getString('cloak_access_token');
    print('staffId ${staffId}');
    print(tfaToken);
    print(token);
//   AppUrl.ClientsList+'?staffId=${staffId}',
    setState(() {
      _isLoading  = 'is_loading';
    });

    try{
    //  Map<String, dynamic> encData =  EncryptOrDecrypt().buildtwofactorData(authCode: token,requesPayload: null,extendedToken: tfaToken);
    //  Map<String, dynamic> encData_2 = EncryptOrDecrypt().buildEncData(encData);


      Response responsevv = await get(
        AppUrl.ClientsList+'/nx360?staffId=${staffId}&offset=0&limit=10',
       // AppUrl.ClientsList+'?staffId=${staffId}',
     //   AppUrl.enc_clients_lists,
     //   body: jsonEncode(encData_2),
        headers: {
        //   'Content-Type': 'application/json',
        //   'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        // //  'Authorization': 'Bearer ${accessToken}',
        //   'Fineract-Platform-TFA-Token': '${tfaToken}',
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );
      print(responsevv.body);


      // final Map<String, dynamic> encryptedResponseData = json.decode(responsevv.body);
      // String decryptResult = encryptedResponseData['result'];
      // String decryptedResponse = EncryptOrDecrypt().decryptText(decryptResult);
      //
      // Map<String, dynamic> responseData2 = jsonDecode(decryptedResponse);
      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      var newClientData = responseData2['pageItems'];
      print('New clientdata ${newClientData.length}');
      setState(() {
        _isLoading = 'loaded';
        clientsData = newClientData;
      });
      print(clientsData);
    }
    catch(e){
      print(e);
    }

  }



  getSearchCLientsList() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    print('staffId ${staffId}');
    print(tfaToken);
    print(token);
//   AppUrl.ClientsList+'?staffId=${staffId}',
    try{
      Response responsevv = await get(
        AppUrl.ClientsList,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );
      print(responsevv.body);

      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      var newClientData = responseData2['pageItems'];
      print('New clientdata ${newClientData.length}');
      setState(() {
        searchCLientData = newClientData;
      });
      // print('searchCLientData ${searchCLientData}');
    }
    catch(e){
      print(e);
    }

  }


  @override

  int CLientID;

  allWordsCapitilize (String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }




  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isSearchLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child:  Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
      key: _scaffoldKey,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,

        appBar:
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:  Theme
              .of(context)
              .backgroundColor,
          title:
          // Showcase(
          //             key: _two,
          //             title: 'Search',
          //             description: 'Tap here to search for all clients',
          //   child:
          //
          //             ),
          InkWell(
              onTap: (){
                MyRouter.pushPage(context, ClientSearchPages());
              },
              child:

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.96,
                height: MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search,color: Colors.grey,),
                    SizedBox(width: 20,),
                    Text('Search Existing client',style: TextStyle(color: Colors.grey,fontSize: 15),),
                  ],
                ),
              )
          ),

        ),


        // AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 15),
        //     child: Text('Clients', style: TextStyle(
        //         fontSize: 27,
        //         fontWeight: FontWeight.bold,
        //         color: Theme.of(context).textTheme.headline6.color,
        //         fontFamily: 'Nunito Bold')),
        //   ),
        //   backgroundColor:  Theme
        //       .of(context)
        //       .backgroundColor,
        //   actions: [
        //     Showcase(
        //       key: _two,
        //       title: 'Search',
        //       description: 'Tap here to search for all clients',
        //       shapeBorder: const CircleBorder(),
        //       child: IconButton(
        //           onPressed: (){
        //         showSearch(context: context, delegate: ClientSearch());
        //    //   MyRouter.pushPage(context, TestSearch());
        //       }, icon: Icon(FeatherIcons.search,color: Theme.of(context).colorScheme.secondary,)),
        //     )
        //   ],
        // ),

        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification){
            if(notification.direction == ScrollDirection.forward){
              setState(() {
                isScrolled = true;
              });
            }
            else if (notification.direction ==ScrollDirection.reverse){
              setState(() {
                isScrolled = false;
              });
            }
          },
          child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:


            //  clientsData.length == 0 && _isLoading == 'is_loading' ? ShimmerListLoading() : clientsData.length == 0 && _isLoading == 'loaded' ? NoCliientView() : _ClientsList()
              NoCliientView()

          ),

        ),




        floatingActionButton:
        FloatingActionButton.extended(
          onPressed: (){
            MyRouter.pushPage(context, AddClient());
          },
          backgroundColor: Color(0xff1A9EF4),
          autofocus: true,
          isExtended: isScrolled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
          label: Text('Add Clients'),
          icon: Icon(Icons.add),

        )
      //   Showcase(
      //   key: _one,
      //   title: 'Add Client',
      //   titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
      //   description: 'Tap here to add a new client',
      //   //shapeBorder: const CircleBorder(),
      //   child:
      //   // FloatingActionButton(
      //   //     onPressed: (){
      //   //       MyRouter.pushPage(context, AddClient());
      //   //     },
      //   //     child: SvgPicture.asset("assets/images/new_plus.svg",
      //   //       height: 70.0,
      //   //       width: 70.0,)
      //   // ),
      //
      //
      // )
      ),
    );
  }


  _ClientsList() {
    return RefreshIndicator(
      onRefresh: () => getCLientsList(),
      child:
      ListView.builder(
        itemCount: clientsData.length,
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,position){
       //   return _leadsContactView(clientsData[position]['firstname'][0] == 'O' ? Colors.green : clientsData[position]['firstname'][0] == 'S' ? Colors.brown : Colors.orange, clientsData[position]['firstname'] + " " +clientsData[position]['lastname'], clientsData[position]['accountNo'],clientsData[position]['firstname'][0] + clientsData[position]['lastname'][0]);
        //  print(clientsData[position]['status']['value']);
          if(position == 0){
            var newWids =  _leadsContactView(ColorReturn().retStatus(clientsData[0]['status']['value']),
                toBeginningOfSentenceCase(clientsData[0]['displayName']),
                clientsData[position]['accountNo'],clientsData[0]['displayName'][0]
                    + clientsData[0]['displayName'][1],
                '${clientsData[0]['status']['value']} ');
            return InkWell(
              onTap: (){
                print('tapped :: >>');
                MyRouter.pushPage(context, ViewClient(clientID: clientsData[0]['id'],));
              },
                child: showcasefirstTile(context,newWids)
            );
          }

          return InkWell(
            onTap: (){
              MyRouter.pushPage(context, ViewClient(clientID: clientsData[position]['id'],));
            },
            child:    _leadsContactView(
                ColorReturn().retStatus(clientsData[position]['status']['value']),
                toBeginningOfSentenceCase(clientsData[position]['displayName']),
                  '',
                clientsData[position]['displayName'][0]
                    + clientsData[position]['displayName'][1],
                ' ${clientsData[position]['status']['value']} ')
            ,
          );


        },
      ),
    );

  }


  // 0033906702
  // if clientData position firstname is in colordata .. choose from
  // the color data else choose last

  Widget showcasefirstTile(BuildContext context,Widget widName) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: widName
      // Showcase(
      //   key: _three,
      //   description: 'Tap to view client',
      //   disposeOnTap: true,
      //   onTargetClick: () {
      //     // Navigator.push<void>(
      //     //   context,
      //     //   MaterialPageRoute<void>(
      //     //     builder: (_) => const Detail(),
      //     //   ),
      //     // ).then((_) {
      //     //   setState(() {
      //     //     ShowCaseWidget.of(context)!.startShowCase([_four, _five]);
      //     //   });
      //     // });
      //   },
      //   child: widName
      // ),
    );
  }

  _leadsContactView(Color colm,String title,String date,String nameLogo,String employer){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

        height: 80,
        child: ListTile(
          leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
          title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 12,fontWeight: FontWeight.w600),),
          subtitle: Text(employer,style: TextStyle(fontSize: 9,color: Colors.blueGrey),),
          trailing:  Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.blueGrey,)
        ),
      ),
    );
  }

  _LeadingUserTile(Color cols,String nameLogo){
    return Container(
      padding: EdgeInsets.only(top: 1),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cols,
        borderRadius: BorderRadius.all(Radius.circular(60)),

      ),
      child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
    );
  }


  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose...",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          DraggableScrollableSheet(
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.blue[100],
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 25,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text('Item $index'));
                    },
                  ),
                );
              }
          ),

        ],
      ),
    );
  }

  Widget NoCliientView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('Search for existing clients.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Using the textbox above',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            // Container(
            //   width: 155,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     color: Color(0xff077DBB),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: TextButton(
            //     onPressed: (){
            //       MyRouter.pushPage(context,AddClient());
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 0.0),
            //       child:   Text(
            //         'Add Client',
            //         style: TextStyle( fontSize: 12,
            //           color: Colors.white,),
            //       ),
            //
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }


}

Widget NoSearchResult(){
  return Container(
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 200),
          SvgPicture.asset("assets/images/no_loan.svg",
            height: 90.0,
            width: 90.0,),
          SizedBox(height: 20,),
          Text('No Client Records .',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 6,),
          Text('Your search returned no result,try again',style: TextStyle(color: Colors.black,fontSize: 14,),),
          SizedBox(height: 20,),

        ],
      ),
    ),
  );
}

class ClientSearch extends SearchDelegate<String>{


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [IconButton(onPressed: () async{
        // searchClient(query);
      query = '';
    }, icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return IconButton(onPressed: (){}, icon: IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,

      ),
      onPressed: (){
        close(context, null);
      },
    ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
    return NoSearchResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
   //rerer throw UnimplementedError();
   //   print('query ${query}');
    // if(UnimplementedError()){
    //
    // }

    //displayName

    // final suggestionsList  = query.isEmpty ? clientsData.take(5).toList() :
    //  clientsData.where((element) =>element['lastname'].substring(0,1).toUpperCase().contains(query) || toBeginningOfSentenceCase(element['lastname']).contains(query) || element['lastname'].contains(query) || element['lastname'].startsWith(query) || toBeginningOfSentenceCase(element['firstname']).contains(query) || element['firstname'].contains(query) || element['firstname'].startsWith(query)).toList();

    final suggestionsList  = query.isEmpty ? searchCLientData.take(5).toList() :
    searchCLientData.where((element) =>
              element['mobileNo'].toString().contains(query)||
              element['id'].toString().contains(query)||
              element['bvn'].toString().startsWith(query)||
              element['bvn'].toString().contains(query)||
                  element['externalId'].toString().contains(query)||
              element['emailAddress'].toString().contains(query)||
              element['emailAddress'].toString().startsWith(query.toUpperCase())

    ).toList();

    // // toBeginningOfSentenceCase(element['displayName']).contains(toBeginningOfSentenceCase(query)) ||
    //     element['displayName'].contains(query) ||
    //     element['displayName'].startsWith(query.toUpperCase())).toList();


    _LeadingUserTile(Color cols,String nameLogo){
      return Container(
        padding: EdgeInsets.only(top: 1),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cols,
          borderRadius: BorderRadius.all(Radius.circular(60)),

        ),
        child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
      );
    }

    _leadsContactView(Color colm,String title,String date,String nameLogo,String employer,String status){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

          height: 80,
          child: ListTile(
              leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
              title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 12,fontWeight: FontWeight.w600),),
              subtitle: Row(
                children: [
                  Text(employer),
                  Text(status,style: TextStyle(color: status == 'pending' ? Colors.orangeAccent : Colors.green),)
                ],
              ),
              trailing:  Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.blueGrey,)
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestionsList.length,
      primary: false,
      scrollDirection: Axis.vertical,
      itemBuilder: (context,position){
        //   return _leadsContactView(clientsData[position]['firstname'][0] == 'O' ? Colors.green : clientsData[position]['firstname'][0] == 'S' ? Colors.brown : Colors.orange, clientsData[position]['firstname'] + " " +clientsData[position]['lastname'], clientsData[position]['accountNo'],clientsData[position]['firstname'][0] + clientsData[position]['lastname'][0]);
      //  print(clientsData[position]['id']);
        return InkWell(
          onTap: (){
          //  print('client ID ${clientsData[position]['id']}');
            MyRouter.pushPage(context, ViewClient(clientID: suggestionsList[position]['id'],));
         //   MyRouter.pushPage(context, DocumentUpload());
          },
          child:   _leadsContactView(ColorReturn().retStatus(suggestionsList[position]['status']['value']), suggestionsList[position]['displayName'], suggestionsList[position]['accountNo'],suggestionsList[position]['displayName'][0] + suggestionsList[position]['displayName'][0],'','')
          ,
        );
      },
    );
  }


  Widget StatusColor (String value){
    return Text('value',style: TextStyle(color: value == 'Pending' ? Colors.orangeAccent : Colors.red),);
  }

  // Widget searchBarUI(){
  //
  //   return
  //     FloatingSearchBar(
  //     hint: 'Search.....',
  //     openAxisAlignment: 0.0,
  //    // maxWidth: 600,
  //     axisAlignment:0.0,
  //     scrollPadding: EdgeInsets.only(top: 16,bottom: 20),
  //     elevation: 4.0,
  //     physics: BouncingScrollPhysics(),
  //     onQueryChanged: (query){
  //       //Your methods will be here
  //     },
  //    // showDrawerHamburger: false,
  //     transitionCurve: Curves.easeInOut,
  //     transitionDuration: Duration(milliseconds: 500),
  //     transition: CircularFloatingSearchBarTransition(),
  //     debounceDelay: Duration(milliseconds: 500),
  //     actions: [
  //       FloatingSearchBarAction(
  //         showIfOpened: false,
  //         child: CircularButton(icon: Icon(Icons.place),
  //           onPressed: (){
  //             print('Places Pressed');
  //           },),
  //       ),
  //       FloatingSearchBarAction.searchToClear(
  //         showIfClosed: false,
  //       ),
  //     ],
  //     builder: (context, transition){
  //       return ClipRRect(
  //         borderRadius: BorderRadius.circular(8.0),
  //         child: Material(
  //           color: Colors.white,
  //           child: Container(
  //             height: 200.0,
  //             color: Colors.white,
  //             child: Column(
  //               children: [
  //                 ListTile(
  //                   title: Text('Home'),
  //                   subtitle: Text('more info here........'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //
  //   );
  // }



}


class TestItem {
  final String label;
  dynamic value;

  TestItem({@required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}
