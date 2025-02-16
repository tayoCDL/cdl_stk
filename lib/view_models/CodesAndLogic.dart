import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Login/login.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

import '../util/encryptDecrypt.dart';
class RetCodes {
  headerAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };
    return bHeader;
  }

  fetchCodes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getCode,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);
    //  return responsevv.body;
    var responseData2 = json.decode(responsevv.body);

    //  print(responseData2);
    return responseData2;
  }

  Future<Map<String, dynamic>> getReferalsAndStaffData(
      {BuildContext context}) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    int staffId = prefs.getInt('staffId');
    print(tfaToken);
    print(token);

    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };

    Response responsevv =
        await get(AppUrl.getStaffCredential + '${staffId}', headers: bHeader);
  print('responsestaff code ${responsevv.statusCode}');
    if(responsevv.statusCode == 401){
      // result = {
      //   'data': null,
      //   'status': false,
      //   'message': 'UnAuthenticated',
      // };
      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: "Login Expired",
        message: 'Please Login Again',
        duration: Duration(seconds: 3),
      ).show(context);

   //   MyRouter.pu(context, LoginScreen(login_type: 'Loan Management',));
      MyRouter.pushPageReplacement(context,  LoginScreen(login_type: 'Loan Management',));
    }


    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      String agentCode = responseData['agentCode'];
      prefs.setString('agentCode', agentCode);
      // print('agent COde ${agentCode}');

      Response responseAgent = await get(
          AppUrl.ClientsList + '?referralIdentity=${agentCode}',
          headers: bHeader);

      print('responseagent code ${responseAgent.statusCode}');



      if (responseAgent.statusCode == 200) {
        final Map<String, dynamic> responseDataAgent =
            json.decode(responseAgent.body);
        int referralCount = responseDataAgent['totalFilteredRecords'];
        print('get response from agent Code ${responseDataAgent}');

        print('end from auth provider ');
        var fetchDoe = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': fetchDoe,
          'referralCount': referralCount,
          'totalReferral': responseDataAgent['pageItems']
        };
      }
    } else {
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['defaultUserMessage']
      };
    }

    return result;
  }


  Future<Map<String, dynamic>> clientAccount(String clientId,
      {BuildContext context}) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    // int staffId = prefs.getInt('staffId');
    print(tfaToken);
    print(token);

    Map<String, String> bHeader = {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };

    Response responsevv =
    await get(AppUrl.clientAccount + '${clientId}', headers: bHeader);
    print('responsestaff code ${responsevv.statusCode}');
    if(responsevv.statusCode == 401){
      // result = {
      //   'data': null,
      //   'status': false,
      //   'message': 'UnAuthenticated',
      // };
      Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        title: "Login Expired",
        message: 'Please Login Again',
        duration: Duration(seconds: 3),
      ).show(context);

      //   MyRouter.pu(context, LoginScreen(login_type: 'Loan Management',));
      MyRouter.pushPageReplacement(context,  LoginScreen(login_type: 'Loan Management',));
    }


    if (responsevv.statusCode == 200) {
      final List<dynamic> responseData = json.decode(responsevv.body);
      result = {
        'status': true,
        'message': 'account lists generated',
        'data': responseData
      };

       } else {
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['defaultUserMessage']
      };
    }

    return result;
  }


  Future<Map<String, dynamic>> fetchCodesFromBackend() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    Response responsevv = await get(
      AppUrl.getCode,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      final List<dynamic> responseData = json.decode(responsevv.body);
      print('from auth provider');
      print(responseData);
      print('end from auth provider');

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['defaultUserMessage']
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> getLeadProduct() async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response response = await get(
        AppUrl.productSummary,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData2 = json.decode(response.body);
        print(responseData2);
        result = {
          'status': true,
          'message': 'Successful',
          'data': responseData2
        };
      } else {
        result = {'status': false, 'message': json.decode(response.body)};
      }
    } catch (e) {
      print(e);
      return result = {
        'status': false,
        'message': 'Network_error',
        'data': 'No Internet connection'
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> getCodes(String valID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getCodeValue + '${valID}/codevalues',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network_error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);
        print('end from auth provider');

        var fetchDoe = responseData;

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<List<dynamic>> getterAPI(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print('this is url${url}');
    var result;
    try {
      Response response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> responseData2 = json.decode(response.body);
        print(responseData2);

        result = [true, 'Successful', responseData2];
      } else {
        result = [false, 'failed', json.decode(response.body)];
      }
    } catch (e) {
      print(e);
      return result = [false, 'Network_error', 'No Internet connection'];
    }

    return result;
  }

  Future<Map<String, dynamic>> DocumentConfiguration() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.documentConfig,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network_error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(responsevv.body)['codeData'];
        print('from auth provider');
        //  print(responseData);
        print('end from auth provider');

        var fetchDoe = responseData;

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Network error',
        };
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> SingleLoanDocumentConfiguration(
      int codeID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.singleLoanDocumentConfig + '${codeID}/codes',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network_error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(responsevv.body)['codeData'];
        print('from auth provider');
        //  print(responseData);
        print('end from auth provider');

        var fetchDoe = responseData;

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Network error',
        };
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> employers(int sector, String name) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    print(AppUrl.allEmployers + '&employerType=${sector}&name=${name}');

    try {
      Response responsevv = await get(
        AppUrl.allEmployers + '&employerType=${sector}&name=${name}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> searchClient(String name) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    // print(tfaToken);
    print(token + '>> ${AppUrl.newSeachClient + '${name}'}');

//  AppUrl.searchClient + '${name}',
    // https://40.113.169.208:8443/fineract-provider/api/v1/clients/nx360?offset=0&limit=100&bvn=2231744
    try {
      Response responsevv = await get(
        AppUrl.newSeachClient + '${name}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        print('eee >> ${responsevv.body}');

        final Map<String, dynamic> responseData = json.decode(responsevv.body);

        var fetchDoe = responseData;
        print('hFetch ${responseData}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
        print('result >> ${result}');
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> leadSearch(
      int staffId, String searchName) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');



    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);


    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    print(
        '>> ${AppUrl.getSequestTypePendingOnMe + '/${staffId}?search=${searchName}'}');

    try {
      Response responsevv = await get(
        AppUrl.getSequestTypePendingOnMe + '${staffId}?search${searchName}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        print(responsevv);

        final Map<String, dynamic> responseData = json.decode(responsevv.body);

        print('from auth provider');
        //  print(responseData);
        print('end from auth provider');

        var fetchDoe = responseData;
        print('this Data ${responseData['data']}');

        result = {
          'status': true,
          'message': 'Successful',
          'data': fetchDoe['data']
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      print('eer >> ${e}');

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> Leademployers(String employerName) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    print(AppUrl.allEmployers + '&name=${employerName}');
    try {
      Response responsevv = await get(
        AppUrl.allEmployers + '&name=${employerName}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> employerProduct(int employerId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

  //  print(AppUrl.allEmployers + '&name=${employerName}');
    try {
      Response responsevv = await get(
        AppUrl.employerProduct + '${employerId}/loanproducts',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      print('>> responsee ${responsevv.body}');

      if (responsevv.statusCode == 200) {

        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      }
      else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> thirdparty_employerProduct(int employerId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    //  print(AppUrl.allEmployers + '&name=${employerName}');
    try {
      Response responsevv = await get(
        AppUrl.thirdparty_employerProduct + '${employerId}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      print('>> responsee ${responsevv.body}');
     //  if (responsevv.statusCode == 200 && responsevv.body.isEmpty) {
     //
     // //   final Map<String,dynamic> responseData = json.decode(responsevv.body);
     //    print('from auth provider');
     //    //  print(responseData);
     //
     //   // var fetchDoe = responseData;
     // //   print('end from auth provider ${fetchDoe} is firced');
     //
     //    result = {'status': true, 'message': 'Successful', 'data': {} };
     //  }
      if (responsevv.statusCode == 200) {

        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      }
      else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }



  Future<Map<String, dynamic>> CustomerbanksList() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getBanks,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> accounts(String clientID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getSingleClient + '${clientID}' + '/accounts/summary',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }




  Future<Map<String, dynamic>> activityList(String accountNumber) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getSingleClient + '${accountNumber}' + '/tracking',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is forced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection',
          'statusCode': 500
        };
      } else {
        result = {
          'status': false,
          'message': 'Unable to fetch',
          'statusCode': 404
        };
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> recoveryOverview(int collectionID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(collectionID);

    try {
      Response responsevv = await get(
        AppUrl.loanCollection + '/' + '${collectionID}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is forced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection',
          'statusCode': 500
        };
      } else {
        result = {
          'status': false,
          'message': 'Unable to fetch',
          'statusCode': 404
        };
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> loanSold(
      int loanOfficerId, int loanStatus) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    String iUrl = AppUrl.loanGet +
        'loanStatusId=${loanStatus}&loanOfficerId=${loanOfficerId}&orderBy=id&sortOrder=desc&locale=en&dateFormat=yyyy-MM-dd';
    print(iUrl);

    try {
      Response responsevv = await get(
        AppUrl.loanGet +
            'loanStatusId=${loanStatus}&loanOfficerId=${loanOfficerId}&orderBy=id&sortOrder=desc&locale=en&dateFormat=yyyy-MM-dd',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        //    print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> loanLists(String clientID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
     //   AppUrl.getSingleClient + '${clientID}' + '/accounts',
        AppUrl.loanLists + '${clientID}'+ '&sortOrder=desc&orderBy=loan_status_id',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> filterLoanWithStatusId(String clientID,int loanStatusId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        //   AppUrl.getSingleClient + '${clientID}' + '/accounts',
        AppUrl.loanLists + '${clientID}' + '&loanStatusId=${loanStatusId}&sortOrder=desc',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        //  print(responseData);

        var fetchDoe = responseData;
        print('end from auth provider ${fetchDoe} is firced');

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> affectedUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');

    var result;

    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);

    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.affectedUsers,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      print('from auth provider');
      //  print(responseData);
      print('end from auth provider');

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getTicketStatus(String ticketId) async {
    print('ticketID ${ticketId}');
    var result;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var sequesttoken = prefs.getString('sequestToken');
      print('sequest Token ${sequesttoken}');
      Response responsevv = await get(
        AppUrl.getAvailableStatusByTicket + ticketId,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );
      print('this is the ticket Status ${responsevv.body}');

      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);
      var TicketStatus = responseData2['data'];

      result = {'status': true, 'message': 'Successful', 'data': TicketStatus};
      print('result << ${result}');
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> departmentUnit({bool isenabledforstk=false}) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);


    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.deparmentUnit + '?enabledforstk=${isenabledforstk}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      print('from auth provider');
      //  print(responseData);
      print('end from auth provider');

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> ticketType(int affectedUserType) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');

    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);

    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    //
    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.ticketType + affectedUserType.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getCategorybyUnitId(int unitId) async {
    var result;
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // print('ticketInt ${ticketInt} unitId ${unitId}');
    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);

    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);
    //   print('this api ${AppUrl.getCategoryByUnitId + '${unitId}'}');
    Response responsevv = await get(
      AppUrl.getCategoryByUnitId + '${unitId}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    print('v Status code ${responsevv.statusCode}');
    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> categoryType(int ticketInt, int unitId) async {
    var result;
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('ticketInt ${ticketInt} unitId ${unitId}');
    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);


    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);
    print('this api ${AppUrl.categoryApi + '${ticketInt}/${unitId}/1'}');
    Response responsevv = await get(
      AppUrl.categoryApi + '${ticketInt}/${unitId}/1',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    print('v Status code ${responsevv.statusCode}');
    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> categoryTypeForOpportunity(int ticketInt) async {
    var result;
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);

  //  final SharedPreferences prefs = await SharedPreferences.getInstance();

    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.categoryApiForOpportunity + '${ticketInt}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> banksList() async {
    var result;
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);


    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.getBanks,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData;

      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getSubCategoryType(int categoryID) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');


    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    Response Sequestresponse = await post(
      Uri.parse(AppUrl.sequestLogin),
      body: json.encode(sequestLoginData),
      headers: <String, String>{
        'cache-control': 'no-cache',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(Sequestresponse.body);
    final Map<String, dynamic> sequestData = json.decode(Sequestresponse.body);

  //  final SharedPreferences prefs = await SharedPreferences.getInstance();

    var sequestTokenTaker =
        prefs.setString('sequestToken', sequestData['token']);

    var sequesttoken = prefs.getString('sequestToken');
    print('this is the old token');
    print(sequesttoken);

    Response responsevv = await get(
      AppUrl.getSubcategoryApi + '${categoryID}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sequesttoken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getSubValues(
      int firstValue, int secondValue) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getCodeValue + '${firstValue}/codevalues/child/${secondValue}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');

        var fetchDoe = responseData;

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getLoanProducts(
      int clientId, int employerId) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print(
        'loan product ${AppUrl.productEngine + '${clientId}' + '&staffInSelectedOfficeOnly=false&templateType=individual&employerId=${employerId}'}');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual&employerId=${employerId}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['productOptions'];
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': 'Unable to retrieve'};
    }

    return result;
  }

  Future<Map<String, dynamic>> repayment_loan_products(
     int employerId) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');


    Response responsevv = await get(
      AppUrl.repayment_productEngine + '&staffInSelectedOfficeOnly=false&templateType=individual&employerId=${employerId}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['productOptions'];
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': 'Unable to retrieve'};
    }

    return result;
  }


  Future<Map<String, dynamic>> getLoanPurpose(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    try {
      Response responsevv = await get(
        AppUrl.productEngine +
            '${clientId}' +
            '&productId=${productId}' +
            '&staffInSelectedOfficeOnly=false&templateType=individual',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      if (responsevv.statusCode == 200) {
        print(responsevv);
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData['loanPurposeOptions'];
        print('fetch doe purpose ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': 'Unable to retrieve data'};
      }

      return result;
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {'status': false, 'message': 'Unable to retrieve data'};
      }
    }
  }

  Future<Map<String, dynamic>> fundingOptions(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['fundOptions'];
      print('fetch doe purpose ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getLoanMetrics(String params) async {
    var result;
    var dateFormat = "dd MMMM yyyy";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('loan metrics URL ${AppUrl.loanMetrics + '${params}'}');

    Response responsevv = await get(
      AppUrl.loanMetrics + '${params}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['pageItems'];
      print('fetch metrics ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getLoanFrequency(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['termFrequencyTypeOptions'];
      print('fetch doe purpose ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getAmortizationType(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['amortizationTypeOptions'];
      print('fetch doe purpose ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getInterestMethod(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['interestTypeOptions'];
      print('fetch doe purpose ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getFullTemplate(
      int clientId, int productId, int employerID) async {
    var result;

    print('sent items ${clientId},${productId},${employerID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print('engine engine');
    print(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual&employerId=${employerID}',
    );
    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual&employerId=${employerID}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('this Status Code ${responsevv.statusCode} ${responsevv.body}');

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;
      print('fetch doe overrides ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getRepaymentFrequency(
      int clientId, int productId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.productEngine +
          '${clientId}' +
          '&productId=${productId}' +
          '&staffInSelectedOfficeOnly=false&templateType=individual',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData['repaymentFrequencyTypeOptions'];
      print('fetch doe overrides ${fetchDoe}');
      result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getSentinelData({var url, var parameter}) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('this is url ${url}');
    try {
      Response responsevv = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      ).timeout(
        Duration(seconds: 90),
        onTimeout: () {
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
        },
      );

      print('response BBBB ${responsevv.statusCode}');
      if (responsevv.statusCode == 404) {
        result = {'status': false, 'message': 'Connection timed out'};
      }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        print('eee ${e}');
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyBVN(var subData) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('subData ${subData}');

    final Map<String, dynamic> kycData = {
      "bvn": subData['bvn'],
      "phone": subData['phone'],
      "accountNumber": subData['accountNumber'],
      "bankCode": subData['bankCode'],
      "sendOtp": true
    };

    try {
      print('urlName ${AppUrl.getKyc} ');

      Response responsevv = await post(
        AppUrl.getKyc,
        body: json.encode(kycData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      ).timeout(
        Duration(seconds: 290),
        onTimeout: () {
          // Closing client here throwns an error
          // client.close(); // Connection closed before full header was received
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );

      print('response BBBB ${responsevv.body}');
      // if (responsevv.statusCode == 500) {
      //   result = {'status': false, 'message': 'Unable to validate BVN'};
      //
      // }
      if (responsevv.statusCode == 404) {
        result = {'status': false, 'message': 'Connection timed out'};
      }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      print('failed request>> ${e}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        print('eee ${e}');
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }



  Future<Map<String, dynamic>> checkAvailability(var subData) async {
    var result;
    final Map<String, dynamic> kycData = {
      "bvn": subData['bvn'],
    };

    print(AppUrl.checkAvailability + '${kycData['bvn']}/checkavailability' );

    try {
      Response responsevv = await get(AppUrl.checkAvailability + '${kycData['bvn']}/checkavailability',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      ).timeout(
        Duration(seconds: 290),
        onTimeout: () {
           result = {
            'status': false,
            'message': 'Connection timed out',
          };
        },
      );
      print('response BBBB ${responsevv.statusCode}');
      if (responsevv.statusCode == 404) {
        result = {'status': false, 'message': 'Connection timed out'};
      }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        print('eee ${e}');
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> changeInterestRate(var subData) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('subData ${subData}');

    final Map<String, dynamic> kycData = {
      "bvn": subData['bvn'],
      "productId": subData['productId'],
      "loanAmount": subData['loanAmount'],
    };

    try {
      print('urlName ${kycData.toString()}');

      Response responsevv = await post(
        AppUrl.interestChannel,
        body: json.encode(kycData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      ).timeout(
        Duration(seconds: 190),
        onTimeout: () {
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
        },
      );

      print('response BBBB ${responsevv.statusCode}');
      // if (responsevv.statusCode == 500) {
      //   result = {'status': false, 'message': 'Unable to validate BVN'};
      //
      // }
      if (responsevv.statusCode == 404) {
        result = {'status': false, 'message': 'Connection timed out'};
      }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        print('eee ${e}');
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getClientProfile(String clientID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleClient + clientID,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;

    return newClientData;
  }

  Future<Map<String, dynamic>> new_getClientProfile(String clientID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleClientForLoanReview + clientID,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;

    return newClientData;
  }



 // https://nx360dev.creditdirect.ng:8443/fineract-provider/api/v1/clients/cdl/292901

  Future<Map<String, dynamic>> remittaChannel(var subData) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('subData ${subData}');

    // final Map<String, dynamic> kycData = {
    //   "bvn": subData['bvn'],
    //   "phone": subData['phone'],
    //   "accountNumber": subData['accountNumber'],
    //   "bankCode": subData['bankCode'],
    //   "sendOtp": true
    // };

    try {
      print('urlName ${AppUrl.remittaReference}');

      Response responsevv = await post(
        AppUrl.remittaReference,
        body: json.encode(subData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      ).timeout(
        Duration(seconds: 290),
        onTimeout: () {
          // Closing client here throwns an error
          // client.close(); // Connection closed before full header was received
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );

      print('response BBBB ${responsevv.statusCode}');
      // if (responsevv.statusCode == 500) {
      //   result = {'status': false, 'message': 'Unable to validate BVN'};
      //
      // }
      if (responsevv.statusCode == 404) {
        result = {'status': false, 'message': 'Connection timed out'};
      }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        print('eee ${e}');
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyAccountNumber(var subData) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('subData ${subData}');

    final Map<String, dynamic> kycData = {
      // "bvn": subData['bvn'],
      //  "phone": subData['phone'],
      "accountNumber": subData['accountNumber'],
      "bankCode": subData['bankCode'],
      //  "sendOtp": true
    };

    try {
      Response responsevv = await post(
        AppUrl.verifyAccountNumber,
        body: json.encode(kycData),
        headers: {
          'Content-Type': 'application/json',
          //  'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': APP_TOKEN,
          // 'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      ).timeout(
        Duration(seconds: 90),
        onTimeout: () {
          // Closing client here throwns an error
          // client.close(); // Connection closed before full header was received
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );

      print('response BBBB ${responsevv.statusCode}');
      // if (responsevv.statusCode == 500) {
      //   result = {'status': false, 'message': 'Unable to validate BVN'};
      //
      // }
      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getMBSBank() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Response responsevv = await get(
        AppUrl.getMBSBank,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      );

      print('response BBBB ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print('phone and otp ${phone} ${otp}');

    try {
      Response responsevv = await get(
        AppUrl.verifyClientOTP + '${phone}/${otp}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      );

      print('response BBBBfinals ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides client OTP ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {
          'status': false,
          'data': {
            "status": false,
            "message": json.decode(responsevv.body)['message'],
            "data": null
          },
          'message': json.decode(responsevv.body)['message']
        };
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': {
            "status": false,
            "message": "Internet connection error.",
            "data": null
          }
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyAccountBumber(var AccountData) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> accountData = {
      "accountNumber": AccountData['accountNumber'],
      "bankCode": AccountData['sortCode']
    };

    try {
      Response responsevv = await post(
        AppUrl.validateBankInfo,
        body: json.encode(accountData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {'status': false, 'message': 'Network_error'};
      }
    }

    return result;
  }



  Future<Map<String, dynamic>> getRiskDetails(
      {String bvn, String productId}) async {
    var result;
   //   print('>> productId ${productId} and ${bvn}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   // print('client bvn >> ${bvn}');
//  print('appUrl >> ${AppUrl.getRisksDetails + '?Bvn=${bvn}&ProductId=${productId}',}');
    try {
      Response responsevv = await get(
        AppUrl.getRisksDetails + '?Bvn=${bvn}&ProductId=${productId}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APP_TOKEN,
        },
      );

      if (responsevv.statusCode == 200) {
        print('responsevv, this is res ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;
        print('fetch doe overrides ${fetchDoe}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {'status': false, 'message': 'Network_error'};
      }
    }

    return result;
  }



  Future<Map<String, dynamic>> getConfigForLoan(
    int loanID,
  ) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getLoanDetails + '${loanID}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('responsevv ${responsevv.body}');

    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var checkLaf = responseData['isLafSigned'];
      var fetchDoe = responseData['configs'][0]['codeData'];
      print('fetch doe overrides ${fetchDoe}');
      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
        'lafStatus': checkLaf
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getLendersLists() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getLendersLists,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('responsevv ${responsevv.body}');

    if (responsevv.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(responsevv.body);

      var fetchDoe = responseData['pageItems'];
      print('fetch doe overrides ${fetchDoe}');
      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> requestLafOTP(int loanID, String mode) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    //   AppUrl.getLoanPaymentLinkMethod + '${loanID}' + '?command=tokenization&mode=${mode}',
    //     AppUrl.getLoanDetails + '${loanID}' + '/laf/otp/both',
    try {
      Response responsevv = await get(
        // AppUrl.getLoanPaymentLinkMethod +
        //     '${loanID}' +
        //     '?command=tokenization&mode=both',
        AppUrl.newSendLafOtp + '${loanID}' + '?channelId=77',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      if (responsevv.statusCode == 200) {
        print('responsevv >> ${responsevv.body}');
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        var fetchDoe = responseData;


        result = {
          'status': true,
          'message': 'Successful',
          'data': fetchDoe,
        };
      } else {
        result = {
          'status': false,
          'message': json.decode(responsevv.body)['errors'][0]['developerMessage']
        };

        print(
            'message >> ${json.decode(responsevv.body)['errors'][0]['developerMessage']}');
      }
    }
    catch(e){
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
       return  result = {'status': false, 'message': 'Internal Server error'};

      }
    }



    return result;


  }

  Future<Map<String, dynamic>> sendLinkToCLient(
      int loanID, String mode, String commandType) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print(AppUrl.getLoanPaymentLinkMethod +
        '${loanID}' +
        '?command=${commandType}&mode=${mode}');
    Response responsevv = await get(
      AppUrl.getLoanPaymentLinkMethod +
          '${loanID}' +
          '?command=${commandType}&mode=${mode}',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<bool> isBvnAvailable(int clientId) async {
    var result;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    Response responsevv = await get(
      AppUrl.getSingleClient + clientId.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    //print(responseData2);
    var newClientData = responseData2;

    print('new client bvn >> ${newClientData['bvn']}');

    if (newClientData['bvn'] != null &&
        newClientData['bvn'].toString().length == 11) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }


    Future<Map<String,dynamic>> lafDocument(int loanID) async{
      var result;
    try{
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        var token = prefs.getString('base64EncodedAuthenticationKey');
        var tfaToken = prefs.getString('tfa-token');

        Response responsevv = await get(
          AppUrl.lafDocument + '${loanID}',
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}',
            'Fineract-Platform-TFA-Token': '${tfaToken}',
          },
        );

        if (responsevv.statusCode == 200) {
          final Map<String,dynamic>responseData = json.decode(responsevv.body);

          var fetchDoe = responseData;
          result = {'status': true, 'message': json.decode(responsevv.body)['defaultUserMessage'], 'data': fetchDoe};
          }
          else {
          result = {'status': false, 'message': json.decode(responsevv.body)['defaultUserMessage']};
           }
           }catch(e){
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
         result = {'status': false, 'message': 'Internal Server Error'};
      }
    }
      print('laf result ${result}');
      return result;

  }

  // Future<Map<String, dynamic>> lafDocument(int loanID) async {
  //   var result;
  //
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var token = prefs.getString('base64EncodedAuthenticationKey');
  //   var tfaToken = prefs.getString('tfa-token');
  //
  //   Response responsevv = await get(
  //     //279 ${loanID}
  //     AppUrl.lafDocument + '${loanID}',
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
  //       'Authorization': 'Basic ${token}',
  //       'Fineract-Platform-TFA-Token': '${tfaToken}',
  //     },
  //   );
  //
  //   final Map<String, dynamic> responseData = json.decode(responsevv.body);
  //
  //
  //   if (responsevv.statusCode == 200) {
  //     result = {'status': true, 'message': 'LAF Generated successfully'};
  //   }
  //   if (responsevv.statusCode == 403) {
  //     result = {'status': false, 'message': 'Customer yet to accept LAF'};
  //
  //   }
  //
  //   else {
  //     result = {'status': false, 'message': 'message'};
  //   }
  //
  //   return result;
  // }


  Future<Map<String, dynamic>> lafDownoad(int loanID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      //279 ${loanID}
      AppUrl.lafDownload + '${loanID}' + '/download',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      // print('responsevv.statusCode ${responsevv.statusCode}');
      // final List<dynamic> responseData = json.decode(responsevv.body);
      // var fetchDoe = responseData;
      //
      // var dir=await getApplicationDocumentsDirectory();
      // String tempPath = dir.path;
      //
      // File file = new File('$tempPath/pdfLaf.png');
      // await file.writeAsBytes(responseData);
      //
      // result = {'status': true, 'message': 'Successful',};

    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyLafOTP(int loanID, String OTPtoken) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(

     // AppUrl.getLoanDetails + '${loanID}' + '/laf/otp/' + OTPtoken + '/accept',
        AppUrl.newVerifyOtp + '${loanID}' + '/${OTPtoken}?channelId=77',
    //  body: json.encode(null),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    // print('did response get here ');
    print(responsevv.body);
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> addNote(
      var note, int loanID, String methodType, int noteId) async {
    print('method type ${methodType}');

    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv;

    if (methodType == 'post') {
      responsevv = await post(
        AppUrl.getLoanDetails + '${loanID}' + '/notes',
        body: json.encode(note),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          // Closing client here throwns an error
          // client.close(); // Connection closed before full header was received
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );
    } else {
      responsevv = await put(
        AppUrl.getLoanDetails + '${loanID}' + '/notes/${noteId}',
        body: json.encode(note),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          // Closing client here throwns an error
          // client.close(); // Connection closed before full header was received
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );
    }

    print('did response get here ');
    print(responsevv.body);
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      print(responsevv.body);
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> SendLoanForApproval(
      var note, int loanID, String approvalType) async {
    ///external/loan/{loanId}/decide
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    //base URL/loan

    // loans/3636?command=draftapprove
    // String url  = approvalType == 'auto_review' ? AppUrl.externalApprove + '${loanID}' + '/decide' : AppUrl.getLoanDetails + '${loanID}?command=draftapprove';
   // String url = AppUrl.getLoanDetails + '${loanID}?command=draftapprove';
    String url = AppUrl.newSendLoanForApproval + '${loanID}';

    print('url ${url}');
    Response responsevv = await post(
      url,
      body: json.encode(note),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('did response get here ');
    print(responsevv.body);
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['errors'][0]['developerMessage']
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> sendForReApprove(
      var note, int approvalId, String approvalType) async {
    ///external/loan/{loanId}/decide
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    //base URL/loan

    // loans/3636?command=draftapprove
    // String url  = approvalType == 'auto_review' ? AppUrl.externalApprove + '${loanID}' + '/decide' : AppUrl.getLoanDetails + '${loanID}?command=draftapprove';
    // String url = AppUrl.getLoanDetails + '${loanID}?command=draftapprove';
    String url = AppUrl.sendForReApprove + '${approvalId}';

    print('url ${url}');
    Response responsevv = await post(
      url,
      body: json.encode(note),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    print('did response get here ');
    print(responsevv.body);
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['errors'][0]['developerMessage']
      };
    }

    return result;
  }


  Future<Map<String, dynamic>> requestemployerValidation(
      int clientID, String mode) async {
    var result;

    print('client iD ${clientID} ${mode}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleClient + '${clientID}' + '/employers/otp/' + mode,
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );

    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> employerValidation(
      int clientID, String tokenReceived) async {
    var result;

    print('client iD ${clientID} ${tokenReceived}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    final Map<String, String> validationData = {
      "token": tokenReceived,
    };
    Response responsevv = await post(
      AppUrl.getSingleClient +
          '${clientID}' +
          '/employers/otp/validate?token=${tokenReceived}',
      // AppUrl.getSingleClient + '913' + '/employers/otp/validate',
      body: json.encode(null),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.statusCode);
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else if (responsevv.statusCode == 404) {
      result = {
        'status': false,
        'message': 'Unable to validate OTP',
      };
    } else {
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }




  Future<Map<String, dynamic>> bankStatementAnalyser(
      var analysisData, int loanId, int clientId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    print('analysisdata ${analysisData} ${loanId} ${clientId}');
    //'${analysisData['loanId']}
    //   AppUrl.getLoanDetails + clientId.toString() + '/analyse/bankstatement/6/verify',
    // https://192.168.88.64:8443/fineract-provider/api/v1/loans/292657/analyse/bankstatement/6/verify

    Response responsevv = await post(
      // AppUrl.getLoanDetails + loanId.toString() + '/analyse/bankstatement/6',
      AppUrl.getLoanDetails + clientId.toString() + '/decide',
      body: json.encode(analysisData),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print('responsevv.statusCode ${responsevv.statusCode}');
    if (responsevv.statusCode == 200) {
      print(responsevv);
      final Map<String, dynamic> responseData = json.decode(responsevv.body);
      var fetchDoe = responseData;

      result = {
        'status': true,
        'message': 'Successful',
        'data': fetchDoe,
      };
    } else {
      if (responsevv.statusCode == 500) {
        result = {'status': false, 'message': 'Server error, please try again'};
      }
      result = {'status': false, 'message': json.decode(responsevv.body)};
    }

    return result;
  }

  Future<Map<String, dynamic>> getEmployersBranch(int firstValue) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    //2645

    try {
      Response responsevv = await get(
        AppUrl.allEmployersBranch + '${firstValue}',
        // AppUrl.allEmployersBranch + '2645',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');

        var fetchDoe = responseData;

        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> loanPermission(int staffId,int clientId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    //2645
    AppUrl appUrl = AppUrl();
    String request_url = appUrl.loan_permission(staffId, clientId);
    try {
      Response responsevv = await get(
        request_url,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

     // print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(responsevv.body);
 //       print('from auth provider');
        var fetchDoe = responseData;
        print('loan permission >> ${responseData}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
         result = {'status': false, 'message': 'Internal server error',};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> getLoanOfferForClient(int clientId) async {
    var result;

    //2645
    AppUrl appUrl = AppUrl();
    String request_url = appUrl.getLoanOfferForClient(clientId);
    try {
      Response responsevv = await get(
        request_url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${USSD_BEARER}',
        },
      );

       print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(responsevv.body);
        //       print('from auth provider');
        var fetchDoe = responseData;
        print('offers lists>> ${responseData}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Internal server error',};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> getEmailValidationStatus(int clientId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    AppUrl appUrl = AppUrl();
    String requestUrl = appUrl.getOrPostEmailValidationStatus(clientId, false);
    try {
      Response response = await get(
        requestUrl,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic $token',
          'Fineract-Platform-TFA-Token': '$tfaToken',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        // Decode the response body as a JSON object
        final List<dynamic> responseData = json.decode(response.body);

        // Ensure the responseData is not empty
        if (responseData.isNotEmpty) {
          var fetchDoe = responseData[0]; // Access the first element in the array
          print('email val >> ${fetchDoe}');
          result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
        } else {
          result = {'status': false, 'message': 'Response data is empty'};
        }
      } else {
        result = {'status': false, 'message': json.decode(response.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': e.toString()};
      }
    }

    return result;
  }


  Future<Map<String, dynamic>> postEmailValidationStatus(int clientId,Map<String,dynamic> emailData) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    AppUrl appUrl = AppUrl();
    String request_url = appUrl.getOrPostEmailValidationStatus(clientId,false);
    try {
      Response responsevv = await post(
        request_url,
        body: json.encode(emailData),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(responsevv.body);
        //       print('from auth provider');
        var fetchDoe = responseData;
        print('email val >> ${responseData}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Internal server error',};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> putEmailValidationStatus(int clientId,Map<String,dynamic> emailData) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    AppUrl appUrl = AppUrl();
    String request_url = appUrl.getOrPostEmailValidationStatus(clientId,false);
    try {
      Response responsevv = await put(
        request_url,
        body: json.encode(emailData),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(responsevv.body);
        //       print('from auth provider');
        var fetchDoe = responseData;
        print('email val >> ${responseData}');
        result = {'status': true, 'message': 'Successful', 'data': fetchDoe};
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Internal server error',};

      }
    }

    return result;
  }



  Future<Map<String, dynamic>> getRcoveryLists() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.loanCollection,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');

        var sendDataToFrontEnd = responseData;

        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> calculateSettlement() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.loanCollection,
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');

        var sendDataToFrontEnd = responseData;

        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> calculateRepayment(
      var calculateReschedule) async {
    print('repaymnent ${calculateReschedule}');
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    print(
        'calculate reschedule ${calculateReschedule} ${AppUrl.loanRepaymentCalculator}');

    try {
      Response responsevv = await post(
        AppUrl.loanSchedule,
        body: json.encode(calculateReschedule),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> loanRepaymentCalculator(
      var calculateReschedule) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await post(
        AppUrl.loanRepaymentCalculator,
        body: json.encode(calculateReschedule),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> new_loanRepaymentCalculator(
      var calculateReschedule) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await post(
        AppUrl.new_loanRepaymentCalculator,
        body: json.encode(calculateReschedule),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      }
      else {

        //
          result = {'status': false, 'message': json.decode(responsevv.body)['errors'][0]['developerMessage']};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }


  Future<Map<String, dynamic>> getSttlement(
      int loanID, String todayDate) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print('todayDate ${todayDate}');

    try {
      print(
          'Payload >> ${AppUrl.getLoanDetails + '${loanID}/transactions/template?command=foreclosure&dateFormat=dd MMMM yyyy&locale=en&transactionDate=${todayDate}'}');
      Response responsevv = await get(
        AppUrl.getLoanDetails +
            '${loanID}/transactions/template?command=foreclosure&dateFormat=dd MMMM yyyy&locale=en&transactionDate=${todayDate}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider settlement balance ');
        var sendDataToFrontEnd = responseData;
        print('settleement ${sendDataToFrontEnd}');
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getLoanNote(int loanID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getLoanDetails + '${loanID}/notes',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Successful'};
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getApprovals(int loanID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getApprovals + '${loanID}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Successful'};
      }
    }

    return result;
  }


  Future<Map<String, dynamic>> getEmployerInLoanView(
      int loanID, var employer) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    Map<String, dynamic> employmentData = {
      "employeeNumber": employer['employeeNumber'],
      "employerId": employer['employerId'],
      "note": employer['note'],
    };

    print('called >> ${employmentData}');

    try {
      Response responsevv = await put(
        AppUrl.getLoanDetails + '${loanID}/employer',
        body: json.encode(employmentData),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print('>>>> ${responsevv.statusCode} ${(responsevv.body)}');

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      print('eee << ${e.toString()}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Unknown server error'};
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getDocumentNote(int loanID) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
// loans/{loanId}/documents/all
    try {
      Response responsevv = await get(
        AppUrl.getLoanDetails + '${loanID}/documents/all',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);
      print(responsevv.statusCode);

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Successful'};
      }
    }

    return result;
  }


  Future<Map<String, dynamic>> get_SingleDocument(int loanID,int documentId) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
// URL: "https://40.113.169.208:8443/fineract-provider/api/v1/loans/268558/documents/base64/16405"
    try {
      Response responsevv = await get(
        AppUrl.getLoanDetails + '${loanID}/documents/base64/${documentId}',
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print(responsevv.body);
      print((responsevv.statusCode));

      if (responsevv.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {'status': false, 'message': 'Failed'};
      }
    }

    return result;
  }


  Future<Map<String, dynamic>> addDocument(int loanID, var docObject) async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await post(
        AppUrl.getLoanDetails + '${loanID}/documents/bulkbase64',
        body: json.encode(docObject),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': 'Basic ${token}',
          'Fineract-Platform-TFA-Token': '${tfaToken}',
        },
      );

      print('responsevv.body ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;
        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Successful',
        };
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getProductInformation() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      Response responsevv = await get(
        AppUrl.getProductInformation,
        headers: {
          'Content-Type': 'application/json',
          // 'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': PRODUCT_INFO_TOKEN,
        },
      );

      print('responsevv.body ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        final List<dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;

        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Successful',
        };
      }
    }

    // var sendDataToFrontEnd = [
    //   {
    //     "name":"fed Speed",
    //     "sector":"public",
    //     "description":"fed Speed",
    //     "documentNTB": "fjdfj,dffdjdf,dfdfdf",
    //     "documentTopUp": "fjdfj,dffdjdf,dfdfdf",
    //     "documentSettlemnt": "fjdfj,dffdjdf,dfdfdf",
    //
    //   }
    //
    // ];
    // result = {'status': true, 'message': 'Successful', 'data': sendDataToFrontEnd};

    return result;
  }

  Future<Map<String, dynamic>> getProductCycle() async {
    var result;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);

    try {
      print('App Url ${AppUrl.getProductCycle}');
      Response responsevv = await get(
        AppUrl.getProductCycle,
        headers: {
          'Content-Type': 'application/json',
          // 'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
          'Authorization': PRODUCT_INFO_TOKEN,
        },
      );

      print('responsevv.body ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;

        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Successful',
        };
      }
    }

    // var sendDataToFrontEnd = [
    //   {
    //     "name":"fed Speed",
    //     "sector":"public",
    //     "description":"fed Speed",
    //     "documentNTB": "fjdfj,dffdjdf,dfdfdf",
    //     "documentTopUp": "fjdfj,dffdjdf,dfdfdf",
    //     "documentSettlemnt": "fjdfj,dffdjdf,dfdfdf",
    //
    //   }
    //
    // ];
    // result = {'status': true, 'message': 'Successful', 'data': sendDataToFrontEnd};

    return result;
  }

  Future<Map<String, dynamic>> getProductMetrics(
      String loanOfficerId, String cycleId) async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String loanOfficer = prefs.getString('loanOfficerId');

    //print('this is the officer ID ${loanOfficer}');
    // =1377&cycleId=3
    var result;

    try {
      print(
        'App Url  ${AppUrl.getProductMetrics} ${loanOfficerId}&cycleId=${cycleId}',
      );
      Response responsevv = await get(
        AppUrl.getProductMetrics + '${loanOfficerId}&cycleId=${cycleId}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': PRODUCT_INFO_TOKEN,
        },
      );

      print('responsevv.body ${responsevv.statusCode}');

      if (responsevv.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responsevv.body);
        print('from auth provider');
        var sendDataToFrontEnd = responseData;

        result = {
          'status': true,
          'message': 'Successful',
          'data': sendDataToFrontEnd
        };
      } else {
        result = {'status': false, 'message': json.decode(responsevv.body)};
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      } else {
        result = {
          'status': false,
          'message': 'Successful',
        };
      }
    }

    // var sendDataToFrontEnd = [
    //   {
    //     "name":"fed Speed",
    //     "sector":"public",
    //     "description":"fed Speed",
    //     "documentNTB": "fjdfj,dffdjdf,dfdfdf",
    //     "documentTopUp": "fjdfj,dffdjdf,dfdfdf",
    //     "documentSettlemnt": "fjdfj,dffdjdf,dfdfdf",
    //
    //   }
    //
    // ];
    // result = {'status': true, 'message': 'Successful', 'data': sendDataToFrontEnd};

    return result;
  }

  Future<Map<String, dynamic>> get_encryptAndSend(Map<String,dynamic> userData) async {
    try {
      // appCloakLogin();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> requestData = _buildRequestData(requestPayload: userData);
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(requestData);
      // _loggedInStatus = Status.Authenticating;
      // notifyListeners();
      print('enc data >> ${encData}');
        AppUrl appUrl = AppUrl();
  String request_url =     appUrl.appThirdParty(
          userData['channelId'],
          userData['staffId'],
          userData['companyUUId']);
      String accessToken = prefs.getString('cloak_access_token');
///
      print('>> request url >> ${request_url}');
      Response response = await _postWithTimeout(
        request_url,
        json.encode(null),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

    //  print('>> response body 111 ${response.body}');
      return _handle_successfulResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post_encryptAndSend(Map<String,dynamic> userData,{int tp_customerId,int channelId}) async {
    try {
      // appCloakLogin();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var token = prefs.getString('base64EncodedAuthenticationKey');
      var tfaToken = prefs.getString('tfa-token');

    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> requestData = _buildRequestData(requestPayload: userData,authCode: token,extendedToken: tfaToken);
      print('request data ${requestData}');
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(requestData);
      // _loggedInStatus = Status.Authenticating;
      // notifyListeners();
      print('enc data >> ${encData}');
      AppUrl appUrl = AppUrl();
      String request_url =     appUrl.book_thirdparty_loan(
        channelId ??  1,
        tp_customerId,);
      String accessToken = prefs.getString('cloak_access_token');

      Response response = await _postWithTimeout(
        request_url,
        json.encode(encData),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );


      return _handle_successfulResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> fetch_wacs_profile(Map<String,dynamic> userData,{String staffId}) async {
    try {
      // appCloakLogin();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var token = prefs.getString('base64EncodedAuthenticationKey');
      var tfaToken = prefs.getString('tfa-token');

      //  final SharedPreferences prefs = await SharedPreferences.getInstance();
       Map<String, dynamic> requestData = _buildRequestData(requestPayload: userData,authCode: token,extendedToken: tfaToken);
      print('this is request data >> ${requestData}');
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(requestData);
      // _loggedInStatus = Status.Authenticating;
      // notifyListeners();
      print('enc data >> ${encData}');
      AppUrl appUrl = AppUrl();
      String request_url =     appUrl.fetch_wacs_info(
        2,
        staffId,);
      String accessToken = prefs.getString('cloak_access_token');

      Response response = await _postWithTimeout(
        request_url,
        json.encode(encData),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

      return _handle_successfulResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }





  Map<String, dynamic> _handleException(Exception e) {
    if (e.toString().contains('SocketException') || e.toString().contains('HandshakeException')) {
      return _generateErrorResponse('Network error: No Internet connection', 500);
    } else {
      return _generateErrorResponse('Unable to fetch data', 404);
    }
  }

  Map<String, dynamic> _generateErrorResponse(String message, int statusCode) {
    return {
      'status': false,
      'message': message,
      'statusCode': statusCode,
    };
  }


  Map<String, dynamic> _handleError(dynamic error) {
    print('Error: $error');
    if (error.toString().contains('SocketException') || error.toString().contains('HandshakeException')) {
      // _loggedInStatus = Status.NotLoggedIn;
      // notifyListeners();
      return {'status': false, 'message': 'Network error', 'data': 'No Internet connection'};
    }

    return {'status': false, 'message': 'An unexpected error occurred'};
  }

  Future<Response> _postWithTimeout(String url, String body, Map<String, String> headers) async {
    try {
      return await post(
        url,
        body: body,
        headers: headers,
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          // _loggedInStatus = Status.NotLoggedIn;
          // notifyListeners();
          return null;
        },
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Response> _getWithTimeout(String url, Map<String, String> headers) async {
    try {
      return await get(
        url,
        headers: headers,
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          // _loggedInStatus = Status.NotLoggedIn;
          // notifyListeners();
          return null;
        },
      );
    } catch (e) {
      throw e;
    }
  }



  Map<String, dynamic> _handle_successfulResponse(Response response) {
    print('response type >> ${response.statusCode}');
    if (response.statusCode == 401 ) {
      return {'status': false, 'message': "Auth service not available, contact support",'statusCode': 401};
    }
    if (response == null) {
      // _loggedInStatus = Status.NotLoggedIn;
      // notifyListeners();
      return {'status': false, 'message': 'Connection timed out'};
    }


    if (response.statusCode == 200) {
      return _handleSuccessfulResponse(response);
    }
    else {
      // _loggedInStatus = Status.NotLoggedIn;
      // notifyListeners();
      final Map<String, dynamic> encryptedResponseData = json.decode(response.body);
      return {'status': false, 'message': encryptedResponseData['message'],'statusCode': response.statusCode};
    }
  }

  Map<String, dynamic> _handleSuccessfulResponse(Response response) {
    final Map<String, dynamic> encryptedResponseData = json.decode(response.body);
    print('>> enc response ${encryptedResponseData}');
    String decryptResult = encryptedResponseData['result'];
    print('>> dec result ${decryptResult}');
    String decryptedResponse = EncryptOrDecrypt().decryptText(decryptResult);
    print('>> dec response ${decryptedResponse}');
    Map<String, dynamic> responseData = jsonDecode(decryptedResponse);

    var userData = responseData;
    // User authUser = User.fromJson(userData);
    // UserPreferences().saveUser(authUser);
    // _loggedInStatus = Status.LoggedIn;
    // notifyListeners();
    // encTwofactor();
    return {'status': true, 'message': 'Successful','data': responseData,'statusCode': response.statusCode};
  }


  // Map<String, dynamic> _buildRequestData(Map<String,dynamic> appRequest) {
  //   return {
  //     "authorization": "",
  //     "extendedToken": "",
  //   //  "userImeiNumber": "2332332545454",
  //     "requestPayload": appRequest,
  //   };
  // }

  Map<String, dynamic> _buildRequestData(
      {String authCode,
        String extendedToken,
        Map<String, dynamic> requestPayload}) {
    return {

      "authorization": 'Basic $authCode',
      "extendedToken": extendedToken ?? '',
     // "userImeiNumber": "2332332545454",
      "requestPayload": requestPayload,
    };
  }


}
