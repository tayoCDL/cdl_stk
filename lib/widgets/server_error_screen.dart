import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sales_toolkit/util/router.dart';

class ServerErrorScreen extends StatefulWidget {
  const ServerErrorScreen({Key key}) : super(key: key);

  @override
  _ServerErrorScreenState createState() => _ServerErrorScreenState();
}

class _ServerErrorScreenState extends State<ServerErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Color(0xff077DBB),),
        //   onPressed: (){
        //     MyRouter.popPage(context);
        //   },
        // ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
     //   controller: controller, // Optional
        child: Container(
            child: Center(
              child: Column(
                children: [
                  Icon(FeatherIcons.frown,size: 110,),
                  SizedBox(height: 20,),
                  Text('Oops',style: TextStyle(fontFamily: 'Nunito SansRegular',fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('It\'s not you, something broke from our end',style: TextStyle(fontFamily: 'Nunito SemiBold',fontSize: 16,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)
                      ),
                      onPressed: ()
                  {
                    MyRouter.popPage(context);
                    MyRouter.popPage(context);
                //    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black
                          ),
                          child: Text('Go Back'))
                  )

                ],
              ),
            ),
        ),
      ),
    );
  }
}
