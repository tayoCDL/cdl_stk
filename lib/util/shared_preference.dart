
import 'package:sales_toolkit/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId',user.userId);
    prefs.setString('username',user.username);
    prefs.setString('base64EncodedAuthenticationKey',user.base64EncodedAuthenticationKey);
    prefs.setBool('authenticated',user.authenticated);
    prefs.setInt('officeId',user.officeId);
    prefs.setString('officeName',user.officeName);
    prefs.setInt('staffId',user.staffId);
    prefs.setString('staffDisplayName',user.staffDisplayName);
    prefs.setBool('shouldRenewPassword',user.shouldRenewPassword);
    prefs.setBool('isTwoFactorAuthenticationRequired',user.isTwoFactorAuthenticationRequired);


    return prefs.commit();

  }

  Future<User> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId");
    String username = prefs.getString("username");
    String base64EncodedAuthenticationKey = prefs.getString("base64EncodedAuthenticationKey");
    bool authenticated = prefs.getBool("authenticated");
    int officeId = prefs.getInt("officeId");
    String officeName = prefs.getString("officeName");
    int staffId = prefs.getInt("staffId");
    String staffDisplayName = prefs.getString("staffDisplayName");
    bool shouldRenewPassword = prefs.getBool("shouldRenewPassword");
    bool isTwoFactorAuthenticationRequired = prefs.getBool("isTwoFactorAuthenticationRequired");


    return User(
        userId: userId,
        username: username,
        base64EncodedAuthenticationKey: base64EncodedAuthenticationKey,
        authenticated: authenticated,
        officeId: officeId,
        officeName: officeName,
        staffId: staffId,
        staffDisplayName: staffDisplayName,
        shouldRenewPassword: shouldRenewPassword,
        isTwoFactorAuthenticationRequired: isTwoFactorAuthenticationRequired

    );

  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('username');
    prefs.remove('base64EncodedAuthenticationKey');
    prefs.remove('authenticated');
    prefs.remove('officeName');
    prefs.remove('staffDisplayName');

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("base64EncodedAuthenticationKey");
    return token;
  }

}