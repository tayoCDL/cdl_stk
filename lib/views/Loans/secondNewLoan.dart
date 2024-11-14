import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/view_models/addLoan.dart';
import 'package:sales_toolkit/views/Loans/DocumentExtraScreen.dart';
import 'package:sales_toolkit/views/Loans/DocumentsForLoan.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondNewLoan extends StatefulWidget {
  // const SecondNewLoan({Key key}) : super(key: key);
  //
  // @override
  // _SecondNewLoanState createState() => _SecondNewLoanState();

  final int clientID, productID, loanID, employerId, loanPurpose, sectorID;
  final String TheloanOfficer, comingFrom, customerID, clientBVN;
  final Map<String, dynamic> loadfedgoData;
  const SecondNewLoan(
      {Key key,
        this.clientID,
        this.productID,
        this.TheloanOfficer,
        this.loanID,
        this.employerId,
        this.loanPurpose,
        this.sectorID,
        this.comingFrom,
        this.customerID,
        this.clientBVN,
        this.loadfedgoData})
      : super(key: key);
  @override
  _SecondNewLoanState createState() => _SecondNewLoanState(
      clientID: this.clientID,
      productID: this.productID,
      TheloanOfficer: this.TheloanOfficer,
      loanID: this.loanID,
      employerId: this.employerId,
      loanPurpose: this.loanPurpose,
      sectorID: this.sectorID,
      comingFrom: this.comingFrom,
      customerID: this.customerID,
      clientBVN: this.clientBVN,
      loadfedgoData: this.loadfedgoData);
}

class _SecondNewLoanState extends State<SecondNewLoan> {
  int clientID, productID, loanID, employerId, loanPurpose, sectorID;
  String TheloanOfficer, comingFrom, customerID, clientBVN;
  final Map<String, dynamic> loadfedgoData;
  _SecondNewLoanState(
      {this.clientID,
        this.productID,
        this.TheloanOfficer,
        this.loanID,
        this.employerId,
        this.loanPurpose,
        this.sectorID,
        this.comingFrom,
        this.customerID,
        this.clientBVN,
        this.loadfedgoData});

  List<String> frequencyArray = [];
  List<String> collectFrequency = [];
  List<dynamic> allFrequency = [];

  List<String> amortizationArray = [];
  List<String> collectAmortization = [];
  List<dynamic> allAmortization = [];

  List<String> lendersNameArray = [];
  List<String> collectLendersName = [];
  List<dynamic> allLendersName = [];

  List<String> collectDocumentType = [];

  List<String> interstTypeArray = [];
  List<String> collectInterestType = [];
  List<dynamic> allInterstType = [];
  var updateRequired = [];
  String accountName = '';
  String bankName = '';
  int singleLendersid,singleLendersid2,singleLendersid3;
  String bankCode, accountTypeString;
  int bankInt, bankClassificationInt, bankAccountTypeListInt;
  bool isRequestLoading = false;

  List<String> repaymentArray = [];
  List<String> collectRepayment = [];
  List<dynamic> allRepayment = [];
  int loanOptionInt = 0;
  String realMonth = '';
  String singleLendersName = '';
  bool _isLoading = false;
  bool _isFederalOrState = false;
  bool showPrivateInterest = false;
  int productInt, purposeInt, frequencyInt, repaymentFrequencyInt;
  String alternateRepayment = '';
  double interestRateForPrivate;
  List<dynamic> objectFetched = [];
  bool isCrcSaved = false;
  Map<String, dynamic> load_fedgoData;
  String submitOnLoan = '';

  bool isBankLoading = false;

  TextEditingController accountNumber = TextEditingController();

  List<String> bankAccountArray = [];
  List<String> collectBankAcount = [];
  List<dynamic> allBankAccount = [];

  List<String> bankAccountArray2 = [];
  List<String> collectBankAcount2 = [];
  List<dynamic> allBankAccount2 = [];

  List<String> bankAccountArray3 = [];
  List<String> collectBankAcount3 = [];
  List<dynamic> allBankAccount3 = [];


  List<String> bankClassificationArray = [];
  List<String> collectBankClassification = [];
  List<dynamic> allBankClassification = [];

  List<dynamic> lendersLists = [];

  List<String> banksListArray = [];
  List<String> collectBanksList = [];
  List<dynamic> allBanksList = [];
  var bankInfo = [];
  int lenderIndex = 0;

  bool showUpdateLender = false;
  bool showAddLender = false;

  List<TextEditingController> list_bankAccountControllers = [];
  ScrollController _scrollController = ScrollController(); // Step 1: Create a ScrollController

  void _scrollUp() {
    // Ensure the controller is attached and move to the desired position
    if (_scrollController.hasClients) {

      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,  // Scroll to the top
        duration: Duration(milliseconds: 500),       // Adjust duration as needed
        curve: Curves.easeInOut,                     // Smooth scrolling curve
      );
    }
  }
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to the bottom
      duration: Duration(seconds: 1), // Duration of the animation
      curve: Curves.easeInOut, // Curve of the animation
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
  void initState() {

    // TODO: implement initState
    //  loadFrequencyTemplate();
    //   loadAmortizationOptions();
    //   loadInterestOptions();
    if (loanID == null) {
      //  getRiskDetailsWithBvn();
    }

    // ('fedgo data >print> ${loadfedgoData}');
    print('names ${sectorID}');
    isPermittedtobookTopUp();
    if (loanID != null) {
      getLoanDetails();
    }

    loadFullTemplate();
    loadRepayment();

    // buy over features
    getLendersLists();
    getbankAccountList();
    getbankClassificationList();
    getbanksList();

    // end buy over features
    // calculateReschedule();

    // fundingOptionTemplate();

    var now = new DateTime.now();

// Find the last day of the month.
//     var beginningNextMonth = (now.month < 12) ? new DateTime(now.year, now.month + 1, 1) : new DateTime(now.year + 1, 1, 1);
//     var lastDay = beginningNextMonth.subtract(new Duration(days: 1)).day;
//
//     print('lastDay ${lastDay}');
//
//     super.initState();

    // get last day of the current month
    // from that object... get the current month {1-12}
    // if the month is 2
    // convert date to readable date 12 oct 1990

    // then set the new alternate date

    /// OTHERS
    ///
    // add two days to it

    var newJiffy = Jiffy().endOf(Units.MONTH).add(duration: Duration(days: 28));

    // var jiffy1 = Jiffy().add(duration: Duration(days: 1));
    print('newJiffy ${newJiffy.month}');
    var vlaMonth = newJiffy.month;

    if (vlaMonth == 2) {
      var fubruaryJiffy = newJiffy.dateTime.toString();
      print('feb Jiffy ${fubruaryJiffy}');
      String vDate = getDateForNextRepayment(fubruaryJiffy);
      print('vDate ${vDate}');
      setState(() {
        alternateRepayment = vDate;
      });
    } else {
      var otherJiffy = newJiffy.add(duration: Duration(days: 2));
      print('other Jiffy ${otherJiffy.dateTime}');
      var newDee = otherJiffy.dateTime.toString();
      String vDate = getDateForNextRepayment(newDee);
      print('vDate ${vDate} ${newDee}');
      setState(() {
        alternateRepayment = vDate;
      });
    }

    // get last date of the month
    // then check the next month if it's february
  }

  getLendersLists() async {
    final Future<Map<String, dynamic>> response = RetCodes().getLendersLists();

    response.then((responseData) {
      print('lenders lists>> << ${responseData}');
      List<dynamic> newLenders = responseData['data'];

      setState(() {
        allLendersName = newLenders;
      });

      for (int i = 0; i < newLenders.length; i++) {
        //  print(newLenders[i]['displayName']);
        collectLendersName.add(newLenders[i]['displayName']);
      }
      print('vis alali');
      print(collectLendersName);

      setState(() {
        lendersNameArray = collectLendersName;
        //   List<dynamic> selectID =   allLendersName.where((element) => element['displayName'] == _title).toList();
        //  titleInt = selectID[0]['id'];
      });
    });
  }

  // buy over
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
  //              flushbarPosition: FlushbarPosition.BOTTOM,
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
  //              flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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

  // end buy over

  getRiskDetailsWithBvn() {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> response = RetCodes()
        .getRiskDetails(bvn: clientBVN, productId: productID.toString());

    response.then((responseData) {
      print('decider this>> << ${responseData}');
      setState(() {
        // clientBvn = responseData['bvn'];
        var new_interest =
        responseData['data']['data']['deciderSetupProfile']['interestRate'];
        submitOnLoan =
        responseData['data']['data']['deciderSetupProfile']['categoryName'];
        //  print('>> ${load_fedgoData}');
        load_fedgoData = {
          "interestRate": responseData['data']['data']['deciderSetupProfile']
          ['interestRate'],
          "firstCentralPdf": responseData['data']['data']
          ['firstCentralResponse']['base64Pdf'],
          "creditRegistryPdf": responseData['data']['data']['creditRegistry']
          ['base64Pdf'],
        };
        nominal_interest.text = new_interest.toString();
        print('isFedgofetched >> ${load_fedgoData}');
      });

      //  Flushbar(
      //           flushbarPosition: FlushbarPosition.BOTTOM,
      //           flushbarStyle: FlushbarStyle.GROUNDED,
      //   backgroundColor: Colors.blue,
      //   title: 'Message',
      //   message: responseData['data']['message'] ?? ' ',
      //   duration: Duration(seconds: 3),
      // ).show(context);
    });

    print('isFedgofetched >> ${load_fedgoData}');
    setState(() {
      _isLoading = false;
      // nominal_interest.text = load_fedgoData['interestRate'];
    });
  }

  changeInterestRateForPrivate() {
    Map<String, dynamic> interestData = {
      "bvn": clientBVN,
      "productId": productID,
      "loanAmount": principal.text
      // "bvn": '22239215361',
      // "productId": 71,
      // "loanAmount": '50000'
    };

    setState(() {
      showPrivateInterest = true;
    });

    if (interestData['loanAmount'] != null) {
      final Future<Map<String, dynamic>> response =
      RetCodes().changeInterestRate(interestData);

      response.then((responseData) {
        print('this>> << ${responseData}');
        setState(() {
          //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
          if (responseData['data']['data']['categpries'] == null) {
            showPrivateInterest = false;
          } else {
            var nomsInterest =
            responseData['data']['data']['categpries']['interestRate'];
            nominal_interest.text = nomsInterest.toString();
            min_interest = nomsInterest.toString();
            max_interest = nomsInterest.toString();
            showPrivateInterest = false;
          }
        });
      });
    }
  }

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
      //  print('heelo here' + response['data']);

      if (response == null ||
          response['data'] == null ||
          response['message'] == 'Network error') {
        setState(() {
          isRequestLoading = false;
          isBankLoading = false;
        });
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
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

        setState(() {});
        Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
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
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: "Error!",
          message: 'Account could not be validated',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }


  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  TextEditingController repaymentDate = TextEditingController();

  TextEditingController principal = TextEditingController();
  TextEditingController netpay = TextEditingController();
  TextEditingController committment = TextEditingController();
  TextEditingController no_of_repayments = TextEditingController();
  TextEditingController loanTerm = TextEditingController();
  TextEditingController repaidEvery = TextEditingController();
  TextEditingController nominal_interest = TextEditingController();
  TextEditingController buy_over_settlement_balance = TextEditingController();
  TextEditingController buy_over_settlement_balance_2 = TextEditingController();
  DateTime CupertinoSelectedDate =
  DateTime.now().add(Duration(days: 15, hours: 0));
  AddLoanProvider addLoanProvider = AddLoanProvider();

  Map<String, dynamic> fullTemps;
  Map<String, dynamic> vOverrides, vOverrides2;
  List<dynamic> chargesData;
  int ClientaccountLinkingOptions = 100;
  bool value = false;
  bool isBuyOver = false;
  bool isBuyOvertopup = false;
  String min_repayment = '';
  String max_repayment = '';
  String min_principal = '';
  String max_principal = '';

  String min_interest = '';
  String max_interest = '';
  double repaymentAmount = 0.0;
  bool _canUseForTopUp = false;
  bool isBuyOverAvailable = false;
  bool isBuyOverTopUpAvailable = false;
  int maxLenderCount = 0;
  List<dynamic> productOptions = [];
  bool canBookOtherLoans = true;
  List<String> loanOptionArray = [];
  List<String> collectLoanOption = [];
  List<dynamic> allLoanOption = [];

  int employerID;

  //final formatCurrency = new NumberFormat.simpleCurrency();

  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

  loadFrequencyTemplate() async {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanFrequency(clientID, productID);
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allFrequency = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectFrequency.add(newEmp[i]['value']);
      }
      print('vis alali purpose..');
      print(collectFrequency);

      setState(() {
        frequencyArray = collectFrequency;
      });
    });
  }

  loadAmortizationOptions() async {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getAmortizationType(clientID, productID);
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allAmortization = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectAmortization.add(newEmp[i]['value']);
      }
      print('vis alali purpose..');
      print(collectAmortization);

      setState(() {
        amortizationArray = collectAmortization;
      });
    });
  }

  loadInterestOptions() async {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getInterestMethod(clientID, productID);
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allInterstType = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectInterestType.add(newEmp[i]['value']);
      }
      print('vis alali interest..');
      print(collectInterestType);

      setState(() {
        interstTypeArray = collectInterestType;
      });
    });
  }

  loadRepayment() async {
    final Future<Map<String, dynamic>> respose =
    RetCodes().getRepaymentFrequency(clientID, productID);
    respose.then((response) {
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        allRepayment = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['value']);
        collectRepayment.add(newEmp[i]['value']);
      }
      print('vis alali interest..');
      print(collectRepayment);

      setState(() {
        repaymentArray = collectRepayment;
      });
    });
  }

  loadFullTemplate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Future<Map<String, dynamic>> respose =
    RetCodes().getFullTemplate(clientID, productID, employerId);

    respose.then((response) {
      print('this is the loadAllow');
      print(response['data']);

      Map<String, dynamic> fullTemplate = response['data'];

      setState(() {
        fullTemps = fullTemplate;

        print('product other config ${fullTemps['product']['otherConfig']}');

        //  print('hello >> ${fullTemps['employerLoanProductDataOptions'][0]['loanProductId']}');
// Employer charges should be checked
        ClientaccountLinkingOptions =
        fullTemps['accountLinkingOptions'][0]['id'];
        print(
            'account Linking ID ${fullTemps['accountLinkingOptions'][0]['id']}');
        vOverrides = fullTemps['product']['allowAttributeOverrides'];
        vOverrides2 = fullTemps;
        print('chargesData from full template --> ${chargesData}');
        if (chargesData == null) {
          // chargesData = fullTemps['employerLoanProductDataOptions'] == null
          //     ? fullTemps['charges']
          //     : fullTemps['employerLoanProductDataOptions'] ??
          //         fullTemps['charges'];
          chargesData = fullTemps['employerLoanProductDataOptions'] == null
              ? fullTemps['charges']
              : fullTemps['employerLoanProductDataOptions'][0]['charges'] ??
              fullTemps['charges'];
          print('NewchargesData from full template --> ${chargesData}');
        }
        min_repayment = fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['minNumberOfRepayments'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['minNumberOfRepayments']
            .toString() ??
            fullTemps['product']['minNumberOfRepayments'].toString();

        max_repayment = fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['maxNumberOfRepayments'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['maxNumberOfRepayments']
            .toString() ??
            fullTemps['product']['maxNumberOfRepayments'].toString();
        min_principal = formatCurrency
            .format(fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['minPrincipal']
            : fullTemps['employerLoanProductDataOptions'][0]
        ['minPrincipal'] ??
            fullTemps['product']['minPrincipal'])
            .toString();
        max_principal = formatCurrency
            .format(fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['maxPrincipal']
            : fullTemps['employerLoanProductDataOptions'][0]
        ['maxPrincipal'] ??
            fullTemps['product']['maxPrincipal'])
            .toString();
        min_interest = fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['minInterestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
            .toString() ??
            fullTemps['product']['minInterestRatePerPeriod'].toString();
        max_interest = fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['maxInterestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['maxNominalInterestRatePerPeriod']
            .toString() ??
            fullTemps['product']['maxInterestRatePerPeriod'].toString();

        _canUseForTopUp = fullTemps['canUseForTopup'];
        isBuyOverAvailable = fullTemps['product']['isBuyOver'];
        isBuyOverTopUpAvailable = fullTemps['product']['isBuyOverTopUp'];
        maxLenderCount = fullTemps['product']['maximumLenderCount'];

        // delete this


        // end delete this

        if (fullTemps['product']['repaymentMethod'] != null) {
          print('repayment method ${fullTemps['product']['repaymentMethod']}');

          List<dynamic> allReps = [];

          var valLenght = fullTemps['product']['repaymentMethod'];
          print('valLengh ${valLenght}');
          for (int i = 0; i < valLenght.length; i++) {
            print(
                'test data ${fullTemps['product']['repaymentMethod'][i]['description']}');
            //var nTemps =  fullTemps['product']['repaymentMethod']['name'];
            allReps
                .add(fullTemps['product']['repaymentMethod'][i]['description']);
          }
          if (allReps.contains('Deduction at Source')) {
            _isFederalOrState = true;
          }
          //  _isFederal = fullTemps['repaymentMethod'] == null ? false : fullTemps['product']['repaymentMethod']['name'] != 'Deduction at Source' ? false : true;

          print('_sfederal ${_isFederalOrState}');
        }

        print('can use for top up ${_canUseForTopUp}');
        if (_canUseForTopUp) {
          productOptions = fullTemps['clientActiveLoanOptions'];
        }
        print('product Options ${productOptions}');
        setState(() {
          loanOptionArray = [];
          allLoanOption = productOptions;
        });

        for (int i = 0; i < productOptions.length; i++) {
          //  print(newEmp[i].affectedTypeName);
          collectLoanOption.add(productOptions[i]['productName'] +
              "-" +
              productOptions[i]['accountNo']);
        }

        print('vis alali catgory');
        print(collectLoanOption);

        setState(() {
          loanOptionArray = collectLoanOption;
        });
        prefs.setBool(
            'isAutoDisburse',
            fullTemps['autoDisburse'] == null
                ? false
                : fullTemps['autoDisburse']);
        prefs.setBool(
            'isBankStatement',
            fullTemps['product']['otherConfig'] == null
                ? false
                : fullTemps['product']['otherConfig']['checkBankStatement']);
      });

      print('loan option array ${loanOptionArray}');

      print('attribute overrides ${fullTemps['product']['no_of_repayments']}');
      //  print('vOverried ${vOverrides['amortizationType']}');
      print(formatCurrency.format(100000));
      repaidEvery.text = fullTemps['product']['repaymentEvery'].toString();

      if (loanID == null) {
        print(
            'new<< ${interestRateForPrivate} ${load_fedgoData != null ? load_fedgoData['interestRate'].toString() : fullTemps['employerLoanProductDataOptions'] == null ? fullTemps['product']['interestRatePerPeriod'].toString() : fullTemps['employerLoanProductDataOptions'][0]['interestRate'].toString()}');
        principal.text = fullTemps['product']['principal'].toString();
        nominal_interest.text = load_fedgoData != null
            ? load_fedgoData['interestRate'].toString()
            : fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
            .toString();
        no_of_repayments.text =
            fullTemps['product']['numberOfRepayments'].toString();
      }
      //     nominal_interest.text = fullTemps['product']['numberOfRepayments'].toString();
    });
  }

  getLoanDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');

    Response responsevv = await get(
      AppUrl.getLoanDetails +
          loanID.toString() +
          '?associations=all&exclude=guarantors,futureSchedule',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      //  loanDetail = newClientData;
      print('mewCLient Data ${newClientData['id']}');
      print('new<< ${interestRateForPrivate}');
      netpay.text = newClientData['netPay'].toString();
      // committment.text = newClientData['']

      principal.text = newClientData['principal'].toString();
      no_of_repayments.text = newClientData['numberOfRepayments'].toString();
      nominal_interest.text = newClientData['interestRatePerPeriod'].toString();
      // repaymentDate.text =
      loanID = newClientData['id'];
      repaymentDate.text = retDOBfromBVN(
          '${newClientData['expectedFirstRepaymentOnDate'][0]}-${newClientData['expectedFirstRepaymentOnDate'][1]}-${newClientData['expectedFirstRepaymentOnDate'][2]}');

      if(newClientData['buyOverLoanDetail'] != null){
          lendersLists = newClientData['buyOverLoanDetail'];
        //  maxLenderCount = lendersLists.length;
       //   _canUseForTopUp = newClientData['buyOverLoanDetail'];
          isBuyOverAvailable = true;
          isBuyOvertopup = newClientData['isTopup'];
          isBuyOver = isBuyOvertopup == true ? false : true;

          isBuyOverTopUpAvailable = newClientData['canUseForTopup'];
          lenderIndex =  maxLenderCount - lendersLists.length;
          print('lenders lists ${ lendersLists.length} ${lenderIndex} ${maxLenderCount}');
      }
         });
  }

  calculateReschedule() async {
    print('repayment << ${chargesData.map((e) => {
      "chargeId": e['chargeId'] == null ? e['id'] : e['chargeId'],
      "amount": loanID == null
          ? e['amount']
          : (e['amountOrPercentage'] == null
          ? e['amount']
          : e['amountOrPercentage']),
      "id": loanID == null ? null : e['id']
    }).toList()}');
    // print('charges Data << ${chargesData.toList()}');

    DateTime now = DateTime.now();
    String vasCoddd = retsNx360dates(now);

    Map<String, dynamic> repaymentSchedule = {
      "commitment": committment.text.isEmpty ? 0 : committment.text,
      "netpay": netpay.text,
      "clientId": clientID,
      "productId": productID,
      "principal": principal.text,
      "loanTermFrequency": no_of_repayments.text,
      "loanTermFrequencyType": 2,
      "numberOfRepayments": no_of_repayments.text,
      "repaymentEvery": repaidEvery.text,
      "repaymentFrequencyType": 2,
      "interestRatePerPeriod": load_fedgoData != null
          ? load_fedgoData['interestRate']
          : _isFederalOrState == false
          ? nominal_interest.text
          : fullTemps['employerLoanProductDataOptions'] == null
          ? fullTemps['product']['interestRatePerPeriod'].toString()
          : fullTemps['employerLoanProductDataOptions'][0]
      ['interestRate']
          .toString(),
      "amortizationType": vOverrides2['amortizationType']['id'],
      "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
      "interestType": vOverrides2['interestType']['id'],
      "interestCalculationPeriodType":
      vOverrides2['interestCalculationPeriodType']['id'],
      "allowPartialPeriodInterestCalcualtion":
      fullTemps['allowPartialPeriodInterestCalcualtion'],
      "inArrearsTolerance": vOverrides['inArrearsTolerance'] == true ? 1 : 0,
      "graceOnArrearsAgeing": vOverrides2['graceOnArrearsAgeing'],
      "transactionProcessingStrategyId":
      vOverrides2['transactionProcessingStrategyId'],
      "rates": [],
      // "charges":  [
      //   {
      //     "chargeId": chargesData[0]['id'],
      //     "amount": chargesData[0]['amount']
      //   }
      // ],
      "charges": chargesData.length == 0
          ? []
          :
      // [
      //           {
      //             "chargeId":
      //                 chargesData[0]['chargeId'] ?? chargesData[0]['id'],
      //             "amount": loanID == null
      //                 ? chargesData[0]['amount']
      //                 : chargesData[0]['amountOrPercentage'],
      //             "id": loanID == null ? null : chargesData[0]['id']
      //           }
      //         ],

      chargesData
          .map((e) => {
        "chargeId": e['chargeId'] == null ? e['id'] : e['chargeId'],
        "amount": loanID == null
            ? e['amount']
            : (e['amountOrPercentage'] == null
            ? e['amount']
            : e['amountOrPercentage']),
        "id": loanID == null ? null : e['id']
      })
          .toList(),
      "locale": "en",
      "dateFormat": "dd MMMM yyyy",
      "loanType": "individual",
      "expectedDisbursementDate": vasCoddd,
      "submittedOnDate": vasCoddd,
    };

    final Future<Map<String, dynamic>> respose =
    RetCodes().calculateRepayment(repaymentSchedule);

    respose.then((response) {
      print('repayment schedule ${response['data']}');
      if (response['status'] == false || response['status'] == null) {
        setState(() {
          repaymentAmount = 0.0;
        });
      }
      setState(() {
        repaymentAmount =
        response['data']['periods'][1]['totalOriginalDueForPeriod'];
      });
    });
  }

  isPermittedtobookTopUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String passed_staff_id = prefs.getString('loanOfficerId');
    RetCodes rtCocdes = RetCodes();
    rtCocdes
        .loanPermission(int.tryParse(passed_staff_id), clientID)
        .then((value) {
      setState(() {
        //  canBookOtherLoans = false;
        canBookOtherLoans = value['data'] == null
            ? false
            : value['data']['loanBookingPermission']['canBookOtherLoans'] ??
            false;
        //    bool canBookNewLoan = value['data'] == null ? false :  value['data']['loanBookingPermission']['canBookNewLoan'] ?? false;
        //  bool canBookOtherLoans = value['data'] == null ? false : value['data']['loanBookingPermission']['canBookOtherLoans'] ?? false;

        print('>> can book other loans ${canBookOtherLoans}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime nextRepaymentDate = now.add(const Duration(days: 30));
    String getNextRepaymentDate = retsNx360dates(nextRepaymentDate);
    String vasCoddd = retsNx360dates(now);
    // int passedLoanID = prefs.getInt('loanCreatedId');

    int random(min, max) {
      return min + Random.secure().nextInt(max - min);
    }

    addDocsfromCrcAndFirstCentral() {
      setState(() {
        objectFetched.add(
          {
            "id": random(1, 50),
            "name": "First Central",
            "fileName": "First Central",
            //  "size": bankFileSize,
            "type": "application/pdf",
            "location": load_fedgoData['firstCentralPdf'],
            "description": "First Central"
          },
        );
        objectFetched.add(
          {
            "id": random(1, 50),
            "name": "Credit Registry",
            "fileName": "Credit Registry",
            //  "size": bankFileSize,
            "type": "application/pdf",
            "location": load_fedgoData['creditRegistryPdf'],
            "description": "Credit Registry"
          },
        );
      });
    }

    // getDocumentsForLoan() async{
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   int passedLoanID = prefs.getInt('loanCreatedId');
    //   final Future<Map<String, dynamic>> respose =
    //   RetCodes().getDocumentNote(passedLoanID);
    //
    //   respose.then((response) {
    //     print('note response ${response}');
    //     if (response == null ||
    //         response['status'] == null ||
    //         response['status'] == false) {
    //
    //       return Flushbar(
    //             flushbarPosition: FlushbarPosition.BOTTOM,
    //             flushbarStyle: FlushbarStyle.GROUNDED,
    //         backgroundColor: Colors.red,
    //         title: 'Error',
    //         message: ' Unable to attach document',
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //
    //
    //     } else {
    //
    //
    //       print('documents array ${response['data']}');
    //     }
    //   });
    // }

    uploadDocsForLoan(dynamic objFetched) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _isLoading = true;
      });
      final Future<Map<String, dynamic>> respose =
      addLoanProvider.addDocumentForLoan(objFetched);

      print('start response from login');

      print(respose.toString());

      respose.then((response) {
        AppTracker().trackActivity('DOCUMENT UPLPOADED',
            payLoad: {"response": response.toString(), "clientId": clientID});
        setState(() {
          _isLoading = false;
          //  isCrcSaved = true;
        });
        print('response from provider ${response['data']}');

        //  getDocumentsForLoan();
        if (response['status'] == false) {
          Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['message'],
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    geSingleLoanConfig(int configID) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int passedLoanID = prefs.getInt('loanCreatedId');
      setState(() {
        _isLoading = true;
      });
      final Future<Map<String, dynamic>> respose =
      RetCodes().SingleLoanDocumentConfiguration(configID);

      respose.then((response) async {
        setState(() {
          _isLoading = false;
          collectDocumentType = [];
        });
        print(response['data']);

        List<dynamic> newEmp = response['data'];

        print('collect Docs ${newEmp}');

        List<dynamic> modifiedEmp =
        newEmp.where((element) => element['systemDefined']).toList();

        print('modifed emp ${modifiedEmp}');

        for (int i = 0; i < modifiedEmp.length; i++) {
          collectDocumentType.add(modifiedEmp[i]['name']);
        }

        print(
            'collect Document ${collectDocumentType} ${collectDocumentType.length}');

        if (load_fedgoData != null) {
          print('fedGo not empty');
          addDocsfromCrcAndFirstCentral();
          uploadDocsForLoan(objectFetched);
        }

        // if(!collectDocumentType.contains('Loan Agreement Form') && collectDocumentType.length == 1){
        //   print('documents required are ${collectDocumentType}');
        //   MyRouter.pushPage(context, DocumentExtraScreen(
        //     // clientID: clientID,
        //   ));
        // }

        if (collectDocumentType.length == 1 &&
            collectDocumentType.contains('Loan Agreement Form')) {
          print('documents required are ${collectDocumentType}');
          // upload docs

          // end upload docs

          MyRouter.pushPage(
              context,
              DocumentForLoan(
                clientID: clientID,
              ));
          // MyRouter.pushPage(context, DocumentExtraScreen(
          //   passedclientID: clientID,
          //   loanID: passedLoanID,
          // ));
        } else if (collectDocumentType.length <= 2 &&
            collectDocumentType.contains('Loan Agreement Form') ||
            collectDocumentType.contains('Statement')) {
          print('documents required are ${collectDocumentType}');
          // MyRouter.pushPage(
          //     context,
          //     DocumentForLoan(
          //       clientID: clientID,
          //       moreDocument: 'go_to_extra_screen',
          //     ));

          MyRouter.pushPage(
              context,
              DocumentExtraScreen(
                passedclientID: clientID,
                loanID: passedLoanID,
                moreDocument: 'go_to_extra_screen',
              ));
        } else {
          print('more documents required add new screen');
          // MyRouter.pushPage(
          //     context,
          //     DocumentForLoan(
          //       clientID: clientID,
          //       moreDocument: 'go_to_extra_screen',
          //     ));

          MyRouter.pushPage(
              context,
              DocumentExtraScreen(
                passedclientID: clientID,
                loanID: passedLoanID,
                moreDocument: 'go_to_extra_screen',
              ));
        }
        //   [{id: 55, name: Loan Agreement Form, systemDefined: true, codeValues: Document LAF,Online LAF,Others LAF,SMS LAF}, {id: 58, name: Statement, systemDefined: true, codeValues: Bank Statement}]

        //    final SharedPreferences prefs = await SharedPreferences.getInstance();
      });
    }

    getPassedLoanDetails() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('base64EncodedAuthenticationKey');
      var tfaToken = prefs.getString('tfa-token');
      int passedLoanID = prefs.getInt('loanCreatedId');

      Response responsevv = await get(
        AppUrl.getLoanDetails +
            passedLoanID.toString() +
            '?associations=all&exclude=guarantors,futureSchedule',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      var newClientData = responseData2;
      setState(() {
        // loanDetail = newClientData;

        if (newClientData['configs'] != null) {
          int docConfigData = newClientData['configs'][0]['id'];
          if (docConfigData != null) {
            geSingleLoanConfig(docConfigData);
          }
        } else {
          return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: 'Loan Config not found',
            duration: Duration(seconds: 6),
          ).show(context);
        }
      });
      //   print('Loan detail ${loanDetail}');
    }

    var submitWithoutDecider = () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (fullTemps == null || fullTemps.isEmpty) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.blueAccent,
          title: 'Hold ✊',
          message: 'Please hold, loan configuration still loading ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      setState(() {
        _isLoading = true;
      });

      MyRouter.popPage(context);

      int passedLoanID = prefs.getInt('loanCreatedId');

      Map<String, dynamic> personalData = {
        "id": passedLoanID == null ? loanID : passedLoanID,
        "commitment": committment.text.isEmpty ? 0 : committment.text,
        "netpay": netpay.text,
        "clientId": clientID,
        "productId": productID,
        "principal": principal.text,
        "loanPurpose": loanPurpose,
        "linkAccountId": ClientaccountLinkingOptions,
        "loanTermFrequency": no_of_repayments.text,
        "loanTermFrequencyType": 2,
        "numberOfRepayments": no_of_repayments.text,
        "repaymentEvery": repaidEvery.text,
        "repaymentFrequencyType": 2,
        "loanIdToClose": loanOptionInt,
                 "isTopup":  isBuyOvertopup || value ? true : false,
        "interestRatePerPeriod": load_fedgoData != null
            ? load_fedgoData['interestRate']
            : _isFederalOrState == false
            ? nominal_interest.text
            : fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['interestRate']
            .toString(),
        // "amortizationType": vOverrides['amortizationType'] == true ? 1 : 0,
        // "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        // "interestType":  vOverrides['interestType'] == true ? 1 : 0,
        // "interestCalculationPeriodType": vOverrides['interestCalculationPeriodType'] == true ? 1 : 0,
        // "allowPartialPeriodInterestCalcualtion": fullTemps['allowPartialPeriodInterestCalcualtion'],
        // "inArrearsTolerance":  vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        // "graceOnArrearsAgeing": vOverrides['graceOnArrearsAgeing'] == true ? 1 : 0,
        // "transactionProcessingStrategyId": vOverrides['transactionProcessingStrategyId'] == true ? 1 : 0,
        // // "graceOnPrinci palPayment": 1,
        // "graceOnInterestPayment": 1,
        "amortizationType": vOverrides2['amortizationType']['id'],
        "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        "interestType": vOverrides2['interestType']['id'],
        "interestCalculationPeriodType":
        vOverrides2['interestCalculationPeriodType']['id'],
        "allowPartialPeriodInterestCalcualtion":
        fullTemps['allowPartialPeriodInterestCalcualtion'],
        "inArrearsTolerance": vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        "graceOnArrearsAgeing": vOverrides2['graceOnArrearsAgeing'],
        "transactionProcessingStrategyId":
        vOverrides2['transactionProcessingStrategyId'],
        "NextRepaymentDate":
        !_isFederalOrState ? repaymentDate.text : alternateRepayment,
        // "graceOnInterestCharged": 1,
        "rates": [],
        "charges": chargesData.length == 0
            ? []
            :
        //  [
        // {
        //   "chargeId":
        //       chargesData[0]['chargeId'] ?? chargesData[0]['id'],
        //   "amount": loanID == null
        //       ? chargesData[0]['amount']
        //       : chargesData[0]['amountOrPercentage'],
        //   "id": loanID == null ? null : chargesData[0]['id']
        // }
        // ]
        chargesData
            .map((e) => {
          "chargeId":
          e['chargeId'] == null ? e['id'] : e['chargeId'],
          "amount": loanID == null
              ? e['amount']
              : (e['amountOrPercentage'] == null
              ? e['amount']
              : e['amountOrPercentage']),
          "id": loanID == null ? null : e['id']
        })
            .toList(),
        "locale": "en",
        "dateFormat": "dd MMMM yyyy",
        "loanType": "individual",
        "expectedDisbursementDate": vasCoddd,
        "submittedOnDate": vasCoddd,
        //  "linkAccountId": loanOptionInt == 0 ? null : loanOptionInt,
        //"methodType": loanID == null ? "post" : "put",
        "methodType": loanID == null && passedLoanID == null ? "post" : "put",
      };

      print('response from personal ${personalData}');

      final Future<Map<String, dynamic>> respose =
      addLoanProvider.addLoan(personalData, 'fail');
      print('start response from login');

      respose.then((response) {
        print('response from provider 002 ${response}');

        if (response == null ||
            response['status'] == null ||
            response['status'] == false) {
          setState(() {
            _isLoading = false;
          });

          Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['message'],
            duration: Duration(seconds: 6),
          ).show(context);

          if (response['suggested_amount'] != null) {
            return alert(
              context,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                      onTap: () {
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: Row(
                children: [
                  Text(
                    '${response['message']} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ],
              ),
              textOK: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RoundedButton(
                    buttonText: 'Okay',
                    onbuttonPressed: () {
                      MyRouter.popPage(context);
                    },
                  )),
            );
          }
        } else {
          getPassedLoanDetails();

          setState(() {
            _isLoading = false;
          });

          prefs.setBool('sendForManualReview', true);

          Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Loan Originated',
            duration: Duration(seconds: 6),
          ).show(context);
        }
      });
    };

    var submitLoanToCheckForDSR = () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // if(chargesData.isEmpty){
      //   return   Flushbar(
      //           flushbarPosition: FlushbarPosition.BOTTOM,
      //           flushbarStyle: FlushbarStyle.GROUNDED,
      //     backgroundColor: Colors.red,
      //     title: 'Error ',
      //     message: 'Loan charge not found ',
      //     duration: Duration(seconds: 3),
      //   ).show(context);
      // }

      if (nominal_interest.text == '0.0') {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Error',
          message: 'Client is not qualified to book this loan',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (fullTemps == null || fullTemps.isEmpty) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.blueAccent,
          title: 'Hold ✊',
          message: 'Please hold, loan configuration still loading ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (netpay.text.length < 3 || netpay.text.isEmpty) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Validation Error',
          message: 'Netpay is required ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (principal.text.isEmpty) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Validation Error',
          message: 'Principal is required ',
          duration: Duration(seconds: 3),
        ).show(context);
      }
      if (no_of_repayments.text.isEmpty) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Validation Error',
          message: 'Loan term is required ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      if (int.tryParse(no_of_repayments.text) > int.tryParse(max_repayment)) {
        return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.redAccent,
          title: 'Validation Error',
          message: 'Max repayment is out of range ',
          duration: Duration(seconds: 3),
        ).show(context);
      }

      setState(() {
        _isLoading = true;
      });

      print('>> buyover state >>  ${(value == false || isBuyOvertopup == false) && (loanOptionInt == 0 || loanOptionInt > 0) == false  }');
      print(
          'app value value ${value} ${loanOptionInt} ${isBuyOvertopup} ${isBuyOvertopup || value ? true : false}');

      int passedLoanID = prefs.getInt('loanCreatedId');

      print('passed Loan ID ${passedLoanID} ${loanID}');

      Map<String, dynamic> personalData = {
        "id": passedLoanID == null ? loanID : passedLoanID,
        "commitment": committment.text.isEmpty ? 0 : committment.text,
        "netpay": netpay.text,
        "clientId": clientID,
        "productId": productID,
        "principal": principal.text,
        "loanPurpose": loanPurpose,
        "linkAccountId": ClientaccountLinkingOptions,
        "loanIdToClose": loanOptionInt,
        "loanTermFrequency": no_of_repayments.text,
        "loanTermFrequencyType": 2,
        "numberOfRepayments": no_of_repayments.text,
        "repaymentEvery": repaidEvery.text,
        "repaymentFrequencyType": 2,
        "submittedOnNote": submitOnLoan,
            "isTopup":  isBuyOvertopup || value ? true : false,
        "interestRatePerPeriod": load_fedgoData != null
            ? load_fedgoData['interestRate']
            : _isFederalOrState == false
            ? nominal_interest.text
            : fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['interestRate']
            .toString(),
        //   "amortizationType": vOverrides['amortizationType'] == true ? 1 : 0,
        //   "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        //   "interestType":  vOverrides['interestType'] == true ? 1 : 0,
        //   "interestCalculationPeriodType": vOverrides['interestCalculationPeriodType'] == true ? 1 : 0,
        //   "allowPartialPeriodInterestCalcualtion": fullTemps['allowPartialPeriodInterestCalcualtion'],
        //   "inArrearsTolerance":  vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        // "graceOnArrearsAgeing": vOverrides['graceOnArrearsAgeing'] == true ? 1 : 0,
        // "transactionProcessingStrategyId": vOverrides['transactionProcessingStrategyId'] == true ? 1 : 0,

        "amortizationType": vOverrides2['amortizationType']['id'],
        "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        "interestType": vOverrides2['interestType']['id'],
        "interestCalculationPeriodType":
        vOverrides2['interestCalculationPeriodType']['id'],
        "allowPartialPeriodInterestCalcualtion":
        fullTemps['allowPartialPeriodInterestCalcualtion'],
        "inArrearsTolerance": vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        "graceOnArrearsAgeing": vOverrides2['graceOnArrearsAgeing'],
        "transactionProcessingStrategyId":
        vOverrides2['transactionProcessingStrategyId'],

        // "graceOnPrincipalPayment": 1,
        // "graceOnInterestPayment": 1,
        "NextRepaymentDate":
        !_isFederalOrState ? repaymentDate.text : alternateRepayment,
        // "graceOnInterestCharged": 1,
        "rates": [],
        "charges": chargesData.length == 0
            ? []
            :
        // [
        //           {
        //             "chargeId":
        //                 chargesData[0]['chargeId'] ?? chargesData[0]['id'],
        //             "amount": loanID == null
        //                 ? chargesData[0]['amount']
        //                 : chargesData[0]['amountOrPercentage'],
        //             "id": loanID == null ? null : chargesData[0]['id']
        //           }
        //         ],
        chargesData
            .map((e) => {
          "chargeId":
          e['chargeId'] == null ? e['id'] : e['chargeId'],
          "amount": loanID == null
              ? e['amount']
              : (e['amountOrPercentage'] == null
              ? e['amount']
              : e['amountOrPercentage']),
          "id": loanID == null ? null : e['id']
        })
            .toList(),

        "locale": "en",
        "dateFormat": "dd MMMM yyyy",
        "loanType": "individual",
        "expectedDisbursementDate": vasCoddd,
        "submittedOnDate": vasCoddd,
        // "buyOverLoanDetail": lendersLists.length == 0
        //     ? {}
        //     : {
        //         "locale": "en",
        //         "lenders": lendersLists,
        //         "buyOverInterestType": 3
        //       },
        //  "linkAccountId": loanOptionInt == 0 ? null : loanOptionInt,
        "methodType": loanID == null && passedLoanID == null ? "post" : "put",
      };

      Map<String, dynamic> buyOverData = {
        "id": passedLoanID == null ? loanID : passedLoanID,
        "commitment": committment.text.isEmpty ? 0 : committment.text,
        "netpay": netpay.text,
        "clientId": clientID,
        "productId": productID,
        "principal": principal.text,
        "loanPurpose": loanPurpose,
        "linkAccountId": ClientaccountLinkingOptions,
        "loanIdToClose": loanOptionInt,
        "loanTermFrequency": no_of_repayments.text,
        "loanTermFrequencyType": 2,
        "numberOfRepayments": no_of_repayments.text,
        "repaymentEvery": repaidEvery.text,
        "repaymentFrequencyType": 2,
        "submittedOnNote": submitOnLoan,
        "isTopup":  isBuyOvertopup || value ? true : false,
        "interestRatePerPeriod": load_fedgoData != null
            ? load_fedgoData['interestRate']
            : _isFederalOrState == false
            ? nominal_interest.text
            : fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]
        ['interestRate']
            .toString(),
        //   "amortizationType": vOverrides['amortizationType'] == true ? 1 : 0,
        //   "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        //   "interestType":  vOverrides['interestType'] == true ? 1 : 0,
        //   "interestCalculationPeriodType": vOverrides['interestCalculationPeriodType'] == true ? 1 : 0,
        //   "allowPartialPeriodInterestCalcualtion": fullTemps['allowPartialPeriodInterestCalcualtion'],
        //   "inArrearsTolerance":  vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        // "graceOnArrearsAgeing": vOverrides['graceOnArrearsAgeing'] == true ? 1 : 0,
        // "transactionProcessingStrategyId": vOverrides['transactionProcessingStrategyId'] == true ? 1 : 0,

        "amortizationType": vOverrides2['amortizationType']['id'],
        "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        "interestType": vOverrides2['interestType']['id'],
        "interestCalculationPeriodType":
        vOverrides2['interestCalculationPeriodType']['id'],
        "allowPartialPeriodInterestCalcualtion":
        fullTemps['allowPartialPeriodInterestCalcualtion'],
        "inArrearsTolerance": vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        "graceOnArrearsAgeing": vOverrides2['graceOnArrearsAgeing'],
        "transactionProcessingStrategyId":
        vOverrides2['transactionProcessingStrategyId'],

        // "graceOnPrincipalPayment": 1,
        // "graceOnInterestPayment": 1,
        "NextRepaymentDate":
        !_isFederalOrState ? repaymentDate.text : alternateRepayment,
        // "graceOnInterestCharged": 1,
        "rates": [],
        "charges": chargesData.length == 0
            ? []
            :
        // [
        //           {
        //             "chargeId":
        //                 chargesData[0]['chargeId'] ?? chargesData[0]['id'],
        //             "amount": loanID == null
        //                 ? chargesData[0]['amount']
        //                 : chargesData[0]['amountOrPercentage'],
        //             "id": loanID == null ? null : chargesData[0]['id']
        //           }
        //         ],
        chargesData
            .map((e) => {
          "chargeId":
          e['chargeId'] == null ? e['id'] : e['chargeId'],
          "amount": loanID == null
              ? e['amount']
              : (e['amountOrPercentage'] == null
              ? e['amount']
              : e['amountOrPercentage']),
          "id": loanID == null ? null : e['id']
        })
            .toList(),

        "locale": "en",
        "dateFormat": "dd MMMM yyyy",
        "loanType": "individual",
        "expectedDisbursementDate": vasCoddd,
        "submittedOnDate": vasCoddd,
        "buyOverLoanDetail": lendersLists.length == 0
            ? {}
            : {
          "locale": "en",
          "lenders": lendersLists,
          "buyOverInterestType": 3
        },
        //  "linkAccountId": loanOptionInt == 0 ? null : loanOptionInt,
        "methodType": loanID == null && passedLoanID == null ? "post" : "put",
      };


      Map<String, dynamic> personalData_2 = {
        "id": passedLoanID == null ? loanID : passedLoanID,
        "commitment": committment.text.isEmpty ? 0 : committment.text,
        "netpay": netpay.text,
        "clientId": clientID,
        "productId": productID,
        "principal": principal.text,
        "loanPurpose": loanPurpose,
        "linkAccountId": ClientaccountLinkingOptions,
        "loanIdToClose": loanOptionInt,
        "loanTermFrequency": no_of_repayments.text,
        "loanTermFrequencyType": 2,
        "numberOfRepayments": no_of_repayments.text,
        "repaymentEvery": repaidEvery.text,
        "repaymentFrequencyType": 2,
                 "isTopup":  isBuyOvertopup || value ? true : false,
        "interestRatePerPeriod": _isFederalOrState == false
            ? nominal_interest.text
            : fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
            .toString(),
        // "amortizationType": vOverrides['amortizationType'] == true ? 1 : 0,
        // "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        // "interestType":  vOverrides['interestType'] == true ? 1 : 0,
        // "interestCalculationPeriodType": vOverrides['interestCalculationPeriodType'] == true ? 1 : 0,
        // "allowPartialPeriodInterestCalcualtion": fullTemps['allowPartialPeriodInterestCalcualtion'],
        // "inArrearsTolerance":  vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        // "graceOnArrearsAgeing": vOverrides['graceOnArrearsAgeing'] == true ? 1 : 0,
        // "transactionProcessingStrategyId": vOverrides['transactionProcessingStrategyId'] == true ? 1 : 0,

        "amortizationType": vOverrides2['amortizationType']['id'],
        "isEqualAmortization": fullTemps['isEqualAmortization'] == true ? 1 : 0,
        "interestType": vOverrides2['interestType']['id'],
        "interestCalculationPeriodType":
        vOverrides2['interestCalculationPeriodType']['id'],
        "allowPartialPeriodInterestCalcualtion":
        fullTemps['allowPartialPeriodInterestCalcualtion'],
        "inArrearsTolerance": vOverrides['inArrearsTolerance'] == true ? 1 : 0,
        "graceOnArrearsAgeing": vOverrides2['graceOnArrearsAgeing'],
        "transactionProcessingStrategyId":
        vOverrides2['transactionProcessingStrategyId'],

        // "graceOnPrincipalPayment": 1,
        // "graceOnInterestPayment": 1,
        "NextRepaymentDate":
        !_isFederalOrState ? repaymentDate.text : alternateRepayment,
        // "graceOnInterestCharged": 1,
        "rates": [],
        "charges": chargesData.length == 0
            ? []
            : chargesData
            .map((e) => {
          "chargeId":
          e['chargeId'] == null ? e['id'] : e['chargeId'],
          "amount": loanID == null
              ? e['amount']
              : (e['amountOrPercentage'] == null
              ? e['amount']
              : e['amountOrPercentage']),
          "id": loanID == null ? null : e['id']
        })
            .toList(),
        // [
        //           {
        //             "chargeId":
        //                 chargesData[0]['chargeId'] ?? chargesData[0]['id'],
        //             "amount": loanID == null
        //                 ? chargesData[0]['amount']
        //                 : chargesData[0]['amountOrPercentage'],
        //             "id": loanID == null ? null : chargesData[0]['id']
        //           }
        //         ],
        "locale": "en",
        "dateFormat": "dd MMMM yyyy",
        "loanType": "individual",
        "expectedDisbursementDate": vasCoddd,
        "submittedOnDate": vasCoddd,
        //  "linkAccountId": loanOptionInt == 0 ? null : loanOptionInt,
        "methodType": loanID == null && passedLoanID == null ? "post" : "put",
        "paymentMethodId": 7,
        "paymentMethodReference": customerID
      };

      print(
          'response from personal ${personalData_2['charges']} ${_isFederalOrState}');

      final Future<Map<String, dynamic>> respose = addLoanProvider.addLoan(
          comingFrom == 'remitta_refs' ? personalData_2 : (isBuyOver == true || isBuyOvertopup == true) ? buyOverData : personalData, 'pass',
          comingFrom: comingFrom != null ? 'remitta_refs' : null,buyOverOpt: isBuyOver == true ? true : isBuyOvertopup );
      print('start response from login');

      respose.then((response) {
        print('response from provider 001 ${response}');

        AppTracker().trackActivity('ADD/UPDATE LOAN',
            payLoad: {...personalData, "response": response.toString()});

        if (response == null ||
            response['status'] == null ||
            response['status'] == false) {
          setState(() {
            _isLoading = false;
          });

          Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: 'Error',
            message: response['message'],
            duration: Duration(seconds: 6),
          ).show(context);

          if (response['suggested_amount'] != null) {
            return alert(
              context,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                      onTap: () {
                        MyRouter.popPage(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
              content: Row(
                children: [
                  Text(
                    '${response['message']} \nsuggested amount is N ${response['suggested_amount']} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ],
              ),
              textOK: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child:
                // IconButton(
                //   icon:
                //   Icon(Icons.copy),
                //   iconSize: 25,
                //   color: Colors.blue,
                // )

                RoundedButton(
                  buttonText: 'Copy Amount',
                  onbuttonPressed: () {
                    // sendNoteForLoan(methodType,noteId);
                    String cp_text = response['suggested_amount'].toString();
                    Clipboard.setData(ClipboardData(text: cp_text));
                    MyRouter.popPage(context);
                    Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                      backgroundColor: Colors.green,
                      title: 'Success',
                      message: 'Amount copied to clipboard',
                      duration: Duration(seconds: 5),
                    ).show(context);
                  },
                ),

                // RoundedButton(buttonText: 'Okay',onbuttonPressed: (){
                //   MyRouter.popPage(context);
                // },)
              ),
            );
          }
        } else {
          getPassedLoanDetails();
          // MyRouter.pushPage(context, DocumentForLoan(
          //   clientID: clientID,
          // ));

          setState(() {
            _isLoading = false;
          });
          Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Loan Originated',
            duration: Duration(seconds: 6),
          ).show(context);
        }
      });
    };




    return LoadingOverlay(
      isLoading: _isLoading || isRequestLoading,
      progressIndicator: Container(
        height: 80,
        width: 80,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.295,
              child: Column(
                children: [
                  ProgressStepper(
                    stepper: 0.4,
                    title: 'Loan Terms',
                    subtitle: 'Loan Offer',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Terms',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily:
                                              'Nunito SansRegular')),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          'Kindly fill in all required information in the loan \n application form.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily:
                                              'Nunito SansRegular')),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          'Repayment Amount NGN: ${formatCurrency.format(repaymentAmount)}'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),

                                // SizedBox(
                                //   height: 20,
                                // ),
                                ProductWidge(),
                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height *
                                //       0.04,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                //
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Text('Repaid Every',style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),)
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height *
                                //       0.07,
                                // ),

                                // SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ],
                      )),
                  // SizedBox(
                  //   height: 10,
                  // ),


                ],
              ),
            ),
          ),
          bottomNavigationBar: DoubleBottomNavComponent(
            text1: 'Previous',
            text2: 'Next',
            callAction1: () {
              MyRouter.popPage(context);
            },
            callAction2: () {
              //   submitLoanToCheckForDSR();
              if (netpay.text.length < 3 || netpay.text.isEmpty) {
                return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.redAccent,
                  title: 'Validation Error',
                  message: 'Netpay is required ',
                  duration: Duration(seconds: 3),
                ).show(context);
              }
              if (!_isFederalOrState && repaymentDate.text.isEmpty == true) {
                return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.redAccent,
                  title: 'Validation Error',
                  message: 'First repayment date is required ',
                  duration: Duration(seconds: 3),
                ).show(context);
              } else if (load_fedgoData == null &&
                  (productID == FEDG0_LOAN_ID || productID == DPL_LOAN)) {
                return Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.blue,
                  title: "Hold",
                  message: 'System is recalculating Interest rate',
                  duration: Duration(seconds: 3),
                ).show(context);
              } else {
                (_isFederalOrState == false && showPrivateInterest == true)
                    ? Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                  backgroundColor: Colors.blue,
                  title: "Hold",
                  message: 'Calculating loan interest',
                  duration: Duration(seconds: 3),
                ).show(context)
                    : submitLoanToCheckForDSR();
              }
            },
          )

        // BottomNavComponent(
        //   text: 'Next',
        //   callAction: (){
        //     submitLoanToCheckForDSR();
        //   },
        // ),

      ),
    );
  }

  Widget LoanStepper() {
    return Material(
      elevation: 10,
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        padding: EdgeInsets.only(left: 45, right: 45),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: Color(0xff3ECB98),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 18,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      color: Color(0xff177EB9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Terms',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 23,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Document',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ProductWidge() {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.76,
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: EntryField(
                    context, netpay, 'Net Pay *', '', TextInputType.number,
                    onChanged: (value) {})),
            SizedBox(
              height: 6,
            ),
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //     child: EntryField(context, committment, 'Committment (optional)','Enter committment',TextInputType.number)
            // ),
            // SizedBox(height: 6,),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: EntryField(
                    context,
                    principal,
                    'Principal ',
                    'Principal (min: ₦${min_principal}, max: ₦${max_principal})*',
                    TextInputType.number)),
            SizedBox(
              height: 6,
            ),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: EntryField(
                    context,
                    no_of_repayments,
                    'Loan Tenure ',
                    'Loan Tenure (min: ${min_repayment} months, max: ${max_repayment} months)*',
                    TextInputType.number)),

            SizedBox(
              height: 6,
            ),

            !_isFederalOrState
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.095,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,

                      // set border width
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0)), // set rounded corner radius
                    ),
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'Nunito SansRegular'),
                      autofocus: false,
                      readOnly: true,
                      controller: repaymentDate,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              //  _selectDate(context);
                              showDatePicker();
                            },
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.blue,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.6),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'First repayment Date *',
                          floatingLabelStyle:
                          TextStyle(color: Color(0xff205072)),
                          hintText: '',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito SansRegular'),
                          labelStyle: TextStyle(
                              fontFamily: 'Nunito SansRegular',
                              color: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .color)),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
              ),
            )
                : SizedBox(),

            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //     child: EntryField(context, loanTerm, 'Loan Term *','12',TextInputType.number)
            // ),
            // SizedBox(height: 6,),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //   child: DropDownComponent(items: frequencyArray,
            //       onChange: (String item) async{
            //         setState(() {
            //           List<dynamic> selectID =   allFrequency.where((element) => element['value'] == item).toList();
            //           print('this is select ID');
            //           print(selectID[0]['id']);
            //           frequencyInt = selectID[0]['id'];
            //           print('end this is select ID');
            //
            //         });
            //
            //       },
            //       label: "Frequency *",
            //       selectedItem: "---",
            //       validator: (String item){
            //
            //       }
            //   ),
            // ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //   child: DropDownComponent(items: repaymentArray,
            //       onChange: (String item) async{
            //         setState(() {
            //           List<dynamic> selectID =   allRepayment.where((element) => element['value'] == item).toList();
            //           print('this is select ID');
            //           print(selectID[0]['id']);
            //           repaymentFrequencyInt = selectID[0]['id'];
            //           print('end this is select ID');
            //
            //         });
            //
            //       },
            //       label: "Repayment Frequency *",
            //       selectedItem: "---",
            //       validator: (String item){
            //
            //       }
            //   ),
            // ),

            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //     child: EntryField(context, repaidEvery, 'Repaid Every *','1',TextInputType.number)
            // ),

            SizedBox(
              height: 6,
            ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //   child: DropDownComponent(items: frequencyArray,
            //       onChange: (String item) async{
            //         setState(() {
            //           List<dynamic> selectID =   allFrequency.where((element) => element['value'] == item).toList();
            //           print('this is select ID');
            //           print(selectID[0]['id']);
            //           frequencyInt = selectID[0]['id'];
            //           print('end this is select ID');
            //
            //
            //         });
            //
            //       },
            //       label: "Frequency *",
            //       selectedItem: "---",
            //       validator: (String item){
            //
            //       }
            //   ),
            // ),
            // SizedBox(height: 6,),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: EntryField(
                    context,
                    nominal_interest,
                    'Product Rate ',
                    'Product Rate (min: ${min_interest} & max: ${max_interest}) *',
                    TextInputType.number,
                    isRead: true)),
            SizedBox(
              height: 5,
            ),
            Visibility(
              visible: showPrivateInterest,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                //   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  // color: ColorUtils.PRIMARY_COLOR,
                  color: Color(0xff98c4eb),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outlined,
                          color: ColorUtils.PRIMARY_COLOR,
                          size: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Our system is re-calculating loan interest.\n This message will disappear when it\'s completed',
                          style: TextStyle(
                              color: ColorUtils.PRIMARY_COLOR,
                              fontSize: 13,
                              fontFamily: 'Nunito SansRegular'),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            (_canUseForTopUp == true &&
                !loanOptionArray.isEmpty &&
                canBookOtherLoans == true)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: this.value,
                  onChanged: (bool value) {
                    setState(() {
                      this.value = value;
                      this.isBuyOvertopup = false;
                      this.isBuyOver = false;
                    });
                  },
                ),
                Text(
                  'IS THIS A TOP UP LOAN?',
                  style: TextStyle(fontSize: 11),
                ),

              ],
            )
                : Text(''),

            SizedBox(
              height: 5,
            ),


            // lendersLists.length == 0 ? SizedBox() :
            // Container(
            //            padding: EdgeInsets.symmetric(horizontal: 20),
            //        //  height: AppHelper().pageHeight(context) * 0.03,
            //          child: Align(
            //                alignment: Alignment.topLeft,
            //                child: Row(
            //                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                  children: [
            //                    Text('Lenders Lists',style: TextStyle(fontFamily: 'Nunito SemiBold'),),
            //                    SizedBox(height: 10,),
            //                    InkWell(
            //                      onTap: (){
            //                        showBottomSheetForLenders(context);
            //                      },
            //                      child:
            //                      Stack(
            //                        children: [
            //                          Icon(
            //                            FeatherIcons.bookmark,
            //                            color: Colors.black, // Change the color as needed
            //                            size: 24.0, // Adjust the size as needed
            //                          ),
            //                          Positioned(
            //                            right: 0,
            //                            top: 0,
            //                            child: Container(
            //                              padding: EdgeInsets.all(2), // Padding around the number
            //                              decoration: BoxDecoration(
            //                                color: Colors.blue, // Background color
            //                                borderRadius: BorderRadius.circular(10), // Circular shape
            //                              ),
            //                              constraints: BoxConstraints(
            //                                minWidth: 16,
            //                                minHeight: 16,
            //                              ),
            //                              child: Text(
            //                                '${lendersLists.length == 0 ? '0' : lendersLists.length.toString()}', // The number to display
            //                                style: TextStyle(
            //                                  color: Colors.white,
            //                                  fontSize: 10, // Adjust the font size as needed
            //                                  fontWeight: FontWeight.bold,
            //                                ),
            //                                textAlign: TextAlign.center,
            //                              ),
            //                            ),
            //                          ),
            //                        ],
            //                      )
            //
            //                    )
            //                  ],
            //                ),
            //          ),
            //        ),

            isBuyOverAvailable == true
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: this.isBuyOver,
                  onChanged: (bool value) {
                    setState(() {
                      this.isBuyOver = value;
                      this.isBuyOvertopup = false;
                      this.value = false;
                    });
                    if(value == true){
                      print('scrolldown');
                      _scrollUp();
                    }
                  },
                ),
                Text(
                  'IS THIS A BUY-OVER LOAN?',
                  style: TextStyle(fontSize: 11),
                ),
                SizedBox(width: AppHelper().pageWidth(context) * 0.34,),
                isBuyOver == true ?  IconButton(
                  onPressed: (){
                    // _scrollDown();
                    // double currentPosition = _scrollController.position.pixels;
                    //
                    // // Scroll down by 50 pixels
                    // _scrollController.jumpTo(currentPosition + 20);



                  },
                  icon: Icon(FeatherIcons.arrowDown,color: ColorUtils.PRIMARY_COLOR,),
                ) : SizedBox()
              ],
            )
                : SizedBox(),
            SizedBox(height: 5,),
            (isBuyOverTopUpAvailable == true &&
                !loanOptionArray.isEmpty &&
                canBookOtherLoans == true)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: this.isBuyOvertopup,
                  onChanged: (bool value) {
                    print('vals topup >> ${value}');
                    setState(() {
                      this.isBuyOvertopup = value;

                      this.value = false;
                      this.isBuyOver = false;
                    });
                  },
                ),
                Text(
                  'IS THIS A BUY OVER TOP UP LOAN?',
                  style: TextStyle(fontSize: 11),
                )
              ],
            )
                : Text(''),

            SizedBox(
              height: 5,
            ),

            value == true || isBuyOvertopup
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  DropDownComponent(
                      items: loanOptionArray,
                      onChange: (String item) {
                        String newItem = item.substring(item.length - 10);
                        print('newitem ${newItem}');
                        setState(() {
                          List<dynamic> selectID = allLoanOption
                              .where((element) =>
                          element['accountNo'] == newItem)
                              .toList();
                          print('this is select ID ${selectID}');
                          print('select ID ${selectID[0]['id']}');
                          loanOptionInt = selectID[0]['id'];
                          // print('end this is select ID');
                        });
                      },
                      label: "Select a Loan to close",
                      selectedItem: "---",
                      validator: (String item) {}),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
                : Text(''),

            SizedBox(height: 5,),
            if(lendersLists.length > 0)
              AddedLender(),

            if(lenderIndex != 0 && showAddLender == true)
            // showUpdateLender = true;
            // showAddLender = false;
            // showUpdateLender == true ? showUpdateLenderAccordion() :
              showAddLenderAccordion(),

            // if(lenderIndex != 0 && (showUpdateLender == true && showAddLender == false) )
            // // showUpdateLender = true;
            // // showAddLender = false;
            // // showUpdateLender == true ? showUpdateLenderAccordion() :
            //   showUpdateLenderAccordion(context),


            SizedBox(
              height: 10,
            ),
            isBuyOver == true || isBuyOvertopup == true
                ?
            // buyOverWidget()
            MultipleLendersWidget()
                : SizedBox(),

            //
            //   isBuyOver == true
            //       ?
            // //  buyOverWidget()
            //  MultipleLendersWidget()
            //       : SizedBox(),
          ],
        ),
      ),
    );
  }

  // Widget RepaidWidget(){
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.95,
  //     padding: EdgeInsets.only(top: 15),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //             child: EntryField(context, principal, 'Repaid Every *','1',TextInputType.number)
  //         ),
  //         SizedBox(height: 6,),
  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //         //   child: DropDownComponent(items: frequencyArray,
  //         //       onChange: (String item) async{
  //         //         setState(() {
  //         //           List<dynamic> selectID =   allFrequency.where((element) => element['value'] == item).toList();
  //         //           print('this is select ID');
  //         //           print(selectID[0]['id']);
  //         //           frequencyInt = selectID[0]['id'];
  //         //           print('end this is select ID');
  //         //
  //         //
  //         //         });
  //         //
  //         //       },
  //         //       label: "Frequency *",
  //         //       selectedItem: "---",
  //         //       validator: (String item){
  //         //
  //         //       }
  //         //   ),
  //         // ),
  //         // SizedBox(height: 6,),
  //
  //         Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //             child: EntryField(context, principal, 'Nominal Interest Rate *','122121',TextInputType.number)
  //         ),
  //
  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //         //   child: Container(
  //         //     height: MediaQuery.of(context).size.height * 0.095,
  //         //     child: Padding(
  //         //       padding: const EdgeInsets.symmetric(horizontal: 0),
  //         //       child: Container(
  //         //         decoration: BoxDecoration(
  //         //           color: Theme.of(context).backgroundColor,
  //         //
  //         //           // set border width
  //         //           borderRadius: BorderRadius.all(
  //         //               Radius.circular(5.0)), // set rounded corner radius
  //         //         ),
  //         //         child:
  //         //         TextFormField(
  //         //
  //         //           style: TextStyle(fontFamily: 'Nunito SansRegular'),
  //         //
  //         //           autofocus: false,
  //         //           readOnly: true,
  //         //           controller: dateController,
  //         //
  //         //           decoration: InputDecoration(
  //         //               suffixIcon: IconButton(
  //         //                 onPressed: (){
  //         //                   _selectDate(context);
  //         //                 },
  //         //                 icon:   Icon(Icons.date_range,color: Colors.blue
  //         //                   ,) ,
  //         //               ),
  //         //               fillColor: Colors.white,
  //         //               filled: true,
  //         //               focusedBorder:OutlineInputBorder(
  //         //                 borderSide: const BorderSide(color: Colors.grey, width: 0.6),
  //         //
  //         //               ),
  //         //               border: OutlineInputBorder(
  //         //
  //         //               ),
  //         //               labelText: 'Interest charged from *',
  //         //               floatingLabelStyle: TextStyle(color:Color(0xff205072)),
  //         //               hintText: '10 May 2022',
  //         //               hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
  //         //               labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)
  //         //
  //         //           ),
  //         //           textInputAction: TextInputAction.done,
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //         // SizedBox(height: 6,),
  //         //
  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //         //   child: DropDownComponent(items: amortizationArray,
  //         //       onChange: (String item) async{
  //         //         setState(() {
  //         //           List<dynamic> selectID =   allAmortization.where((element) => element['value'] == item).toList();
  //         //           print('this is select ID');
  //         //           print(selectID[0]['id']);
  //         //           frequencyInt = selectID[0]['id'];
  //         //           print('end this is select ID');
  //         //
  //         //
  //         //         });
  //         //
  //         //       },
  //         //       label: "Amortization Type *",
  //         //       selectedItem: "---",
  //         //       validator: (String item){
  //         //
  //         //       }
  //         //   ),
  //         // ),
  //         // SizedBox(height: 6,),
  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //         //   child: DropDownComponent(items: interstTypeArray,
  //         //       onChange: (String item) async{
  //         //         setState(() {
  //         //           List<dynamic> selectID =   allInterstType.where((element) => element['value'] == item).toList();
  //         //           print('this is select ID');
  //         //           print(selectID[0]['id']);
  //         //           frequencyInt = selectID[0]['id'];
  //         //           print('end this is select ID');
  //         //
  //         //
  //         //         });
  //         //
  //         //       },
  //         //       label: "Interest Method *",
  //         //       selectedItem: "---",
  //         //       validator: (String item){
  //         //
  //         //       }
  //         //   ),
  //         // ),
  //         // SizedBox(height: 6,),
  //
  //
  //       ],
  //     ),
  //   );
  // }

  // _selectDate(BuildContext context) async {
  //   final DateTime selected = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(1930),
  //     lastDate: DateTime(2025),
  //   );
  //   if (selected != null && selected != selectedDate)
  //     setState(() {
  //       selectedDate = selected;
  //       print(selected);
  //       //  date = selected.toString();
  //       String vasCoddd = retsNx360dates(selected);
  //       repaymentDate.text = vasCoddd;
  //
  //     });
  // }
  //

  // showBottomSheetForLenders(){
  //   return
  //     showModalBottomSheet(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
  //         ),
  //         context: context,
  //         builder: (context) {
  //           return
  //
  //
  //             Container(
  //             padding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
  //             height: AppHelper().pageHeight(context) * 0.9,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   child: Align(
  //                       alignment: Alignment.topLeft,
  //                       child: Text("Lender's Lists",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 21),)
  //                   ),
  //                 ),
  //
  //                 Column(
  //                   children: [
  //                     ListTile(
  //
  //                       title: Container(
  //                         height: MediaQuery.of(context).size.height * 0.465,
  //                         child: ListView.builder(
  //                          //   reverse: true,
  //                            itemCount: lendersLists.length == 0 ? 0 : lendersLists.length ?? 0,
  //                           //    itemCount: 6,
  //                             scrollDirection: Axis.vertical,
  //                             physics: AlwaysScrollableScrollPhysics(),
  //                             itemBuilder: (index,position){
  //                               var single_Lender = lendersLists[position];
  //                               return
  //                                 ExpansionTile(
  //                                   title: Text(
  //                                     "${single_Lender['lenderAccountName']}",
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 16.0,
  //                                     ),
  //                                   ),
  //                                   children: [
  //                                     ListTile(
  //                                       title: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Account name",
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             "${single_Lender['lenderAccountName']}", // Replace with actual lender's name
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.w300, // Light text
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     ListTile(
  //                                       title: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Account Number",
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             "${single_Lender['lenderAccountNumber']}", // Replace with actual bank name
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.w300, // Light text
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     ListTile(
  //                                       title: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Settlement Balance",
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             "${single_Lender['settlementBalance']}", // Replace with actual account number
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.w300, // Light text
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     ListTile(
  //                                       title: Row(
  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Lender's ID",
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             "${single_Lender['lenderId']}", // Replace with actual lender's ID
  //                                             style: TextStyle(
  //                                               fontWeight: FontWeight.w300, // Light text
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Align(
  //                                       alignment: Alignment.topRight,
  //                                       child:      InkWell(
  //                                         onTap: (){
  //                                           lendersLists.removeAt(position);
  //                                           setState(() {
  //                                           });
  //                                         },
  //                                         child: Container(
  //                                             margin: EdgeInsets.only(right: 10),
  //                                             width: 75,
  //                                             height: 35,
  //                                             decoration: BoxDecoration(
  //                                               color: ColorUtils.REJECTED_COLOR,
  //                                               borderRadius: BorderRadius.all(Radius.circular(8)),
  //                                             ),
  //                                           child: Center(child: Text('Remove',style: TextStyle(color: ColorUtils.REJECTED_TEXT),))
  //                                         ),
  //                                       ),
  //                                     )
  //                                   ],
  //                                 );
  //                             }),
  //                       ),
  //                       // trailing:
  //                       // clientStatus(colorChoser('current_cycle'), 'Current Cycle',containerSIze: 80,fontSize: 10,containerHeight: 30,fontColor: Color(
  //                       //     0xff7f7777)
  //                       // )
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  // }

  // void showBottomSheetForLenders(BuildContext context) {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(30),
  //         topRight: Radius.circular(30),
  //       ),
  //     ),
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             height: MediaQuery.of(context).size.height * 0.9,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   child: Align(
  //                     alignment: Alignment.topLeft,
  //                     child: Text(
  //                       "Lender's Lists",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 21,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: lendersLists.length,
  //                     itemBuilder: (context, index) {
  //                       var singleLender = lendersLists[index];
  //                       return ExpansionTile(
  //                         title: Text(
  //                           "${singleLender['lenderAccountName']}",
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16.0,
  //                           ),
  //                         ),
  //                         children: [
  //                           buildLenderInfoRow("Account name",
  //                               singleLender['lenderAccountName']),
  //                           buildLenderInfoRow("Account Number",
  //                               singleLender['lenderAccountNumber']),
  //                           buildLenderInfoRow("Settlement Balance",
  //                               singleLender['settlementBalance']),
  //                           buildLenderInfoRow("Lender's ID",
  //                               singleLender['lenderId'].toString()),
  //                           Align(
  //                             alignment: Alignment.topRight,
  //                             child: InkWell(
  //                               onTap: () {
  //
  //
  //                               print('previous removed >> ${lenderIndex}');
  //
  //                                 setState(() {
  //                                   lenderIndex --;
  //                                 });
  //                                 print('lender removed >> ${lenderIndex}');
  //                                 //  setState(() {
  //                                 //    lendersLists.removeAt(index);
  //                                 // //   lenderIndex --;
  //                                 //  });
  //
  //                               },
  //                               child: Container(
  //                                 margin: EdgeInsets.only(right: 10),
  //                                 width: 75,
  //                                 height: 35,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.red, // Adjust as needed
  //                                   borderRadius:
  //                                   BorderRadius.all(Radius.circular(8)),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Remove',
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget buildLenderInfoRow(String title, String value) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w300, // Light text
            ),
          ),
        ],
      ),
    );
  }

  Widget buyOverWidget() {
    return Container(
        height: AppHelper().pageHeight(context) * 0.32,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: DropDownComponent(
                    items: lendersNameArray,
                    onChange: (String item) {
                      setState(() {
                        // addLendersName = item;
                        List<dynamic> selectID = allLendersName
                            .where((element) => element['displayName'] == item)
                            .toList();
                        print('this is select ID');
                        print(selectID[0]['id']);
                        singleLendersid = selectID[0]['id'];
                        singleLendersName = selectID[0]['displayName'];
                        print('end this is select ID');
                      });
                    },
                    label: "Lender's Name",
                    selectedItem: singleLendersName,
                    validator: (String item) {}),
              ),
              SizedBox(
                height: 15,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: DropDownComponent(
                    items: banksListArray,
                    onChange: (String item) {
                      setState(() {
                        List<dynamic> selectID = allBanksList
                            .where((element) => element['name'] == item)
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: BankAccountNumberEntryField(
                      context,
                      accountNumber,
                      'Account Number *',
                      'Account Number',
                      TextInputType.number,
                      maxLenghtAllow: 10)),
              //  SizedBox(height: 10,),
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
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: EntryField(context, buy_over_settlement_balance,
                      'Settlement Balance', '', TextInputType.number)),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: AppHelper().pageWidth(context) * 0.41,
                  child: RoundedButton(
                    onbuttonPressed: () {
                      //  doLogin();
                      addLenders(context, maxLenderCount);
                    },
                    buttonText: 'Save',
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }

  // addLenders(){
  //
  //   Map<String,dynamic> localLenders = {
  //     "lenderAccountNumber" : accountNumber.text,
  //     "lenderAccountName" : accountName,
  //     "lenderBankId" : bankCode ,
  //     "lenderId" : singleLendersid,
  //     "settlementBalance" : buy_over_settlement_balance.text
  //   };
  //
  //
  //   lendersLists.add(localLenders);
  //
  //   setState(() {
  //     accountNumber.text = '';
  //     accountName = '';
  //     bankCode = '';
  //     singleLendersid = null;
  //     buy_over_settlement_balance.text = '';
  //   });
  //
  //   print('app lenders lists >> ${lendersLists}');
  //
  // }

  Widget MultipleLendersWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Multiple Lenders',
              style: TextStyle(
                  fontFamily: 'Nunito SemiBold', fontWeight: FontWeight.w300),
            ),
            InkWell(
                onTap: () {
                  // setState(() {
                  //   lenderIndex --;
                  // });
                  print('>> lender Index >> ${lenderIndex - 1} ${maxLenderCount}');

                  if (lenderIndex -1  >= maxLenderCount) {
                    print('max count reached');
                    Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
                      backgroundColor: Colors.red,
                      title: 'Error',
                      message: "max Lender count reached",
                      duration: Duration(seconds: 3),
                    ).show(context);
                  } else {
                    //  print('max count22 ${maxLenderCount} ${lenderIndex}');
                    setState(() {
                      if(lenderIndex == 0){
                        lenderIndex = 1;
                      }
                      showAddLender = true;
                    });

                  }
                },
                child: Text(
                  '+  Add Lender',
                  style: TextStyle(color: lenderIndex -1  >= maxLenderCount ? ColorUtils.GREY_BG : ColorUtils.PRIMARY_COLOR),
                )),
          ],
        ));
  }

  // AddedLender(){
  //   return
  //     Container(
  //       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 3),
  //       margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //
  //       color: Colors.white,
  //       //   height: AppHelper().pageHeight(context) * 0.42,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Column(
  //             children: [
  //               ListTile(
  //                 title: SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.225,
  //                  // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
  //                   child: ListView.builder(
  //                     //   reverse: true,
  //                       itemCount: lendersLists.length == 0 ? 0 : lendersLists.length ?? 0,
  //                       //    itemCount: 6,
  //                       scrollDirection: Axis.vertical,
  //                       physics: AlwaysScrollableScrollPhysics(),
  //                       itemBuilder: (index,position){
  //                         var single_Lender = lendersLists[position];
  //                         return
  //                           ExpansionTile(
  //                             title: Text(
  //                               "${single_Lender['lenderName']}",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16.0,
  //                               ),
  //                             ),
  //                             children: [
  //                               ListTile(
  //                                 title: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       "Account name",
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "${single_Lender['lenderAccountName']}", // Replace with actual lender's name
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w300, // Light text
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               ListTile(
  //                                 title: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       "Account Number",
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "${single_Lender['lenderAccountNumber']}", // Replace with actual bank name
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w300, // Light text
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               ListTile(
  //                                 title: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       "Settlement Balance",
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "${single_Lender['settlementBalance']}", // Replace with actual account number
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w300, // Light text
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               ListTile(
  //                                 title: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       "Lender's ID",
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     Text(
  //                                       "${single_Lender['lenderId']}", // Replace with actual lender's ID
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w300, // Light text
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: (){
  //                                       // lendersLists.removeAt(position);
  //                                       // setState(() {
  //                                       // });
  //
  //                                       print(single_Lender);
  //                                       setState(() {
  //                                         showUpdateLender = true;
  //                                         showAddLender = false;
  //
  //                                         // updateNeeded = {
  //                                         //   "singleLender": single_Lender,
  //                                         //   "appPosition": position
  //                                         // };
  //
  //                                       });
  //
  //                                       showUpdateLenderAccordion(
  //                                           singlelender: single_Lender,
  //                                           appPosition: position
  //                                       );
  //
  //
  //
  //                                     },
  //                                     child: Container(
  //                                         margin: EdgeInsets.only(right: 10),
  //                                         width: 75,
  //                                         height: 35,
  //                                         decoration: BoxDecoration(
  //                                           color: ColorUtils.PRIMARY_COLOR,
  //                                           borderRadius: BorderRadius.all(Radius.circular(8)),
  //                                         ),
  //                                         child: Center(child: Text('Update',style: TextStyle(color: Colors.white),))
  //                                     ),
  //                                   ),
  //                                   SizedBox(width: 5,),
  //                                   InkWell(
  //                                     onTap: (){
  //                                       lendersLists.removeAt(position);
  //                                       setState(() {
  //                                       });
  //                                     },
  //                                     child: Container(
  //                                         margin: EdgeInsets.only(right: 10),
  //                                         width: 75,
  //                                         height: 35,
  //                                         decoration: BoxDecoration(
  //                                           color: ColorUtils.REJECTED_COLOR,
  //                                           borderRadius: BorderRadius.all(Radius.circular(8)),
  //                                         ),
  //                                         child: Center(child: Text('Remove',style: TextStyle(color: ColorUtils.REJECTED_TEXT),))
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             ],
  //                           );
  //                       }),
  //                 ),
  //                 // trailing:
  //                 // clientStatus(colorChoser('current_cycle'), 'Current Cycle',containerSIze: 80,fontSize: 10,containerHeight: 30,fontColor: Color(
  //                 //     0xff7f7777)
  //                 // )
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //     );
  //
  // }

  Widget AddedLender() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              ListTile(
                title: ListView.builder(
                  shrinkWrap: true, // Allows ListView to take only the space it needs
                  physics: NeverScrollableScrollPhysics(), // Disable scroll for ListView to avoid conflict
                  itemCount: lendersLists.length == 0 ? 0 : lendersLists.length,
                  itemBuilder: (context, position) {
                    var single_Lender = lendersLists[position];
                    return ExpansionTile(
                      title: Text(
                        "${single_Lender['lenderName']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Account name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${single_Lender['lenderAccountName']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Account Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${single_Lender['lenderAccountNumber']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Settlement Balance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${single_Lender['settlementBalance']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lender's ID",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${single_Lender['lenderId']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                print(single_Lender);
                                setState(() {
                                  showUpdateLender = true;
                                  showAddLender = false;
                                });
                                setState((){
                                  updateRequired = [position,single_Lender];
                                });

                                showUpdateLenderAccordion(context);
                                // showUpdateLenderAccordion(
                                //   singlelender: single_Lender,
                                //   appPosition: position,
                                // );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 75,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: ColorUtils.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {

                                lendersLists.removeAt(position);
                                setState(() {
                                  lenderIndex --;
                                });
                                print('updated state >> ${lenderIndex}');
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 75,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: ColorUtils.REJECTED_COLOR,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: ColorUtils.REJECTED_TEXT),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // showUpdateLenderAccordion() {
  //   int findPosition = updateRequired[0];
  //   Map<String,dynamic> findData = updateRequired[1];
  //
  //   print('find data ${findData} ${findPosition}');
  // //  String newLenderName = findData.where((e)=> e[id])
  //
  //       buy_over_settlement_balance_2.text = findData['settlementBalance'];
  //   accountNumber.text = findData['lenderAccountNumber'];
  //
  //   setState(() {
  //     accountName = findData['lenderAccountName'];
  //     bankCode = findData['lenderBankId'];
  //     singleLendersName = findData['lenderName'];
  //    singleLendersid = findData['lenderId'];
  //   });
  //
  //   return Container(
  //     //  height: AppHelper().pageHeight(context) * 0.35,
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     margin: EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(color: Colors.white),
  //     child: ExpansionTile(
  //       title: Text('Update Lender'),
  //       children: [
  //         SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                 child: DropDownComponent(
  //                     items: lendersNameArray,
  //                     onChange: (String item) {
  //                       setState(() {
  //                         // addLendersName = item;
  //                         List<dynamic> selectID = allLendersName
  //                             .where(
  //                                 (element) => element['displayName'] == item)
  //                             .toList();
  //                         print('this is select ID');
  //                         print(selectID[0]['id']);
  //                         singleLendersid = selectID[0]['id'];
  //                         singleLendersName = selectID[0]['displayName'];
  //                         print('end this is select ID');
  //                       });
  //                     },
  //                     label: "Lender's Name",
  //                     selectedItem: singleLendersName,
  //                     validator: (String item) {}),
  //               ),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                 child: DropDownComponent(
  //                     items: banksListArray,
  //                     onChange: (String item) {
  //                       setState(() {
  //                         List<dynamic> selectID = allBanksList
  //                             .where((element) => element['name'] == item)
  //                             .toList();
  //                         bankCode = selectID[0]['bankSortCode'];
  //                         bankInt = selectID[0]['id'];
  //                         accountName = '';
  //                         bankName = selectID[0]['name'];
  //                         //print('bankInt code ${bankCode}');
  //                       });
  //                     },
  //                     label: "Bank * ",
  //                     selectedItem: bankName,
  //                     validator: (String item) {}),
  //               ),
  //
  //               Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                   child: BankAccountNumberEntryField(
  //                       context,
  //                       accountNumber,
  //                       'Account Number *',
  //                       'Account Number',
  //                       TextInputType.number,
  //                       maxLenghtAllow: 10)),
  //               //  SizedBox(height: 10,),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Text('Account Name: '),
  //                     Text(
  //                       '${accountName}',
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                           fontFamily: 'Nunito SansRegular'),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //                   child: EntryField(context, buy_over_settlement_balance_2,
  //                       'Settlement Balance', '', TextInputType.number)),
  //
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //                   width: AppHelper().pageWidth(context) * 0.38,
  //                   child: RoundedButton(
  //                     onbuttonPressed: () {
  //                       //  doLogin();
  //                       updateLender(context,findPosition);
  //                     },
  //                     buttonText: 'Update',
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 2,
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }



  void showUpdateLenderAccordion(BuildContext context) {
    int findPosition = updateRequired[0];
    Map<String, dynamic> findData = Map<String, dynamic>.from(updateRequired[1]);

    // Initialize text controllers
    buy_over_settlement_balance.text = findData['settlementBalance'].toString();
    accountNumber.text = findData['lenderAccountNumber'];
    accountName = findData['lenderAccountName'];
    bankName = findData['lenderBankName'];
    bankInt = findData['lenderBankId'];
    singleLendersName = findData['lenderName'];
    singleLendersid = findData['lenderId'];

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // Initialize Timer to periodically check for state changes
            Timer timer;
            String previousAccountName = accountName;

            void startPeriodicCheck() {
              timer = Timer.periodic(Duration(seconds: 2), (timer) {
                // Check if accountName has changed
                if (accountName != previousAccountName) {
                  modalSetState(() {
                    // Update the previous accountName
                    previousAccountName = accountName;
                    print('previous account name >> ${previousAccountName} ${accountName}');
                  });
                }
              });
            }

            void stopPeriodicCheck() {
              timer?.cancel();
            }

            // Start the periodic check when the modal is created
            startPeriodicCheck();

            // Dispose the timer when the modal is closed
            return WillPopScope(
              onWillPop: () async {
                stopPeriodicCheck();
                return true;
              },
              child: FractionallySizedBox(
                heightFactor: 0.81,
                child:
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              stopPeriodicCheck(); // Stop timer when closed
                            },
                            child: Icon(FeatherIcons.xCircle),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: DropDownComponent(
                            items: lendersNameArray,
                            onChange: (String item) {
                              modalSetState(() {
                                List<dynamic> selectID = allLendersName
                                    .where((element) => element['displayName'] == item)
                                    .toList();
                                singleLendersid = selectID[0]['id'];
                                singleLendersName = selectID[0]['displayName'];
                              });
                            },
                            label: "Lender's Name",
                            selectedItem: singleLendersName,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: DropDownComponent(
                            items: banksListArray,
                            onChange: (String item) {
                              modalSetState(() {
                                List<dynamic> selectID = allBanksList
                                    .where((element) => element['name'] == item)
                                    .toList();
                                bankCode = selectID[0]['bankSortCode'];
                                bankInt = selectID[0]['id'];
                                accountName = '';
                                bankName = selectID[0]['name'];
                              });
                            },
                            label: "Bank * ",
                            selectedItem: bankName,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: BankAccountNumberEntryField(
                            context,
                            accountNumber,
                            'Account Number *',
                            'Account Number',
                            TextInputType.number,
                            maxLenghtAllow: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Account Name: '),
                              Text(
                                accountName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: EntryField(
                            context,
                            buy_over_settlement_balance,
                            'Settlement Balance',
                            '',
                            TextInputType.number,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: RoundedButton(
                              onbuttonPressed: () {
                                // fetchBankInfo(accountNumber.text, bankCode).then((_) {
                                //
                                // });
                                modalSetState(() {});
                                updateLender(context, findPosition);
                              },
                              buttonText: 'Update',
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  showAddLenderAccordion() {
    return Container(
      //  height: AppHelper().pageHeight(context) * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: Colors.white),
      child: ExpansionTile(
        title: Text('Add Lender'),
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropDownComponent(
                      items: lendersNameArray,
                      onChange: (String item) {
                        setState(() {
                          // addLendersName = item;
                          List<dynamic> selectID = allLendersName
                              .where(
                                  (element) => element['displayName'] == item)
                              .toList();
                          print('this is select ID');
                          print(selectID[0]['id']);
                          singleLendersid = selectID[0]['id'];
                          singleLendersName = selectID[0]['displayName'];
                          print('end this is select ID');
                        });
                      },
                      label: "Lender's Name",
                      selectedItem: singleLendersName,
                      validator: (String item) {}),
                ),
                SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropDownComponent(
                      items: banksListArray,
                      onChange: (String item) {
                        setState(() {
                          List<dynamic> selectID = allBanksList
                              .where((element) => element['name'] == item)
                              .toList();
                          bankCode = selectID[0]['bankSortCode'];
                          bankInt = selectID[0]['id'];
                          accountName = '';
                          bankName = selectID[0]['name'];
                          //print('bankInt code ${bankCode}');
                        });
                      },
                      label: "Bank * ",
                      selectedItem: bankName,
                      validator: (String item) {}),
                ),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: BankAccountNumberEntryField(
                        context,
                        accountNumber,
                        'Account Number *',
                        'Account Number',
                        TextInputType.number,
                        maxLenghtAllow: 10)),
                //  SizedBox(height: 10,),
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
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: EntryField(context, buy_over_settlement_balance,
                        'Settlement Balance', '', TextInputType.number)),

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: AppHelper().pageWidth(context) * 0.38,
                    child: RoundedButton(
                      onbuttonPressed: () {
                        //  showUpdateLenderAccordion(context);
                        //  doLogin();
                        addLenders(context, maxLenderCount);
                      },
                      buttonText: 'Save',
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addLenders(BuildContext context, int maxLenderCount) {
    String errorMessage;

    // // if(lenderIndex == 1){
    //   setState(() {
    //     lenderIndex++;
    //   });
    // // }
    // // else {
    // //   setState(() {
    // //     lenderIndex ++;
    // //   });
    // // }

    print('lender count >> ${lenderIndex}');
    // Check for empty or null fields
    if (accountNumber.text.isEmpty) {
      errorMessage = 'Account number is required.';
    }
    else if (accountName.isEmpty) {
      errorMessage = 'Account name is required.';
    }
    else if (bankInt == null) {
      errorMessage = 'Bank code is required.';
    } else if (singleLendersid == null) {
      errorMessage = 'Lender ID is required.';
    } else if (buy_over_settlement_balance.text.isEmpty) {
      errorMessage = 'Settlement balance is required.';
    } else if (lendersLists.length >= maxLenderCount) {
      errorMessage = 'You cannot add more than $maxLenderCount lender (s).';
    }

    // Show validation error if any
    if (errorMessage != null) {
      Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Validation error',
        message: errorMessage,
        duration: Duration(seconds: 3),
      ).show(context);
      return;
    }

    // Add lender if all fields are valid and maxLenderCount is not exceeded
    Map<String, dynamic> localLenders = {
      "lenderAccountNumber": accountNumber.text,
      "lenderAccountName": accountName,
     //   "lenderAccountName": 'efre erre',
      "lenderBankId": bankInt,
      "lenderBankName": bankName,
      "lenderId": singleLendersid,
      "settlementBalance": buy_over_settlement_balance.text,
      "lenderName": singleLendersName
    };

    lendersLists.add(localLenders);

    Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
      title: 'Success',
      message: 'New lender added',
      duration: Duration(seconds: 3),
    ).show(context);


    setState(() {
      lenderIndex++;
      showAddLender = false;
      accountNumber.text = '';
      accountName = '';
      bankCode = '';
      bankName = '';
      bankInt = null;
      singleLendersName = '';
      singleLendersid = null;
      buy_over_settlement_balance.text = '';

    });

    print('app lenders lists >> $lendersLists');

  }


  void updateLender(BuildContext context,int dataPosition) {
    String errorMessage;

    // // if(lenderIndex == 1){
    //   setState(() {
    //     lenderIndex++;
    //   });
    // // }
    // // else {
    // //   setState(() {
    // //     lenderIndex ++;
    // //   });
    // // }
    Navigator.pop(context);
    print('lender count >> ${lenderIndex}');
    // Check for empty or null fields
    if (accountNumber.text.isEmpty) {
      errorMessage = 'Account number is required.';
    }
    else if (accountName.isEmpty) {
      errorMessage = 'Account name is required.';
    }
    else if (bankInt == null) {
      errorMessage = 'Bank code is required.';
    } else if (singleLendersid == null) {
      errorMessage = 'Lender ID is required.';
    } else if (buy_over_settlement_balance.text.isEmpty) {
      errorMessage = 'Settlement balance is required.';
    }
    // else if (lendersLists.length >= maxLenderCount) {
    //   errorMessage = 'You cannot add more than $maxLenderCount lenders.';
    // }

    // Show validation error if any
    if (errorMessage != null) {
      Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: 'Validation error',
        message: errorMessage,
        duration: Duration(seconds: 3),
      ).show(context);
      return;
    }

    // Add lender if all fields are valid and maxLenderCount is not exceeded
    Map<String, dynamic> localLenders = {
      "lenderAccountNumber": accountNumber.text,
      "lenderAccountName": accountName,
      //  "lenderAccountName": '',
      "lenderBankId": bankInt,
      "lenderBankName": bankName,
      "lenderId": singleLendersid,
      "settlementBalance": buy_over_settlement_balance.text,
      "lenderName": singleLendersName
    };

    setState(() {
      lendersLists[dataPosition] = {...lendersLists[dataPosition], ...localLenders};

    });
//   lendersLists.add(localLenders);

    Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
      title: 'Success',
      message: 'Lender Updated Successfully',
      duration: Duration(seconds: 3),
    ).show(context);


    setState(() {
      // lenderIndex++;
      showUpdateLender = false;
      accountNumber.text = '';
      accountName = '';
      bankCode = '';
      bankName = '';
      bankInt = null;
      singleLendersName = '';
      singleLendersid = null;
      buy_over_settlement_balance.text = '';

    });
    // MyRouter.popPage(context);
    // Navigator.pop(context);
    print('app lenders updates lists >> $lendersLists');

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
                          print(CupertinoSelectedDate);
                          String retDate =
                          retsNx360dates(CupertinoSelectedDate);
                          print('ret Date ${retDate}');
                          repaymentDate.text = retDate;
                        });
                    },
                    initialDateTime:
                    DateTime.now().add(Duration(days: 15, hours: 0)),
                    // minimumYear: 2022,
                    // maximumYear: 2022,
                    maximumDate:
                    DateTime.now().add(Duration(days: 45, hours: 0)),
                    minimumDate:
                    DateTime.now().add(Duration(days: 14, hours: 0)),
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  //  onPressed: () => Navigator.of(context).pop(),
                  onPressed: () {
                    String retDate = retsNx360dates(CupertinoSelectedDate);
                    print('ret Date ${retDate}');
                    repaymentDate.text = retDate;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  retsNx360dates(DateTime selected) {
    String newdate = selectedDate.toString().substring(0, 10);
    print(
        'newdate ${newdate} selected ${selected} added ${DateTime.now().add(Duration(days: 0))}');

    String formattedDate = DateFormat.yMMMMd().format(selected);

    String removeComma = formattedDate.replaceAll(",", "");

    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String concatss = o2 + " " + o1 + " " + o3;
    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }

  Widget EntryField(BuildContext context, var editController, String labelText,
      String hintText, var keyBoard,
      {bool isPassword = false,
        Function onChanged,
        bool isRead = false,
        var maxLenghtAllow}) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      height: MediaSize.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLength: maxLenghtAllow,
                style: TextStyle(fontFamily: 'Nunito SansRegular'),
                keyboardType: keyBoard,
                onChanged: (value) {
                  if ((netpay.text.length > 4 && netpay.text.length < 6) &&
                      loanID == null &&
                      (productID == FEDG0_LOAN_ID || productID == DPL_LOAN)) {
                    getRiskDetailsWithBvn();
                  }
                  if (netpay.text.length != 0 &&
                      principal.text.length != 0 &&
                      no_of_repayments.text.length != 0) {
                    calculateReschedule();

                    print('fed or state ${_isFederalOrState}');
                    //   _isFederalOrState == false ? changeInterestRateForPrivate() : null;
                  }
                },
                controller: editController,
                readOnly: isRead,

                // validator: (value)=>value.isEmpty?'Please enter password':null,
                // onSaved: (value) => vals = value,

                decoration: InputDecoration(
                    suffixIcon: isPassword == true
                        ? Icon(
                      Icons.remove_red_eye,
                      color: Colors.black38,
                    )
                        : null,
                    fillColor: Colors.white,
                    filled: true,
                    counter: SizedBox.shrink(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.grey, width: 0.6),
                    ),
                    border: OutlineInputBorder(),
                    labelText: labelText,
                    //  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: Colors.black, fontFamily: 'Nunito SansRegular'),
                    labelStyle: TextStyle(
                        fontFamily: 'Nunito SansRegular',
                        color: Theme.of(context).textTheme.headline2.color)),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                hintText,
                style: TextStyle(color: Colors.black, fontSize: 9),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BankAccountNumberEntryField(BuildContext context, var editController,
      String labelText, String hintText, var keyBoard,
      {bool isPassword = false, var maxLenghtAllow}) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            //   color: Theme.of(context).backgroundColor,

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

  Widget savingLinkage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      padding: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            DropDownComponent(
                items: [],
                onChange: (String item) {
                  setState(() {});
                },
                label: "Link Savings",
                selectedItem: "---",
                validator: (String item) {}),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: this.value,
                  onChanged: (bool value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                ),
                Text(
                  'Create standing instructions at disbursement',
                  style: TextStyle(fontSize: 11),
                )
              ],
            )
          ],
        ),
      ),
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

  getDateForNextRepayment(String getDate) {
    print('getDate ${getDate}');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems ${removeComma}');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

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

    print('newOO ${newOO}');

    String concatss = newOO + " " + realMonth + " " + o1;

    print("concatss new Date from edit ${concatss}");

    return concatss;
  }
}


