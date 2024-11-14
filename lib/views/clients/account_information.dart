import 'dart:convert';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/util/app_url.dart';
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

class AccountInformation extends StatefulWidget {
  final int clientID;
  final String comingFrom;
  const AccountInformation({Key key,this.clientID,this.comingFrom}) : super(key: key);
  @override
  _AccountInformationState createState() => _AccountInformationState(
      clientID: this.clientID,
      comingFrom: this.comingFrom
  );
}


class _AccountInformationState extends State<AccountInformation> {

  int clientID;
  String comingFrom;
  _AccountInformationState({this.clientID,this.comingFrom});

  var clientProfile = {};
  var clientAvatar = '';
  var activityList = [];
  String realMonth = '';
  List<dynamic> CustomerProduct = [];
  String clientAcountNumber = '';


  final formatCurrency = NumberFormat.currency(locale: "en_US",
      symbol: "");

  @override
  void initState() {
    // TODO: implement initState
    final recentChat = recentChats[0];
    getClientAccount();
    super.initState();
  }

  getClientAccount() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Future<Map<String,dynamic>> respose =   RetCodes().clientAccount(clientID.toString() ,context: context);
    respose.then(
            (response) {
          print('this is referal ${response['data']}');
          if(response['data'] == null && response['message'] == 'Unauthenticated'){
            MyRouter.pushPageReplacement(context, LoginScreen(login_type: 'Loan Management',));
          }
            print('this is referal ${response['data']}');
          // setState(() {
          //   referalCount = response['referralCount'];
          //   supervisor = response['data']['organisationalRoleParentStaff']['displayName'] == null ? 'N/A': response['data']['organisationalRoleParentStaff']['displayName'];
          //   agentCode = response['data']['agentCode']== null ? 'N/A': response['data']['agentCode'];
          //   loanOfficerId = response['data']['id'];
          //   agentFirstName = response['data']['firstname'];
          // });

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
              // flexibleSpace: FlexibleSpaceBar(
              //   centerTitle: true,
              //   title:
              //
              //   Text(clientProfile.isEmpty ? '- -' : '${clientProfile['displayName'].toString()}',
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 13.0,
              //           fontFamily: 'Nunito SansRegular',
              //           fontWeight: FontWeight.bold
              //       )
              //   ),
              //
              //
              //   background:
              //   // CircleAvatar(
              //   //   backgroundColor: Colors.transparent,
              //   //   child: SizedBox(
              //   //     width: 90,
              //   //     height: 90,
              //   //     child: ClipOval(
              //   //       child:
              //   //
              //   //       ,
              //   //     ),
              //   //   ),
              //   // )
              //
              //
              // ),
              actions: [



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
                  height: clientProfile.isEmpty ? MediaQuery.of(context).size.height * 0.61 : clientProfile['status']['value'] == 'InComplete' ? MediaQuery.of(context).size.height * 0.57 : MediaQuery.of(context).size.height * 0.61,
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
