
import 'dart:convert';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankAnalyser{
  //final List<String> bankResult;
  final int clientId;
  final String amountrequested;
  final String productId;
  final String tenure;
  final int loanId;

  // var bankResult =[];

  BankAnalyser({this.clientId,this.amountrequested,this.productId,this.tenure,this.loanId});


  Future<Map<String, dynamic>>  completeBankAnalyser() async{
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int passedLoanID = prefs.getInt('loanCreatedId');

    Map<String,String> bHeader =  {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };
    Response responsevv = await get(
      AppUrl.getLoanDetails + passedLoanID.toString() + '?associations=all&exclude=guarantors,futureSchedule',
      headers:bHeader
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    var newClientData = responseData2;
    Map<String,dynamic> loanDetail = {
      "amount_requested":newClientData['principal'],
      "productId":newClientData['loanProductId'],
      "tenure": newClientData['numberOfRepayments'],
      "id": newClientData['id'],
      "clientID": newClientData['clientId']
    };

    // //print('loan details ${loanDetail.toString()}');
    // return loanDetail;

    Response responsevvBank = await get(
      AppUrl.getSingleClient + newClientData['clientId'].toString() + '/banks',
      headers: bHeader,
    );
    //print(responsevv.body);

    final List<dynamic> responseData2Bank = json.decode(responsevvBank.body);
    //print('responseData2Bank ${responseData2Bank}');
    var newClientDatabank = responseData2Bank;


    var  bankStatment = {
      "bankSortCode": newClientDatabank[0]['bank']['bankSortCode'].toString(),
      "accountName": newClientDatabank[0]['accountname'],
      "accountNumber": newClientDatabank[0]['accountnumber'],
      "bankname": newClientDatabank[0]['bank']['name']
    };


    // mbs analysis

    Response responsevvMbs = await get(
      AppUrl.getMBSBank,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDbGllbnRJZCI6IjEyIiwiZXhwIjoxODA1Nzk1MjA4LCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo0NDMwOS8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo0NDMwOS8ifQ.6jXp8pR2r3HMeWcgFxo7rnZb2gMuiHryXq_fayoJMog',
      },
    );
    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevvMbs.body);
      var fetchDoe = responseData;
      var  bankResult = fetchDoe['data']['result'];


      List<dynamic> selectSortCode =  bankResult.where((element) => element['sortCode'] == bankStatment['bankSortCode']).toList();

      //print('this is Clientx code ${selectSortCode}');
      int mbsSortCode = selectSortCode[0]['id'];


      // get mobile number
      Response responsevvPersonal = await get(
        AppUrl.getSingleClient + newClientData['clientId'].toString(),
        headers: bHeader
      );
      final Map<String,dynamic> responseData2Personal = json.decode(responsevvPersonal.body);
    String phonenumber = responseData2Personal['mobileNo'];
      var loandData = {
        "amount_requested":newClientData['principal'],
        "productId":newClientData['loanProductId'],
        "tenure": newClientData['numberOfRepayments'],
        "id": newClientData['id'],
        "clientID": newClientData['clientId'],
        "externalBankId": mbsSortCode
      };
      Map<String,dynamic> bankAnalyser = {
        "externalBankId":mbsSortCode ,
        "amountRequested": newClientData['principal'],
        "productId": newClientData['loanProductId'],
        "tenure": newClientData['numberOfRepayments'],
        "phone": phonenumber,
        "loanId":newClientData['id'],
      };

      int clientId = newClientData['clientId'];
      int passLoanID = newClientData['id'];


      // run bank analyser

      // end run bank analyser

      // start
      /////

      Response Analysisresponse = await post(
        // AppUrl.getLoanDetails + loanId.toString() + '/analyse/bankstatement/6',
        AppUrl.getLoanDetails + clientId.toString() + '/decide',
        body: json.encode(bankAnalyser),
        headers: bHeader
      );

      print('this is analysisBody ${Analysisresponse.body}');

      if (Analysisresponse.statusCode == 200) {
        print(responsevv);
        final Map<String, dynamic> responseData = json.decode(Analysisresponse.body);
        var fetchDoe = responseData;

      return  result = {'status': true, 'message': 'Successful', 'data': fetchDoe,};
      }
      else {
        if(Analysisresponse.statusCode == 500){
        return  result = {
            'status': false,
            'message': 'Server error, please try again'
          };
        }
       return result = {
          'status': false,
          'message': json.decode(responsevv.body)
        };
      }


      /////
      final Future<Map<String,dynamic>> respose =   RetCodes().bankStatementAnalyser(bankAnalyser,passLoanID,clientId);
      respose.then((response) async {
        print('response from analyser ${response}');


        if(response['status'] == false){
        return  result  = {"status": false,"message":"Unable to analyse"};
        }
        else {
          if(response['data']['status'] == 'FAIL'){
           return result  = {"status": false,"message":"Auto analysis failed, please try the manual route"};
          }
          else if(response['data']['status'] == 'COUNTER_OFFER'){
            result  = {"status": true,"message":response['data']['reason']};
          }
          else {
            result  = {"status": true,"message":response['data']['reason']};

          }
          int tempLoanID =  prefs.getInt('loanCreatedId');
          bool isAutoDisbursed = prefs.getBool('isAutoDisburse');

        }
      });

      // end
      // return loandData;
    }



    else {
    }

  }

}