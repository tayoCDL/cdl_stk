import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sales_toolkit/util/router.dart';

import '../../../widgets/rounded-button.dart';
import '../../../widgets/text-input-with-border.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key key}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  bool isObscured = false;
  TextEditingController phone_number = TextEditingController();
  TextEditingController verification_code = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Color(0xff077DBB),),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cdlBg.png'),
                fit: BoxFit.cover,
                //  colorFilter: ColorFilter.mode(Color(0xff3593c4).withOpacity(0.7), BlendMode.darken),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Divider(
                    height: MediaQuery.of(context).size.height * 0.06,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Customer Verification',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1E1E2E),
                                fontFamily: 'Nunito Bold')),
                      ],
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter customer phone number',
                          style:
                              TextStyle(color: Color(0xff1E1E2E), fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 19,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputWithBorder(
                      isObscure: isObscured,
                      eyeOpen: isObscured,
                      onButtonPressed: () {
                        print('pressed');
                        setState(() {
                          isObscured = !isObscured;
                        });
                        print('isObsured ${isObscured}');
                      },
                      maxLenght: 4,
                      controls: phone_number,
                      isIconAvailable: false,
                      hint: 'Phone Number',
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                    ),
                  ),
                  Divider(
                    height: 8,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputWithBorder(
                      isObscure: isObscured,
                      eyeOpen: isObscured,
                      onButtonPressed: () {
                        print('pressed');
                        setState(() {
                          isObscured = !isObscured;
                        });
                        print('isObsured ${isObscured}');
                      },
                      maxLenght: 4,
                      controls: verification_code,
                      isIconAvailable: true,
                      suffixWidget: TextButton(
                        // disabledColor: Colors.blueGrey,
                        onPressed: null,
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text( 'Get Code' ,style: TextStyle(fontSize: 15,color: Color(0xff077DBB),fontWeight: FontWeight.bold),)),
                      ),
                      hint: 'Verification Code',
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                    ),
                  ),
                  Divider(
                    height: 29,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundedButton(
                      onbuttonPressed: () {
                        // MyRouter.pushPage(
                        //     context,
                        //     FingerprintPage()
                        // );

                      },
                      buttonText: "Verify",
                    ),
                  ),
                  Divider(
                    height: 15,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Divider(
                    height: 15,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Can’t receive verification code via SMS?',
                          style:
                          TextStyle(color: Color(0xff707070), fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Receive verification code via Call',
                          style:
                          TextStyle(color: Color(0xff127DBB), fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
