import 'package:flutter/material.dart';

class ColorReturn {

   retCOlor(String Alpha) {
    if(Alpha == 'A'){
      return Colors.blue;
    }
    if(Alpha == 'B'){
      return Colors.blueGrey;
    }
    if(Alpha == 'C'){
      return Colors.black;
    }
    if(Alpha == 'D'){
      return Colors.red;
    }   if(Alpha == 'E'){
      return Colors.orange;
    }   if(Alpha == 'F'){
      return Colors.deepOrange;
    }   if(Alpha == 'G'){
      return Colors.deepOrangeAccent;
    }   if(Alpha == 'H'){
      return Colors.grey;
    }   if(Alpha == 'I'){
      return Colors.lightGreen;
    }   if(Alpha == 'J'){
      return Colors.teal;
    }   if(Alpha == 'K'){
      return Colors.cyanAccent;
    }   if(Alpha == 'L'){
      return Colors.purple;
    }   if(Alpha == 'M'){
      return Colors.deepPurple;
    }   if(Alpha == 'N'){
      return Colors.yellow;
    }   if(Alpha == 'O'){
      return Colors.brown;
    }   if(Alpha == 'P'){
      return Colors.deepOrangeAccent;
    }
    if(Alpha == 'Q'){
      return Colors.blueGrey;
    }
    if(Alpha == 'R'){
      return Colors.purple;
    }
    if(Alpha == 'S'){
      return Colors.green;
    }
    if(Alpha == 'T'){
      return Colors.cyan;
    }
    if(Alpha == 'U'){
      return Colors.amber;
    }
    if(Alpha == 'V'){
      return Colors.lightBlue;
    }
    if(Alpha == 'W'){
      return Colors.orange;
    }
    if(Alpha == 'X'){
      return Colors.pink;
    }
    if(Alpha == 'Y'){
      return Colors.blueGrey;
    }
    if(Alpha == 'Z'){
      return Colors.indigoAccent;
    }

   }


  retStatus(String value){
    if(value.toLowerCase() == 'incomplete'){
      return Colors.red;
    }
    if(value.toLowerCase() == 'pending'){
      return Colors.orange;
    }
    if(value.toLowerCase() == 'active' ){
      return Colors.green;
    }
  }

}