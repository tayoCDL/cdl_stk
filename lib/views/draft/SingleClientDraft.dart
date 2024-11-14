import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/BankDetails.dart';
import 'package:sales_toolkit/views/clients/DocumentUpload.dart';
import 'package:sales_toolkit/views/clients/EmploymentInfo.dart';
import 'package:sales_toolkit/views/clients/NextofKin.dart';
import 'package:sales_toolkit/views/clients/PersonalInfo.dart';
import 'package:sales_toolkit/views/clients/ResidentialDetails.dart';
import 'package:sales_toolkit/views/clients/client_lists.dart';

import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewClientDraft extends StatefulWidget {
  final int clientID;
  const ViewClientDraft({Key key, this.clientID}) : super(key: key);
  @override
  _ViewClientDraftState createState() =>
      _ViewClientDraftState(clientID: this.clientID);
}

class _ViewClientDraftState extends State<ViewClientDraft> {
  int clientID;
  _ViewClientDraftState({this.clientID});

  Map<String, Object> clientPersonal = {};
  var clientProfile = {};

  String dummyAvatar =
      "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a\r\nHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy\r\nMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCACWAJYDASIA\r\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\r\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\r\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\r\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\r\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\r\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\r\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\r\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2Siii\r\ngAooooAKKWjFABRS4qvdX9pZDNxOiH+7nJ/Ic0AT0YrAn8WW6HEFvJJ7sQo/rVf/AIS5/wDnzX/v\r\n5/8AWoA6eisK28VWshC3ELw/7QO4f4/pW5FJHPEskTq6N0ZTkGgBcUlOxSUAJRRiigAooooAKKKK\r\nACiiigApaKUCgAApwFKBWfrtybTR53U4dhsU/X/62aAMLWfEMjyNbWT7I1OGlU8t9D2Fc6SWJJJJ\r\nPUmkooAKKKKACrllql3p+Rby7VY5KkAg1TooA7jQ9Z/tRXjlVUnTnC9GHqK1iK4PQJ/I1q2OTh22\r\nEDvngfriu/IoAixRTiKSgBtFLSUAFFFFABS0lKKAFAp4FIBT1FACgVg+MONJh/67j/0Fq6JRWJ4u\r\nhL6IHH/LOVWP6j+tAHB0UUUAFFFFABRRRQBd0hS2sWYAz++U/rXpBWuA8MqG8Q2gIzyx/wDHTXob\r\nLQBXIphFTMKjIoAjpKcRSUAJRRRQAtKKSnigByipFFNUVKooAcorJ8UzRw6BMr/elKog9TnP9DWy\r\nornPG6/8Sm3b0nA/8dP+FAHC0UUUAFFFFABRRRQBf0W8Sw1i2uZBlFYhvYEEZ/DOa9NIzXkdesWW\r\n46dbF/veUufrgUADComFWGFQsKAISKYakYUw0ANopaKAFFPWmCpFoAeoqZRUa1MtAD1FZXim0N1o\r\nE+0ZaLEoH06/pmtdaeKAPG6K6vxho9pYJb3FpAIhI7CQKTgnqMDoO/SuUoAKKKKACiiigCeztXvb\r\n2G2jBLSOF+nvXrW0KoUDAAwKy9B0W20yzikEQN06AySHk5PUD0FaxoAhYVCwqdqiagCBhUZqVqjN\r\nADKKKKAHCnrTBUi0ASrUy1CtTLQBItPFNFOFAHOeN42fQ42UEhJ1LewwR/MivPq9b1GWzh0+Vr8q\r\nLYja+4E5zx0HNeUXAiFzKIGZoQ58st1K54z+FAEdFFFABUkEElzcRwRLueRgqj3NR10XhS90zT7m\r\nae+k2S4CxEoWwO/Qden60AehKoVQo6AYpDTgQRkHIPQ000ARtULVM1RNQBC1RGpWqJqAGGig0UAK\r\nKkWoxUi0ATLUq1CtLLcw20fmTypGg/idsCgC0tPFcnfeNLaIFLGIzN2d/lX8up/Sucu/EmrXZIa7\r\neNSSQsXyAe2RyfxNAGr4z1YXNymnwtmOE5kI6F/T8Ofz9q5WjrRQAUUUUAFFFFAHofhLVhe6cLSR\r\nv9Itxjn+JOx/Dp+XrXQGvH4ppYJBJDI8bjoyNgj8a2rPxZqlqVEkouIwMbZRz+Y5z9c0AehNULVj\r\n2PizT7zCzE20h7Sfd/76/wAcVrFgyhlIIPIIPWgCNqjNSNURoAaaKKKAFFU7rWbGyyJZ1Lj+BPmP\r\n6dPxrmta1uW4ne3t3KQKSpKnl/8A61YdAHS3vi6ZwUsohEP778t+XQfrXP3FzPdSeZPK8j+rHNRU\r\nUAFFFFABRRRQAUUUUAFFFFABRRRQAVbs9SvLA5tp2Qd16qfwPFVKKAOstPFyPhbyAof78fI/I8/z\r\nrat761vFzbzpJ3wDyPqOtec0qsyMGRirDkEHBFAHpdFc9omu+cjQXrgOgysh/iHofeigDlnOZGPu\r\nabQTkk0UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBNbttkJzjiiolbac0UAJRRRQA\r\nUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB/9k=";

  @override
  @override
  void initState() {
    // TODO: implement initState
    getCompleteClientView();
    super.initState();
  }

  retRealFile(String img) {
    var Velo = img.split(',').first;
    int chopOut = Velo.length + 1;
    String realfile =
        img.substring(chopOut).replaceAll("\n", "").replaceAll("\r", "");
    return realfile;
  }

  AddClientProvider addClientProvider = AddClientProvider();

  getCompleteClientView() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    prefs.remove('inputBvn');
    prefs.remove('prefsEmpSector');
    prefs.remove('clientId');
    prefs.remove('tempEmployerInt');
    prefs.remove('tempResidentialInt');
    prefs.remove('tempNextOfKinInt');
    prefs.remove('tempBankInfoInt');
    prefs.remove('tempClientInt');
    prefs.remove('isLight');

    List<String> clLists = prefs.getStringList('ListDraftClient');
    String singleClient = clLists[clientID];
    var responseData2 = jsonDecode(singleClient);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      clientProfile = newClientData;
    });
    print(clientProfile);
  }

  Widget build(BuildContext context) {
    var finalValidation = () async {
      Map<dynamic, dynamic> draftValidation = {
        "clients": {
          // "id": clientProfile['clients']['id'],
          "doYouWantToUpdateCustomerInfo": true,
          "firstname": clientProfile['clients']['firstname'],
          "middlename": clientProfile['clients']['middlename'],
          "lastname": clientProfile['clients']['lastname'],
          "activationChannelId": 57,
          "mobileNo": clientProfile['clients']['mobileNo'],
          "emailAddress": clientProfile['clients']['emailAddress'],
          "officeId": 1,
          "genderId": clientProfile['clients']['genderId'],
          "locale": "en",
          "dateOfBirth": "14 December 2016",
          "dateFormat": "dd MMMM yyyy",
          "clientClassificationId": clientProfile['clients']
              ['clientClassificationId'],
          "titleId": clientProfile['clients']['titleId'],

          "bvn": clientProfile['clients']['bvn'],
          // "bvn":'21243434334',
          //   "referralIdentity" : "biola",
          "numberOfDependent": clientProfile['clients']['numberOfDependent'],
          "educationLevelId": clientProfile['clients']['educationLevelId'],
          "maritalStatusId": clientProfile['clients']['maritalStatusId'],
          "isComplete": false
        },
        "avatar": clientProfile['avatar'],
        "clientBanks": [
          {
            // "id": clientProfile['clientBanks'][0]['id'],
            // "bankId" : clientProfile['clientBanks'][0]['bank']['id'],
            "bankId": 4,
            "bankAccountTypeId": clientProfile['clientBanks'][0]
                ['bankAccountTypeId'],
            "bankClassificationId": clientProfile['clientBanks'][0]
                ['bankClassificationId'],
            "accountnumber": clientProfile['clientBanks'][0]['accountnumber'],
            "accountname": clientProfile['clientBanks'][0]['accountname'],
            "active": true
          }
        ],
        "familyMembers": [
          {
            "firstName": clientProfile['familyMembers'][0]['firstName'],
            "middleName": clientProfile['familyMembers'][0]['middleName'],
            "lastName": clientProfile['familyMembers'][0]['lastName'],
            "qualification": "BSC",
            "relationshipId": clientProfile['familyMembers'][0]
                ['relationshipId'],
            "maritalStatusId": clientProfile['familyMembers'][0]
                ['maritalStatusId'],
            "genderId": clientProfile['familyMembers'][0]['genderId'],
            "professionId": clientProfile['familyMembers'][0]['professionId'],
            "mobileNumber": clientProfile['familyMembers'][0]['mobileNumber'],
            "age": clientProfile['familyMembers'][0]['age'],
            "isDependent": true
          }
        ],
        "addresses": [
          {
            "dateMovedIn": "14 October 2016",
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            "addressTypeId": clientProfile['addresses'][0]['addressTypeId'],
            "addressLine1": clientProfile['addresses'][0]['addressLine1'],
            "addressLine2": clientProfile['addresses'][0]['addressLine2'],
            "city": clientProfile['addresses'][0]['city'],
            "lgaId": clientProfile['addresses'][0]['lgaId'],
            "stateProvinceId": clientProfile['addresses'][0]['stateProvinceId'],
            "countryId": clientProfile['addresses'][0]['countryId'],
            // "residentStatusId": clientProfile['addresses'][0]['residentStatusId']
            "residentStatusId": clientProfile['addresses'][0]['countryId'],
            "addressId": clientProfile['addresses'][0]['addressId']
          }
        ],
        "clientEmployers": [
          {
            // "id": clientProfile['clientEmployers'][0]['id'],
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            "employmentDate": "14 October 2016",
            // "emailAddress": clientProfile['clientEmployers'][0]['emailAddress'],
            "emailAddress": 'neeqa@gmail.com',
            "mobileNo": clientProfile['clientEmployers'][0]['mobileNo'],
            "employerId": 3,
            "staffId": clientProfile['clientEmployers'][0]['staffId'],
            "countryId": 29,
            "stateId": clientProfile['clientEmployers'][0]['stateId'],
            "lgaId": clientProfile['clientEmployers'][0]['lgaId'],
            "officeAddress": clientProfile['clientEmployers'][0]
                ['officeAddress'],
            "nearestLandMark": clientProfile['clientEmployers'][0]
                ['nearestLandMark'],
            "jobGrade": clientProfile['clientEmployers'][0]['jobGrade'],
            "employmentStatusId": clientProfile['clientEmployers'][0]
                ['employmentStatusId'],
            "salaryRangeId": clientProfile['clientEmployers'][0]
                ['salaryRangeId'],
            "active": true
          }
        ],
        // "clientIdentifiers": [
        //   {
        //     "id": 567,
        //     "expiryDate" : "14 October 2026",
        //     "locale": "en",
        //     "dateFormat": "dd MMMM yyyy",
        //     "documentTypeId": 1,
        //     "documentKey": 71123122,
        //     "description": "8 Michael Oguns",
        //     "status" : "ACTIVE",
        //     "attachment" : {
        //       "location" : "iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAfSURBVDhPY/wPBAwUACYoTTYYNWDUABAYNYBiAxgYAGCfBBqAaJk0AAAAAElFTkSuQmCC",
        //       "name" : "name_name.png",
        //       "description" : "test test",
        //       "fileName" : "test.png",
        //       "size" : 300,
        //       "type" : "image/png"
        //     }
        //   }
        // ]
      };

      final Future<Map<String, dynamic>> respose =
          addClientProvider.finalClientValidation(draftValidation);
      print('start response from login');

      print(respose.toString());

      respose.then((response) {
        if (response['status'] == false) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        } else {
          MyRouter.pushPage(context, ClientLists());
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Client Creation success',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

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
                onPressed: () {
                  MyRouter.popPage(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                    clientProfile.isEmpty
                        ? '- -'
                        : '${clientProfile['clients']['firstname']} ${clientProfile['clients']['lastname']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: 'Nunito SansRegular',
                        fontWeight: FontWeight.bold)),
                background: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Container(
                      height: 50,
                      width: 50,
                      child: clientProfile['avatar'] == null ||
                              clientProfile['avatar'].isEmpty
                          ? Image.memory(base64Decode(retRealFile(dummyAvatar)))
                          : Image.memory(base64Decode(
                              retRealFile(clientProfile['avatar'])))),
                  radius: 50.0,
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.height * 0.252,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer Type: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'State',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer ID: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            clientProfile.isEmpty
                                ? '- -'
                                : '${clientProfile['clients']['id']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activation Date: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '27 November, 2010',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Client’s Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                      //     clientProfile.isEmpty ? SizedBox() :   clientProfile['clients']['status']['value'] == 'InComplete' ? clientStatus( Color(0xffFF0808), clientProfile['clients']['status']['value'])
                      //         :   clientProfile['clients']['status']['value'] == 'Pending' ? clientStatus( Colors.orange, clientProfile['clients']['status']['value'])
                      //         :   clientProfile['clients']['status']['value'] == 'Active' ? clientStatus( Colors.green, clientProfile['clients']['status']['value'])
                      //         : clientStatus( Colors.blueAccent, clientProfile['clients']['status']['value '])
                      //
                      //
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Personal Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Title: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Text(clientProfile.isEmpty ? '- -' : '${clientProfile['clients']['title']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'First Name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['firstname'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Middle Name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['middlename'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Last name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['lastname'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Gender: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //  Text(clientProfile.isEmpty ? '- -' : '${clientProfile['clients']['gender']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('Date Of Birth: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                              //     Text(clientProfile.isEmpty ? '- -' : '${clientProfile['clients']['dateOfBirth'][2]} - ${clientProfile['dateOfBirth'][1]} - ${clientProfile['dateOfBirth'][0]}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                              //
                              //   ],
                              // ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Marital Status: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //   Text(clientProfile.isEmpty ? '- -' : '${clientProfile['clients']['maritalStatus']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'No. Of Dependents: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['numberOfDependent'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Phone Number: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['mobileNo'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile.isEmpty
                                        ? '- -'
                                        : '${clientProfile['clients']['emailAddress'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 30,
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        PersonalInfo(
                                            bvnFirstName: clientProfile['clients']
                                                ['firstname'],
                                            bvnMiddleName:
                                                clientProfile['clients']
                                                    ['middlename'],
                                            bvnLastName: clientProfile['clients']
                                                ['lastname'],
                                            bvnEmail: clientProfile['clients']
                                                ['emailAddress'],
                                            bvnPhone1: clientProfile['clients']
                                                ['mobileNo'],
                                            ClientInt: clientProfile['clients']
                                                ['id'],
                                            comingFrom: 'SingleCustomerScreen',
                                            PassedtitleInt:
                                                clientProfile['clients']
                                                    ['title']['id'],
                                            PassedgenderInt:
                                                clientProfile['clients']
                                                    ['gender']['id'],
                                            PassednoOfdepsInt:
                                                clientProfile['clients']
                                                    ['numberOfDependent'],
                                            PassededucationInt:
                                                clientProfile['clients']
                                                    ['educationLevel']['id']));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Employment Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Organisation: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //  Text(clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty ? '- -' : '${clientProfile['clientEmployers'][0]['employer']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'State : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //   Text(clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty ? '- -' : '${clientProfile['clientEmployers'][0]['state']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'LGA : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Text( clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty ? '- -' : '${clientProfile['clientEmployers'][0]['lga']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['officeAddress'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nearest Landmark: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['nearestLandMark'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Employer\'s Phone number: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['mobileNo'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Staff ID: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['staffId'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Job Role/Grade: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['jobGrade'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date Of employment: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['employmentDate'][2]} - ${clientProfile['clientEmployers'][0]['employmentDate'][1]} - ${clientProfile['clientEmployers'][0]['employmentDate'][0]}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Work Email : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientEmployers'] == null ||
                                            clientProfile['clientEmployers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientEmployers'][0]['emailAddress'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Salary Range : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //  Text(clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty ? '- -' : '${clientProfile['clientEmployers'][0]['salaryRange']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        EmploymentInfo(
                                          ClientInt: clientProfile['clients']
                                              ['id'],

                                          // Employmentaddress: clientProfile['clientEmployers'][0]['employer']['name'],
                                          // EmploymentJobRole: clientProfile['clientEmployers'][0]['jobGrade'],
                                          // EmploymentNeareastLandmark: clientProfile['clientEmployers'][0]['nearestLandMark'],
                                          // EmploymentSalaryPayday: '22',
                                          // EmploymentSalaryRange: clientProfile['clientEmployers'][0]['salaryRange']['name'],
                                          // EmploymentStaffId: clientProfile['clientEmployers'][0]['staffId'],
                                          // EmploymentWorkEmail: clientProfile['clientEmployers'][0]['emailAddress'],
                                          // EmploymentPhoneNumber: clientProfile['clientEmployers'][0]['mobileNo'],
                                          //
                                          comingFrom: 'SingleCustomerScreen',
                                        ));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Residential Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Permanent Residential State: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['addresses'] == null ||
                                            clientProfile['addresses'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['addresses'][0]['stateName'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'LGA: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['addresses'] == null ||
                                            clientProfile['addresses'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['addresses'][0]['lga'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Permanant Address : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['addresses'] == null ||
                                            clientProfile['addresses'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['addresses'][0]['addressLine1'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['addresses'] == null ||
                                            clientProfile['addresses'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['addresses'][0]['addressLine1'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Residential Status: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['addresses'] == null ||
                                            clientProfile['addresses'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['addresses'][0]['residentStatus'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        ResidentialDetails(
                                            //ResidentialPermanentResidentialState: 1,
                                            ClientInt: clientProfile['clients']
                                                ['id'],
                                            // ResidentialPermanentLGA: clientProfile['addresses'][0]['lgaId'],
                                            //   permanentAddress: clientProfile['addresses'][0]['addressLine1'],
                                            //   nearestLandmark: clientProfile['addresses'][0]['nearestLandMark'],
                                            // ResidentialStatus: clientProfile['addresses'][0]['residentStatusId'],
                                            // ResidentialNoOfYears: clientProfile['addresses'][0]['stateProvinceId'],
                                            ComingFrom:
                                                'SingleCustomerScreen'));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Next Of Kin Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'First Name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['firstName'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Middle Name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['middleName'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'First Name: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['lastName'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Qualification: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['qualification'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Relationship: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['relationship'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Marital Status: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['maritalStatus'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mobile Number: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['mobileNumber'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Age: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['familyMembers'] == null ||
                                            clientProfile['familyMembers']
                                                .isEmpty
                                        ? '- -'
                                        : '${clientProfile['familyMembers'][0]['age'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        NextOfKinDetails(
                                            ClientInt: clientProfile['clients']
                                                ['id'],
                                            comingFrom:
                                                'SingleCustomerScreen'));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Bank Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bank: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //  Text(clientProfile['clientBanks']  == null || clientProfile['clientBanks'].isEmpty ? '- -' : '${clientProfile['clientBanks'][0]['bank']['name'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Account Number: ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientBanks'] == null ||
                                            clientProfile['clientBanks'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientBanks'][0]['accountnumber'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Account Name : ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clientProfile['clientBanks'] == null ||
                                            clientProfile['clientBanks'].isEmpty
                                        ? '- -'
                                        : '${clientProfile['clientBanks'][0]['accountname'].toString()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        BankDetails(
                                            ClientInt: clientProfile['clients']
                                                ['id'],
                                            // PassedbankName:  clientProfile['clientBanks'][0]['bank']['name'],
                                            // PassedaccountName: clientProfile['clientBanks'][0]['accountname'],
                                            // PassedaccountNumber: clientProfile['clientBanks'][0]['accountnumber'],
                                            comingFrom:
                                                'SingleCustomerScreen'));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text('Document Uploads',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: clientProfile[
                                                    'clientIdentifiers'] ==
                                                null ||
                                            clientProfile['clientIdentifiers']
                                                .isEmpty
                                        ? 0
                                        : clientProfile['clientIdentifiers']
                                            .length,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (index, position) {
                                      return ListTile(
                                        leading: Text(
                                          '${clientProfile['clientIdentifiers'][position]['documentType']['attachment']['name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        trailing: InkWell(
                                            onTap: () {
                                              //  MyRouter.pushPage(context, PdfBase64Viewer('${clientProfile['clientIdentifiers'][position]['attachment']['location']}'));
                                            },
                                            child: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.blue,
                                            )),
                                      );

                                      //  Text('${clientProfile['clientIdentifiers'][position]['documentType']['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);
                                    }),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: RoundedButton(
                                  onbuttonPressed: () {
                                    MyRouter.pushPage(
                                        context,
                                        DocumentUpload(
                                            ClientInt: clientProfile['clients']
                                                ['id'],
                                            comingFrom:
                                                'SingleCustomerScreen'));
                                  },
                                  buttonText: 'Edit',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RoundedButton(
                      buttonText: 'ReValidate',
                      onbuttonPressed: () {
                        //       Flushbar(
                        //              flushbarPosition: FlushbarPosition.TOP,
                        //              flushbarStyle: FlushbarStyle.GROUNDED,
                        //   backgroundColor: Colors.green,
                        //   title: "Success",
                        //   message: 'Client Creation success',
                        //   duration: Duration(seconds: 3),
                        // ).show(context);

                        //   MyRouter.pushPage(context, MainScreen());
                        finalValidation();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clientStatus(Color statusColor, String status) {
    return Container(
      width: 85,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(
          child: Text(
        status,
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
