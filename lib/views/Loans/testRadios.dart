import 'package:flutter/material.dart';

class TestRadio extends StatefulWidget {
  const TestRadio({Key key}) : super(key: key);

  @override
  _TestRadioState createState() => _TestRadioState();
}

class _TestRadioState extends State<TestRadio> {

  final List<String> one = [
    '1',
    '2',
  ];


  var _oneValue = '';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: one.length,
                  controller: ScrollController(),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => Container(
                    height: 50,
                    color: Colors.white,
                    child: RadioListTile(title: Text(one[index]),
                      value: one[index],
                      groupValue: _oneValue,
                      onChanged: (value) {
                        setState(() {
                          _oneValue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

            ],
          ),
        ),
      ),
    );
  }
}
