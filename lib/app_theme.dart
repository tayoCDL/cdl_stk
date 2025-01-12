import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = Color(0xff686795);
  static Color kAccentColor = Color(0xff077DBB);
  static Color kAccentColorVariant = Color(0xffF7A3A2);
  static Color kUnreadChatBG = Color(0xffEE1D1D);

  static final TextStyle kAppTitle = GoogleFonts.grandHotel(fontSize: 36);

  static final TextStyle heading2 = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w200,
    letterSpacing: 1.5,
  );

  static final TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w200,
    fontFamily: 'Nunito SansRegular',
    letterSpacing: 1.5,
  );

  static final TextStyle bodyText1 = TextStyle(
      color: Color(0xffAEABC9),
      fontSize: 11,
      letterSpacing: 1.2,
      // fontFamily: 'Nunito SansRegular',
      fontWeight: FontWeight.w100);

  static final TextStyle bodyTextMessage =
      TextStyle(fontSize: 11, letterSpacing: 1.5,fontWeight: FontWeight.w200 ,);

  static final TextStyle bodyTextTime = TextStyle(
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.w200,
    letterSpacing: 1,
    // fontFamily: 'Nunito SansRegular'
  );
}
