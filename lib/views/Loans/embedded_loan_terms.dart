import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/Loans/DocumentsForLoan.dart';
import 'package:sales_toolkit/views/Loans/secondNewLoan.dart';
import 'package:sales_toolkit/views/clients/SingleCustomerScreen.dart';
import 'package:sales_toolkit/views/clients/ViewClient.dart';
import 'package:sales_toolkit/widgets/BottomNavComponent.dart';
import 'package:sales_toolkit/widgets/DoubleButtonBottomNav.dart';
import 'package:sales_toolkit/widgets/Stepper.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:sales_toolkit/widgets/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_date_utils.dart';
import '../../widgets/rounded-button.dart';
import 'DocumentExtraScreen.dart';

class EmbeddedLoanTerms extends StatefulWidget {
  // const NewLoan({Key key}) : super(key: key);
  //
  // @override
  // _NewLoanState createState() => _NewLoanState();

  final int clientID, productId, loanId, employerId, sectorID, parentClientType;
  final Map<String,dynamic> thirdPartyLoanResponse,otherInfo;
  const EmbeddedLoanTerms(
      {Key key,
        this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType,
        this.thirdPartyLoanResponse,
        this.otherInfo,
      })
      : super(key: key);

  @override
  _EmbeddedLoanTermsState createState() => _EmbeddedLoanTermsState(
      clientID: this.clientID,
      productId: this.productId,
      loanId: this.loanId,
      employerId: this.employerId,
      sectorID: this.sectorID,
      parentClientType: this.parentClientType,
      thirdPartyLoanResponse: this.thirdPartyLoanResponse,
      otherInfo: this.otherInfo
  );
}

class _EmbeddedLoanTermsState extends State<EmbeddedLoanTerms> {
  int clientID, productId, loanId, employerId, sectorID, parentClientType;
   Map<String,dynamic> thirdPartyLoanResponse,otherInfo;

  TextEditingController staffId = TextEditingController(text: 'CDL00OP');
  TextEditingController principal = TextEditingController();
  TextEditingController no_of_repayments = TextEditingController();

  List<String> collectDocumentType = [];


  String netpay;
  String committment;
  // String no_of_repayments;
  String loanTerm;
  String repaidEvery;
  String nominal_interest;


  _EmbeddedLoanTermsState(
      {this.clientID,
        this.productId,
        this.loanId,
        this.employerId,
        this.sectorID,
        this.parentClientType,
        this.thirdPartyLoanResponse,
        this.otherInfo
      });

  @override
  List<String> productArray = [];
  List<String> collectProduct = [];
  List<String> collectProds = [];

  List<dynamic> allProduct = [];
  List<String> filteredProduct = [];

  List<String> purposeArray = [];
  List<String> collectPurpose = [];
  List<dynamic> allPurpose = [];
  List<dynamic> allEmployer = ["employer"];
  bool _isLoading = false;

  int sectorId;

  List<String> fundingArray = [];
  List<String> collectFunding = [];
  List<dynamic> allFunding = [];
  String productName = '';
  String PassloanPurpose = '';
  String username,clientBvn;
  int productInt, purposeInt;
  var employmentProfile = [];
  int employerID;
  String alternateDate;
  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
  bool _isFederalOrState = false;



  Map<String, dynamic> fullTemps;
  Map<String, dynamic> vOverrides, vOverrides2;
  List<dynamic> chargesData;
  int ClientaccountLinkingOptions = 100;
  bool value = false;
  String min_repayment = '';
  String max_repayment = '';
  String min_principal = '';
  String max_principal = '';

  String min_interest = '';
  String max_interest = '';
  double repaymentAmount = 0.0;
  bool _canUseForTopUp = false;
  List<dynamic> productOptions = [];

  List<String> loanOptionArray = [];
  List<String> collectLoanOption = [];
  List<dynamic> allLoanOption = [];
  DateTime disburse_now = DateTime.now();
  
  void initState() {
    // TODO: implement initState

    print('print parent ${parentClientType}');
    //loadPurposeTemplate();
    autoPickDate();
    getUserProfile();
    //fundingOptionTemplate();
    if (loanId != null) {
      getLoanDetails();
    }
    // getEmploymentProfile();
    getSalesUsername();
    loadFullTemplate();
    // print('loan Id ${loanId}');
  print('other info >> ${otherInfo}');
  print('third party response >> ${thirdPartyLoanResponse}');
    super.initState();
  }

  loadFullTemplate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

      int productID = otherInfo['loanProductId'];

    final Future<Map<String, dynamic>> respose =
    RetCodes().getFullTemplate(clientID, productID, employerId);
    respose.then((response) {
      print('this is the loadAllow');
      print(response['data']);

      Map<String, dynamic> fullTemplate = response['data'];

      setState(() {
        Map<String,dynamic> mapDynamicData = thirdPartyLoanResponse['staffInfo']['data'];
        netpay = mapDynamicData['net_pay'].toString();

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
              : fullTemps['employerLoanProductDataOptions'][0]['charges']  ??
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
      repaidEvery = fullTemps['product']['repaymentEvery'].toString();

      if (loanId == null) {
        // print('new<< ${interestRateForPrivate} ${
        //     load_fedgoData != null  ? load_fedgoData['interestRate'] .toString() :
        //     fullTemps['employerLoanProductDataOptions'] == null
        //         ? fullTemps['product']['interestRatePerPeriod'].toString()
        //         : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
        //         .toString()
        // }');
        principal.text = fullTemps['product']['principal'].toString();
        nominal_interest = fullTemps['employerLoanProductDataOptions'] == null
            ? fullTemps['product']['interestRatePerPeriod'].toString()
            : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
            .toString();
        no_of_repayments.text =
            fullTemps['product']['numberOfRepayments'].toString();
      }
           nominal_interest = fullTemps['product']['numberOfRepayments'].toString();
    });
  }

  calculateReschedule() async {
    print('repayment << ${
        chargesData.map((e) =>
        {
          "chargeId":e['chargeId'] == null ? e['id'] : e['chargeId'],
          "amount": loanId == null ? e['amount'] : (e['amountOrPercentage'] == null ? e['amount'] : e['amountOrPercentage']),
          "id": loanId == null ? null : e['id']
        }
        ).toList()
    }');
    // print('charges Data << ${chargesData.toList()}');

    DateTime now = DateTime.now();

    String vasCoddd = retsNx360dates(now);
    int productID = otherInfo['loanProductId'];
    Map<String, dynamic> repaymentSchedule = {
      "commitment": 0,
      "netpay": netpay,
      "clientId": clientID,
      "productId": productID,
      "principal": principal.text,
      "loanTermFrequency": no_of_repayments.text,
      "loanTermFrequencyType": 2,
      "numberOfRepayments": no_of_repayments.text,
      "repaymentEvery": repaidEvery,
      "repaymentFrequencyType": 2,
      "interestRatePerPeriod":
     _isFederalOrState == false
          ? nominal_interest
          : fullTemps['employerLoanProductDataOptions'] == null
          ? fullTemps['product']['interestRatePerPeriod'].toString()
          : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
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

      chargesData.map((e) =>
      {
        "chargeId":e['chargeId'] == null ? e['id'] : e['chargeId'],
        "amount": loanId == null ? e['amount'] : (e['amountOrPercentage'] == null ? e['amount'] : e['amountOrPercentage']),
        "id": loanId == null ? null : e['id']
      }
      ).toList()
      ,
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

  autoPickDate(){

    var newJiffy = Jiffy().endOf(Units.MONTH).add(duration: Duration(days: 28));

    // var jiffy1 = Jiffy().add(duration: Duration(days: 1));
    print('newJiffy ${newJiffy.month}');
    var vlaMonth = newJiffy.month;

    if (vlaMonth == 2) {
      var fubruaryJiffy = newJiffy.dateTime.toString();
      print('feb Jiffy ${fubruaryJiffy}');
      String vDate = AppDateUtils.getDateForNextRepayment(fubruaryJiffy);
      print('vDate ${vDate}');
      setState(() {
        alternateDate = vDate;
      });
    } else {
      var otherJiffy = newJiffy.add(duration: Duration(days: 2));
      print('other Jiffy ${otherJiffy.dateTime}');
      var newDee = otherJiffy.dateTime.toString();
      String vDate = AppDateUtils.getDateForNextRepayment(newDee);
      print('vDate ${vDate} ${newDee}');
      setState(() {
        alternateDate = vDate;
      });
    }
  }

  getUserProfile(){
    final Future<Map<String,dynamic>> response =   RetCodes().getClientProfile(clientID.toString());
    response.then((responseData) {
      print('this>> << ${responseData}');
      setState(() {
        clientBvn = responseData['bvn'];

        //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
        //    String nomsInterest = responseData['data']['data']['categpries']['interestRate'].toString();

      });

    });

  }

  getSalesUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    print('Vusername ${Vusername}');
    prefs.remove('loanCreatedId');
    setState(() {
      loanOfficer.text = Vusername;
    });
  }

  getEmploymentProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    setState(() {
      _isLoading = true;
    });
    Response responsevv = await get(
      AppUrl.getSingleClient + clientID.toString() + '/employers',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    final List<dynamic> responseData2 = json.decode(responsevv.body);
    print('responseData2 ${responseData2}');


    setState(() {
      allEmployer = responseData2;

      employerID = responseData2[0]['employer']['parent']['id'];
      sectorId = responseData2[0]['employer']['sector']['id'];
      parentClientType =
      responseData2[0]['employer']['parent']['clientType']['id'];
      _isLoading = false;

      if(responseData2.length == 0){
        allEmployer = [];
      }
    });


    print('employer ID ${employerID}');

    //salary_range = employmentProfile[0]['salaryRange']['id'];
  }

  var productData = [];

  loadLoanTemplates() async {
    print('this is clientID ${clientID} ${employerId}');
    int empID = employerID == null ? employerId : employerID;
    print('empID ${empID}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanProducts(clientID, empID);
    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      // print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        collectProduct = [];

        allProduct = newEmp;
      });

      print('all Products ${newEmp}');

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['name']);
        collectProduct.add(newEmp[i]['name']);
      }
      // var filteredProduct = collectProduct.where((element) => element['name'] == 'FEDERAL SPEED')
      filteredProduct = collectProduct;
      print('sector ID ${sectorID}');

      //fed speed=> 28
// state => 43
      // dpl => 36

// so far federal speed, digital personal loan and state loan is part of result... display it to user then yank every other thing out

      // if(parentClientType != null && parentClientType == 67){
      //   filteredProduct =   collectProduct.where((element) => element == 'FEDERAL SPEED' || element == 'Nano Loan' || element == 'FEDERAL LOAN' || element == 'FEDERAL').toList();
      // }
      // else if (parentClientType != null && parentClientType == 68){
      //   filteredProduct =   collectProduct.where((element) => element == 'Sharp Sharp (State Business)' || element == 'State Loan Product' ).toList();
      // }
      // else if (parentClientType != null && parentClientType == 2645){
      //   filteredProduct =   collectProduct.where((element) => element == 'DEVICE FINANCING' || element == 'Digital Personal Loan' || element == 'Nano Loan' || element == 'PayFi').toList();

      // }

      //   print('real newEmp ${newEmp}');
// real_sandbox
      var filtered = newEmp
          .where((element) =>
      element['id'] == 43 || element['id'] == 36 || element['id'] == 28 || element['id'] == 30)
          .toList();



      // NEW PRODUCTION
      //  || element['id'] == 42
      // var filtered = newEmp
      //     .where((element) =>
      //    element['id'] == 63 || element['id'] == 40 || element['id'] == 55 || element['id'] == 64 || element['id'] == 49 || element['id'] == 52 || element['id'] == 71 || element['id'] == 72)
      //     .toList();


// SANDBOX
      //   var filtered = newEmp.where((element) => element['id'] == 49 || element['id'] == 40).toList();

      for (int i = 0; i < filtered.length; i++) {
        print(filtered[i]['name']);
        collectProds.add(filtered[i]['name']);
        collectProduct.add(filtered[i]['name']);
      }

      print('vis alali filtered product.. ${collectProds}');
      //print(filteredProduct);

      setState(() {
        filteredProduct = collectProds;
        productArray = collectProduct;
        _isLoading = false;
      });
    });
  }

  loadPurposeTemplate(int productId) async {
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String, dynamic>> respose =
    RetCodes().getLoanPurpose(clientID, productId);

    respose.then((response) {
      setState(() {
        _isLoading = false;
      });
      print(response['data']);
      List<dynamic> newEmp = response['data'];

      setState(() {
        collectPurpose = [];
        allPurpose = newEmp;
      });

      for (int i = 0; i < newEmp.length; i++) {
        print(newEmp[i]['name']);
        collectPurpose.add(newEmp[i]['name']);
      }
      print('vis alali purpose..');
      print(collectPurpose);

      setState(() {
        purposeArray = collectPurpose;
        _isLoading = false;
      });
    });
  }


  getLoanDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('this is ir ');

    Response responsevv = await get(
      AppUrl.getLoanDetails + loanId.toString(),
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
      productName = newClientData['loanProductName'];
      PassloanPurpose = newClientData['loanPurposeName'];
      productInt = newClientData['loanProductId'];
      purposeInt = newClientData['loanPurposeId'];
      clientID = newClientData['clientId'];
    });
  }




  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  TextEditingController extrernalID = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController loanOfficer = TextEditingController();

  // bool value = false;


  confirmRequestAndBookLoan() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    String disburseNow = AppDateUtils.retsNx360dates(disburse_now);

    Map<String,dynamic> sendLoanDataForThirdParty = {

        "numberOfRepayments": no_of_repayments.text,
        "productId": otherInfo['loanProductId'],
        "loanOfficerId": prefs.getInt('staffId'),
        "clientId": clientID,
        "dateFormat": "dd MMMM yyyy",
        "locale": "en",
        "submittedOnDate": disburseNow,
        "activationChannelId": 77,
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
      chargesData.map((e) =>
      {
        "chargeId":e['chargeId'] == null ? e['id'] : e['chargeId'],
        "amount": loanId == null ? e['amount'] : (e['amountOrPercentage'] == null ? e['amount'] : e['amountOrPercentage']),
        "id": loanId == null ? null : e['id']
      }
      ).toList()
      ,
        "linkAccountId": ClientaccountLinkingOptions,
        "createStandingInstructionAtDisbursement": true,
        "loanTermFrequency": no_of_repayments.text,
        "principal": principal.text,
        "loanType": "individual",
        "loanPurposeId": otherInfo['loanProductId'],
        "expectedDisbursementDate": disburseNow,

      // "expectedDisbursementDate": vasCoddd,
      // "submittedOnDate": vasCoddd,

        "loanTermFrequencyType": 2,
        "repaymentEvery": repaidEvery,
        "repaymentFrequencyType": 2,
      "interestRatePerPeriod": fullTemps['employerLoanProductDataOptions'] == null
          ? fullTemps['product']['interestRatePerPeriod'].toString()
          : fullTemps['employerLoanProductDataOptions'][0]['interestRate']
          .toString(),
        "netpay": netpay,
        "amortizationType": vOverrides2['amortizationType']['id'],
        "interestType": vOverrides2['interestType']['id'],
        "interestCalculationPeriodType":   vOverrides2['interestCalculationPeriodType']['id'],
        "transactionProcessingStrategyId":  vOverrides2['transactionProcessingStrategyId'],
        "commitment": 0,
        "employerId": otherInfo['employerId']

    };
    print('loan data >> ${sendLoanDataForThirdParty}');
    setState(() {
      _isLoading = true;
    });
    final Future<Map<String,dynamic>> response =   RetCodes().post_encryptAndSend(sendLoanDataForThirdParty,tp_customerId: thirdPartyLoanResponse['id']);
    response.then((responseData) {
      setState(() {
        _isLoading = false;
      });
      print('this encrypted>> << ${responseData['data']}');
      setState(() {
        if(responseData['statusCode'] == 200){
          prefs.setInt('loanCreatedId', responseData['data']['loanId']);
          getPassedLoanDetails();

          setState(() {
            _isLoading = false;
          });
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.green,
            title: "Success",
            message: 'Loan Originated',
            duration: Duration(seconds: 6),
          ).show(context);

        }
        else {
          Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.red,
            title: "Error",
            message: responseData['message'],
            duration: Duration(seconds: 30),
          ).show(context);
        }

      });
      // setState(() {
      //   clientBvn = responseData['bvn'];
      //
      //   //  interestRateForPrivate = responseData['data']['data']['categpries']['interestRate'];
      //   //    String nomsInterest = responseData['data']['data']['categpries']['interestRate'].toString();
      //
      // });

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
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Loan Config not found',
          duration: Duration(seconds: 30),
        ).show(context);
      }
    });
    //   print('Loan detail ${loanDetail}');
  }

  geSingleLoanConfig(int configID) async{
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

      // if(load_fedgoData != null){
      //   print('fedGo not empty');
      //   addDocsfromCrcAndFirstCentral();
      //   uploadDocsForLoan(objectFetched);
      // }

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
            )
        );
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
            )
        );

      }
      //   [{id: 55, name: Loan Agreement Form, systemDefined: true, codeValues: Document LAF,Online LAF,Others LAF,SMS LAF}, {id: 58, name: Statement, systemDefined: true, codeValues: Bank Statement}]

      //    final SharedPreferences prefs = await SharedPreferences.getInstance();
    });
  }



  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: Container(
        height: 120,
        width: 120,
        child: Lottie.asset('assets/images/newLoader.json'),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: IconButton(
        //     onPressed: (){
        //       MyRouter.popPage(context);
        //     },
        //     icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        //   ),
        //   title: Text('Loans',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        //   centerTitle: true,
        // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  // LoanStepper(),
                  ProgressStepper(
                    stepper: 0.2,
                    title: 'Loan  Details',
                    subtitle: 'Loan Term',
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child:    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Loan Terms',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Nunito SansRegular')),

                                    Text(
                                        'View your loan details.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontFamily: 'Nunito SansRegular')),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      repaymentWidget(),
                      SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Principal Amount',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200,fontFamily: 'Nunito Bold'),
                              textAlign: TextAlign.start,)),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                          child: EntryField(
                              context,
                              principal,
                              'Principal ',
                              'Principal',
                              TextInputType.number,
                              suffixWidget: Text('₦',style: TextStyle(color: ColorUtils.DARKER_GREY,),)

                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('This is the intended loan amount',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,fontFamily: 'Nunito SemiBold'),
                              textAlign: TextAlign.start,)),
                      ),

                      SizedBox(height: 40,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Tenure',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200,fontFamily: 'Nunito Bold'),
                              textAlign: TextAlign.start,)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            EntryField(
                                context,
                                no_of_repayments,
                                'Loan Tenure ',
                                'Loan Tenure (min: ${min_repayment} months, max: ${max_repayment} months)*',
                                TextInputType.number),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Select preferred loan duration for repayment',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,fontFamily: 'Nunito SemiBold'),
                                    textAlign: TextAlign.start,)),
                            ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Loan Terms',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black,
                      //               fontSize: 20,
                      //               fontFamily: 'Nunito SansRegular')),
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //
                      //       Text(
                      //           'View your loan details.',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w100,
                      //               color: Colors.grey,
                      //               fontSize: 15,
                      //               fontFamily: 'Nunito SansRegular')),
                      //       SizedBox(
                      //         height: 20,
                      //       ),
                      //
                      //       SizedBox(
                      //         height: 20,
                      //       )
                      //     ],
                      //   ),
                      // ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: DoubleBottomNavComponent(
          text1: 'Previous',
          callAction1: (){
            MyRouter.popPage(context);
          },
          text2: 'Book Loan',
          callAction2: () {

            // showModalBottomSheet(
            //   context: context,
            //   builder: ((builder) => confirmBooking()),
            // );
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: confirmBooking(),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
            );




          },
        ),
      ),
    );
  }

  Widget confirmBooking() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Text('Confirm Loan Request',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w200,fontFamily: 'Nunito Bold'),),
            SizedBox(height: 10,),
            Text('Are you sure you want to proceed with this loan request? Once confirmed, your request will be processed accordingly. '),
            SizedBox(height: 15,),
            RoundedButton(
              onbuttonPressed: (){
                MyRouter.popPage(context);
                confirmRequestAndBookLoan();
              },
              buttonText: 'Confirm Request',
            ),
          SizedBox(height: 20,),
            RoundedButton(
              bgColor: Colors.white,
              textColor: Color(0xff077DBB),
              borderColor: Color(0xff077DBB),
                isPrimaryColor: true,
              onbuttonPressed: (){
                MyRouter.popPage(context);
              },
              buttonText: 'Cancel',
            ),


        ],
      ),
    );
  }



  Widget repaymentWidget(){
    return Container(
        width: MediaQuery.of(context).size.width * 0.86,
        height: MediaQuery.of(context).size.height * 0.16,
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: ColorUtils.DARK_BACKGROUND_COLOR
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Repayment Amount',style: TextStyle(color: ColorUtils.COLOR_TEXT,fontFamily: 'Nunito SansRegular',fontSize: 12),),
          SizedBox(height: 5,),
          Text('₦ ${formatCurrency.format(repaymentAmount)}',style: TextStyle(color: ColorUtils.WHITE_COLOR,fontFamily: 'Nunito SemiBold',fontSize: 24),),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Net Pay',style: TextStyle(color: ColorUtils.COLOR_TEXT,fontFamily: 'Nunito SansRegular',fontSize: 12),),
                  SizedBox(height: 5,),
                  Text('₦${formatCurrency.format(thirdPartyLoanResponse['staffInfo']['data']['net_pay'])}',style: TextStyle(color: ColorUtils.WHITE_COLOR,fontFamily: 'Nunito SemiBold',fontSize: 14),),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Repayment Date',style: TextStyle(color: ColorUtils.COLOR_TEXT,fontFamily: 'Nunito SansRegular',fontSize: 12),),
                  SizedBox(height: 5,),
                  Text(alternateDate ?? '',style: TextStyle(color: ColorUtils.WHITE_COLOR,fontFamily: 'Nunito SemiBold',fontSize: 14),),
                  SizedBox(height: 5,),

                ],
              ),
            ],
          )
        ],
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
                      color: Color(0xff177EB9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
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
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Terms',
                  style: TextStyle(
                      color: Colors.grey,
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
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ))),
                SizedBox(
                  width: 10,
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
      height: MediaQuery.of(context).size.height * 0.52,
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [


          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Staff ID: ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
          //     Text('CDL 002',style: TextStyle(color: Colors.black,fontSize: 19,),)
          //   ],
          // ),dummyDataPass('Staff Id', 'CDL 002'),
          SizedBox(height: 5),
          dummyDataPass('First Name', 'Lucas'),
          SizedBox(height: 5),
          dummyDataPass('Last Name', 'Rodriguez'),
          SizedBox(height: 5),
          dummyDataPass('Retirement Date', '2024-05-25'),
          SizedBox(height: 5),
          dummyDataPass('Net Pay', '511516.08'),
          SizedBox(height: 5),
          dummyDataPass('Gross Pay', '511516.08'),
          SizedBox(height: 5),
          dummyDataPass('Gross Deduction', '0'),
          SizedBox(height: 5),
          dummyDataPass('Payment Date', '2024-02-29'),
          SizedBox(height: 5),
          dummyDataPass('Available Deduction', '255758.04'),
          SizedBox(height: 5),
          dummyDataPass('Can Do Top Up', 'true'),
          SizedBox(height: 5),
          dummyDataPass('Max Top Up', '258758.04'),



          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: DropDownComponent(
          //       items: ['Employer 1','Employer 2'],
          //       onChange: (String item) async {
          //
          //       },
          //       label: "Employers   *",
          //       selectedItem: '',
          //       validator: (String item) {
          //         if (item.length == 0) {
          //           return "Employers ";
          //         }
          //       }),
          // ),
          // SizedBox(
          //   height: 6,
          // ),

          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          //     child: EntryField(context, loanOfficer, 'Loan Officer *','Loan Officer',TextInputType.name,isRealOnly: true)
          // ),

          SizedBox(
            height: 6,
          ),

          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }

  Widget dummyDataPass(String value,String title){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child:   Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$value ',style: TextStyle(fontSize: 17,color: Colors.grey[500],fontWeight: FontWeight.bold),),
          Text('$title',style: TextStyle(color: Colors.black,fontSize: 19,),)
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        print(selected);
        //  date = selected.toString();
        String vasCoddd = retsNx360dates(selected);
        dateController.text = vasCoddd;
      });
  }

  retsNx360dates(DateTime selected) {
    String newdate = selectedDate.toString().substring(0, 10);
    print(newdate);

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

  Widget EntryField(
      BuildContext context,
      var editController,
      String labelText,
      String hintText,
      var keyBoard, {
        bool isPassword = false,
        isRealOnly: false,
       var suffixWidget
      }) {
    var MediaSize = MediaQuery.of(context).size;
    return Container(
      height: MediaSize.height * 0.08,
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
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: keyBoard,

            controller: editController,
            onChanged: (value) {

              if (netpay.length != 0 &&
                  principal.text.length != 0 &&
                  no_of_repayments.text.length != 0)
              {
                calculateReschedule();
              }

            },
            // validator: (value)=>value.isEmpty?'Please enter password':null,
            // onSaved: (value) => vals = value,
            readOnly: isRealOnly,
            decoration: InputDecoration(
                suffixIcon: isPassword == true
                    ? Icon(
                  Icons.remove_red_eye,
                  color: Colors.black38,
                )
                    : null,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.6),
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                floatingLabelStyle: TextStyle(color: Color(0xff205072)),
                hintText: hintText,
                suffix: suffixWidget,
                hintStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Nunito SansRegular'),
                labelStyle: TextStyle(
                    fontFamily: 'Nunito SansRegular',
                    color: Theme.of(context).textTheme.headline2.color)),
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

  Widget noEmployerDialog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Color(0xffDE914A).withOpacity(0.21),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Warning',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Icon(Icons.clear)
                ],
                //
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Loan product is not detected for client \n kindly update the client employer to view loan product',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    MyRouter.pushPage(
                        context,
                        SingleCustomerScreen(
                          clientID: clientID,
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Update client Employer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

}
