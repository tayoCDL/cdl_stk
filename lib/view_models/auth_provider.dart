import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/domain/user.dart';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_service.dart';
import 'package:sales_toolkit/util/app_tracker.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/encryptDecrypt.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  notify() {
    notifyListeners();
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;

    final Map<String, dynamic> responseData = json.decode(response.body);

    // print(responseData);

    if (response.statusCode == 200) {
      var userData = responseData['data'];

      // now we will create a user model
      User authUser = User.fromJson(responseData);

      // now we will create shared preferences and save data
      UserPreferences().saveUser(authUser);

      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Successfully registered',
        'data': responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> login(

      String username, String password, String login_type,{bool isAgent}) async {


    // app_cloak_login();
    print('>> isAgent ${isAgent}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String seQuestPassword = prefs.getString('sequestpassword');

    var result;

    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

//hnrfxksazeekn

    final Map<String, String> sequestLoginData = {
      "username": "MobileUser",
      "email": "mobuser@fcmb.com",
      "password": seQuestPassword
    };

    //
    // Response Sequestresponse = await post(
    //   Uri.parse(AppUrl.sequestLogin),
    //   body: json.encode(sequestLoginData),
    //   headers:<String, String> {
    //    'cache-control': 'no-cache',
    //     'Content-Type': 'application/json; charset=UTF-8',
    //
    //   },
    // ).timeout(
    //   Duration(seconds: 90),
    //   onTimeout: () {
    //     // Closing client here throwns an error
    //     // client.close(); // Connection closed before full header was received
    //     _loggedInStatus = Status.NotLoggedIn;
    //
    //     result = {'status': false, 'message': 'Connection timed out',};
    //     //
    //   },);

    String url = username.contains('salestoolkit@qa.team') || isAgent == true ? AppUrl.login : AppUrl.login_ldap;
     //   print('login_url ${url}');
//   String url = AppUrl.login;
    try {
      Response response = await post(
        url,
        body: json.encode(loginData),
        headers: {
          'Content-Type': 'application/json',
          'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        },
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          _loggedInStatus = Status.NotLoggedIn;
          notifyListeners();
          result = {
            'status': false,
            'message': 'Connection timed out',
          };
          //
        },
      );

    //  var appDynamic = AppService().post(url,data: loginData);;

      // appDynamic.then((value) =>
      //     print('app value ${value.data}')
      // );
      if (response == null) {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        return result = {
          'status': false,
          'message': 'Connection timed out',
        };
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
     //   print('>> staffId ${responseData['staffId'].toString()}');
        AppTracker().trackActivity('Login Attempt',payLoad: {"email": username,"userId": responseData['staffId']});
        AppTracker().identifyUser(responseData['staffId'].toString());
        AppTracker().getPeople_Set(props: "email",to: username);
        AppTracker().getPeople_Append(props: "name",to: responseData['staffDisplayName']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('base64EncodedAuthenticationKey',
            responseData['base64EncodedAuthenticationKey']);

        String roleName = responseData['roles'][0]['name'];
        prefs.setString('roleName', roleName);

        prefs.setString('login_type', login_type);
        print('vasEncoded ');

        // var sequestTokenTaker = prefs.setString('sequestToken', sequestData['token']);

        print('from auth provider');
        print(responseData);
        print('end from auth provider');

        var token = prefs.getString('base64EncodedAuthenticationKey');
        // print('base 64 token ${token}');

        Response responsevv = await post(
          AppUrl.twofactor + 'email&extendedToken=true',
          body: json.encode(null),
          headers: {
            'Content-Type': 'application/json',
            'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
            'Authorization': 'Basic ${token}'
          },
        );

        var userData = responseData;
        User authUser = User.fromJson(userData);
        UserPreferences().saveUser(authUser);
        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        print(responseData2);

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      }
      else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        print('Json ${response.body}');
        notifyListeners();
        result = {
          'status': false,
          // 'message': json.decode(response.body)['error']
          'message': 'Invalid username or password'
        };
      }

      return result;
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        _loggedInStatus = Status.NotLoggedIn;

        notifyListeners();
        return result = {
          'status': false,
          'message': 'Network error',
          'data': 'No Internet connection'
        };
      }
    }
  }

  static onError(error) {
    print('the error is ${error.detail}');
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  Future<Map<String, dynamic>> encTwofactor() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('n');
      Map<String, dynamic> loginData = EncryptOrDecrypt().buildtwofactorData(authCode: token,requesPayload: null,extendedToken: '');
      print('loginData >> ${loginData}');
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(loginData);
      _loggedInStatus = Status.Authenticating;
      notifyListeners();
      String twoFactorUrl = AppUrl.enc_two_factor;
      String accessToken = prefs.getString('cloak_access_token');

      Response response = await _postWithTimeout(
        twoFactorUrl,
        json.encode(encData),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

 //     return _handleSuccessResponse(response, 'login');
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> encValidatefactor(String two_factor_code) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('base64EncodedAuthenticationKey');

      Map<String, dynamic> loginData = EncryptOrDecrypt().buildtwofactorData(authCode: token,requesPayload: null,extendedToken: '');
      print('loginData >> ${loginData}');
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(loginData);
      _loggedInStatus = Status.Authenticating;
      notifyListeners();

      String twoFactorUrl = AppUrl.enc_valdate_two_factor+two_factor_code;
      String accessToken = prefs.getString('cloak_access_token');

      Response response = await _postWithTimeout(
        twoFactorUrl,
        json.encode(encData),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

           return _handleTwoFactorResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> encryptAndLogin(
      String username, String password, String loginType) async {
    try {
     // appCloakLogin();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> loginData = _buildLoginData(username, password);
      Map<String, dynamic> encData = EncryptOrDecrypt().buildEncData(loginData);
      _loggedInStatus = Status.Authenticating;
      notifyListeners();

      String loginUrl = AppUrl.enc_login;
      String accessToken = prefs.getString('cloak_access_token');

      Response response = await _postWithTimeout(
        loginUrl,
        json.encode(encData),
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

      return _handleLoginResponse(response, loginType);
    } catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _buildLoginData(String username, String password) {
    return {
      "authorization": "",
      "extendedToken": "",
      "userImeiNumber": "2332332545454",
      "requestPayload": {"username": username, "password": password},
    };
  }

  Map<String, dynamic> _handleLoginResponse(Response response, String loginType) {
    if (response == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      return {'status': false, 'message': 'Connection timed out'};
    }

    if (response.statusCode == 200) {
      return _handleSuccessfulLogin(response, loginType);
    }
    else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      return {'status': false, 'message': 'Invalid username or password'};
    }
  }

  Object _handleTwoFactorResponse(Response response) {
    if (response == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      return {'status': false, 'message': 'Connection timed out'};
    }

    if (response.statusCode == 200) {
      return _handleSuccessfulValidateTwoFA(response);
    }
    else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      return {'status': false, 'message': 'Invalid username or password'};
    }
  }

  Map<String, dynamic> _handleSuccessfulLogin(Response response, String loginType) {
    final Map<String, dynamic> encryptedResponseData = json.decode(response.body);
    String decryptResult = encryptedResponseData['result'];
    String decryptedResponse = EncryptOrDecrypt().decryptText(decryptResult);

    Map<String, dynamic> responseData = jsonDecode(decryptedResponse);

    var userData = responseData;
    User authUser = User.fromJson(userData);
    UserPreferences().saveUser(authUser);
    _loggedInStatus = Status.LoggedIn;
    notifyListeners();
    encTwofactor();
    return {'status': true, 'message': 'Successful', 'user': authUser};
  }


  Future<Map<String, dynamic>> _handleSuccessfulValidateTwoFA(Response response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encryptedResponseData = json.decode(response.body);
    String decryptResult = encryptedResponseData['result'];
    String decryptedResponse = EncryptOrDecrypt().decryptText(decryptResult);

    Map<String, dynamic> responseData = jsonDecode(decryptedResponse);

    // var userData = responseData;
    // User authUser = User.fromJson(userData);
    // UserPreferences().saveUser(authUser);
    // _loggedInStatus = Status.LoggedIn;
    // notifyListeners();

    var tfaToken = prefs.setString('tfa-token', responseData['token']);

    notifyListeners();

    return {'status': true, 'message': 'Successful',};

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
          _loggedInStatus = Status.NotLoggedIn;
          notifyListeners();
          return null;
        },
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> appCloakLogin() async {
    print('running key cloak');
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cloakRequest = EncryptOrDecrypt().cloakCredentials();
      String url = AppUrl.login_cloak;

      Response response = await _postWithTimeout(
        url,
        json.encode(cloakRequest),
        {'Content-Type': 'application/json'},
      );

      if (response == null) {
        return {'status': false, 'message': 'Connection timed out'};
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String cloakAccessToken = responseData['accessToken'];
        print('cloak access token >> ${cloakAccessToken}');
        prefs.setString('cloak_access_token', cloakAccessToken);
      }

      return {'status': true, 'message': 'Successful'};
    } catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleError(dynamic error) {
    print('Error: $error');
    if (error.toString().contains('SocketException') || error.toString().contains('HandshakeException')) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      return {'status': false, 'message': 'Network error', 'data': 'No Internet connection'};
    }

    return {'status': false, 'message': 'An unexpected error occurred'};
  }
}
