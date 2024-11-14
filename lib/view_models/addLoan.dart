import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/domain/user.dart';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotSent,
  Sent,
  Sending,
}

class AddLoanProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  Status _addStatus = Status.NotSent;

  Status get addStatus => _addStatus;

  set otpStatus(Status value) {
    _addStatus = value;
  }

  notify(){
    notifyListeners();
  }

  static Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);

    // print(responseData);

    if(response.statusCode == 200){

      var userData = responseData['data'];

      // now we will create a user model
      User authUser = User.fromJson(responseData);

      // now we will create shared preferences and save data
      UserPreferences().saveUser(authUser);

      result = {
        'status':true,
        'message':'Successfully registered',
        'data':authUser
      };

    }else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> addLoan(var passedLoanData,
      String isDeciderPassed,
      {String comingFrom,bool buyOverOpt = false}) async {
    var result;
     // return result;

    print('decide status ${isDeciderPassed}');
    _addStatus = Status.NotSent;
    notifyListeners();

    print(passedLoanData);
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    var clientId = prefs.getInt('clientId');
    print(clientId);
    print(token);
    //   January 24, 1991


    Map<String,String> bHeader =  {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };


    // check the client's bank statement
    Map<String,dynamic> bankStatementCheck = {
      "productId": passedLoanData['productId'],
      "amountRequested": passedLoanData['principal'],
      "tenure": passedLoanData['numberOfRepayments'],
    };


    // if it's federal call analyse statement .. decide.. pass /fail
    // state or private, skip.. then
    // if federal .. don't go to MBS
    //AppUrl.getLoanDetails + '${passedLoanData['clientId']}/analyse/statement/verify
    print('bankStatementCheck ${bankStatementCheck}');
      var localProductID = passedLoanData['productId'];
    // if(isDeciderPassed == 'pass'){
    //
    //   try
    //   {
    //     Response responsevv = await post(
    //         AppUrl.getLoanDetails + '${passedLoanData['clientId']}/analyse/statement/verify',
    //         body: json.encode(bankStatementCheck),
    //         headers: bHeader
    //     );
    //
    //
    //     print('this is responseVV ${responsevv.body}');
    //
    //     if(responsevv.statusCode != null && responsevv.statusCode == 403){
    //       return {
    //         'status': false,
    //         'msg_source': 'loan_decider',
    //         'message': json.decode(responsevv.body)['errors'][0]['developerMessage'],
    //       };
    //     }
    //
    //     // print('loan Status ${responsevv.body}');
    //     final Map<String, dynamic> loanDatabankStatement = json.decode(responsevv.body);
    //
    //
    //
    //     print('user reason ${json.decode(responsevv.body)}  ${responsevv.statusCode}');
    //
    //     if(loanDatabankStatement['status'] == 'FAIL'){
    //       return {
    //         'status': false,
    //         'msg_source': 'loan_decider',
    //         'message': json.decode(responsevv.body)['reason'],
    //       };
    //     }
    //
    //
    //
    //
    //   }
    //
    //   catch(e){
    //     print('this is an exception ${e}');
    //     if (e.toString().contains('SocketException') ||
    //         e.toString().contains('HandshakeException')) {
    //       return result = {'status': false, 'message': 'Network error','data':'No Internet connection'};
    //
    //     }
    //   }
    //
    // }



    // end check the client bank staatement



    final Map<String, dynamic> dsrData = {
      "id": passedLoanData['id'],
      "commitment": passedLoanData['commitment'],
      "netpay":passedLoanData['netpay'],
      "clientId": passedLoanData['clientId'],
      "productId": passedLoanData['productId'],
      "principal": passedLoanData['principal'],
      "loanTermFrequency": passedLoanData['loanTermFrequency'],
      "loanTermFrequencyType": passedLoanData['loanTermFrequencyType'],
      "numberOfRepayments": passedLoanData['numberOfRepayments'],
      "repaymentEvery": passedLoanData['repaymentEvery'],
      "repaymentFrequencyType": passedLoanData['repaymentFrequencyType'],
      "interestRatePerPeriod": passedLoanData['interestRatePerPeriod'],
      "amortizationType": passedLoanData['amortizationType'],
      "isEqualAmortization": passedLoanData['isEqualAmortization'],
      "interestType": passedLoanData['interestType'],
      "interestCalculationPeriodType": passedLoanData['interestCalculationPeriodType'],
      "allowPartialPeriodInterestCalcualtion": passedLoanData['allowPartialPeriodInterestCalcualtion'],
      "inArrearsTolerance": passedLoanData['inArrearsTolerance'],
      "graceOnPrincipalPayment": passedLoanData['graceOnPrincipalPayment'],
      "graceOnInterestPayment": passedLoanData['graceOnInterestPayment'],
      "graceOnArrearsAgeing": passedLoanData['graceOnArrearsAgeing'],
      "transactionProcessingStrategyId": passedLoanData['transactionProcessingStrategyId'],
      "graceOnInterestCharged": passedLoanData['graceOnInterestCharged'],

      "rates": [],
      "charges": passedLoanData['charges'],
      "locale": "en",
      "dateFormat": passedLoanData['dateFormat'],
      "loanType": passedLoanData['loanType'],
      "expectedDisbursementDate":passedLoanData['expectedDisbursementDate'],
      "submittedOnDate": passedLoanData['submittedOnDate']

    };




    try{
      Response responsevv = await post(
        AppUrl.checkDsr,
        body: json.encode(dsrData),
        headers: bHeader
      );



      print('responsevv.body ${responsevv}');
      // var e = responsevv.body;
      // if (e.toString().contains('SocketException') ||
      //     e.toString().contains('HandshakeException')) {
      //   result = {'status': false, 'message': 'Network error','data':'No Internet connection'};
      //
      // }

      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);
        _addStatus = Status.Sent;
        notifyListeners();
          print('returned from response data 2 ${responseData2['pass']}');


        if(responseData2['pass'] == true){
          print('got here');

          final Map<String, dynamic> loanData = {

            "allowPartialPeriodInterestCalcualtion": passedLoanData['allowPartialPeriodInterestCalcualtion'],
            "amortizationType": passedLoanData['amortizationType'],
            "clientId": passedLoanData['clientId'],
            "dateFormat": "dd MMMM yyyy",
            "disbursementData": [],
            "expectedDisbursementDate": passedLoanData['expectedDisbursementDate'],
            "interestCalculationPeriodType" : passedLoanData['interestCalculationPeriodType'],
            "interestRatePerPeriod": passedLoanData['interestRatePerPeriod'],
            "interestType": passedLoanData['interestType'],
            "isEqualAmortization": passedLoanData['isEqualAmortization'],
            "loanTermFrequency": passedLoanData['loanTermFrequency'],
            "loanTermFrequencyType": passedLoanData['loanTermFrequencyType'],
            "loanType": "individual",
            "locale": "en",
            "loanPurposeId":passedLoanData['loanPurpose'],
            "netpay":passedLoanData['netpay'],
            "numberOfRepayments": passedLoanData['numberOfRepayments'],
            "principal": passedLoanData['principal'],
            "productId": passedLoanData['productId'],
            "isTopup": passedLoanData['isTopup'],
            "rates": [],
            "charges": passedLoanData['charges'],
            "activationChannelId": 77,
            'loanOfficerId': prefs.getInt('staffId'),
            "createStandingInstructionAtDisbursement": true,
            "linkAccountId": passedLoanData['linkAccountId'],
            "loanIdToClose": passedLoanData['loanIdToClose'],
            // "canUseForTopup":passedLoanData['canUseForTopup'],
            "repaymentsStartingFromDate": passedLoanData['NextRepaymentDate'],
         //  "buyOverLoanDetail": passedLoanData['buyOverLoanDetail'],
            "repaymentEvery": passedLoanData['repaymentEvery'],
            "repaymentFrequencyType": passedLoanData['repaymentFrequencyType'],
            "submittedOnDate": passedLoanData['submittedOnDate'],
            "transactionProcessingStrategyId": passedLoanData['transactionProcessingStrategyId'],
          };


          print('Passed<< onLoanEdit ${passedLoanData['charges']}');

          final Map<String, dynamic> EditloanData = {

            "allowPartialPeriodInterestCalcualtion": passedLoanData['allowPartialPeriodInterestCalcualtion'],
            "amortizationType": passedLoanData['amortizationType'],
            "clientId": passedLoanData['clientId'],
            "dateFormat": "dd MMMM yyyy",
            "disbursementData": [],
            "expectedDisbursementDate": passedLoanData['expectedDisbursementDate'],
            "interestCalculationPeriodType" : passedLoanData['interestCalculationPeriodType'],
            "interestRatePerPeriod": passedLoanData['interestRatePerPeriod'],
            "interestType": passedLoanData['interestType'],
            "isEqualAmortization": passedLoanData['isEqualAmortization'],
            "loanTermFrequency": passedLoanData['loanTermFrequency'],
            "loanTermFrequencyType": passedLoanData['loanTermFrequencyType'],
            "loanType": "individual",
            "locale": "en",
            "isTopup": passedLoanData['isTopup'],
            "loanPurposeId":passedLoanData['loanPurpose'],
            "repaymentsStartingFromDate": passedLoanData['NextRepaymentDate'],
            "netpay":passedLoanData['netpay'],
            "numberOfRepayments": passedLoanData['numberOfRepayments'],
            "principal": passedLoanData['principal'],
            "productId": passedLoanData['productId'],
            "rates": [],
            "charges": passedLoanData['charges'],
            "activationChannelId": 77,
            'loanOfficerId': prefs.getInt('staffId'),
            "loanIdToClose": passedLoanData['loanIdToClose'],
            "createStandingInstructionAtDisbursement": true,
            "linkAccountId": passedLoanData['linkAccountId'],

            // "canUseForTopup":passedLoanData['canUseForTopup'],
            "buyOverLoanDetail": passedLoanData['buyOverLoanDetail'],
            "repaymentEvery": passedLoanData['repaymentEvery'],
            "repaymentFrequencyType": passedLoanData['repaymentFrequencyType'],
           // "submittedOnDate": passedLoanData['methodType'] == 'post' ? passedLoanData['submittedOnDate'] : null,
            "transactionProcessingStrategyId": passedLoanData['transactionProcessingStrategyId'],
          };

          final Map<String, dynamic> RemittaloanData = {

            "allowPartialPeriodInterestCalcualtion": passedLoanData['allowPartialPeriodInterestCalcualtion'],
            "amortizationType": passedLoanData['amortizationType'],
            "clientId": passedLoanData['clientId'],
            "dateFormat": "dd MMMM yyyy",
            "disbursementData": [],
            "expectedDisbursementDate": passedLoanData['expectedDisbursementDate'],
            "interestCalculationPeriodType" : passedLoanData['interestCalculationPeriodType'],
            "interestRatePerPeriod": passedLoanData['interestRatePerPeriod'],
            "interestType": passedLoanData['interestType'],
            "isEqualAmortization": passedLoanData['isEqualAmortization'],
            "loanTermFrequency": passedLoanData['loanTermFrequency'],
            "loanTermFrequencyType": passedLoanData['loanTermFrequencyType'],
            "loanType": "individual",
            "locale": "en",
            "loanPurposeId":passedLoanData['loanPurpose'],
            "netpay":passedLoanData['netpay'],
            "numberOfRepayments": passedLoanData['numberOfRepayments'],
            "principal": passedLoanData['principal'],
            "productId": passedLoanData['productId'],
            "isTopup": passedLoanData['isTopup'],
            "rates": [],
            "charges": passedLoanData['charges'],
            "activationChannelId": 77,
            'loanOfficerId': prefs.getInt('staffId'),
            "createStandingInstructionAtDisbursement": true,
            "linkAccountId": passedLoanData['linkAccountId'],
            "loanIdToClose": passedLoanData['loanIdToClose'],
            // "canUseForTopup":passedLoanData['canUseForTopup'],
            "repaymentsStartingFromDate": passedLoanData['NextRepaymentDate'],

            "repaymentEvery": passedLoanData['repaymentEvery'],
            "repaymentFrequencyType": passedLoanData['repaymentFrequencyType'],
            "submittedOnDate": passedLoanData['submittedOnDate'],
            "transactionProcessingStrategyId": passedLoanData['transactionProcessingStrategyId'],
            "paymentMethodId": 7,
            "paymentMethodReference": passedLoanData['paymentMethodReference']

          };


          final Map<String, dynamic> buyOverLoanData = {

            "allowPartialPeriodInterestCalcualtion": passedLoanData['allowPartialPeriodInterestCalcualtion'],
            "amortizationType": passedLoanData['amortizationType'],
            "clientId": passedLoanData['clientId'],
            "dateFormat": "dd MMMM yyyy",
            "disbursementData": [],
            "expectedDisbursementDate": passedLoanData['expectedDisbursementDate'],
            "interestCalculationPeriodType" : passedLoanData['interestCalculationPeriodType'],
            "interestRatePerPeriod": passedLoanData['interestRatePerPeriod'],
            "interestType": passedLoanData['interestType'],
            "isEqualAmortization": passedLoanData['isEqualAmortization'],
            "loanTermFrequency": passedLoanData['loanTermFrequency'],
            "loanTermFrequencyType": passedLoanData['loanTermFrequencyType'],
            "loanType": "individual",
            "locale": "en",
            "loanPurposeId":passedLoanData['loanPurpose'],
            "netpay":passedLoanData['netpay'],
            "numberOfRepayments": passedLoanData['numberOfRepayments'],
            "principal": passedLoanData['principal'],
            "productId": passedLoanData['productId'],
            "isTopup": passedLoanData['isTopup'],
            "rates": [],
            "charges": passedLoanData['charges'],
            "activationChannelId": 77,
            'loanOfficerId': prefs.getInt('staffId'),
            "createStandingInstructionAtDisbursement": true,
            "linkAccountId": passedLoanData['linkAccountId'],
            "loanIdToClose": passedLoanData['loanIdToClose'],
            // "canUseForTopup":passedLoanData['canUseForTopup'],
            "repaymentsStartingFromDate": passedLoanData['NextRepaymentDate'],
            "buyOverLoanDetail": passedLoanData['buyOverLoanDetail'],
            "repaymentEvery": passedLoanData['repaymentEvery'],
            "repaymentFrequencyType": passedLoanData['repaymentFrequencyType'],
            "submittedOnDate": passedLoanData['submittedOnDate'],
            "transactionProcessingStrategyId": passedLoanData['transactionProcessingStrategyId'],

          };





          // "id": passedLoanData['id'],
          var vLoanData = comingFrom == null ? ( buyOverOpt == false ? loanData : buyOverLoanData) : RemittaloanData;

          print('this is loanData ${vLoanData}');
          print('this is loanData edited ${EditloanData}');

          try{
            Response loanResponse;
            if(passedLoanData['methodType'] == 'post'){
              loanResponse = await post(
                AppUrl.createLoan,
                body: json.encode(vLoanData),
                headers: bHeader
              ).timeout(
                Duration(seconds: 60),
                onTimeout: () {
                  // Closing client here throwns an error
                  // client.close(); // Connection closed before full header was received
                  result = {'status': false, 'message': 'Connection timed out',};
                  //
                },);;
            }
            else {
                print('salesToolkit ${ AppUrl.getLoanDetails + '${passedLoanData['id']}' + '/salestoolkit'}');
              loanResponse = await put(
                AppUrl.getLoanDetails + '${passedLoanData['id']}' + '/salestoolkit',
                body: json.encode(EditloanData),
                headers:bHeader,
              ).timeout(
                Duration(seconds: 60),
                onTimeout: () {
                  result = {'status': false, 'message': 'Connection timed out',};
                  //
                },);

            }

            if(loanResponse.statusCode == 200 ) {
              final Map<String, dynamic> loanRespo = json.decode(
                  loanResponse.body);
              print(' loanRespo ${loanRespo}');
              prefs.setInt('loanCreatedId', loanRespo['loanId']);
              result = {'status': true, 'message': 'Successful','data':loanResponse.body};
            }
            else {
              // print('loan ${responseData2}');
              result = {'status': false, 'message': json.decode(loanResponse.body)['errors'][0]['defaultUserMessage'],'data':loanResponse.body};
            }


          }catch(e){
            print('loan ${e.toString()}');
            result = {'status': false, 'message': 'Unable to create loan',};
          }

        }
        else {
          result = {
            'status': false,
            'message': json.decode(responsevv.body)['decision'],
            'decision_issue':true,
            'suggested_amount':  json.decode(responsevv.body)['suggestedAmount'],
          };
        }


      }
      else {

        _addStatus = Status.Sent;
        notifyListeners();
        _addStatus = Status.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
        };
      }

    }
    catch(e){

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {'status': false, 'message': 'Network error','data':'No Internet connection'};

      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;

  }

  Future<Map<String, dynamic>> addDocumentForLoan(var docLoan) async {
    var result;

    _addStatus = Status.Sending;
    notifyListeners();

    print(docLoan);
    print('personalData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> loanData =
      [
        // {
        //   "name": "Bank Statement",
        //   "fileName": docLoan['fileName'],
        //   "type": int.parse(docLoan['type']),
        //   "location": docLoan['location'],
        //   "description": "uploading a Bank Statement"
        // }
        // {
        //   "location" : docLoan['location'],
        //   "name" : docLoan['fileName'],
        //   "description" : "Bank Statement",
        //   "fileName" : docLoan['fileName'],
        //   "type" : docLoan['type']
        // }

        // {
        //   "location" : "iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAfSURBVDhPY/wPBAwUACYoTTYYNWDUABAYNYBiAxgYAGCfBBqAaJk0AAAAAElFTkSuQmCC",
        //   "name" : "name_name.png",
        //   "description" : "test test",
        //   "fileName" : "test.png",
        //   "size" : 300,
        //   "type" : "image/png"
        // }
        ];


    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print(token);
    Response responsevv = await post(
      AppUrl.bulkBase64 + 'loans/${prefs.getInt('loanCreatedId')}/documents/bulkbase64',
      body: json.encode(docLoan),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('responsevv.body for bulk base ${responsevv.body}');
    if(responsevv.statusCode == 200 ){
      final List<dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      _addStatus = Status.Sent;
      notifyListeners();

      result = {'status': true, 'message': 'Successful','data':responseData2};


    } else {
            print('json Response ${responsevv.body}');
      _addStatus = Status.Sent;
      notifyListeners();
      _addStatus = Status.NotSent;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['errors'][0]['defaultUserMessage']
      };
    }

    //2


    return result;

  }




  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }




}