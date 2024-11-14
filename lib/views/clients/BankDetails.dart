import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addClient.dart';
import 'package:sales_toolkit/views/clients/CustomerPreview.dart';
import 'package:sales_toolkit/views/clients/DocumentUpload.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/post_put_method.dart';

class BankDetails extends StatefulWidget {
  final int ClientInt, bankId;
  final String PassedbankName,
      PassedaccountNumber,
      PassedaccountName,
      comingFrom;

  const BankDetails(
      {Key key,
      this.PassedaccountName,
      this.PassedaccountNumber,
      this.PassedbankName,
      this.ClientInt,
      this.comingFrom,
      this.bankId})
      : super(key: key);

  @override
  _BankDetailsState createState() => _BankDetailsState(
      PassedaccountNumber: this.PassedaccountNumber,
      PassedbankName: this.PassedbankName,
      PassedaccountName: this.PassedaccountName,
      ClientInt: this.ClientInt,
      comingFrom: this.comingFrom,
      bankId: this.bankId);
}

class _BankDetailsState extends State<BankDetails> {
  int ClientInt, bankId;

  String PassedbankName, PassedaccountNumber, PassedaccountName, comingFrom;

  _BankDetailsState(
      {this.PassedaccountName,
      this.PassedbankName,
      this.PassedaccountNumber,
      this.ClientInt,
      this.comingFrom,
      bankId});

  TextEditingController accountNumber = TextEditingController();

  final _form = GlobalKey<FormState>(); //for storing form state.

  List<String> bankAccountArray = [];
  List<String> collectBankAcount = [];
  List<dynamic> allBankAccount = [];

  List<String> bankClassificationArray = [];
  List<String> collectBankClassification = [];
  List<dynamic> allBankClassification = [];

  List<String> banksListArray = [];
  List<String> collectBanksList = [];
  List<dynamic> allBanksList = [];
  var bankInfo = [];

  // List<String> bankClassificationArray = [];
  // List<String> collectbankClassification = [];
  // List<dynamic> allbankClassification= [];

  bool isBankLoading = false;
  bool isRequestLoading = false;
  String accountName = '';
  String bankName = '';
  String bankCode, accountTypeString;
  int bankInt, bankClassificationInt, bankAccountTypeListInt;

  @override
  void initState() {
    // TODO: implement initState
    getbankAccountList();
    getbankClassificationList();
    getbanksList();
    getBankInfoInformation();
    super.initState();
  }

  getbankAccountList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('42');

    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allBankAccount = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectBankAcount.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectBankAcount);
    //
    //   setState(() {
    //     bankAccountArray = collectBankAcount;
    //   });
    // }
    // );

    respose.then((response) async {
      //print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBankAccount'));

        //
        if (prefs.getString('prefsBankAccount').isEmpty) {
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
            allBankAccount = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectBankAcount.add(mtBool[i]['name']);
          }

          setState(() {
            bankAccountArray = collectBankAcount;
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

        prefs.setString('prefsBankAccount', jsonEncode(newEmp));

        setState(() {
          allBankAccount = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectBankAcount.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBankAcount);

        setState(() {
          bankAccountArray = collectBankAcount;
        });
      }
    });
  }

  // getbanksList(){
  //   final Future<Map<String,dynamic>> respose =   RetCodes().CustomerbanksList();
  //
  //
  //   setState(() {
  //     isRequestLoading = true;
  //
  //   });
  //
  //   respose.then((response) {
  //     setState(() {
  //       isRequestLoading = false;
  //     });
  //
  //
  //     //print(response['data']);
  //     List<dynamic> newEmp = response['data'];
  //
  //     setState(() {
  //       allBanksList = newEmp;
  //     });
  //
  //     for(int i = 0; i < newEmp.length;i++){
  //       //print(newEmp[i]['name']);
  //       collectBanksList.add(newEmp[i]['name']);
  //     }
  //     //print('vis alali');
  //     //print(collectBanksList);
  //
  //     setState(() {
  //       banksListArray = collectBanksList ;
  //     });
  //   }
  //   );
  //
  //
  //
  //   respose.then((response) async {
  //     //print(response['data']);
  //
  //     if(response['status'] == false){
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //       List<dynamic> mtBool = jsonDecode(prefs.getString('prefsBanksList'));
  //
  //
  //       //
  //       if(prefs.getString('prefsBanksList').isEmpty){
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //           backgroundColor: Colors.red,
  //           title: 'Offline mode',
  //           message: 'Unable to load data locally ',
  //           duration: Duration(seconds: 3),
  //         ).show(context);
  //
  //       }
  //       //
  //       else {
  //
  //         setState(() {
  //           allBanksList = mtBool;
  //         });
  //
  //         for(int i = 0; i < mtBool.length;i++){
  //           //print(mtBool[i]['name']);
  //           collectBanksList.add(mtBool[i]['name']);
  //         }
  //
  //         setState(() {
  //           banksListArray = collectBanksList;
  //         });
  //
  //       Flushbar(
  //              flushbarPosition: FlushbarPosition.TOP,
  //              flushbarStyle: FlushbarStyle.GROUNDED,
  //           backgroundColor: Colors.orange,
  //           title: 'Offline mode',
  //           message: 'Locally saved data loaded ',
  //           duration: Duration(seconds: 3),
  //         ).show(context);
  //
  //       }
  //
  //     } else {
  //       List<dynamic> newEmp = response['data'];
  //
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //       prefs.setString('prefsBanksList', jsonEncode(newEmp));
  //
  //
  //       setState(() {
  //         allBanksList = newEmp;
  //       });
  //
  //       for(int i = 0; i < newEmp.length;i++){
  //         //print(newEmp[i]['name']);
  //         collectBanksList.add(newEmp[i]['name']);
  //       }
  //       //print('vis alali');
  //       //print(collectBanksList);
  //
  //       setState(() {
  //         banksListArray = collectBanksList;
  //       });
  //     }
  //
  //   }
  //   );
  //
  //
  // }

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

  getbankClassificationList() {
    final Future<Map<String, dynamic>> respose = RetCodes().getCodes('41');
    // respose.then((response) {
    //   //print(response['data']);
    //   List<dynamic> newEmp = response['data'];
    //
    //   setState(() {
    //     allBankClassification = newEmp;
    //   });
    //
    //   for(int i = 0; i < newEmp.length;i++){
    //     //print(newEmp[i]['name']);
    //     collectBankClassification.add(newEmp[i]['name']);
    //   }
    //   //print('vis alali');
    //   //print(collectBankClassification);
    //
    //   setState(() {
    //     bankClassificationArray = collectBankClassification;
    //   });
    // }
    // );

    respose.then((response) async {
      //print(response['data']);

      if (response['status'] == false) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<dynamic> mtBool =
            jsonDecode(prefs.getString('prefsBankClassification'));

        //
        if (prefs.getString('prefsBankClassification').isEmpty) {
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
            allBankClassification = mtBool;
          });

          for (int i = 0; i < mtBool.length; i++) {
            //print(mtBool[i]['name']);
            collectBankClassification.add(mtBool[i]['name']);
          }

          setState(() {
            bankClassificationArray = collectBankClassification;
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

        prefs.setString('prefsBankClassification', jsonEncode(newEmp));

        setState(() {
          allBankClassification = newEmp;
        });

        for (int i = 0; i < newEmp.length; i++) {
          //print(newEmp[i]['name']);
          collectBankClassification.add(newEmp[i]['name']);
        }
        //print('vis alali');
        //print(collectBankClassification);

        setState(() {
          bankClassificationArray = collectBankClassification;
        });
      }
    });
  }

  getBankInfoInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int localclientID =
        ClientInt == null ? prefs.getInt('clientId') : ClientInt;

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    //print(tfaToken);
    //print(token);
    print('${AppUrl.getSingleClient + localclientID.toString() + '/banks'}');
    Response responsevv = await get(
      AppUrl.getSingleClient + localclientID.toString() + '/banks',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print('bank returned');
    print(responsevv.body);
//3040512046
    final List<dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;
    setState(() {
      bankInfo = newClientData;
      print(">> ${bankInfo}");
      bankInt = bankInfo[0]['bank']['id'];
      bankName = bankInfo[0]['bank']['name'];
      bankCode = bankInfo[0]['bank']['bankSortCode'];
      bankAccountTypeListInt = bankInfo[0]['bankAccountType'] == null
          ? 0
          : bankInfo[0]['bankAccountType']['id'] ?? 0;
      accountTypeString = bankInfo[0]['bankAccountType'] == null
          ? ''
          : bankInfo[0]['bankAccountType']['name'] ?? '';
    });
    //print('bankInfo ${bankInfo}');
    accountName = bankInfo[0]['accountname'];
    accountNumber.text = bankInfo[0]['accountnumber'];

    //print('bankId ${bankId}');
    prefs.setInt(
        'tempBankInfoInt', bankInfo.isEmpty ? null : bankInfo[0]['id']);
  }

  @override
  AddClientProvider addClientProvider = AddClientProvider();

  fetchBankInfo(String accountNumber, String sortCode) {
    setState(() {
      isRequestLoading = true;
      accountName = '';
    });

    Map<String, dynamic> subData = {
      "accountNumber": accountNumber,
      "bankCode": sortCode
    };
    final Future<Map<String, dynamic>> respose =
        RetCodes().verifyAccountNumber(subData);

    // //print('account data ${accountData}');
    // final Future<Map<String,dynamic>> respose =   RetCodes().verifyAccountBumber(accountData);

    respose.then((response) {
      // //print('heelo here' + response['data']);

      if (response == null ||
          response['data'] == null ||
          response['message'] == 'Network error') {
        setState(() {
          isRequestLoading = false;
          isBankLoading = false;
        });
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Network Error',
          message: 'Unable to connect to internet',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (response['message'] == 'Network error') {
        setState(() {
          isRequestLoading = false;
          isBankLoading = false;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.orangeAccent,
          title: 'Network Error',
          message: 'Proceed, data has been saved to draft',
          duration: Duration(seconds: 3),
        ).show(context);

        //   return MyRouter.pushPage(context, DocumentUpload());
      }

      if (response['data'] == null || response['status'] == false) {
        setState(() {
          isRequestLoading = false;
          isBankLoading = false;
        });
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Error!",
          message: 'Account could not be validated',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (response['data']['status'] == true) {
        setState(() {
          isRequestLoading = false;
        });
        //  //print('this is a test' + response['data']['email']);
        setState(() {
          // accountName = response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] ;
          //   accountName = response['data']['data']['lastName'] == null ? '' : response['data']['data']['lastName'] + ' ' + response['data']['data']['firstName'] == null ? '' : response['data']['data']['firstName'];

          String LastName = response['data']['data']['lastName'] == null
              ? ''
              : response['data']['data']['lastName'];
          String FirstName = response['data']['data']['firstName'] == null
              ? ''
              : response['data']['data']['firstName'];

          accountName = response['data']['data']['accountName'];

          isBankLoading = false;
        });

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.green,
          title: "Success",
          message: 'Account Validation Successful',
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        setState(() {
          isRequestLoading = false;
        });
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Error!",
          message: 'Account could not be validated',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  Widget build(BuildContext context) {
    bool _isLoading = false;
    var submitBank = () async {
      //return   MyRouter.pushPage(context, DocumentUpload());

      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      setState(() {
        isRequestLoading = true;
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int getBankInfo = prefs.getInt('tempBankInfoInt');

      //print('bankInfo this ${getBankInfo}');

      Map<String, dynamic> colBankData = {
        'clientId': ClientInt == null ? prefs.getInt('clientId') : ClientInt,
        'id': getBankInfo == null ? null : getBankInfo,
        'account_number': accountNumber.text,
        "accountName": accountName,
        'bankId': bankInt,
        'bankAccountTypeId': bankAccountTypeListInt
      };

      if (accountName.length < 2) {
        setState(() {
          isRequestLoading = false;
        });
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Account name empty or too short',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      int localclientID =
          ClientInt == null ? prefs.getInt('clientId') : ClientInt;

      PostAndPut postAndPut = new PostAndPut();

      postAndPut.isClientActive(localclientID).then((value) {
        String client_status = value.toString();
        final Future<Map<String, dynamic>> respose =
            addClientProvider.addBankDetails(colBankData, client_status);
        //print('start response from login');

        //print(respose.toString());

        respose.then((response) {
          if (response == null) {
            return Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Error',
              message: 'Unable to fetch details,try again',
              duration: Duration(seconds: 3),
            ).show(context);
          }

          if (response['status'] == false) {
            setState(() {
              isRequestLoading = false;
            });

            if (response['message'] == 'Network_error') {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.orangeAccent,
                title: 'Network Error',
                message: 'Proceed, data has been saved to draft',
                duration: Duration(seconds: 3),
              ).show(context);

              return MyRouter.pushPage(context, DocumentUpload());
            }

            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.red,
              title: 'Error',
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          } else {
            setState(() {
              isRequestLoading = false;
            });

            //print('account Name ${accountName.length}');

            if (accountName.length < 2 &&
                response['message'] != 'Network_error') {
              return Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.redAccent,
                title: "Error",
                message: 'Unable to proceed,account validation incorrect',
                duration: Duration(seconds: 3),
              ).show(context);
            }

            if (comingFrom == 'CustomerPreview') {
              return MyRouter.pushPage(context, CustomerPreview());
            }
            if (comingFrom == 'SingleCustomerScreen') {
              return MyRouter.pushPage(
                  context,
                  SingleCustomerScreen(
                    clientID: ClientInt,
                  ));
            }

            MyRouter.pushPage(context, DocumentUpload());
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.GROUNDED,
              backgroundColor: Colors.green,
              title: "Success",
              message: 'Client profile updated successfully',
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      });
    };

    return LoadingOverlay(
      isLoading: isRequestLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProgressStepper(
                  stepper: 0.80,
                  title: 'Bank Details',
                  subtitle: 'Document Upload',
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text(
                          'Ensure you enter correct information, some of the information provided will later be matched with your BVN details.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Form(
                          key: _form,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: DropDownComponent(
                                    items: banksListArray,
                                    onChange: (String item) {
                                      setState(() {
                                        List<dynamic> selectID = allBanksList
                                            .where((element) =>
                                                element['name'] == item)
                                            .toList();

                                        bankCode = selectID[0]['bankSortCode'];
                                        bankInt = selectID[0]['id'];
                                        accountName = '';
                                        //print('bankInt code ${bankCode}');
                                      });
                                    },
                                    label: "Bank * ",
                                    selectedItem: bankName,
                                    validator: (String item) {}),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: DropDownComponent(
                                    items: bankAccountArray,
                                    onChange: (String item) async {
                                      setState(() {
                                        List<dynamic> selectID = allBankAccount
                                            .where((element) =>
                                                element['name'] == item)
                                            .toList();
                                        print('this is select ID');
                                        print(selectID[0]['id']);
                                        bankAccountTypeListInt =
                                            selectID[0]['id'];
                                        print('end this is select ID');
                                      });
                                    },
                                    label: "Account Type * ",
                                    selectedItem: accountTypeString,
                                    validator: (String item) {}),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: EntryField(
                                      context,
                                      accountNumber,
                                      'Account Number *',
                                      'Account Number',
                                      TextInputType.number,
                                      maxLenghtAllow: 10)),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(
          text1: 'Previous',
          text2: 'Next',
          callAction2: () {
            submitBank();
            //  MyRouter.pushPage(context, DocumentUpload());
          },
          callAction1: () {
            MyRouter.popPage(context);
          },
        ),
      ),
    );
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText, var keyBoard,
      {bool isPassword = false, var maxLenghtAllow}) {
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
            maxLength: maxLenghtAllow,
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,

            onChanged: (String value) {
              if (value.isEmpty) {
                setState(() {
                  isBankLoading = false;
                });
                // //print('isLoading is ${isBVNLoading}');

              } else if (value.length != 10) {
                setState(() {
                  isBankLoading = true;
                });
                //print('isloading  ${isBankLoading}');
              } else {
                fetchBankInfo(accountNumber.text, bankCode);
                setState(() {
                  isBankLoading = false;
                });
                //print('re isloading  ${isBankLoading}');
              }
            },

            controller: editController,

            validator: (value) {
              if (value.isEmpty) {
                return 'Field cannot be empty';
              }
            },

            // onSaved: (value) => vals = value,

            decoration: InputDecoration(
                suffixIcon: Visibility(
                  visible: isBankLoading,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color),
                counter: SizedBox.shrink()),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }
}
