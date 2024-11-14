import 'dart:convert';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteractionChat.dart';
import 'package:sales_toolkit/views/Interactions/CreateOpportunity.dart';
import 'package:sales_toolkit/views/Interactions/clientOpportunity.dart';
import 'package:sales_toolkit/views/Loans/EmbeddedLoanView.dart';
import 'package:sales_toolkit/views/Loans/LoanView.dart';
import 'package:sales_toolkit/views/Interactions/AddInteraction.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteraction.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/views/clients/PersonalInfo.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/views/trops/trops_issues_lists.dart';
import 'package:sales_toolkit/widgets/ProfileShimmer.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_toolkit/models/message_model.dart';

import '../trops/log_trops_issues.dart';
import '../trops/trops_users_issues_lists.dart';
import 'account_information.dart';

class ViewClient extends StatefulWidget {
  final int clientID;
  final String comingFrom;
  const ViewClient({Key key,this.clientID,this.comingFrom}) : super(key: key);
  @override
  _ViewClientState createState() => _ViewClientState(
      clientID: this.clientID,
      comingFrom: this.comingFrom
  );
}


class _ViewClientState extends State<ViewClient> {

  int clientID;
  String comingFrom;
  _ViewClientState({this.clientID,this.comingFrom});

  var clientProfile = {};
  var clientAvatar = '';
  var activityList = [];
  String realMonth = '';
  List<dynamic> CustomerProduct = [];
  List<dynamic> clientAccounts = [];
  String clientAcountNumber = '';

  String dummyAvatar =   "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a\r\nHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy\r\nMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCACWAJYDASIA\r\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\r\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\r\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\r\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\r\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\r\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\r\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\r\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2Siii\r\ngAooooAKKWjFABRS4qvdX9pZDNxOiH+7nJ/Ic0AT0YrAn8WW6HEFvJJ7sQo/rVf/AIS5/wDnzX/v\r\n5/8AWoA6eisK28VWshC3ELw/7QO4f4/pW5FJHPEskTq6N0ZTkGgBcUlOxSUAJRRiigAooooAKKKK\r\nACiiigApaKUCgAApwFKBWfrtybTR53U4dhsU/X/62aAMLWfEMjyNbWT7I1OGlU8t9D2Fc6SWJJJJ\r\nPUmkooAKKKKACrllql3p+Rby7VY5KkAg1TooA7jQ9Z/tRXjlVUnTnC9GHqK1iK4PQJ/I1q2OTh22\r\nEDvngfriu/IoAixRTiKSgBtFLSUAFFFFABS0lKKAFAp4FIBT1FACgVg+MONJh/67j/0Fq6JRWJ4u\r\nhL6IHH/LOVWP6j+tAHB0UUUAFFFFABRRRQBd0hS2sWYAz++U/rXpBWuA8MqG8Q2gIzyx/wDHTXob\r\nLQBXIphFTMKjIoAjpKcRSUAJRRRQAtKKSnigByipFFNUVKooAcorJ8UzRw6BMr/elKog9TnP9DWy\r\nornPG6/8Sm3b0nA/8dP+FAHC0UUUAFFFFABRRRQBf0W8Sw1i2uZBlFYhvYEEZ/DOa9NIzXkdesWW\r\n46dbF/veUufrgUADComFWGFQsKAISKYakYUw0ANopaKAFFPWmCpFoAeoqZRUa1MtAD1FZXim0N1o\r\nE+0ZaLEoH06/pmtdaeKAPG6K6vxho9pYJb3FpAIhI7CQKTgnqMDoO/SuUoAKKKKACiiigCeztXvb\r\n2G2jBLSOF+nvXrW0KoUDAAwKy9B0W20yzikEQN06AySHk5PUD0FaxoAhYVCwqdqiagCBhUZqVqjN\r\nADKKKKAHCnrTBUi0ASrUy1CtTLQBItPFNFOFAHOeN42fQ42UEhJ1LewwR/MivPq9b1GWzh0+Vr8q\r\nLYja+4E5zx0HNeUXAiFzKIGZoQ58st1K54z+FAEdFFFABUkEElzcRwRLueRgqj3NR10XhS90zT7m\r\nae+k2S4CxEoWwO/Qden60AehKoVQo6AYpDTgQRkHIPQ000ARtULVM1RNQBC1RGpWqJqAGGig0UAK\r\nKkWoxUi0ATLUq1CtLLcw20fmTypGg/idsCgC0tPFcnfeNLaIFLGIzN2d/lX8up/Sucu/EmrXZIa7\r\neNSSQsXyAe2RyfxNAGr4z1YXNymnwtmOE5kI6F/T8Ofz9q5WjrRQAUUUUAFFFFAHofhLVhe6cLSR\r\nv9Itxjn+JOx/Dp+XrXQGvH4ppYJBJDI8bjoyNgj8a2rPxZqlqVEkouIwMbZRz+Y5z9c0AehNULVj\r\n2PizT7zCzE20h7Sfd/76/wAcVrFgyhlIIPIIPWgCNqjNSNURoAaaKKKAFFU7rWbGyyJZ1Lj+BPmP\r\n6dPxrmta1uW4ne3t3KQKSpKnl/8A61YdAHS3vi6ZwUsohEP778t+XQfrXP3FzPdSeZPK8j+rHNRU\r\nUAFFFFABRRRQAUUUUAFFFFABRRRQAVbs9SvLA5tp2Qd16qfwPFVKKAOstPFyPhbyAof78fI/I8/z\r\nrat761vFzbzpJ3wDyPqOtec0qsyMGRirDkEHBFAHpdFc9omu+cjQXrgOgysh/iHofeigDlnOZGPu\r\nabQTkk0UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBNbttkJzjiiolbac0UAJRRRQA\r\nUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB/9k=";


  retRealFile(String img){
    var Velo =  img.split(',').first;
    int chopOut = Velo.length + 1;
    String realfile =  img.substring(chopOut).replaceAll("\n", "").replaceAll("\r", "");
    return realfile;
  }

  final formatCurrency = NumberFormat.currency(locale: "en_US",
      symbol: "");

  @override
  void initState() {
    // TODO: implement initState
    final recentChat = recentChats[0];
    getClientProfile();
    getClientAvatar();
  //    getaccountsList();
 //   getActivityList();
    getClientAccount();
    getInteracctionForClient();
    super.initState();
  }


  var interactionData = [];

  getInteracctionForClient() async{
    print('clientID ${clientID}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var sequesttoken = prefs.getString('sequestToken');
    print('sequestToken ${sequesttoken}');

    try{
      Response responsevv = await get(
        AppUrl.getRecentTicketByCLientId + '${clientID}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );
      print(responsevv.statusCode);

      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      // print(responseData2);
      var newClientData = responseData2['data'];
      setState(() {
        interactionData = newClientData;
      });
      print(interactionData);
    }
    catch(e){
      print( 'this is ${e}');
    }

  }


  getActivityList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().activityList(clientAcountNumber);

    respose.then((response) async {
      print('received  ${response['data']}');

      if(response['data'] == null){
        print('no channels available');
      }
      else {
        setState(() {
          activityList = response['data']['pageItems'];
        });
        print('activity list ${activityList}');
        // print('this is response ' + response.toString());
        // setState(() {
        //   CustomerProduct = response['data']['summaries'];
        // });
        //
        // print('customer Product ${CustomerProduct}');
      }
    }
    );

  }

  getaccountsList(){
    final Future<Map<String,dynamic>> respose =   RetCodes().accounts(clientID.toString());

    respose.then((response) async {
      print(response['data']);

      if(response['status'] == false){

      } else {
        // print('this is response ' + response.toString());
        setState(() {
          CustomerProduct = response['data']['summaries'];
        });

        print('customer Product ${CustomerProduct}');
      }


    }
    );

  }

  getClientAvatar() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleClientForLoanReview + clientID.toString(),
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
    var newClientData = responseData2;
    setState(() {
      clientAcountNumber = newClientData['clients']['accountNo'];
      clientAvatar = newClientData['avatar'];
    });
    print(clientAvatar);
  }

  getClientProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      // clients/cdl/{clientId}/stk
   //   AppUrl.getSingleClient + 'cdl/' +  clientID.toString() + '/stk',
      AppUrl.getSingleClient + clientID.toString(),
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
    var newClientData = responseData2;
    setState(() {
      clientProfile = newClientData;
    });
    print(clientProfile);
  }

  getClientAccount() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Future<Map<String,dynamic>> respose =   RetCodes().clientAccount(clientID.toString() ,context: context);
    respose.then(
            (response) {
           print('this is app data ${response['data']}');
          if(response['data'] == null && response['message'] == 'Unauthenticated'){
            MyRouter.pushPageReplacement(context, LoginScreen(login_type: 'Loan Management',));
          }

         // [{"clientName":" muritala  DUNMINU Yusuf","bankName":"Credit Direct Finance Limited","accountNumber":"5119806195"}]

          // print('this is referal ${response['data']}');
          setState(() {
            clientAccounts = response['data'];
          });

          //    prefs.setString('loanOfficerId', loanOfficerId.toString());

        }
    );

  }


  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

    comingSoon(){

      return alert(
        context,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pending Client Activation '),
            InkWell(
                onTap: (){
                  MyRouter.popPage(context);
                },
                child: Icon(Icons.clear))
          ],  ),
        content: Text('Client activation is required \nbefore booking loan for this client,\n kindly reachout to your supervisor to \n activate this client on NX360,\n'),
        textOK: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: RoundedButton(buttonText: 'Okay',onbuttonPressed: (){
            MyRouter.popPage(context);
          },
          ),
        ),
      );
    }


    void actionPopUpItemSelected(String value) {

      if (value == 'customer_info') {
        print('got here');
        MyRouter.pushPage(context, SingleCustomerScreen(clientID: clientID,));
      }
      if (value == 'account_information') {
        print('got here');
        MyRouter.pushPage(context, AccountInformation(clientID: clientID,));
      }
      // else if (value == 'interaction') {
      //   MyRouter.pushPage(context,
      //       ClientInteraction(
      //         clientID: clientID,
      //         clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
      //         ClientEmail: clientProfile['emailAddress'],  ));
      //
      // }
      else if(value == 'create_opportunity') {
     //   MyRouter.pushPage(context,
            // ClientOpportunity(
            //   clientID: clientID,
            //   clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
            //   ClientEmail: clientProfile['emailAddress'],  ));
        MyRouter.pushPage(context,LogTropsIssues());
        //  TropIssuesLists(clientID: clientID,);
      }
      else if (value == 'loans' || value == 'embedded_loans') {
        if(clientProfile['status']['value'] == 'Pending'){
          comingSoon();
        }

       // embedded_loans
        else if(value == 'loans'){
          MyRouter.pushPage(context, LoanView(clientID: clientID,));
        //  TropIssuesLists(clientID: clientID,);
        }

        else if(value == 'embedded_loans'){
          //  MyRouter.pushPage(context,NewLoan(clientID: clientID,employerId: employerID,sectorID:sectorId,parentClientType:parentClient ,));
          MyRouter.pushPage(context, EmbeddedNewLoan(clientID: clientID,));
          //  TropIssuesLists(clientID: clientID,);
        }

      }
      else if (value == 'new_interaction') {
        MyRouter.pushPage(context, AddInteraction(
          clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
          ClientEmail: clientProfile['emailAddress'],
          ClientID: clientProfile['id'],
        ));
      }
      else if (value == 'all_interaction') {
        MyRouter.pushPage(context, ClientInteraction(
          clientID: clientID,
          clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
          ClientEmail: clientProfile['emailAddress'],
        ));
      }

      else {
        comingSoon();
      }

    }


    return Scaffold(
   //   backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.white,
      body: clientProfile.isEmpty ? clientProfile == null ? Text('Unable to load'): ProfileShimmerLoading():

      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: (){
                  if(comingFrom == 'oppsLogged'){
                    MyRouter.popPage(context);
                  }
                  else {
                    MyRouter.pushPageReplacement(context, MainScreen());
                  }
                  //   MyRouter.popPage(context);
                },
                icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title:

                Text(clientProfile.isEmpty ? '- -' : '${clientProfile['displayName'].toString()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontFamily: 'Nunito SansRegular',
                        fontWeight: FontWeight.bold
                    )
                ),


                background:
                // CircleAvatar(
                //   backgroundColor: Colors.transparent,
                //   child: SizedBox(
                //     width: 90,
                //     height: 90,
                //     child: ClipOval(
                //       child:
                //
                //       ,
                //     ),
                //   ),
                // )

                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Container(
                      height: 100,
                      width: 100,
                      child:
                      clientAvatar == null || clientAvatar.isEmpty ?  Image.memory(
                          base64Decode(
                              retRealFile(dummyAvatar)
                          )
                      )
                          :
                      Image.memory(
                          base64Decode(
                              retRealFile(clientAvatar)
                          )
                      )
                  ),
                  minRadius: 90.0,

                ),
              ),
              actions: [

                clientProfile['status']['value'] == 'Active' || clientProfile['status']['value'] == 'Pending' ?

                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.blue,),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'customer_info',
                        child: Text('Customer Information',),
                      ),
                      // PopupMenuItem(
                      //   value: 'interaction',
                      //   child: Text('Interaction'),
                      // ),
                      // PopupMenuItem(
                      //   value: 'account_information',
                      //   child: Text('Account Information'),
                      // ),
                      PopupMenuItem(
                        value: 'create_opportunity',
                        child: Text('Initiate Tickets'),
                      ),
                      // PopupMenuItem(
                      //   value: 'delete',
                      //   child: Text('Channels Activites'),
                      // ),
                      PopupMenuItem(
                        value: 'loans',
                        child: Text('Loans'),
                      ),

                      PopupMenuItem(
                        value: 'embedded_loans',
                        child: Text('Embedded Loans'),
                      ),


                      // PopupMenuItem(
                      //   value: 'delete',
                      //   child: Text('Wallet'),
                      // ),

                    ];
                  },
                  onSelected: (String value) => actionPopUpItemSelected(value),
                ) :

                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.blue,),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'customer_info',
                        child: Text('Customer Information',),
                      ),
                      // PopupMenuItem(
                      //   value: 'interaction',
                      //   child: Text('Interactions'),
                      // ),
                      // PopupMenuItem(
                      //   value: 'delete',
                      //   child: Text('Channels Activites'),
                      // ),
                      

                    ];
                  },
                  onSelected: (String value) => actionPopUpItemSelected(value),
                )
                ,
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: clientProfile.isEmpty ? MediaQuery.of(context).size.height * 0.61 : clientProfile['status']['value'] == 'InComplete' ? MediaQuery.of(context).size.height * 0.57 : MediaQuery.of(context).size.height * 0.65,
                  child: ListView(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer Type: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile.isEmpty || clientProfile['clientType'] == null  ? '- -' :  '${clientProfile['clientType']['name']}',style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('External ID: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile.isEmpty || clientProfile['externalId'] == null  ? 'N/A' :  '${clientProfile['externalId']}',style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer ID: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('${clientID}',style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),
                      // Text('${clientProfile['activationDate']}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Activation Date: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile['activationDate'] != null ?
                          '${retDOBfromBVN('${clientProfile['activationDate'][0]}-${clientProfile['activationDate'][1]}-${clientProfile['activationDate'][2]}')}'
                              : "N/A"
                            ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Creation Date: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile['timeline'] != null ?
                          '${retDOBfromBVN('${clientProfile['timeline']['submittedOnDate'][0]}-${clientProfile['timeline']['submittedOnDate'][1]}-${clientProfile['timeline']['submittedOnDate'][2]}')}'
                              : "N/A"
                            ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Activation Channel: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile['activationChannel'] != null ?
                          '${'${clientProfile['activationChannel']['name']}'}'
                              : "N/A"
                            ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                        ],
                      ),
                      // SizedBox(height: 10,),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                      SizedBox(height: 15,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Client’s Status: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          clientProfile.isEmpty ? SizedBox() :   clientProfile['status']['value'] == 'InComplete' ? clientStatus( Color(0xffFF0808), clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Pending' ? clientStatus( Colors.orange, clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Active' ? clientStatus( Colors.green, clientProfile['status']['value'])
                              : clientStatus( Colors.blueAccent, clientProfile['status']['value '])


                        ],
                      ),

                      // SizedBox(height: 10,),
                      SizedBox(height: 15,),
                      Divider(thickness: 1,height: 1.3,),
                    //  SizedBox(height: 15,),


                  clientAccounts.length == 0
                      ?
                  SizedBox():

                  Container(
                    height: AppHelper().pageHeight(context) * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Removed the duplicate "Bank Name" Row here

                        Expanded(
                          child: Container(
                            height: AppHelper().pageHeight(context) * 0.12,
                            child: ListView.builder(
                              itemCount: clientAccounts.length,
                              itemBuilder: (context, index) {
                                var singleAccount = clientAccounts[index];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Bank Name: ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${singleAccount['bankName']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 4,),
                                            Text(
                                              '${singleAccount['accountNumber']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Divider(thickness: 1, height: 1.3),
                                    SizedBox(height: 15),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       'Account Number: ',
                                    //       style: TextStyle(
                                    //         fontSize: 17,
                                    //         color: Colors.grey[500],
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       '${singleAccount['accountNumber']}',
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontSize: 19,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                      // Container(
                  //   height: AppHelper().pageHeight(context) * 0.15,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('Bank Name: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                  //       // Text('${singleAccount['bankName']}'
                  //       //   ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                  //
                  //       Container(
                  //         height: AppHelper().pageHeight(context) * 0.12,
                  //         child:
                  //         ListView.builder(
                  //             itemCount: clientAccounts.length ?? 0,
                  //             itemBuilder: (index,position){
                  //               var singleAccount  = clientAccounts[position];
                  //               return
                  //                 Column(
                  //                   children: [
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text('Bank Name: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                  //                         Text('${singleAccount['bankName']}'
                  //                           ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 15,),
                  //                     Divider(thickness: 1,height: 1.3,),
                  //                     SizedBox(height: 15,),
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text('Account Number: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                  //                         Text('${singleAccount['accountNumber']}'
                  //                           ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 );
                  //             })
                  //         ,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                    // Container(
                    //     height: AppHelper().pageHeight(context) * 0.12,
                    //     child:
                    //         ListView.builder(
                    //           itemCount: clientAccounts.length ?? 0,
                    //             itemBuilder: (index,position){
                    //             var singleAccount  = clientAccounts[position];
                    //                 return
                    //                   Column(
                    //                     children: [
                    //                       Row(
                    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                         children: [
                    //                           Text('Bank Name: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                    //                           Text('${singleAccount['bankName']}'
                    //                             ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                    //                         ],
                    //                       ),
                    //                       SizedBox(height: 15,),
                    //                       Divider(thickness: 1,height: 1.3,),
                    //                       SizedBox(height: 15,),
                    //                       Row(
                    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                         children: [
                    //                           Text('Account Number: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                    //                           Text('${singleAccount['accountNumber']}'
                    //                             ,style: TextStyle(color: Colors.black,fontSize: 19,),)
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   );
                    //             })
                    //   ,
                    // ),


                      SizedBox(height: 30,),

                      // RoundedButton(buttonText: 'Edit Profile', onbuttonPressed: (){
                      //   MyRouter.pushPage(context, AddClient(
                      //     ClientInt: clientProfile['id'],
                      //     //   sector: clientProfile['clients']['employmentSector'],
                      //     comingFrom: 'viewClient',
                      //     Passedbvn: clientProfile['bvn'],
                      //   ));
                      // }),


                         clientProfile['status']['value'] == 'InComplete' ?  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.43,
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            // color: Color(0xff077DBB),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.blue
                              )
                          ),
                          child: OutlinedButton(
                            onPressed: (){
                              MyRouter.pushPage(context, AddClient(
                                ClientInt: clientProfile['id'],
                                //   sector: clientProfile['clients']['employmentSector'],
                                comingFrom: 'viewClient',
                                Passedbvn: clientProfile['bvn'],
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child:

                              Text(
                                'Edit Profile',
                                style: TextStyle(color: Color(0xff077DBB),fontFamily: 'Nunito SansRegular'),
                              ),

                            ),
                          ),
                        ),
                      ) : SizedBox(),

                    ],
                  ),
                ),




                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text('Products',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                //     ],
                //   ),
                // ),
                //
                //
                //
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Container(
                //     height: 120,
                //     child: ListView.builder(
                //         itemCount: CustomerProduct.length,
                //         primary: false,
                //         scrollDirection: Axis.horizontal,
                //         itemBuilder: (context,position){
                //           //return   productsList(dummyProduct[position]['imageAsset'],dummyProduct[position]['title'],dummyProduct[position]['balance']);
                //           return   productsList(CustomerProduct[position]['name'] == 'Wallet' ? 'assets/images/ov1.svg' : CustomerProduct[position]['name'] == 'Investment' ? 'assets/images/ov2.svg' : 'assets/images/oe3.svg',
                //               CustomerProduct[position]['name'],
                //               CustomerProduct[position]['balance'] == null ? 0 :   CustomerProduct[position]['balance']
                //           );
                //         }
                //     ),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text('Recent Channel Activity',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                //     ],
                //   ),
                // ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: activityList.isEmpty ? noChannels() : recentChannels() ,
                // ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text('Recent Interactions',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                //       PopupMenuButton(
                //         icon: Icon(Icons.more_vert,color: Colors.blue,),
                //         itemBuilder: (context) {
                //           return [
                //             PopupMenuItem(
                //               value: 'new_interaction',
                //               child: Text('New Interaction',),
                //             ),
                //             PopupMenuItem(
                //               value: 'all_interaction',
                //               child: Text('View All'),
                //             ),
                //
                //           ];
                //         },
                //         onSelected: (String value) => actionPopUpItemSelected(value),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                //
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: interactionData.length == 0 ?
                //   Container(
                //       height: MediaQuery.of(context).size.height * 0.4,
                //       child: NoInteractionView()
                //
                //   )
                //
                //       :
                //   ListView.builder(
                //     itemCount:interactionData.length < 4 ? interactionData.length : 4 ,
                //     primary: false,
                //     physics: ClampingScrollPhysics(),
                //     shrinkWrap: true,
                //     scrollDirection: Axis.vertical,
                //     itemBuilder: (context,position){
                //       //   final recentChat = recentChats[position];
                //       return recentInteractions(interactionData[position]['ticketId'],interactionData[position]['title'],interactionData[position]['status'],(){
                //         MyRouter.pushPage(context, ClientInteractionChat(ticketID: interactionData[position]['ticketId'],));
                //       });
                //     },
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              ],
            ),
          ),
        ),
      ),


    );
  }



  Widget productsList(String imageAsset,String title,var balance){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(imageAsset,
                      height: 30.0,
                      width: 30.0,),

                  ],

                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(title,style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //  Text('₦${formatCurrency.format(balance)}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                    Text('₦${balance}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget recentChannels(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.61,
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (index,position){
                    DateTime time1 = DateTime.parse(activityList[position]['lastModifiedDate']);
                    return   Container(
                      height: 60,
                      child: ListTile(
                        leading:    SvgPicture.asset( activityList[position]['activationChannel'] == 'Web' ? 'assets/images/oe3.svg' : 'assets/images/oe2.svg' ,
                          height: 40.0,
                          width: 40.0,
                        ) ,
                        title:Text('${activityList[position]['description']}',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                        subtitle: Text(convertToAgo(time1),style: TextStyle(fontSize: 14,color: Colors.black,),),
                      ),
                    );
                  }),
            ),
            //

            SizedBox(height: 10,),
            // Container(
            //   width: 155,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     color: Color(0xff077DBB),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: FlatButton(
            //     onPressed: (){},
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 0.0),
            //       child: Row(
            //         children: [
            //           Text(
            //             'View All Activities',
            //             style: TextStyle( fontSize: 12,
            //               color: Colors.white,),
            //           ),
            //           SizedBox(width: 10,),
            //           Icon(Icons.arrow_forward,color: Colors.white,size: 15,)
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }


  Widget noChannels(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Container(
              height: 60,
              child: ListTile(
                leading:   SvgPicture.asset('assets/images/oe1.svg',
                  height: 40.0,
                  width: 40.0,),
                title:Text('No Tracking available',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                subtitle: Text('Not available ',style: TextStyle(fontSize: 14,color: Colors.black,),),
              ),
            ),
            Divider(color: Colors.grey,thickness: 0.2,),

          ],
        ),
      ),
    );
  }


  // Widget recentInteractions(){
  //  return ListView.builder(
  //      shrinkWrap: true,
  //      physics: ScrollPhysics(),
  //      itemCount: 2,
  //
  //      itemBuilder: (context, int index) {
  //        final recentChat = recentChats[index];
  //       return InkWell(
  //          onTap: () {
  //            MyRouter.pushPage(context, ClientInteractionChat(
  //              user: recentChat.sender,
  //            ));
  //          },
  //          child: Container(
  //            height: MediaQuery
  //                .of(context)
  //                .size
  //                .height * 0.189,
  //
  //            child: Card(
  //              elevation: 0,
  //              child: Container(
  //                padding: EdgeInsets.only(top: 14),
  //                child: Column(
  //                  children: [
  //                    Padding(
  //                      padding: const EdgeInsets.symmetric(
  //                          vertical: 5, horizontal: 20),
  //                      child: Row(
  //                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                        children: [
  //
  //                          Text('#234567'),
  //                          Container(
  //                            width: 65,
  //                            padding: EdgeInsets.symmetric(
  //                                horizontal: 4, vertical: 3),
  //                            decoration: BoxDecoration(
  //                              borderRadius: BorderRadius.circular(20),
  //                              color: Color(0xffF66C9F).withOpacity(0.9),
  //                              boxShadow: [
  //                                BoxShadow(color: Color(0xffF66C9F),
  //                                    spreadRadius: 0.1),
  //                              ],
  //                            ),
  //                            child: Center(child: Text('Close',
  //                              style: TextStyle(color: Colors.white),)),
  //                          ),
  //
  //                        ],
  //
  //                      ),
  //                    ),
  //                    Container(
  //                      child: ListTile(
  //                        title: Text('Inability to complete loan request',
  //                          style: TextStyle(fontSize: 16,
  //                              color: Colors.black,
  //                              fontWeight: FontWeight.bold),),
  //                        trailing: Icon(
  //                          Icons.arrow_forward_ios_rounded, color: Colors
  //                            .blue,),
  //                        subtitle: Text(
  //                          'Last updated: 2022-01-20', style: TextStyle(
  //                            fontSize: 11,
  //                            color: Colors.grey,
  //                            fontWeight: FontWeight.w200),),
  //                      ),
  //                    )
  //
  //
  //                  ],
  //                ),
  //              ),
  //            ),
  //          ),
  //        );
  //
  //      }
  //  );
  // }



  Widget recentInteractions(String ticketId,String title,String status,Function onTicketTapped){
    return InkWell(
      onTap: onTicketTapped,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.189,

        child: Card(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.only(top: 14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(ticketId),
                      Container(
                        width: 65,
                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff9c9595).withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(color:  Color(0xff9c9595), spreadRadius: 0.1),
                          ],
                        ),
                        child: Center(child: Text(status,style: TextStyle(color: Colors.white),)),
                      ),

                    ],

                  ),
                ),
                Container(
                  child: ListTile(
                    title:Text(title,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,),
                    subtitle: Text('Last updated: 2022-01-20',style: TextStyle(fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w200),),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget NoInteractionView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Interaction Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('This user currently has no interaction.',style: TextStyle(color: Colors.black,fontSize: 14,),),
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
                  MyRouter.pushPage(context, AddInteraction(
                    clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
                    ClientEmail: clientProfile['emailAddress'],
                    ClientID: clientProfile['id'],
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Add New Interaction',
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


  String convertToAgo(DateTime input){
    Duration diff = DateTime.now().difference(input);

    if(diff.inDays >= 1){
      return '${diff.inDays} day(s) ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hour(s) ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
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
