import 'dart:convert';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';

import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/clients/PersonalInfo.dart';
import 'package:sales_toolkit/views/clients/testWeb.dart';

import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/clearCaches.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../../util/enum/color_utils.dart';

class AddClient extends StatefulWidget {
  final int ClientInt;
  final String comingFrom, sector, Passedbvn;
  const AddClient(
      {Key key, this.ClientInt, this.comingFrom, this.sector, this.Passedbvn})
      : super(key: key);

  @override
  _AddClientState createState() => _AddClientState(
      ClientInt: this.ClientInt,
      comingFrom: this.comingFrom,
      sector: this.sector,
      Passedbvn: this.Passedbvn);
}

class _AddClientState extends State<AddClient> {
  int ClientInt;
  String comingFrom, sector, Passedbvn;
  _AddClientState(
      {this.ClientInt, this.comingFrom, this.sector, this.Passedbvn});
  @override
  List<String> empSector = [];
  List<String> collectData = [];
  List<dynamic> allEmp = [];

  List<String> empCategory = [];
  List<String> collectCategory = [];
  List<dynamic> allCategory = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isBVNLoading = false;
  bool isRequestLoading = false;
  bool isAllowedToProceed = false;
  String tempEmail,
      tempFirstName,
      tempMiddleName,
      tempLastName,
      tempPhone1,
      tempPhone2,
      TempdateOfBirth,
      Tempgender;
  List<String> banksListArray = [];
  List<String> collectBanksList = [];
  List<dynamic> allBanksList = [];
  String act_bvn = '';
  var bankInfo = [];
  int catInt;
  String employerSector = '';
  String categorySector = '';
  String accountName = '';
  String realMonth = '';
  String bankCode;
  int bankInt, bankClassificationInt;
  bool bvnFecthedSuccessfully = false;
  bool otpValidationStatus = false;
  DateTime CupertinoSelectedDate = DateTime.now();
  String iAgreeLink = '';
  bool isAvailable;
  String isTestState = 'test';
  void initState() {
    // TODO: implement initState
    bvn.text = Passedbvn;
    if (comingFrom != null) {
      getPersonalInformation();
    }
    if (comingFrom != 'customerPreview') {
      ClearCaches().clearMems();
    }

    //
    getCodesList();
    getbanksList();
    getCategoryList();
    super.initState();
  }

  void dispose() {
    bvn;
    super.dispose();
  }

  getPersonalInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int localclientID = ClientInt;
    //print('localInt ${localclientID}');

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    //print(tfaToken);
    //print(token);
    ///clients/{clientId}/familymembers
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    //print(responsevv.body);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    //print(responseData2);
    var newClientData = responseData2;
    setState(() {
      employerSector = newClientData['employmentSector']['name'];
      empInt = newClientData['employmentSector']['id'];
      Tempgender = newClientData['gender']['name'];
      tempFirstName = newClientData['firstname'];
      tempMiddleName = newClientData['middlename'];
      tempLastName = newClientData['lastname'];
      ;
      tempPhone1 = newClientData['mobileNo'];
      tempEmail = newClientData['emailAddress'];
      catInt = newClientData['clientType']['id'];
      categorySector = newClientData['clientType']['name'];
      isAllowedToProceed = true;
      bvnFecthedSuccessfully = true;
      otpValidationStatus = true;
      //  maritalInt = newClientData['maritalStatus']['id'];
      //  educationInt = newClien tData['educationLevel']['id'];
      // TempdateOfBirth = retDOBfromBVN('${newClientData['dateOfBirth'][0]}-${newClientData['dateOfBirth'][1]}-${newClientData['dateOfBirth'][2]}');
    });

    //  prefs.setInt('tempClientInt', personalInfo.isEmpty ? null :  personalInfo['id']);
    //   if(prefs.getString('inputBvn') == null){
    //     //print('is true ${prefs.getString('inputBvn') }');
    //   }
    //   else {
    //     //print('is false ${prefs.getString('inputBvn') }');
    //   }

    if (prefs.getString('inputBvn') == null) {
      var newBvn = prefs.setString('inputBvn', newClientData['bvn']);
      //print('new Input Bvn ${newBvn}');
    }

    // if(prefs.getInt('employment_type') == null){
    //   prefs.setString('employment_type', newClientData['employmentSector']['id']);
    // }

    var getNewBvn = prefs.getString('inputBvn');
    //print('newBvn ${getNewBvn} ${newClientData['bvn']}');
  }

  getCodesList() {
    setState(() {
      isRequestLoading = true;
    });
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('36');
    respose.then((response) async {
      setState(() {
        isRequestLoading = false;
      });
      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpSector'));

        //
        if (prefs.getString('prefsEmpSector').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allEmp = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectData.add(mtBool[i]['name']);
          }

          setState(() {
            empSector = collectData;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        setState(() {
          isRequestLoading = false;
        });

        //print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpSector', jsonEncode(newEmp));

        int leadToClient = prefs.getInt('leadToClientID');
        //print('lead To Client Id ${leadToClient}');

        setState(() {
          allEmp = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectData.add(newEmp[i]['name']);
        }

        setState(() {
          empSector = collectData;

          if (comingFrom != null) {
            List<dynamic> selectID = allEmp
                .where((element) => element['name'] == employerSector)
                .toList();
            empInt = selectID[0]['id'];

            //print('gender In from Init ${empInt}');
          }
        });
      }
    });
  }

  getCategoryList() {
    setState(() {
      isRequestLoading = true;
    });
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('16');
    respose.then((response) async {
      setState(() {
        isRequestLoading = false;
      });
      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsEmpCategory'));

        //
        if (prefs.getString('prefsEmpCategory').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allCategory = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectCategory.add(mtBool[i]['name']);
          }

          setState(() {
            empCategory = collectCategory;
            //  isAllowedToProceed = true;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        setState(() {
          isRequestLoading = false;
        });

        //print(response['data']);
        List<dynamic> newEmp = response['data'];

        // final LocalStorage storage = new LocalStorage('localstorage_app');
        //
        //
        // final info = json.encode(newEmp);
        // storage.setItem('info', info);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsEmpCategory', jsonEncode(newEmp));

        // int leadToClient = prefs.getInt('leadToClientID');
        // //print('lead To Client Id ${leadToClient}');

        setState(() {
          allCategory = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectCategory.add(newEmp[i]['name']);
        }

        setState(() {
          empCategory = collectCategory;
          if (comingFrom != null) {
            List<dynamic> selectID = allCategory
                .where((element) => element['name'] == categorySector)
                .toList();
            catInt = selectID[0]['id'];
            //print('gender In from Init ${catInt}');
          }
        });
      }
    });
  }

  getbanksList() {
    final Future<Map<String, dynamic>> respose = RetCodes().CustomerbanksList();
    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allBanksList = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectBanksList.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectBanksList);
    //
    //   setState(() {
    //     banksListArray = collectBanksList ;
    //   });
    // }
    // );

    respose.then((response) async {
      //print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBanksList'));

        //
        if (prefs.getString('prefsBanksList').isEmpty) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Offline mode',
            message: 'Unable to load data locally ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
        //
        else {
          setState(() {
            allBanksList = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectBanksList.add(mtBool[i]['name']);
          }

          setState(() {
            banksListArray = collectBanksList;
          });

          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.orange,
            title: 'Offline mode',
            message: 'Locally saved data loaded ',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        List<dynamic> newEmp = response['data'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('prefsBanksList', jsonEncode(newEmp));

        setState(() {
          allBanksList = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectBanksList.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBanksList);

        setState(() {
          banksListArray = collectBanksList;
        });
      }
    });
  }

  errorMessage() {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.orangeAccent,
      title: 'Error',
      message: 'OTP must be verified before proceeding ',
      duration: Duration(seconds: 6),
    ).show(context);
  }

  fetchBvn() async {
    //print('employer sector ${empInt.toString()} category sector ${catInt} ');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String getBVN = prefs.getString('inputBvn');
    //print('pre :: ${getBVN}');

    if (empInt == null || catInt == null) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'Employer or category cannot be empty',
        duration: Duration(seconds: 6),
      ).show(context);
    }

    if (_lights == true && bvn.text.length != 11) {
      //print('employer sector ${empInt.toString()} category sector ${catInt.toString().length}');

      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'BVN field cannot be less than 11 digits',
        duration: Duration(seconds: 6),
      ).show(context);
    }

    //   return enterOTP();
    Map<String, dynamic> subData = {
      "bvn": _lights ? bvn.text : "",
      "phone": "",
      "accountNumber": _lights ? "" : accountNumber.text,
      "bankCode": _lights ? "" : bankCode,
    };
    final Future<Map<String, dynamic>> respose = RetCodes().verifyBVN(subData);

    setState(() {
      isRequestLoading = true;
    });
    respose.then((response) {
      //print('heelo here ${response}'  );

      if (response == null ||
          response['status'] == null ||
          response['data'] == null ||
          response['status'] == false) {
        if (response['message'] == 'Network error') {
          setState(() {
            isAllowedToProceed = true;
          });
        }

        setState(() {
          isRequestLoading = false;
        });
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Unable to validate BVN',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (response['data']['status'] == true &&
          response['data']['data']['firstName'] != null &&
          response['data']['data']['lastName'] != null) {
        // //print('this is a test' + response['data']['email']);
        setState(() {
          // isAllowedToProceed = true;
          tempEmail = response['data']['data']['personalEmail'];
          tempFirstName = response['data']['data']['firstName'];
          tempMiddleName = response['data']['data']['middleName'];
          tempLastName = response['data']['data']['lastName'];
          tempPhone1 = response['data']['data']['phone'];
          tempPhone2 = response['data']['data']['alternatePhone'];
          TempdateOfBirth = response['data']['data']['dateOfBirth'];
          Tempgender = response['data']['data']['gender'];

          String LastName = response['data']['data']['lastName'] == null
              ? ''
              : response['data']['data']['lastName'];
          String FirstName = response['data']['data']['firstName'] == null
              ? ''
              : response['data']['data']['firstName'];

          accountName = LastName + ' ' + FirstName;

          act_bvn = response['data']['data']['bvn'];

          bvnFecthedSuccessfully = true;
        });

        setState(() {
          isRequestLoading = false;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.lightGreen,
          title: "Success",
          message: ' OTP successfully sent to client',
          duration: Duration(seconds: 6),
        ).show(context);

        enterOTP();
      } else {
        setState(() {
          isRequestLoading = false;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: "Error!",
          message: 'validation failed ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  Future<void> shareIagree() async {
    await FlutterShare.share(
        title: 'Provide consent',
        text:
            'To allow us access to your details, kindly enter your BVN and confirm your information.',
        linkUrl: iAgreeLink,
        chooserTitle: 'BVN Consent screen');
  }
// To allow us access to your details, kindly enter your BVN and confirm your information.
//

  checkAvailability() {
    Map<String, dynamic> subData = {
      "bvn": bvn.text,
    };
    final Future<Map<String, dynamic>> respose =
        RetCodes().checkAvailability(subData);
    setState(() {
      //   isRequestLoading = true;
    });
    respose.then((response) {
      print('response availability ${response['data']['data']}');
      if (response['data']['data']['isAvailable'] == false) {
        setState(() {
          iAgreeLink = response['data']['data']['iagreeLink'];
          isAvailable = false;
        });
        showBottomNavForConsent();
        //  share();
      } else {
        setState(() {
          isAvailable = true;
        });
        fetchBvn();
      }
    });
  }

  void _launchURL(BuildContext context, String iAgreeLink) async {
    try {
      await launch(
        iAgreeLink,
        option: CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: CustomTabsAnimation.slideIn()),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Widget loading() {
    return Center(
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: Colors.blue,
              )),
          Text(
            "    Please wait ...",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }

  showBottomNavForConsent() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      context: context,
      builder: ((builder) => bottomSheet()),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Select an option to proceed",
              style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Nunito SansRegular',
                  fontWeight: FontWeight.w700,
                  color: ColorUtils.SELECT_OPTION),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              shareIagree();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Share verification link with client',
                    style: TextStyle(fontSize: 17),
                  ),
                  Icon(
                    Icons.share,
                    color: ColorUtils.SELECT_OPTION,
                    size: 20,
                  )
                ]),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              _launchURL(context, iAgreeLink);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Verify on behalf of customer',
                    style: TextStyle(fontSize: 17),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ColorUtils.SELECT_OPTION,
                    size: 20,
                  )
                ]),
          ),
        ],
      ),
    );
  }

  confirmOTP() {
    setState(() {
      isRequestLoading = true;
    });
    if (otpController.text.isEmpty || otpController.text.length < 5) {
      setState(() {
        isRequestLoading = false;
      });
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Error',
        message: 'OTP length too short ',
        duration: Duration(seconds: 3),
      ).show(context);
    } else {
      MyRouter.popPage(context);
      setState(() {
        isRequestLoading = true;
      });
      final Future<Map<String, dynamic>> respose =
          RetCodes().verifyOTP(tempPhone1, otpController.text);
      respose.then((response) {
        setState(() {
          isRequestLoading = false;
        });
        if (response['data']['status'] == true) {
          setState(() {
            isAllowedToProceed = true;
            otpValidationStatus = true;
          });

          //  MyRouter.popPage(context);

          if (comingFrom != 'customerPreview') {
            ClearCaches().clearMems();
          }

          MyRouter.pushPage(
              context,
              PersonalInfo(
                ClientInt: comingFrom == 'SingleCustomerScreen' ||
                        comingFrom == 'viewClient' ||
                        comingFrom == 'customerPreview' ||
                        comingFrom == 'leadView'
                    ? ClientInt
                    : null,
                bvnEmail: tempEmail,
                bvnFirstName: tempFirstName,
                bvnLastName: tempLastName,
                bvnMiddleName: tempMiddleName,
                bvnPhone1: tempPhone1,
                bvnPhone2: tempPhone2,
                dateOfBirth: TempdateOfBirth,
                Passedgender: Tempgender,
                PassedAccountName: accountName,
                PassedAccountNumber: accountNumber.text,
                PassedBankCode: bankInt.toString(),
                comingFrom: comingFrom == 'SingleCustomerScreen'
                    ? 'SingleCustomerScreen'
                    : comingFrom == 'customerPreview'
                        ? 'customerPreview'
                        : '',
                passedBVN: bvn.text.isEmpty ? act_bvn : bvn.text,
                passedEmployerSector: empInt,
                passedEmployerCategory: catInt,
              ));

          return Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: 'Success',
            message: response['data']['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        } else {
          setState(() {
            isAllowedToProceed = false;
            //  otpController.text = '';
          });
          enterOTP();
          return Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['data']['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        }

        //print('response from client OTP ${response}');
      });
    }
  }

  showBvnDialogIGree() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Client\'s BVN ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.85,
                child: SizedBox(),
              ),
              actions: <Widget>[],
            );
          },
        );
      },
    );
  }

  enterOTP() {
    // return alert(
    //   context,
    //   title: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text('Verify OTP'),
    //       InkWell(
    //           onTap: () async{
    //             setState(() {
    //               isAllowedToProceed = false;
    //             });
    //             MyRouter.popPage(context);
    //           },
    //           child: Icon(Icons.clear))
    //     ],  ),
    //   content: EntryField(context, otpController, 'Enter OTP', 'Enter OTP',),
    //   textOK:
    //   Container(
    //     width: MediaQuery.of(context).size.width * 0.6,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Center(child:
    //
    //           isRequestLoading == true ? loading() :
    //
    //           RoundedButton(buttonText: 'Verify OTP',onbuttonPressed: () async{
    //             final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    //                     confirmOTP();
    //
    //
    //           },
    //
    //           ),
    //
    //         ),
    //       ],
    //     )
    //
    //   ),
    // );

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter OTP received from the Client',
                    style: TextStyle(fontSize: 11),
                  ),
                  InkWell(
                      onTap: () async {
                        setState(() {
                          isAllowedToProceed = false;
                        });
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: EntryField(
                context,
                otpController,
                'Enter OTP',
                'Enter OTP',
              ),
              actions: <Widget>[
                Container(
                    //  width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
// YYYY-MM-DD
                    Center(
                      child: isRequestLoading == true
                          ? loading()
                          : RoundedButton(
                              buttonText: 'Verify OTP',
                              onbuttonPressed: () async {
                                //print('isRequestLoading ${isRequestLoading}');
                                confirmOTP();
                              },
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Center(
                    //   child: InkWell(
                    //       onTap: () {
                    //         MyRouter.popPage(context);
                    //         dobConfirmation();
                    //       },
                    //       child: Text(
                    //         'Not Receiving OTP? Click Here',
                    //         style: TextStyle(fontSize: 11),
                    //       )),
                    // ),
                  ],
                ))

                // new FlatButton(
                //   child: new Text("OK ${isTestState}"),
                //   onPressed: () {
                //           setState((){
                //             isTestState = 'isTexted';
                //
                //           });
                //    // Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      },
    );
  }

  dobConfirmation() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enter Client\'s BVN Date Of Birth',
                      style: TextStyle(fontSize: 11)),
                  InkWell(
                      onTap: () async {
                        setState(() {
                          isAllowedToProceed = false;
                        });
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: EntryField(
                  context, dobController, 'BVN Date Of Birth', 'YYYY-MM-DD',
                  isDateAllowed: true, isRead: true),
              actions: <Widget>[
                Container(
                    //  width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
// YYYY-MM-DD
                    Center(
                      child: isRequestLoading == true
                          ? loading()
                          : RoundedButton(
                              buttonText: 'Verify',
                              onbuttonPressed: () async {
                                //    //print('isRequestLoading ${isRequestLoading}');
                                //  confirmOTP();
                                //print('new newtemp date ${retDOBfromBVN(TempdateOfBirth)} ${dobController.text}');

                                String compA = retDOBfromBVN(TempdateOfBirth);
                                String compB = dobController.text;

                                if (compA.compareTo(compB) == 0) {
                                  // //print('correct');
                                  setState(() {
                                    dobController.text = '';
                                  });
                                  if (comingFrom != 'customerPreview') {
                                    ClearCaches().clearMems();
                                  }
                                  MyRouter.pushPage(
                                      context,
                                      PersonalInfo(
                                        ClientInt: comingFrom ==
                                                    'SingleCustomerScreen' ||
                                                comingFrom == 'viewClient' ||
                                                comingFrom ==
                                                    'customerPreview' ||
                                                comingFrom == 'leadView'
                                            ? ClientInt
                                            : null,
                                        bvnEmail: tempEmail,
                                        bvnFirstName: tempFirstName,
                                        bvnLastName: tempLastName,
                                        bvnMiddleName: tempMiddleName,
                                        bvnPhone1: tempPhone1,
                                        bvnPhone2: tempPhone2,
                                        dateOfBirth: TempdateOfBirth,
                                        Passedgender: Tempgender,
                                        PassedAccountName: accountName,
                                        PassedAccountNumber: accountNumber.text,
                                        PassedBankCode: bankInt.toString(),
                                        comingFrom: comingFrom ==
                                                'SingleCustomerScreen'
                                            ? 'SingleCustomerScreen'
                                            : comingFrom == 'customerPreview'
                                                ? 'customerPreview'
                                                : '',
                                        passedBVN: bvn.text.isEmpty
                                            ? act_bvn
                                            : bvn.text,
                                        passedEmployerSector: empInt,
                                        passedEmployerCategory: catInt,
                                      ));
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP,
                                    flushbarStyle: FlushbarStyle.GROUNDED,
                                    backgroundColor: Colors.green,
                                    title: 'Success',
                                    message: 'Date Of Birth Verified',
                                    duration: Duration(seconds: 3),
                                  ).show(context);
                                } else {
                                  // //print('Not correct');
                                  return Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP,
                                    flushbarStyle: FlushbarStyle.GROUNDED,
                                    backgroundColor: Colors.red,
                                    title: 'Error',
                                    message: 'Date Of Birth not Verified',
                                    duration: Duration(seconds: 3),
                                  ).show(context);
                                }
                              },
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Center(
                      child: InkWell(
                          onTap: () {
                            MyRouter.popPage(context);
                            enterOTP();
                          },
                          child: Text(
                            'Use OTP Instead',
                            style: TextStyle(fontSize: 11),
                          )),
                    ),
                  ],
                ))

                // new FlatButton(
                //   child: new Text("OK ${isTestState}"),
                //   onPressed: () {
                //           setState((){
                //             isTestState = 'isTexted';
                //
                //           });
                //    // Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  var _lights = true;
  String employment_type = '';
  int empInt;

  TextEditingController bvn = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Widget build(BuildContext context) {
    var startProcess = () async {
      //  //print(bvn.text);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // int leadToClient =  prefs.getInt('leadToClientID');
//    int getClientID = prefs.getInt('tempClientInt');
      if (comingFrom != 'customerPreview') {
        ClearCaches().clearMems();

        prefs.remove('tempBankInfoInt');
        //  prefs.clear();
        //print('shared rpefernce ${prefs.getInt('clientId')} ${prefs.getInt('tempResidentialInt')}');
        if (prefs.getInt('clientId') != null) {
          prefs.remove('clientId');
        }
      }

      // if bvn is on and bvn lenght is not 11
      if (_lights && bvn.text.length != 11) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Validation error",
          message: 'BVN lenght must be 11',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        var bvnData = prefs.setString('inputBvn', _lights ? bvn.text : act_bvn);
        var emplyment = prefs.setInt('employment_type', empInt);
        var catEmp = prefs.setInt('emp_category', catInt);

        // if(accountName.length < 2  && response['message'] != 'Network_error'){
        //       Flushbar(
        //              flushbarPosition: FlushbarPosition.TOP,
        //              flushbarStyle: FlushbarStyle.GROUNDED,
        //     backgroundColor: Colors.redAccent,
        //     title: "Error",
        //     message: 'Unable to proceed,account validation incorrect',
        //     duration: Duration(seconds: 3),
        //   ).show(context);
        // }
        if (comingFrom != 'customerPreview') {
          ClearCaches().clearMems();
        }

        MyRouter.pushPage(
            context,
            PersonalInfo(
              ClientInt: comingFrom == 'SingleCustomerScreen' ||
                      comingFrom == 'viewClient' ||
                      comingFrom == 'customerPreview' ||
                      comingFrom == 'leadView'
                  ? ClientInt
                  : null,
              bvnEmail: tempEmail,
              bvnFirstName: tempFirstName,
              bvnLastName: tempLastName,
              bvnMiddleName: tempMiddleName,
              bvnPhone1: tempPhone1,
              bvnPhone2: tempPhone2,
              dateOfBirth: TempdateOfBirth,
              Passedgender: Tempgender,
              PassedAccountName: accountName,
              PassedAccountNumber: accountNumber.text,
              PassedBankCode: bankInt.toString(),
              comingFrom: comingFrom == 'SingleCustomerScreen'
                  ? 'SingleCustomerScreen'
                  : comingFrom == 'customerPreview'
                      ? 'customerPreview'
                      : '',
              passedBVN: bvn.text.isEmpty ? act_bvn : bvn.text,
              passedEmployerSector: empInt,
              passedEmployerCategory: catInt,
            ));
      }
    };

    return LoadingOverlay(
      isLoading: isRequestLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
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
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                children: [
                  Text('Add New Client',
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                          fontFamily: 'Nunito Bold')),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client\'s Details ',
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Switch between using Client\'s BVN or \nBank Account details',
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Nunito SansRegular',
                                fontSize: 14),
                          ),
                        ],
                      ),
                      comingFrom == null
                          ? Container(
                              height: 20,
                              child: CupertinoSwitch(
                                value: _lights,
                                activeColor: Color(0xff077DBB),
                                onChanged: (bool value) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  setState(() {
                                    _lights = value;
                                    //print(_lights);
                                  });
                                  var setLight =
                                      prefs.setBool('isLight', _lights);
                                  bool getLight = prefs.getBool('isLight');
                                  //print('mewLight ${getLight}');
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text('If turned on, you will be required to enter the client\'s \nBVN',style: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular',fontSize: 13),),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'What Employment Sector do you work in ?  ',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                        fontFamily: 'Nunito SansRegular',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  DropDownComponent(
                      items: empSector,
                      onChange: (String item) {
                        setState(() {
                          List<dynamic> selectID = allEmp
                              .where((element) => element['name'] == item)
                              .toList();
                          //print('this is select ID');
                          //print(selectID[0]['id']);
                          empInt = selectID[0]['id'];
                          // catInt =null;
                          categorySector = ' ';
                          //print('end this is select ID ${categorySector}');
                          // categorySector = '';
                          // catInt = 0;
                        });
                      },
                      label: "Select Sector",
                      selectedItem: employerSector,
                      validator: (String item) {}),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownComponent(
                      items: empCategory,
                      popUpDisabled: (String s) {
                        if (empInt == 17) {
                          return s.startsWith('Federal') ||
                              s.startsWith('State') ||
                              s.startsWith('NYSC');
                        } else {
                          return s.startsWith('Private');
                        }
                      },
                      onChange: (String item) {
                        setState(() {
                          List<dynamic> selectID = allCategory
                              .where((element) => element['name'] == item)
                              .toList();
                          //print('this is select ID');
                          //print(selectID[0]['id']);
                          catInt = selectID[0]['id'];
                          //print('end this is select ID');
                          categorySector = selectID[0]['name'];
                        });
                      },
                      label: "Select Category",
                      selectedItem: categorySector,
                      validator: (String item) {}),

                  SizedBox(
                    height: 30,
                  ),
                  _lights == true
                      ? EntryField(context, bvn, 'BVN', 'Enter BVN',
                          maxLenghtAllow: 11,
                          isRead: comingFrom == 'customerPreview' ||
                                  comingFrom == 'SingleCustomerScreen'
                              ? true
                              : false)
                      : bankAccountValidation(),
                  //  TextInputWithFLoating(hint: '11111111111', label: 'BVN',username),
                  _smallInfo(),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              // BottomNavComponent(text:'Start',callAction: (){},)
              // DoubleBottomNavComponent(text1: 'Previous',text2: 'Next',callAction1: (){},callAction2: (){},)
              BottomNavComponent(
                  text: 'Start',
                  callAction: isAllowedToProceed == true
                      ? () {
                          //print('isAllowedToProceed ${isAllowedToProceed}');
                          startProcess();
                        }
                      : () {
                          if (otpValidationStatus == false &&
                              bvnFecthedSuccessfully == true &&
                              isAvailable == true) {
                            enterOTP();
                          } else {
                            if (isAvailable == false) {
                              checkAvailability();
                            } else {
                              fetchBvn();
                            }

                            //   checkAvailability();
                          }

                          //  errorMessage();
                        })),
    );
  }

  _smallInfo() {
    return Visibility(
      visible: isBVNLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Text(
          'BVN must be 11-digits',
          style: TextStyle(
              color: Color(0xff1A9EF4),
              fontFamily: 'Nunito SansRegular',
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText,
      {var maxLenghtAllow, bool isRead = false, bool isDateAllowed = false}) {
    var MediaSize = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(
            readOnly: isRead,
            maxLength: maxLenghtAllow,
            autofocus: false,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: TextInputType.number,
            controller: editController,
            onChanged: (String value) {
              if (value.isEmpty) {
                setState(() {
                  isBVNLoading = false;
                });
                // //print('isLoading is ${isBVNLoading}');

              }

              //  else if( value.length != 10 ){
              if (_lights && value.length != 11) {
                setState(() {
                  isBVNLoading = false;
                });
              } else if (!_lights && value.length != 10) {
                setState(() {
                  isBVNLoading = false;
                });
              } else {
                fetchBvn();
                // checkAvailability();
                setState(() {
                  isBVNLoading = false;
                });
                //print('re isloading  ${isBVNLoading}');
              }
            },
            validator: (String value) {},
            decoration: InputDecoration(

                // suffixIcon:  Visibility(
                //   visible: isBVNLoading,
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: CircularProgressIndicator(color: Colors.lightBlue,),
                //   ),
                // ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                hintText: hintText,
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color),
                counter: SizedBox.shrink(),
                suffixIcon: isDateAllowed
                    ? IconButton(
                        onPressed: () {
                          // showDatePicker();
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1955, 3, 5),
                              maxTime:
                                  DateTime.now().subtract(Duration(days: 6575)),
                              onChanged: (date) {
                            print('change $date');
                            setState(() {
                              String retDate = retsNx360dates(date);
                              dobController.text = retDate;
                            });
                          }, onConfirm: (date) {
                            print('confirm $date');
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                      )
                    : null),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Widget bankAccountValidation() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Text(
              'Enter Bank Details.',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Nunito SansRegular'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 00, vertical: 10),
            child: DropDownComponent(
                items: banksListArray,
                onChange: (String item) {
                  setState(() {
                    List<dynamic> selectID = allBanksList
                        .where((element) => element['name'] == item)
                        .toList();

                    bankCode = selectID[0]['bankSortCode'];
                    bankInt = selectID[0]['id'];
                    //print('bankInt code ${bankCode}');
                  });
                },
                label: "Bank * ",
                selectedItem: "---",
                validator: (String item) {}),
          ),
          SizedBox(
            height: 10,
          ),
          EntryField(
              context, accountNumber, 'Account Number', 'Enter Account Number',
              maxLenghtAllow: 10),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Account Name: '),
                Text(
                  '${accountName}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito SansRegular'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.40,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      if (value != null && value != CupertinoSelectedDate)
                        setState(() {
                          CupertinoSelectedDate = value;
                          //print(CupertinoSelectedDate);
                          String retDate =
                              retsNx360dates(CupertinoSelectedDate);
                          //print('ret Date ${retDate}');

                          //  retDOBfromBVN('2018-6-23');

                          dobController.text = retDate;
                        });
                    },
                    initialDateTime:
                        DateTime.now().add(Duration(days: 0, hours: 1)),
                    minimumYear: 1960,
                    maximumDate:
                        DateTime.now().add(Duration(days: 0, hours: 2)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        });
  }

  retsNx360dates(DateTime selected) {
    //print(selected);
    String newdate = selected.toString().substring(0, 10);
    //print(newdate);

    String formattedDate = DateFormat.yMMMMd().format(selected);

    //print(formattedDate);

    String removeComma = formattedDate.replaceAll(",", "");
    //print('removeComma');
    //print(removeComma);

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String newOO = o2.length == 1 ? '0' + '' + o2 : o2;

    //print('newOO ${newOO}');

    String concatss = newOO + " " + o1 + " " + o3;

    //print("concatss");
    //print(concatss);

    //print(wordList);
    return concatss;
  }

  retDOBfromBVN(String getDate) {
    //print('getDate ${getDate}');
    String newGetDate = getDate.substring(0, 10);
    String removeComma = newGetDate.replaceAll("-", " ");
    //print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    //print(wordList[1]);

    if (wordList[1] == '01') {
      setState(() {
        realMonth = 'January';
      });
    }
    if (wordList[1] == '02') {
      setState(() {
        realMonth = 'February';
      });
    }
    if (wordList[1] == '03') {
      setState(() {
        realMonth = 'March';
      });
    }
    if (wordList[1] == '04') {
      setState(() {
        realMonth = 'April';
      });
    }
    if (wordList[1] == '05') {
      setState(() {
        realMonth = 'May';
      });
    }
    if (wordList[1] == '06') {
      setState(() {
        realMonth = 'June';
      });
    }
    if (wordList[1] == '07') {
      setState(() {
        realMonth = 'July';
      });
    }
    if (wordList[1] == '08') {
      setState(() {
        realMonth = 'August';
      });
    }
    if (wordList[1] == '09') {
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

    String concatss = newOO + " " + realMonth + " " + o1;

    return concatss;
  }
}
