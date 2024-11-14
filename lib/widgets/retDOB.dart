import 'package:flutter/material.dart';

retDOBfromBVN(String getDate){
  String realMonth = '';
  //print('getDate ${getDate}');
  String newGetDate = getDate.substring(0,10);
  String removeComma = newGetDate.replaceAll("-", " ");
  //print('new Rems ${removeComma}');
  List<String> wordList = removeComma.split(" ");
  //print(wordList[1]);

  if(wordList[1] == '01'){

      realMonth = 'January';

  }
  if(wordList[1] == '02'){

      realMonth = 'February';

  }
  if(wordList[1] == '03'){

      realMonth = 'March';

  }
  if(wordList[1] == '04'){

      realMonth = 'April';

  }
  if(wordList[1] == '05'){

      realMonth = 'May';

  }  if(wordList[1] == '06'){

      realMonth = 'June';

  }  if(wordList[1] == '07'){

      realMonth = 'July';

  }  if(wordList[1] == '08'){

      realMonth = 'August';

  }  if(wordList[1] == '09'){

      realMonth = 'September';

  }  if(wordList[1] == '10'){

      realMonth = 'October';

  }
  if(wordList[1] == '11'){

      realMonth = 'November';

  }
  if(wordList[1] == '12'){

      realMonth = 'December';

  }


  String o1 = wordList[0];
  String o2 = wordList[1];
  String o3 = wordList[2];

  String newOO = o3.length == 1 ? '0' + '' + o3 :  o3;

  //print('newOO ${newOO}');

  String concatss =  newOO + " " + realMonth + " " + o1   ;

  print("concatss new Date from edit ${concatss}");

  return concatss;


}
