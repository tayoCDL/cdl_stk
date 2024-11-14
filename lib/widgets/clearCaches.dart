
import 'package:shared_preferences/shared_preferences.dart';

class ClearCaches {

      clearMems() async{
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        //    prefs.remove('leadToClientID');
        prefs.remove('leadId');
        prefs.remove('employerResourceId');
        prefs.remove('tempEmployerInt');
        prefs.remove('tempNextOfKinInt');
        prefs.remove('tempResidentialInt');
        prefs.remove('tempResidentialInt');
      }

}