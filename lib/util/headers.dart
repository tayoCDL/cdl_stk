
import 'package:shared_preferences/shared_preferences.dart';

class Header {

      static dynamic headerFile() async{
        final SharedPreferences prefs = await SharedPreferences.getInstance();

      }

    showHeader() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var token = prefs.getString('base64EncodedAuthenticationKey');
      var tfaToken = prefs.getString('tfaToken');

      Map <String,dynamic>  heads=  {
        'Content-Type': 'application/json',
      'Fineract-Platform-TenantId': 'default',
      'Authorization': 'Basic ${token}',
      'Fineract-Platform-TFA-Token': '${tfaToken}',
    };

      return heads;
    }


}
