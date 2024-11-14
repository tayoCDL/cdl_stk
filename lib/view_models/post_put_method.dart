import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_url.dart';
import '../widgets/constants.dart';

class PostAndPut{
  isClientActive(int clientID) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getSingleClient + clientID.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    final Map<String,dynamic> responseData2 = json.decode(responsevv.body);

    var newClientData = responseData2;

    String clientStatus =newClientData['status']['value'];

    return clientStatus;

   }


}