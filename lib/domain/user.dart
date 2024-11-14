class User {
  String username;
  int userId;
  String base64EncodedAuthenticationKey;
  bool authenticated;
  int officeId;
  int staffId;
  String officeName;
  String staffDisplayName;
  List<dynamic> roles;
  List<dynamic> permissions;
  bool shouldRenewPassword;
  bool isTwoFactorAuthenticationRequired;


  User({this.username,
    this.userId,
    this.base64EncodedAuthenticationKey,
    this.authenticated,
    this.officeId,
    this.staffId,
    this.officeName,
    this.staffDisplayName,
    this.roles,
    this.permissions,
    this.shouldRenewPassword,
    this.isTwoFactorAuthenticationRequired,
  });

  // now create converter

  factory User.fromJson(Map<String,dynamic> responseData){
    return User(
      username: responseData['username'],
      userId: responseData['userId'],
      base64EncodedAuthenticationKey : responseData['base64EncodedAuthenticationKey'],
      authenticated: responseData['authenticated'],
      officeId : responseData['officeId'],
      officeName : responseData['officeName'],
      staffId: responseData['staffId'],
      staffDisplayName: responseData['staffDisplayName'],
      roles: responseData['roles'],
      permissions: responseData['permissions'],
      shouldRenewPassword: responseData['shouldRenewPassword'],
      isTwoFactorAuthenticationRequired: responseData['isTwoFactorAuthenticationRequired'],
    );
  }
}
