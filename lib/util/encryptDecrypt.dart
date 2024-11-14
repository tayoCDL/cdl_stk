import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sales_toolkit/widgets/constants.dart';


class EncryptOrDecrypt{
  final key = encrypt.Key.fromUtf8(enc_key);
  final iv = encrypt.IV.fromUtf8(enc_iv);
  final aesAlgo = 'AES/CBC/PKCS5PADDING';



  encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    String encryptedText = encrypted.base64;
    return encryptedText;
  }

  decryptText(String enryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypt.Encrypted.fromBase64(enryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    String decryptedText = decrypted;
    return decryptedText;
  }


 Map<String,dynamic> cloakCredentials(){
    // return {
    //   "username": "appuser2",
    //   "password": "newuser40"
    // };

   return {
     "payload": payload
       };

  }

  Map<String, dynamic> buildtwofactorData(
      {String authCode,
        String extendedToken,
        Map<String, dynamic> requesPayload}) {
    return {
      "authorization": 'Basic $authCode',
      "extendedToken": extendedToken ?? '',
      "userImeiNumber": "2332332545454",
      "requestPayload": requesPayload,
    };
  }


  Map<String, dynamic> buildEncData(Map<String, dynamic> loginData) {
    String loginString = jsonEncode(loginData);
    String newLoginString = EncryptOrDecrypt().encryptText(loginString);
    return {"payload": newLoginString};
  }

}