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
  Initiate,
  NotSent,
  Sent,
  Sending,
}

class SendOtpProvider extends ChangeNotifier {
  Status _otpStatus = Status.Initiate;

  Status get otpStatus => _otpStatus;

  set otpStatus(Status value) {
    _otpStatus = value;
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

  Future<Map<String, dynamic>> twofactor( String deliveryMethod) async {
    var result;

    _otpStatus = Status.Sending;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    print(token);
    Response responsevv = await post(
      AppUrl.twofactor + '${deliveryMethod}&extendedToken=true',
      body: json.encode(null),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}'
      },
    );
    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);

    //2
    _otpStatus = Status.Sent;
    notifyListeners();

    return result;

  }

  Future<Map<String, dynamic>> validatetwofactor(String rToken) async {
    var result;
    print(rToken);
    _otpStatus = Status.Sending;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    print(token);
    Response responsevv = await post(
      AppUrl.validateTwofactor+rToken,
      body: json.encode(null),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}'
      },
    );
    print(responsevv.body);

    if(responsevv.statusCode == 200 || responsevv.statusCode == 201){
      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
      print(responseData2);

      var tfaToken = prefs.setString('tfa-token', responseData2['token']);

      _otpStatus = Status.Sent;
      notifyListeners();

      result = {'status': true, 'message': 'Successful',};
    } else {
      _otpStatus = Status.NotSent;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(responsevv.body)['error']
      };
    }

    print('result');
    print(result);
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