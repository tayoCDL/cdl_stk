//import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:sales_toolkit/widgets/constants.dart';

class AppTracker{
  //  Mixpanel mixpanel;
    String mixPanelToken = '01bcb7ad255ab432c537f04276890aed';
    trackActivity(String eventName, {Map<String, dynamic> payLoad}) async{
      // mixpanel = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
      //  mixpanel.track(eventName, properties: {...payLoad,"environment":APP_ENVIRONMENT,"Channel":"Salestoolkit"});
    }

    identifyUser(String distinctId) async{
  //     mixpanel = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
  // //    mixpanel.registerSuperPropertiesOnce({'User': 'SalesAgent'});
  //     mixpanel.identify(distinctId);
    }

    getPeople_Set({String props, String to}) async{
      // mixpanel = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
      // mixpanel.getPeople().set(props, to);
    }

    getPeople_Append({String props, String to}) async{
      // mixpanel = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
      // mixpanel.getPeople().append(props, to);
    }




}