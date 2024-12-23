import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';

class AppSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> sections;

  AppSummaryCard({this.sections});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: List.generate(sections.length * 2 - 1, (index) {
          if (index % 2 == 0) {
            // For content sections
            int sectionIndex = index ~/ 2;
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: sections[sectionIndex]['iconColor'],
                      ),
                      SizedBox(width: 5),
                      Text(
                        sections[sectionIndex]['title'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Count
                  Text(
                    "Count",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    sections[sectionIndex]['count'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),

                  // Amount
                  Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₦${sections[sectionIndex]['amount'].toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // For vertical divider
            return Container(
              margin: EdgeInsets.only(right: 10),
              height: 100,

              width: 20,// Explicit height to avoid infinite constraints
              child: VerticalDivider(
                color: ColorUtils.APP_TEXT_BORDER_UTIL,
                thickness: 2,
                width: 20,
              ),
            );
          }
        }),
      ),
    );
  }
}
