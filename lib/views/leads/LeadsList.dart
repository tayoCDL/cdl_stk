import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/util/ColorReturn.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/leads/TestTextField.dart';
import 'package:sales_toolkit/views/leads/addLead.dart';
import 'package:sales_toolkit/views/leads/singleLeadView.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:sticky_headers/sticky_headers.dart';



class LeadList extends StatelessWidget {
  const LeadList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      LeadsLists()
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
      //   builder: Builder(builder: (context) => const LeadsLists()),
      //   autoPlayDelay: const Duration(seconds: 3),
      // ),
    );
  }
}


class LeadsLists extends StatefulWidget {
  const LeadsLists({Key key}) : super(key: key);

  @override
  _LeadsListsState createState() => _LeadsListsState();
}

var leadsData = [];
var allLead = [];
var GlobalLeadData =  [];
bool isScrolled = true;

String _isLoading = 'not_loading';
//var clientsData = [];

class _LeadsListsState extends State<LeadsLists> {

  // checkTour() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ActiveTour =   prefs.getBool('isTourActive1236');
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
  final TextEditingController _typeAheadController = TextEditingController();


  @override
  // void initState() {
  //   // TODO: implement initState
  //  getCLientsList();
  //   super.initState();
  // }

  void initState() {
    super.initState();
    //  checkTour();
    getLeadsList();
    getGlobalLeadsList();
  }

  Future<List> getSuggestions(String query) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Future<Map<String,dynamic>> respose =   RetCodes().searchClient(query);
    //print('resp')
    respose.then((response) async {
      List<dynamic> newEmp = response['data'];
      setState(() {
        allLead =  newEmp;

      });
      // print('newEmp ${newEmp}');

    });
    //  print('employer Array ${allEmployer}');

    return allLead;


  }




  getLeadsList() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    print('staffId ${staffId}');
    print(tfaToken);
    print(token);
    setState(() {
      _isLoading  = 'is_loading';
    });
    //leadOfficerId
    Response responsevv = await get(
      AppUrl.LeadsList+'?leadOfficerId=${staffId}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print('this is leads list');
    print(responsevv.body);
    var newClientData = responseData2['pageItems'];
    setState(() {
      leadsData = newClientData;
      _isLoading = 'loaded';
    });
    print(leadsData);
  }

  getGlobalLeadsList() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    print('staffId ${staffId}');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.LeadsList,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print('this is leads list');
    print(responsevv.body);
    var newClientData = responseData2['pageItems'];
    setState(() {
      GlobalLeadData = newClientData;
    });
    print(GlobalLeadData);
  }

  allWordsCapitilize (String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  @override

  // List<ClientLists> clientList =
  Widget build(BuildContext context) {
    return Scaffold(

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
        Column(
          children: [
            SizedBox(height: 5,),
            // Showcase(
            //         key: _two,
            //         title: 'Search',
            //         description: 'Tap here to search for all leads',
            //   child: TypeAheadField(
            //
            //     textFieldConfiguration: TextFieldConfiguration(
            //       // autofocus: true,
            //         style: DefaultTextStyle.of(context).style.copyWith(
            //             fontStyle: FontStyle.italic
            //         ),
            //         // style: TextStyle(
            //         //   height: 10,
            //         // ),
            //         controller: this._typeAheadController,
            //
            //         decoration: InputDecoration(
            //
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //               borderSide: BorderSide(color: Colors.grey),
            //             ),
            //             contentPadding: EdgeInsets.all(5),
            //             hintText:  'Search Existing Leads ',
            //             prefixIcon: Icon(Icons.search,color: Colors.grey.withOpacity(0.9),)
            //         )
            //     ),
            //
            //     // suggestionsBoxController: parentEmployerController,
            //     transitionBuilder: (context, suggestionsBox, animationController) =>
            //         FadeTransition(
            //           child: suggestionsBox,
            //           opacity: CurvedAnimation(
            //               parent: animationController,
            //               curve: Curves.fastOutSlowIn
            //           ),
            //         ),
            //     suggestionsCallback: (pattern) async {
            //       return await getSuggestions(pattern);
            //       //getEmployersList(realEmployerSector,value);
            //
            //     },
            //     debounceDuration: Duration(milliseconds: 500),
            //     itemBuilder: (context, suggestion) {
            //       //  print('user suggestion ${suggestion}');
            //       return ListTile(
            //         leading: Icon(Icons.person),
            //         title: Text(suggestion['entityName']),
            //         subtitle: Text('${suggestion['entityMobileNo']}'),
            //       );
            //     },
            //     noItemsFoundBuilder: (context) => Container(
            //       height: 100,
            //       child: Center(
            //         child: Text('No Lead Found'),
            //       ),
            //     ),
            //     onSuggestionSelected: (suggestion) {
            //       print('suggestion selected ${suggestion}');
            //       //var entityID = suggestion['entityId'];
            //
            //     //  MyRouter.pushPage(context, ViewLead(clientID: entityID,));
            //       // this._typeAheadController.text = suggestion['name'];
            //       // print('suggesttion ${suggestion}');
            //       // employerInt = suggestion['id'];
            //       // employerDomain = suggestion['emailExtension'];
            //       // getEmployersBranch(employerInt);
            //       // branchEmployerInt = 0;
            //       // setState(() {
            //       //   employerState = '';
            //       //   branchEmployer = '';
            //       //   employerLga = '';
            //       //   address.text = '';
            //       //   employer_phone_number.text = '';
            //       //   _isOTPSent = false;
            //       //   employerArray = [];
            //       // });
            //
            //       // Navigator.of(context).push(MaterialPageRoute(
            //       //     builder: (context) => ProductPage(product: suggestion)
            //       // ));
            //     },
            //   ),
            // ),
          ],
        ),
      ),

      // AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 15),
      //     child: Text('Leads', style: TextStyle(
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
      //       description: 'Tap here to search for all leads',
      //       shapeBorder: const CircleBorder(),
      //       child: IconButton(onPressed: (){
      //         showSearch(context: context, delegate: ClientSearch());
      //       }, icon: Icon(FeatherIcons.search,color: Theme.of(context).colorScheme.secondary,)),
      //     )
      //   ],
      // ),
      body:  NotificationListener<UserScrollNotification>(
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
        child:     Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child:  leadsData.length == 0  && _isLoading == 'is_loading' ? ShimmerListLoading() : leadsData.length == 0 && _isLoading == 'loaded' ? NoLeadView() : _ClientsList()
        ),
      ),




      floatingActionButton:

      FloatingActionButton.extended(
        onPressed: (){
          MyRouter.pushPage(context,AddLead());
          // MyRouter.pushPage(context, TestTextField());
        },
        isExtended: isScrolled,
        backgroundColor: Color(0xff1A9EF4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
        label: Text('Add Prospect'),
        icon: Icon(Icons.add),

      )


      // Showcase(
      //     key: _one,
      //     title: 'Add Prospect',
      //     titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
      //     description: 'Tap here to add a new Prospect',
      //     //shapeBorder: const CircleBorder(),
      //     child:
      //
      //     // FloatingActionButton(
      //     //
      //     //     onPressed: (){
      //     //       MyRouter.pushPage(context,AddLead());
      //     //     },
      //     //     child:     SvgPicture.asset("assets/images/new_plus.svg",
      //     //       height: 70.0,
      //     //       width: 70.0,)
      //     // ),
      //
      //
      //
      //
      //
      // ),

    );
  }


  _ClientsList() {
    return RefreshIndicator(
      onRefresh: () => getLeadsList(),
      child: ListView.builder(
        itemCount: leadsData.length,
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,position){
          //   return _leadsContactView(clientsData[position]['firstname'][0] == 'O' ? Colors.green : clientsData[position]['firstname'][0] == 'S' ? Colors.brown : Colors.orange, clientsData[position]['firstname'] + " " +clientsData[position]['lastname'], clientsData[position]['accountNo'],clientsData[position]['firstname'][0] + clientsData[position]['lastname'][0]);
          // print (leadsData[position]['moreInfo']['clients']['id']);
          return _leadsContactView((){
            MyRouter.pushPage(context, ViewLead(leadID: leadsData[position]['id'],clientID:leadsData[position]['moreInfo']['clients']['id']));
            //ViewLead
          },ColorReturn().retCOlor(leadsData[position]['moreInfo']['clients']['firstname'][0].toUpperCase()),
              toBeginningOfSentenceCase(leadsData[position]['moreInfo']['clients']['firstname']) + " " + leadsData[position]['moreInfo']['clients']['lastname'],
              leadsData[position]['moreInfo']['clients']['accountNo'],
              leadsData[position]['moreInfo']['clients']['firstname'][0] + leadsData[position]['moreInfo']['clients']['lastname'][0],
              leadsData[position]['moreInfo']['clients']['employmentSector']['name'] == null ? 'No Employer' : '${leadsData[position]['moreInfo']['clients']['employmentSector']['name']}');

        },
      ),
    );

  }

  _leadsContactView(var onTapped,Color colm,String title,String date,String nameLogo,String employer){
    return InkWell(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

          height: 80,
          child: ListTile(
              leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
              title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 12,fontWeight: FontWeight.w600),),
              subtitle: Text(employer),
              trailing:  Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.blueGrey,)
          ),
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

  Widget NoLeadView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Prospect Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Click button below to add a prospect',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            Container(
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff077DBB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: (){
                  MyRouter.pushPage(context,AddLead());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Add Prospect',
                    style: TextStyle( fontSize: 12,
                      color: Colors.white,),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}

class ClientSearch extends SearchDelegate<String>{


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [IconButton(onPressed: (){
      query ='';
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
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();

    //displayName

    // final suggestionsList  = query.isEmpty ? clientsData.take(5).toList() :
    //  clientsData.where((element) =>element['lastname'].substring(0,1).toUpperCase().contains(query) || toBeginningOfSentenceCase(element['lastname']).contains(query) || element['lastname'].contains(query) || element['lastname'].startsWith(query) || toBeginningOfSentenceCase(element['firstname']).contains(query) || element['firstname'].contains(query) || element['firstname'].startsWith(query)).toList();

    final suggestionsList  = query.isEmpty ? GlobalLeadData.take(5).toList() :
    GlobalLeadData.where((element) =>
    toBeginningOfSentenceCase(element['moreInfo']['clients']['displayName']).contains(toBeginningOfSentenceCase(query)) ||
        element['moreInfo']['clients']['displayName'].contains(query) ||
        element['moreInfo']['clients']['displayName'].startsWith(query.toUpperCase())).toList();


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

    _leadsContactView(Color colm,String title,String date,String nameLogo,String employer){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

          height: 80,
          child: ListTile(
              leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
              title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 16,fontWeight: FontWeight.w600),),
              subtitle: Text(employer,style: TextStyle(fontSize: 14,color: Colors.blueGrey),),
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
        //print(clientsData[position]['id']);
        var leadData = suggestionsList[position]['moreInfo']['clients'];
        return InkWell(
          onTap: (){
            print('client ID ${GlobalLeadData[position]['id']}');
            // MyRouter.pushPage(context, ViewLead(leadID: suggestionsList[position]['id'],));
            MyRouter.pushPage(context, ViewLead(leadID: suggestionsList[position]['id'],clientID:suggestionsList[position]['moreInfo']['clients']['id']));

            //   MyRouter.pushPage(context, DocumentUpload());
          },
          child:   _leadsContactView(ColorReturn().retCOlor(leadData['firstname'][0].toUpperCase()), leadData['firstname'] + " " +leadData['lastname'], leadData['accountNo'],leadData['firstname'][0] + leadData['lastname'][0],'')
          ,
        );
      },
    );
  }

}
