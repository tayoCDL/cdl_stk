import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/BankDetails.dart';
import 'package:sales_toolkit/views/clients/ChangeLog.dart';
import 'package:sales_toolkit/views/clients/DocumentPreview.dart';
import 'package:sales_toolkit/views/clients/DocumentUpload.dart';
import 'package:sales_toolkit/views/clients/EmploymentInfo.dart';
import 'package:sales_toolkit/views/clients/NextofKin.dart';
import 'package:sales_toolkit/views/clients/ResidentialDetails.dart';
import 'package:sales_toolkit/views/clients/TestFileSelector.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/views/clients/add_client.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:sales_toolkit/widgets/ProfileShimmer.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:sales_toolkit/widgets/server_error_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleCustomerScreen extends StatefulWidget {
  final int clientID;
  const SingleCustomerScreen({Key key, this.clientID}) : super(key: key);
  @override
  _SingleCustomerScreenState createState() =>
      _SingleCustomerScreenState(clientID: this.clientID);
}

class _SingleCustomerScreenState extends State<SingleCustomerScreen> {
  int clientID;
  String realMonth = '';
  _SingleCustomerScreenState({this.clientID});

  Map<String, Object> clientPersonal = {};
  var clientProfile = {};
  bool _isLoading = false;
  String dummyAvatar =
      "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a\r\nHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy\r\nMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCACWAJYDASIA\r\nAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA\r\nAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3\r\nODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm\r\np6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA\r\nAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx\r\nBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK\r\nU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3\r\nuLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2Siii\r\ngAooooAKKWjFABRS4qvdX9pZDNxOiH+7nJ/Ic0AT0YrAn8WW6HEFvJJ7sQo/rVf/AIS5/wDnzX/v\r\n5/8AWoA6eisK28VWshC3ELw/7QO4f4/pW5FJHPEskTq6N0ZTkGgBcUlOxSUAJRRiigAooooAKKKK\r\nACiiigApaKUCgAApwFKBWfrtybTR53U4dhsU/X/62aAMLWfEMjyNbWT7I1OGlU8t9D2Fc6SWJJJJ\r\nPUmkooAKKKKACrllql3p+Rby7VY5KkAg1TooA7jQ9Z/tRXjlVUnTnC9GHqK1iK4PQJ/I1q2OTh22\r\nEDvngfriu/IoAixRTiKSgBtFLSUAFFFFABS0lKKAFAp4FIBT1FACgVg+MONJh/67j/0Fq6JRWJ4u\r\nhL6IHH/LOVWP6j+tAHB0UUUAFFFFABRRRQBd0hS2sWYAz++U/rXpBWuA8MqG8Q2gIzyx/wDHTXob\r\nLQBXIphFTMKjIoAjpKcRSUAJRRRQAtKKSnigByipFFNUVKooAcorJ8UzRw6BMr/elKog9TnP9DWy\r\nornPG6/8Sm3b0nA/8dP+FAHC0UUUAFFFFABRRRQBf0W8Sw1i2uZBlFYhvYEEZ/DOa9NIzXkdesWW\r\n46dbF/veUufrgUADComFWGFQsKAISKYakYUw0ANopaKAFFPWmCpFoAeoqZRUa1MtAD1FZXim0N1o\r\nE+0ZaLEoH06/pmtdaeKAPG6K6vxho9pYJb3FpAIhI7CQKTgnqMDoO/SuUoAKKKKACiiigCeztXvb\r\n2G2jBLSOF+nvXrW0KoUDAAwKy9B0W20yzikEQN06AySHk5PUD0FaxoAhYVCwqdqiagCBhUZqVqjN\r\nADKKKKAHCnrTBUi0ASrUy1CtTLQBItPFNFOFAHOeN42fQ42UEhJ1LewwR/MivPq9b1GWzh0+Vr8q\r\nLYja+4E5zx0HNeUXAiFzKIGZoQ58st1K54z+FAEdFFFABUkEElzcRwRLueRgqj3NR10XhS90zT7m\r\nae+k2S4CxEoWwO/Qden60AehKoVQo6AYpDTgQRkHIPQ000ARtULVM1RNQBC1RGpWqJqAGGig0UAK\r\nKkWoxUi0ATLUq1CtLLcw20fmTypGg/idsCgC0tPFcnfeNLaIFLGIzN2d/lX8up/Sucu/EmrXZIa7\r\neNSSQsXyAe2RyfxNAGr4z1YXNymnwtmOE5kI6F/T8Ofz9q5WjrRQAUUUUAFFFFAHofhLVhe6cLSR\r\nv9Itxjn+JOx/Dp+XrXQGvH4ppYJBJDI8bjoyNgj8a2rPxZqlqVEkouIwMbZRz+Y5z9c0AehNULVj\r\n2PizT7zCzE20h7Sfd/76/wAcVrFgyhlIIPIIPWgCNqjNSNURoAaaKKKAFFU7rWbGyyJZ1Lj+BPmP\r\n6dPxrmta1uW4ne3t3KQKSpKnl/8A61YdAHS3vi6ZwUsohEP778t+XQfrXP3FzPdSeZPK8j+rHNRU\r\nUAFFFFABRRRQAUUUUAFFFFABRRRQAVbs9SvLA5tp2Qd16qfwPFVKKAOstPFyPhbyAof78fI/I8/z\r\nrat761vFzbzpJ3wDyPqOtec0qsyMGRirDkEHBFAHpdFc9omu+cjQXrgOgysh/iHofeigDlnOZGPu\r\nabQTkk0UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBNbttkJzjiiolbac0UAJRRRQA\r\nUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB/9k=";

  @override
  @override
  void initState() {
    // TODO: implement initState
    getCompleteClientView();
    super.initState();
  }

  goBack(BuildContext context, String value) {
    if (value == 'go_back') {
      MyRouter.pushPageReplacement(
          context,
          ViewClient(
            clientID: clientID,
          ));
    } else if (value == 'go_home') {
      MyRouter.pushPageReplacement(context, MainScreen());
    }
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
    prefs.remove('tempResidentialNextOfKinIn');
    prefs.remove('tempResidentialNextOfKinInt');

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

    if (responsevv.statusCode == 500) {
      MyRouter.pushPage(context, ServerErrorScreen());
    }

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);

    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      clientProfile = newClientData;
    });
    print(clientProfile);
  }

  Widget build(BuildContext context) {
    var finalValidation = () async {
      if (clientProfile['clients'].isEmpty ||
          clientProfile['clientBanks'].isEmpty ||
          clientProfile['familyMembers'].isEmpty ||
          clientProfile['addresses'].isEmpty ||
          clientProfile['clientEmployers'].isEmpty) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Some empty fields still in client\'s data',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      Map<dynamic, dynamic> loanValidation = {
        "clients": {
          "id": clientProfile['clients']['id'],
          "doYouWantToUpdateCustomerInfo": true,
          "firstname": clientProfile['clients']['firstname'],
          "middlename": clientProfile['clients']['middlename'],
          "lastname": clientProfile['clients']['lastname'],
          "activationChannelId": 77,
          "mobileNo": clientProfile['clients']['mobileNo'],
          "emailAddress": clientProfile['clients']['emailAddress'],
          // "officeId": 1,
          "genderId": clientProfile['clients']['gender']['id'],
          "locale": "en",
          // "dateOfBirth": "14 December 2016",
          "dateOfBirth": retDOBfromBVN(
              '${clientProfile['clients']['dateOfBirth'][0]}-${clientProfile['clients']['dateOfBirth'][1]}-${clientProfile['clients']['dateOfBirth'][2]}'),
          "dateFormat": "dd MMMM yyyy",
          "clientClassificationId": clientProfile['clients']
              ['clientClassification']['id'],
          "titleId": clientProfile['clients']['title']['id'],

          "bvn": clientProfile['clients']['bvn'],
          //   "referralIdentity" : "biola",
          "numberOfDependent": clientProfile['clients']['numberOfDependent'],
          "educationLevelId": clientProfile['clients']['educationLevel']['id'],
          "maritalStatusId": clientProfile['clients']['maritalStatus']['id'],
          "isComplete": true
        },
        "avatar": clientProfile['avatar'],
        "clientBanks": [
          {
            "id": clientProfile['clientBanks'][0]['id'],
            "bankId": clientProfile['clientBanks'][0]['bank']['id'],
            //"bankId":4,
            // "bankAccountTypeId": clientProfile['clientBanks'][0]['bankAccountType']['id'],
            // "bankClassificationId": clientProfile['clientBanks'][0]['bankClassification']['id'],
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
            "dateMovedIn": retDOBfromBVN(
                '${clientProfile['addresses'][0]['dateMovedIn'][0]}-${clientProfile['addresses'][0]['dateMovedIn'][1]}-${clientProfile['addresses'][0]['dateMovedIn'][2]}'),
            //  "dateMovedIn" : "14 October 2016",
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
            "id": clientProfile['clientEmployers'][0]['id'],
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            // "employmentDate" : "14 October 2016",
            "employmentDate": retDOBfromBVN(
                '${clientProfile['clientEmployers'][0]['employmentDate'][0]}-${clientProfile['clientEmployers'][0]['employmentDate'][1]}-${clientProfile['clientEmployers'][0]['employmentDate'][2]}'),

            "emailAddress": clientProfile['clientEmployers'][0]['emailAddress'],
            // "emailAddress": clientProfile['clientEmployers'][0]['emailAddress'],
            "mobileNo": clientProfile['clientEmployers'][0]['mobileNo'],
            "employerId": clientProfile['clientEmployers'][0]['employer']['id'],
            "staffId": clientProfile['clientEmployers'][0]['staffId'],
            "countryId": 29,
            "stateId": clientProfile['clientEmployers'][0]['state']['id'],
            "lgaId": clientProfile['clientEmployers'][0]['lga']['id'],
            "officeAddress": clientProfile['clientEmployers'][0]
                ['officeAddress'],
            "nearestLandMark": clientProfile['clientEmployers'][0]
                ['nearestLandMark'],
            "jobGrade": clientProfile['clientEmployers'][0]['jobGrade'],
            "employmentStatusId": clientProfile['clientEmployers'][0]
                ['employmentStatus']['id'],
            "salaryRangeId": clientProfile['clientEmployers'][0]['salaryRange']
                ['id'],
            "active": true
          }
        ],
        "clientIdentifiers": [
          {
            "id": 567,
            "expiryDate": "14 October 2026",
            "locale": "en",
            "dateFormat": "dd MMMM yyyy",
            "documentTypeId": 1,
            "documentKey": 71123122,
            "description": "8 Michael Oguns",
            "status": "ACTIVE",
            "attachment": {
              "location":
                  "iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAfSURBVDhPY/wPBAwUACYoTTYYNWDUABAYNYBiAxgYAGCfBBqAaJk0AAAAAElFTkSuQmCC",
              "name": "name_name.png",
              "description": "test test",
              "fileName": "test.png",
              "size": 300,
              "type": "image/png"
            }
          }
        ]
      };

      setState(() {
        _isLoading = true;
      });

      final Future<Map<String, dynamic>> respose =
          addClientProvider.finalClientValidation(loanValidation);
      print('start response from login');

      print(respose.toString());

      respose.then((response) {
        setState(() {
          _isLoading = false;
        });

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
          MyRouter.pushPage(context, MainScreen());
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

    return clientProfile['clients'] == null && clientProfile == null
        ? UnableToLoadUser()
        : clientProfile.isEmpty
            ? ProfileShimmerLoading()
            : LoadingOverlay(
                isLoading: _isLoading,
                progressIndicator: Container(
                  height: 120,
                  width: 120,
                  child: Lottie.asset('assets/images/newLoader.json'),
                ),
                child: Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 200.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: Colors.white,
                          leading:
                              // IconButton(
                              //   onPressed: (){
                              //     //   MyRouter.popPage(context);
                              //     MyRouter.pushPageReplacement(context, ViewClient(clientID:clientID));
                              //   },
                              //   icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
                              // ),
                              // appBack(context),
                              PopupMenuButton(
                            icon: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.blue,
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'go_back',
                                  child: Row(
                                    children: [
                                      //  Icon(Icons.arrow_back_ios,color: ColorUtils.PRIMARY_COLOR,),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Previous Screen',
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'go_home',
                                  child: Row(
                                    children: [
                                      //  Icon(FeatherIcons.home,color: ColorUtils.PRIMARY_COLOR,),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Go To Dashboard'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (String value) => goBack(
                              context,
                              value,
                            ),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                          clientProfile.isEmpty ||
                          clientProfile['clients'] == null ||
                          clientProfile['clients']['firstname'] == null ||
                          clientProfile['clients']['lastname'] == null
                          ? '- -'
                              : '${clientProfile['clients']['firstname']} ${clientProfile['clients']['lastname']}',
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'Nunito SansRegular',
                          fontWeight: FontWeight.bold,
                          ),
                          ),
                          background: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Container(
                                  height: 80,
                                  width: 80,
                                  child: clientProfile['avatar'] == null ||
                                          clientProfile['avatar'].isEmpty
                                      ? Image.memory(base64Decode(
                                          retRealFile(dummyAvatar)))
                                      : Image.memory(base64Decode(retRealFile(
                                          clientProfile['avatar'])))),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: MediaQuery.of(context).size.height * 0.39,
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Customer Type: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   clientProfile.isEmpty ||
                                      //           clientProfile['clients']
                                      //                   ['clientType'] ==
                                      //               null
                                      //       ? '- -'
                                      //       : '${clientProfile['clients']['clientType']['name']}',
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 15,
                                      //   ),
                                      // )
                                      Text(
                                        clientProfile.isEmpty ||
                                            clientProfile['clients'] == null ||
                                            clientProfile['clients']['clientType'] == null ||
                                            clientProfile['clients']['clientType']['name'] == null
                                            ? '- -'
                                            : '${clientProfile['clients']['clientType']['name']}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'External ID: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        clientProfile.isEmpty ||
                                            clientProfile['clients'] == null ||
                                            clientProfile['clients']['externalId'] == null
                                            ? 'N/A'
                                            : '${clientProfile['clients']['externalId']}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Customer ID: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   clientProfile.isEmpty
                                      //       ? '- -'
                                      //       : '${clientProfile['clients']['id']}',
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 15,
                                      //   ),
                                      // )

                                      Text(
                                        clientProfile.isEmpty ||
                                            clientProfile['clients'] == null ||
                                            clientProfile['clients']['id'] == null
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Activation Date: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        clientProfile['clients'] == null ||
                                                clientProfile['clients']
                                                        ['activationDate'] ==
                                                    null
                                            ? "N/A"
                                            : '${retDOBfromBVN('${clientProfile['clients']['activationDate'][0]}-${clientProfile['clients']['activationDate'][1]}-${clientProfile['clients']['activationDate'][2]}')}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Creation Date: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        clientProfile.isEmpty ||
                                            clientProfile['clients'] == null ||
                                            clientProfile['clients']['timeline'] == null ||
                                            clientProfile['clients']['timeline']['submittedOnDate'] == null
                                            ? 'N/A'
                                            : '${retDOBfromBVN('${clientProfile['clients']['timeline']['submittedOnDate'][0]}-${clientProfile['clients']['timeline']['submittedOnDate'][1]}-${clientProfile['clients']['timeline']['submittedOnDate'][2]}')}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Activation Channel: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        clientProfile.isEmpty ||
                                            clientProfile['clients'] == null ||
                                            clientProfile['clients']['activationChannel'] == null ||
                                            clientProfile['clients']['activationChannel']['name'] == null
                                            ? 'N/A'
                                            : '${clientProfile['clients']['activationChannel']['name']}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Client’s Status: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      clientProfile.isEmpty
                                          ? SizedBox()
                                          :
                                      // clientProfile['clients']['status']
                                      //                 ['value'] ==
                                      //             'InComplete'
                                      //         ? clientStatus(
                                      //             Color(0xffFF0808),
                                      //             clientProfile['clients']
                                      //                 ['status']['value'])
                                      //         : clientProfile['clients']
                                      //                     ['status']['value'] ==
                                      //                 'Pending'
                                      //             ? clientStatus(
                                      //                 Colors.orange,
                                      //                 clientProfile['clients']
                                      //                     ['status']['value'])
                                      //             : clientProfile['clients']
                                      //                             ['status']
                                      //                         ['value'] ==
                                      //                     'Active'
                                      //                 ? clientStatus(
                                      //                     Colors.green,
                                      //                     clientProfile['clients']
                                      //                             ['status']
                                      //                         ['value'])
                                      //                 : clientStatus(
                                      //                     Colors.blueAccent,
                                      //                     clientProfile['clients']
                                      //                         ['status']['value '])

                                      getClientStatusWidget(clientProfile),

                              ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Text(
                                              //   clientProfile.isEmpty
                                              //       ? '- -'
                                              //       : '${clientProfile['clients']['title']['name'].toString()}',
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontSize: 15,
                                              //       fontWeight:
                                              //           FontWeight.bold),
                                              // )

                                              Text(
                                                clientProfile.isEmpty ||
                                                    !clientProfile.containsKey('clients') ||
                                                    clientProfile['clients'] == null ||
                                                    !clientProfile['clients'].containsKey('title') ||
                                                    clientProfile['clients']['title'] == null ||
                                                    !clientProfile['clients']['title'].containsKey('name') ||
                                                    clientProfile['clients']['title']['name'] == null
                                                    ? '- -'
                                                    : clientProfile['clients']['title']['name'].toString(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )

                                            ],
                                          ),


                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'First Name: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['firstname'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['firstname']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Middle Name: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['middlename'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['middlename']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Last name: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['lastname'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['lastname']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Gender: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['gender'] == null ||
                                                    clientProfile['clients']['gender']['name'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['gender']['name']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
// Uncomment and fix the Date of Birth section if required
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text('Date Of Birth: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
//     Text(clientProfile.isEmpty ? '- -' : '${clientProfile['clients']['dateOfBirth'][2]} - ${clientProfile['clients']['dateOfBirth'][1]} - ${clientProfile['clients']['dateOfBirth'][0]}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
//   ],
// ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Marital Status: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['maritalStatus'] == null ||
                                                    clientProfile['clients']['maritalStatus']['name'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['maritalStatus']['name']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'No. Of Dependents: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['numberOfDependent'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['numberOfDependent']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Phone Number: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['mobileNo'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['mobileNo']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Email : ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                clientProfile.isEmpty ||
                                                    clientProfile['clients'] == null ||
                                                    clientProfile['clients']['emailAddress'] == null
                                                    ? '- -'
                                                    : '${clientProfile['clients']['emailAddress']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
                                                  AddClient(
                                                    ClientInt: clientProfile['clients'] != null ? clientProfile['clients']['id'] : null,
                                                    comingFrom: 'SingleCustomerScreen',
                                                    Passedbvn: clientProfile['clients'] != null ? clientProfile['clients']['bvn'] : null,
                                                  ),
                                                );
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Organisation: ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['employer']['name'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                'State : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['state']['name'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                'LGA : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['lga']['name'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['officeAddress'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['nearestLandMark'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['mobileNo'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['staffId'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['jobGrade'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text('Date Of employment: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          //     Text(clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty ? '- -' : '${clientProfile['clientEmployers'][0]['employmentDate'][2]} - ${clientProfile['clientEmployers'][0]['employmentDate'][1]} - ${clientProfile['clientEmployers'][0]['employmentDate'][0]}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                          //
                                          //   ],
                                          // ),

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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientEmployers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientEmployers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['clientEmployers'][0]['emailAddress'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text('Salary Range : ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          //     Text(clientProfile['clientEmployers'] ==  null || clientProfile['clientEmployers'].isEmpty || clientProfile['clientEmployers'][0]['salaryRange']['name'] == null ? '- -' : '${clientProfile['clientEmployers'][0]['salaryRange']['name'].toString()} ?? 0',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                          //
                                          //   ],
                                          //
                                          // ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: RoundedButton(
                                              onbuttonPressed: () {
                                                MyRouter.pushPage(
                                                    context,
                                                    EmploymentInfo(
                                                      ClientInt: clientProfile[
                                                          'clients']['id'],
                                                      employerSector: clientProfile[
                                                                  'clients'][
                                                              'employmentSector']
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
                                                      comingFrom:
                                                          'SingleCustomerScreen',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['addresses'] ==
                                                            null ||
                                                        clientProfile[
                                                                'addresses']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['addresses'][0]['stateName'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['addresses'] ==
                                                            null ||
                                                        clientProfile[
                                                                'addresses']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['addresses'][0]['lga'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['addresses'] ==
                                                            null ||
                                                        clientProfile[
                                                                'addresses']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['addresses'][0]['addressLine1'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['addresses'] ==
                                                            null ||
                                                        clientProfile[
                                                                'addresses']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['addresses'][0]['addressLine1'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['addresses'] ==
                                                            null ||
                                                        clientProfile[
                                                                'addresses']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['addresses'][0]['residentStatus'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: RoundedButton(
                                              onbuttonPressed: () {
                                                MyRouter.pushPage(
                                                    context,
                                                    ResidentialDetails(
                                                        //ResidentialPermanentResidentialState: 1,
                                                        ClientInt:
                                                            clientProfile[
                                                                    'clients']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['firstName'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['middleName'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['lastName'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text('Qualification: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          //     Text(clientProfile['familyMembers'] == null || clientProfile['familyMembers'].isEmpty  ? '- -' : '${clientProfile['familyMembers'][0]['qualification'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                          //
                                          //   ],
                                          // ),
                                          // SizedBox(height: 20,),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Relationship: ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['relationship'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['maritalStatus'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['familyMembers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'familyMembers']
                                                            .isEmpty
                                                    ? '- -'
                                                    : '${clientProfile['familyMembers'][0]['mobileNumber'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text('Age: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          //     Text(clientProfile['familyMembers'] == null || clientProfile['familyMembers'].isEmpty  ? '- -' : '${clientProfile['familyMembers'][0]['age'].toString()}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                          //
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: RoundedButton(
                                              onbuttonPressed: () {
                                                MyRouter.pushPage(
                                                    context,
                                                    NextOfKinDetails(
                                                        ClientInt:
                                                            clientProfile[
                                                                    'clients']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientBanks'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientBanks']
                                                            .isEmpty ||
                                                        clientProfile[
                                                                    'clientBanks']
                                                                [0]['bank'] ==
                                                            null
                                                    ? '- -'
                                                    : '${clientProfile['clientBanks'][0]['bank']['name'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                'Account Number: ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientBanks'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientBanks']
                                                            .isEmpty ||
                                                        clientProfile[
                                                                    'clientBanks']
                                                                [0]['bank'] ==
                                                            null
                                                    ? '- -'
                                                    : '${clientProfile['clientBanks'][0]['accountnumber'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                clientProfile['clientBanks'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientBanks']
                                                            .isEmpty ||
                                                        clientProfile[
                                                                    'clientBanks']
                                                                [0]['bank'] ==
                                                            null
                                                    ? '- -'
                                                    : '${clientProfile['clientBanks'][0]['accountname'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: RoundedButton(
                                              onbuttonPressed: () {
                                                MyRouter.pushPage(
                                                    context,
                                                    BankDetails(
                                                        ClientInt:
                                                            clientProfile[
                                                                    'clients']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: clientProfile[
                                                                'clientIdentifiers'] ==
                                                            null ||
                                                        clientProfile[
                                                                'clientIdentifiers']
                                                            .isEmpty
                                                    ? 0
                                                    : clientProfile[
                                                            'clientIdentifiers']
                                                        .length,
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (index, position) {
                                                  return ListTile(
                                                    leading: Text(
                                                      '${clientProfile['clientIdentifiers'][position]['documentType']['name']}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20),
                                                    ),
                                                    trailing: InkWell(
                                                        onTap: () async {
                                                          //    MyRouter.pushPage(context, Codu('${clientProfile['clientIdentifiers'][position]['attachment']['location']}'));

                                                          var documentLocation =
                                                              clientProfile['clientIdentifiers']
                                                                          [
                                                                          position]
                                                                      [
                                                                      'attachment']
                                                                  ['location'];
                                                          var documentType =
                                                              clientProfile[
                                                                          'clientIdentifiers']
                                                                      [position]
                                                                  [
                                                                  'attachment']['type'];
                                                          var documentName =
                                                              clientProfile['clientIdentifiers']
                                                                          [
                                                                          position]
                                                                      [
                                                                      'attachment']
                                                                  ['fileName'];

                                                          if (clientProfile['clientIdentifiers']
                                                                          [
                                                                          position]
                                                                      [
                                                                      'attachment']
                                                                  ['type'] ==
                                                              'application/pdf') {
                                                            String pdf = clientProfile[
                                                                            'clientIdentifiers']
                                                                        [
                                                                        position]
                                                                    [
                                                                    'attachment']
                                                                ['location'];
                                                            String fileName =
                                                                clientProfile['clientIdentifiers']
                                                                            [
                                                                            position]
                                                                        [
                                                                        'attachment']
                                                                    [
                                                                    'fileName'];
                                                            var Velo = pdf
                                                                .split(',')
                                                                .first;
                                                            int chopOut =
                                                                Velo.length + 1;
                                                            var bytes =
                                                                base64Decode(pdf
                                                                    .substring(
                                                                        chopOut)
                                                                    .replaceAll(
                                                                        "\n",
                                                                        "")
                                                                    .replaceAll(
                                                                        "\r",
                                                                        ""));
                                                            final output =
                                                                await getTemporaryDirectory();
                                                            final file = File(
                                                                "${output.path}/${documentName}.pdf");
                                                            await file
                                                                .writeAsBytes(bytes
                                                                    .buffer
                                                                    .asUint8List());
                                                            print(
                                                                "${output.path}/${documentName}.pdf");
                                                            await OpenFile.open(
                                                                "${output.path}/${documentName}.pdf");
                                                            setState(() {});
                                                          } else {
                                                            MyRouter.pushPage(
                                                                context,
                                                                DocumentPreview(
                                                                  passedDocument:
                                                                      documentLocation,
                                                                  passedType:
                                                                      documentType,
                                                                  passedFileName:
                                                                      documentName,
                                                                ));
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          color: Colors.blue,
                                                        )),
                                                  );

                                                  //  Text('${clientProfile['clientIdentifiers'][position]['documentType']['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);
                                                }),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: RoundedButton(
                                              onbuttonPressed: () {
                                                MyRouter.pushPage(
                                                    context,
                                                    DocumentUpload(
                                                        ClientInt:
                                                            clientProfile[
                                                                    'clients']
                                                                ['id'],
                                                        comingFrom:
                                                            'SingleCustomerScreen'));

                                                //     MyRouter.pushPage(context, TestFileSelector());
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
                            clientProfile.isEmpty
                                ? SizedBox()
                                : (clientProfile['clients'] != null &&
                                clientProfile['clients']['status'] != null &&
                                clientProfile['clients']['status']['value'] != null &&
                                clientProfile['clients']['status']['value'] == 'InComplete')
                                ? Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: RoundedButton(
                                buttonText: 'Send For Approval',
                                onbuttonPressed: () {
                                  finalValidation();
                                },
                              ),
                            )
                                : SizedBox(),
                            SizedBox(
                              height: 10,
                            ),

                            clientProfile.isEmpty || clientProfile['clients'] == null || clientProfile['clients']['status'] == null || clientProfile['clients']['status']['value'] == null
                                ? SizedBox()
                                : clientProfile['clients']['status']['value'] == 'Active'
                                ? Container(
                              width: MediaQuery.of(context).size.width * 0.41,
                              child: RoundedButton(
                                buttonText: 'View Change Log',
                                onbuttonPressed: () {
                                  MyRouter.pushPage(
                                    context,
                                    ChangeLog(
                                      clientID: clientID,
                                    ),
                                  );
                                },
                              ),
                            )
                                : SizedBox(),


                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }

  Widget clientStatus(Color statusColor, String status) {
    return Container(
      width: 125,
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

  retDOBfromBVN(String getDate) {
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

    if (wordList[1] == '1') {
      setState(() {
        realMonth = 'January';
      });
    }
    if (wordList[1] == '2') {
      setState(() {
        realMonth = 'February';
      });
    }
    if (wordList[1] == '3') {
      setState(() {
        realMonth = 'March';
      });
    }
    if (wordList[1] == '4') {
      setState(() {
        realMonth = 'April';
      });
    }
    if (wordList[1] == '5') {
      setState(() {
        realMonth = 'May';
      });
    }
    if (wordList[1] == '6') {
      setState(() {
        realMonth = 'June';
      });
    }
    if (wordList[1] == '7') {
      setState(() {
        realMonth = 'July';
      });
    }
    if (wordList[1] == '8') {
      setState(() {
        realMonth = 'August';
      });
    }
    if (wordList[1] == '9') {
      setState(() {
        realMonth = 'September';
      });
    }
    if (wordList[1] == '10') {
      setState(() {
        realMonth = 'October';
      });
    }
    if (wordList[1] == '11') {
      setState(() {
        realMonth = 'November';
      });
    }
    if (wordList[1] == '12') {
      setState(() {
        realMonth = 'December';
      });
    }

    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o3.length == 1 ? '0' + '' + o3 : o3;

    print('newOO ${newOO}');

    String concatss = newOO + " " + realMonth + " " + o1;

    print("concatss new Date from edit ${concatss}");

    return concatss;
  }

  Widget getClientStatusWidget(Map<String, dynamic> clientProfile) {
    if (clientProfile.isEmpty ||
        !clientProfile.containsKey('clients') ||
        clientProfile['clients'] == null ||
        !clientProfile['clients'].containsKey('status') ||
        clientProfile['clients']['status'] == null ||
        !clientProfile['clients']['status'].containsKey('value') ||
        clientProfile['clients']['status']['value'] == null) {
      // Handle missing or null data
      return clientStatus(Colors.blueAccent, 'Unknown');
    }

    // Get the status value
    String status = clientProfile['clients']['status']['value'];

    // Return widget based on status
    if (status == 'InComplete') {
      return clientStatus(const Color(0xffFF0808), status);
    } else if (status == 'Pending') {
      return clientStatus(Colors.orange, status);
    } else if (status == 'Active') {
      return clientStatus(Colors.green, status);
    } else {
      return clientStatus(Colors.blueAccent, status);
    }
  }



  Widget UnableToLoadUser() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Error',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            MyRouter.popPage(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.27),
              SvgPicture.asset(
                "assets/images/no_loan.svg",
                height: 90.0,
                width: 90.0,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Unable to load User.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'We are having issues loading this user try again!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   width: 155,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     color: Color(0xff077DBB),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: FlatButton(
              //     onPressed: (){
              //       MyRouter.pushPage(context,NewLoan(clientID: clientID,));
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 0.0),
              //       child:   Text(
              //         'Book New Loan',
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
      ),
    );
  }
}
