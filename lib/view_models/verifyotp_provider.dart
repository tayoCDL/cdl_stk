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
  notVerified,
  Verifying,
  Verified
}


class VerifyOtpProvider extends ChangeNotifier {
  Status _verifiedStatus = Status.notVerified;

  Status get verifiedInStatus => _verifiedStatus;

  set verifiedInStatus(Status value) {
    _verifiedStatus = value;
  }


  notify(){
    notifyListeners();
  }

  static Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);

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

    }
    else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.get('base64EncodedAuthenticationKey');

    print('token');
    print(token);

    var result;

    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };

    _verifiedStatus = Status.Verifying;
    notifyListeners();

    // var url =
    // Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

    final Map<String, String> verifyData = {
      'deliveryMethod': "email",
      'extendedToken': "true"
    };

    // Response response =  await get(
    //   AppUrl.twofactor + '?deliveryMethod=email&extendedToken=true',
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
    //     'Authorization': 'Basic ${token}',
    //   },
    // );


    Response response = await post(
      AppUrl.twofactor,
      body: json.encode(verifyData),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
      },
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('from auth provider');
      print(responseData);
      print('end from auth provider');

      var userData = responseData;
      User authUser = User.fromJson(userData);
      UserPreferences().saveUser(authUser);
      _verifiedStatus = Status.Verified;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};

    } else {
      _verifiedStatus = Status.notVerified;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

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