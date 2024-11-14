import 'package:flutter/cupertino.dart';

class MyRouter{
  static Future pushPage(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );

    return val;
  }

  static Future pushPageDialog(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
//fa5be3f9-1e5a-42db-a229-9d0d271e8daa
    return val;
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }


  static popPage(BuildContext context){
    Navigator.pop(context);
  }
}
