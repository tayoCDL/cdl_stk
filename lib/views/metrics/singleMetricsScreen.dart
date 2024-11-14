import 'package:flutter/material.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';

class SingleMetricsScreen extends StatefulWidget {
  const SingleMetricsScreen({Key key}) : super(key: key);

  @override
  _SingleMetricsScreenState createState() => _SingleMetricsScreenState();
}

class _SingleMetricsScreenState extends State<SingleMetricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBack(context),
        backgroundColor: Colors.white,
      ),

    );

  }
}
