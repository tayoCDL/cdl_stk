import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteractionChat.dart';
import 'package:sales_toolkit/views/Interactions/AddInteraction.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteraction.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/leads/EmploymentInfo.dart';
import 'package:sales_toolkit/views/leads/ResidentialDetails.dart';
import 'package:sales_toolkit/views/leads/addLead.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_toolkit/models/message_model.dart';

class ViewLead extends StatefulWidget {
  final int leadID,clientID;
  const ViewLead({Key key,this.leadID,this.clientID}) : super(key: key);
  @override
  _ViewLeadState createState() => _ViewLeadState(
      leadID: this.leadID,
      clientID:this.clientID,
  );
}



class _ViewLeadState extends State<ViewLead> {

  int leadID,clientID;
  _ViewLeadState({this.leadID,this.clientID});

  var clientProfile = {};
  List<dynamic> employerProfile = [];
  List<dynamic> residentialProfile = [];
  var leadProfile = {};
  String realMonth = '';
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

    super.initState();
  }



  var interactionData = [];

  getInteracctionForClient() async{
    print('clientID ${clientID}');
    int ClientId = clientProfile['id'];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var sequesttoken = prefs.getString('sequestToken');
    print('sequestToken ${sequesttoken}');

    try{
      Response responsevv = await get(
        AppUrl.getRecentTicketByCLientId + '${ClientId}',
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


  getClientProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('inputBvn');
    prefs.remove('prefsEmpSector');
    prefs.remove('clientId');
    prefs.remove('leadId');
    prefs.remove('tempEmployerInt');
    prefs.remove('tempResidentialInt');
    prefs.remove('tempNextOfKinInt');
    prefs.remove('tempBankInfoInt');
    prefs.remove('tempClientInt');
    prefs.remove('isLight');


    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleLead + leadID.toString(),
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
      clientProfile = newClientData['moreInfo']['clients'];
      employerProfile = newClientData['moreInfo']['clientEmployers'];
      residentialProfile = newClientData['moreInfo']['addresses'];

      leadProfile = newClientData;
    });
    print(clientProfile);
    print('employerProfile ${employerProfile}');
    print('addresses ${employerProfile}');
  }



  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

    void actionPopUpItemSelected(String value) async{

      if (value == 'convert_to_client') {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('leadToClientID', clientProfile['id']);

        MyRouter.pushPage(context, AddClient(ClientInt: clientProfile['id'],comingFrom: 'leadView',));
      }
      else if (value == 'interaction') {
        MyRouter.pushPage(context,
            ClientInteraction(
              clientID: clientID,
              clientName: clientProfile['firstname'] + ' ' + clientProfile['lastname'],
              ClientEmail: clientProfile['emailAddress'],  ));
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
                    child: Image.memory(
                        base64Decode(
                            retRealFile(dummyAvatar)
                        )
                    ),
                  ),
                  radius: 200.0,
                ),
              ),
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.blue,),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'convert_to_client',
                        child: Text('Convert to client',),
                      ),
                      // PopupMenuItem(
                      //   value: 'interaction',
                      //   child: Text('Interactions'),
                      // ),

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
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ListView(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead ID: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('${leadID}',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Client ID: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile.isEmpty || clientProfile == null  ? '- -' : '${clientProfile['id'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead Rating: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(leadProfile['leadRating']  == null ||  leadProfile['leadRating'].isEmpty ? '- -' : '${leadProfile['leadRating']['name']}',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead Category: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(leadProfile['leadCategory']  == null ||  leadProfile['leadCategory'].isEmpty ? '- -' : '${leadProfile['leadCategory']['name']}',style: TextStyle(color: Colors.black,fontSize: 15,),)

                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead Source: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(leadProfile['leadSource']  == null ||  leadProfile['leadSource'].isEmpty ? '- -' : '${leadProfile['leadSource']['name']}',style: TextStyle(color: Colors.black,fontSize: 15,),)

                        ],
                      ),
                      SizedBox(height: 10,),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          clientProfile.isEmpty ? SizedBox() :   clientProfile['status']['value'] == 'InComplete' ? clientStatus( Color(0xffFF0808), clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Pending' ? clientStatus( Colors.orange, clientProfile['status']['value'])
                              :   clientProfile['status']['value'] == 'Active' ? clientStatus( Colors.green, clientProfile['status']['value'])
                              : clientStatus( Colors.blueAccent, clientProfile['status']['value '])


                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Creation Date: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text(clientProfile['timeline'] != null ?
                          '${retDOBfromBVN('${clientProfile['timeline']['submittedOnDate'][0]}-${clientProfile['timeline']['submittedOnDate'][1]}-${clientProfile['timeline']['submittedOnDate'][2]}')}'
                              : "N/A"
                            ,style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),

                    ],
                  ),
                ),


                SizedBox(height: MediaQuery.of(context).size.height * 0.015,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text(
                          'Personal Information',
                          style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold)
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Title: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null ? '- -' : '${clientProfile['title']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('First Name: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null || clientProfile['firstname'] == null ? '- -' : '${clientProfile['firstname'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Middle Name: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null || clientProfile['middlename'] == null ? '- -' : '${clientProfile['middlename'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Last name: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null  || clientProfile['lastname'] == null? '- -' : '${clientProfile['lastname'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Gender: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null || clientProfile['gender']['name'] == null ?  '- -' : '${clientProfile['gender']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date Of Birth: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile['dateOfBirth'] == null ? '- -' : '${clientProfile['dateOfBirth'][2]} - ${clientProfile['dateOfBirth'][1]} - ${clientProfile['dateOfBirth'][0]}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Marital Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null  || clientProfile['maritalStatus']['name'] == null? '- -' : '${clientProfile['maritalStatus']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('No. Of Dependents: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null  ? '- -' : '${clientProfile['numberOfDependent'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Phone Number: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null || clientProfile['mobileNo'] == null ? '- -' : '${clientProfile['mobileNo'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Email : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(clientProfile.isEmpty || clientProfile == null  || clientProfile['emailAddress'] ==null ? '- -' : '${clientProfile['emailAddress'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),


                              SizedBox(height: 30,),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: (){
                                    MyRouter.pushPage(context, AddLead(
                                      leadInt: leadProfile['id'],
                                      PassedleadType: leadProfile['leadTypeId'],
                                      comingFrom: 'LeadSingleView',
                                    ));
                                    // MyRouter.pushPage(context, LeadPersonalInfo(
                                    //
                                    //     bvnFirstName: clientProfile['firstname'],
                                    //     bvnMiddleName: clientProfile['middlename'],
                                    //     bvnLastName: clientProfile['lastname'],
                                    //     bvnEmail: clientProfile['emailAddress'],
                                    //     bvnPhone1: clientProfile['mobileNo'],
                                    //      leadInt: leadProfile['id'],
                                    //     comingFrom: 'LeadSingleView',
                                    //     PassedtitleInt:clientProfile['title']['id'],
                                    //     PassedgenderInt: clientProfile['gender']['id'],
                                    //     PassednoOfdepsInt: clientProfile['numberOfDependent'],
                                    //     PassededucationInt: clientProfile['educationLevel']['id']
                                    // ));
                                    //
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),

                              SizedBox(height: 20,),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.015,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text(
                          'Employment Information',
                          style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold)
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Organisation: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text( employerProfile.isEmpty  || employerProfile[0]['employer'] == null || employerProfile[0]['employer']['name'] == null ? '- -' : '${employerProfile[0]['employer']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('State : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty  || employerProfile[0]['employer'] == null ||  employerProfile[0]['state']['name'] == null ? '- -' : '${employerProfile[0]['state']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('LGA : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty  || employerProfile[0]['employer'] == null ||  employerProfile[0]['lga']['name'] == null ? '- -' : '${employerProfile[0]['lga']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Address : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['officeAddress'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Nearest Landmark: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['nearestLandMark'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Employer\'s Phone number: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['mobileNo'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Staff ID: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['staffId'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Job Role/Grade: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['jobGrade'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date Of employment: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty  || employerProfile[0]['employmentDate'] == null ? '- -' : '${employerProfile[0]['employmentDate'][2]} - ${employerProfile[0]['employmentDate'][1]} - ${employerProfile[0]['employmentDate'][0]}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Work Email : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(employerProfile.isEmpty ? '- -' : '${employerProfile[0]['emailAddress'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),

                              SizedBox(height: 20,),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('Salary Range : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                              //     Text(clientProfile.isEmpty ? '- -' : '${employerProfile[0]['salaryRange']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                              //
                              //   ],
                              //
                              // ),
                              SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: (){
                                    MyRouter.pushPage(context, LeadEmploymentInfo(
                                          ClientInt: clientProfile['id'],
                                        leadInt: leadProfile['id'],
                                        // Employmentaddress: clientProfile['clientEmployers'][0]['employer']['name'],
                                        // EmploymentJobRole: clientProfile['clientEmployers'][0]['jobGrade'],
                                        // EmploymentNeareastLandmark: clientProfile['clientEmployers'][0]['nearestLandMark'],
                                        // EmploymentSalaryPayday: '22',
                                        // EmploymentSalaryRange: clientProfile['clientEmployers'][0]['salaryRange']['name'],
                                        // EmploymentStaffId: clientProfile['clientEmployers'][0]['staffId'],
                                        // EmploymentWorkEmail: clientProfile['clientEmployers'][0]['emailAddress'],
                                        // EmploymentPhoneNumber: clientProfile['clientEmployers'][0]['mobileNo'],
                                        //

                                        comingFrom: 'LeadSingleView'
                                    ));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text(
                          'Residential Information',
                          style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold)
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Permanent Residential State: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text(residentialProfile == null || residentialProfile.isEmpty || residentialProfile[0]['stateName'] == null ? '- -' : '${residentialProfile[0]['stateName'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('LGA: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text( residentialProfile == null || residentialProfile.isEmpty || residentialProfile[0]['lga'] == null ? '- -' : '${residentialProfile[0]['lga'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Permanant Address : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text( residentialProfile == null || residentialProfile.isEmpty || residentialProfile[0]['addressLine1'] == null ? '- -' : '${residentialProfile[0]['addressLine1'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('Address : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                              //     Text( residentialProfile == null || residentialProfile.isEmpty ? '- -' : '${residentialProfile[0]['addressLine1'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                              //
                              //   ],
                              // ),
                              // SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Residential Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                  Text( residentialProfile == null || residentialProfile.isEmpty || residentialProfile[0]['residentStatus'] == null ? '- -' : '${residentialProfile[0]['residentStatus'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                ],
                              ),
                              SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: (){
                                    MyRouter.pushPage(context, LeadResidentialDetails(
                                      //ResidentialPermanentResidentialState: 1,
                                        ClientInt: clientProfile['id'],
                                        leadInt: leadProfile['id'],
                                        // ResidentialPermanentLGA: clientProfile['addresses'][0]['lgaId'],
                                        //   permanentAddress: clientProfile['addresses'][0]['addressLine1'],
                                        //   nearestLandmark: clientProfile['addresses'][0]['nearestLandMark'],
                                        // ResidentialStatus: clientProfile['addresses'][0]['residentStatusId'],
                                        // ResidentialNoOfYears: clientProfile['addresses'][0]['stateProvinceId'],
                                        ComingFrom: 'LeadSingleView'
                                    ));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 35),
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
                //
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: interactionData.length == 0 ? NoInteractionView() : recentInteractions(),
                // ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              ],
            ),
          ),
        ),
      ),


    );
  }



  Widget productsList(String imageAsset,String title,String balance){
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
                    Text(balance,style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),

              ],
            ),
          ),
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
      width: 100,
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
