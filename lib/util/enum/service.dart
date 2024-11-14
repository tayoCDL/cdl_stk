

import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:sales_toolkit/domain/ClientsList.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientsApi {
  static ClientsApi _instance;

  ClientsApi._();

  static ClientsApi get instance {
    if (_instance == null) {
      _instance = ClientsApi._();
    }
    return _instance;
  }

  Future<List<ClientsListData>> getAllUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');

    final getUser =
    await http.get(AppUrl.ClientsList,    headers: {
      'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': 'default',
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '5505ba24f866486aac7f4bd8aa15b0d0',
    });
    final List responseBody = jsonDecode(getUser.body);
    return responseBody.map((e) => ClientsListData.fromJson(e)).toList();
  }
}