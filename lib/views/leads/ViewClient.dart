import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteractionChat.dart';
import 'package:sales_toolkit/views/Loans/LoanView.dart';
import 'package:sales_toolkit/views/Interactions/AddInteraction.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteraction.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_toolkit/models/message_model.dart';

class ViewClient extends StatefulWidget {
  final int clientID;
  const ViewClient({Key key,this.clientID}) : super(key: key);
  @override
  _ViewClientState createState() => _ViewClientState(
      clientID: this.clientID
  );
}


class _ViewClientState extends State<ViewClient> {

  int clientID;
  _ViewClientState({this.clientID});

  var clientProfile = {};
  var clientAvatar = '';
  List<dynamic> CustomerProduct = [];

  String dummyAvatar =   "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a\r\nHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy\r\nMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCACWAJYDASIA\r\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\r\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\r\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\r\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\r\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\r\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\r\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\r\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2Siii\r\ngAooooAKKWjFABRS4qvdX9pZDNxOiH+7nJ/Ic0AT0YrAn8WW6HEFvJJ7sQo/rVf/AIS5/wDnzX/v\r\n5/8AWoA6eisK28VWshC3ELw/7QO4f4/pW5FJHPEskTq6N0ZTkGgBcUlOxSUAJRRiigAooooAKKKK\r\nACiiigApaKUCgAApwFKBWfrtybTR53U4dhsU/X/62aAMLWfEMjyNbWT7I1OGlU8t9D2Fc6SWJJJJ\r\nPUmkooAKKKKACrllql3p+Rby7VY5KkAg1TooA7jQ9Z/tRXjlVUnTnC9GHqK1iK4PQJ/I1q2OTh22\r\nEDvngfriu/IoAixRTiKSgBtFLSUAFFFFABS0lKKAFAp4FIBT1FACgVg+MONJh/67j/0Fq6JRWJ4u\r\nhL6IHH/LOVWP6j+tAHB0UUUAFFFFABRRRQBd0hS2sWYAz++U/rXpBWuA8MqG8Q2gIzyx/wDHTXob\r\nLQBXIphFTMKjIoAjpKcRSUAJRRRQAtKKSnigByipFFNUVKooAcorJ8UzRw6BMr/elKog9TnP9DWy\r\nornPG6/8Sm3b0nA/8dP+FAHC0UUUAFFFFABRRRQBf0W8Sw1i2uZBlFYhvYEEZ/DOa9NIzXkdesWW\r\n46dbF/veUufrgUADComFWGFQsKAISKYakYUw0ANopaKAFFPWmCpFoAeoqZRUa1MtAD1FZXim0N1o\r\nE+0ZaLEoH06/pmtdaeKAPG6K6vxho9pYJb3FpAIhI7CQKTgnqMDoO/SuUoAKKKKACiiigCeztXvb\r\n2G2jBLSOF+nvXrW0KoUDAAwKy9B0W20yzikEQN06AySHk5PUD0FaxoAhYVCwqdqiagCBhUZqVqjN\r\nADKKKKAHCnrTBUi0ASrUy1CtTLQBItPFNFOFAHOeN42fQ42UEhJ1LewwR/MivPq9b1GWzh0+Vr8q\r\nLYja+4E5zx0HNeUXAiFzKIGZoQ58st1K54z+FAEdFFFABUkEElzcRwRLueRgqj3NR10XhS90zT7m\r\nae+k2S4CxEoWwO/Qden60AehKoVQo6AYpDTgQRkHIPQ000ARtULVM1RNQBC1RGpWqJqAGGig0UAK\r\nKkWoxUi0ATLUq1CtLLcw20fmTypGg/idsCgC0tPFcnfeNLaIFLGIzN2d/lX8up/Sucu/EmrXZIa7\r\neNSSQsXyAe2RyfxNAGr4z1YXNymnwtmOE5kI6F/T8Ofz9q5WjrRQAUUUUAFFFFAHofhLVhe6cLSR\r\nv9Itxjn+JOx/Dp+XrXQGvH4ppYJBJDI8bjoyNgj8a2rPxZqlqVEkouIwMbZRz+Y5z9c0AehNULVj\r\n2PizT7zCzE20h7Sfd/76/wAcVrFgyhlIIPIIPWgCNqjNSNURoAaaKKKAFFU7rWbGyyJZ1Lj+BPmP\r\n6dPxrmta1uW4ne3t3KQKSpKnl/8A61YdAHS3vi6ZwUsohEP778t+XQfrXP3FzPdSeZPK8j+rHNRU\r\nUAFFFFABRRRQAUUUUAFFFFABRRRQAVbs9SvLA5tp2Qd16qfwPFVKKAOstPFyPhbyAof78fI/I8/z\r\nrat761vFzbzpJ3wDyPqOtec0qsyMGRirDkEHBFAHpdFc9omu+cjQXrgOgysh/iHofeigDlnOZGPu\r\nabQTkk0UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBNbttkJzjiiolbac0UAJRRRQA\r\nUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB/9k=";

  retRealFile(String img){
    var Velo =  img.split(',').first;
    int chopOut = Velo.length + 1;
    String realfile =  img.substring(chopOut).replaceAll("\n", "").replaceAll("\r", "");
    return realfile;
  }

  @override
  void initState() {
    // TODO: implement initState
    final recentChat = recentChats[0];
    getClientProfile();
    getClientAvatar();
    getaccountsList();
    super.initState();
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




  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

    void actionPopUpItemSelected(String value) {

      if (value == 'customer_info') {
        print('got here');
        MyRouter.pushPage(context, SingleCustomerScreen(clientID: clientID,));
      } else if (value == 'interaction') {
        MyRouter.pushPage(context, ClientInteraction(clientID: clientID,clientName: "Habib",ClientEmail: 'djdj',));

      }
      else if (value == 'loans') {
        MyRouter.pushPage(context, LoanView(clientID: clientID,));

      }
      else if (value == 'new_interaction') {
        MyRouter.pushPage(context, AddInteraction());
      }
      else if (value == 'all_interaction') {
        MyRouter.pushPage(context, ClientInteraction(clientID: clientID,));
      }

      else {

      }

    }


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: (){
                  // MyRouter.popPage(context);
                  MyRouter.pushPageReplacement(context, MainScreen());
                },
                icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text( clientProfile.isEmpty ? '- -' : '${clientProfile['firstname'].toString()}' + " " '${clientProfile['lastname'].toString()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: 'Nunito SansRegular',
                        fontWeight: FontWeight.bold
                    )),
                background: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Container(
                      height: 50,
                      width: 50,
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
                  radius: 50.0,
                ),
              ),
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.blue,),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'customer_info',
                        child: Text('Customer Information',),
                      ),
                      PopupMenuItem(
                        value: 'interaction',
                        child: Text('Interations'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Channels Activites'),
                      ),
                      PopupMenuItem(
                        value: 'loans',
                        child: Text('Loans'),
                      ),

                    ];
                  },
                  onSelected: (String value) => actionPopUpItemSelected(value),
                ),
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
                  height: MediaQuery.of(context).size.height * 0.252,
                  child: ListView(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer Type: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('State',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer ID: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('${clientID}',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Activation Date: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('27 November, 2010',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Client’s Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          clientProfile.isEmpty ? SizedBox() :   clientProfile['status']['value'] == 'InComplete' ? clientStatus( Color(0xffFF0808), clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Pending' ? clientStatus( Colors.orange, clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Active' ? clientStatus( Colors.green, clientProfile['status']['value'])
                              : clientStatus( Colors.blueAccent, clientProfile['status']['value '])


                        ],
                      ),
                    ],
                  ),
                ),




                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Products',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),



                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 120,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: CustomerProduct.length,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,position){
                          //return   productsList(dummyProduct[position]['imageAsset'],dummyProduct[position]['title'],dummyProduct[position]['balance']);
                          return   productsList(CustomerProduct[position]['name'] == 'Wallet' ? 'assets/images/ov1.svg' : CustomerProduct[position]['name'] == 'Investment' ? 'assets/images/ov2.svg' : 'assets/images/oe3.svg',
                              CustomerProduct[position]['name'],
                              // CustomerProduct[position]['balance'] == null ? '0' :
                              CustomerProduct[position]['balance'].toString()

                              ,onTapLoan: (){
                                if(CustomerProduct[position]['name'] == 'Wallet' || CustomerProduct[position]['name'] == 'Investment'){
                                  MyRouter.pushPage(context, LoanView(clientID: clientID,));
                                }
                              });
                        }
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Recent Channel Activity',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: recentLogin(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Interactions',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert,color: Colors.blue,),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'new_interaction',
                              child: Text('New Interaction',),
                            ),
                            PopupMenuItem(
                              value: 'all_interaction',
                              child: Text('View All'),
                            ),

                          ];
                        },
                        onSelected: (String value) => actionPopUpItemSelected(value),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: recentInteractions(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: recentInteractions(),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              ],
            ),
          ),
        ),
      ),


    );
  }



  Widget productsList(String imageAsset,String title,var balance,{Function onTapLoan}){
    return InkWell(
      onTap: onTapLoan,
      child: Padding(
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
                      Text(balance == null ? 0 : balance
                        ,style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget recentLogin(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.44,
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
                title:Text('Logged in to the web portal',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                subtitle: Text('2 hours Ago',style: TextStyle(fontSize: 14,color: Colors.black,),),
              ),
            ),
            Divider(color: Colors.grey,thickness: 0.2,),
            Container(
              height: 60,
              child: ListTile(
                leading:   SvgPicture.asset('assets/images/oe2.svg',
                  height: 40.0,
                  width: 40.0,),
                title:Text('Logged in to the web portal',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                subtitle: Text('2 hours Ago',style: TextStyle(fontSize: 14,color: Colors.black,),),
              ),
            ),
            Divider(color: Colors.grey,thickness: 0.2,),
            Container(
              height: 60,
              child: ListTile(
                leading:   SvgPicture.asset('assets/images/oe3.svg',
                  height: 40.0,
                  width: 40.0,),
                title:Text('Logged in to the web portal',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                subtitle: Text('2 hours Ago',style: TextStyle(fontSize: 14,color: Colors.black,),),
              ),
            ),
            Divider(color: Colors.grey,thickness: 0.2,),
            SizedBox(height: 10,),
            Container(
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff077DBB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: [
                      Text(
                        'View All Activities',
                        style: TextStyle( fontSize: 12,
                          color: Colors.white,),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward,color: Colors.white,size: 15,)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget recentInteractions(){
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: recentChats.length,

        itemBuilder: (context, int index) {
          final recentChat = recentChats[index];
          return InkWell(
            onTap: () {
              MyRouter.pushPage(context, ClientInteractionChat(
                // user: recentChat.sender,
                ticketID: '',
              ));
            },
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.189,

              child: Card(
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 14),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('#234567'),
                            Container(
                              width: 65,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffF66C9F).withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(color: Color(0xffF66C9F),
                                      spreadRadius: 0.1),
                                ],
                              ),
                              child: Center(child: Text('Close',
                                style: TextStyle(color: Colors.white),)),
                            ),

                          ],

                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text('Inability to complete loan request',
                            style: TextStyle(fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded, color: Colors
                              .blue,),
                          subtitle: Text(
                            'Last updated: 2022-01-20', style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w200),),
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ),
          );

        }
    );
  }

  Widget clientStatus(Color statusColor,String status) {
    return Container(
      width: 85,
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(child: Text(status,style: TextStyle(color: Colors.white),)),
    );
  }



}
