import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  static const Map<String, String> monthMap = {
    '01': 'January',
    '02': 'February',
    '03': 'March',
    '04': 'April',
    '05': 'May',
    '06': 'June',
    '07': 'July',
    '08': 'August',
    '09': 'September',
    '10': 'October',
    '11': 'November',
    '12': 'December',
  };

  static String getDateForNextRepayment(String getDate) {
    print('getDate $getDate');
    String removeComma = getDate.replaceAll("-", " ");
    print('new Rems $removeComma');
    List<String> wordList = removeComma.split(" ");
    print(wordList[1]);

    String realMonth = monthMap[wordList[1]] ?? 'Unknown Month';

    String day = wordList[2].length == 1 ? '0' + wordList[2] : wordList[2];

    print('day $day');

    String formattedDate = '$day $realMonth ${wordList[0]}';

    print("formattedDate $formattedDate");

    return formattedDate;
  }

  static String retsNx360dates(DateTime selected) {
    String newdate = selected.toString().substring(0, 10);
    print('newdate $newdate selected $selected added ${DateTime.now().add(Duration(days: 0))}');

    String formattedDate = DateFormat.yMMMMd().format(selected);
    String removeComma = formattedDate.replaceAll(",", "");
    List<String> wordList = removeComma.split(" ");

    // Expecting format like "December 14 2011" -> [December, 14, 2011]
    String month = wordList[0];
    String day = wordList[1];
    String year = wordList[2];

    String formattedOutput = '$day $month $year';
    print("Formatted date: $formattedOutput");
    print(wordList);

    return formattedOutput;
  }


}
