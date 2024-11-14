import 'package:flutter/material.dart';

class LoanNotes extends StatefulWidget {
  const LoanNotes({Key key}) : super(key: key);

  @override
  _LoanNotesState createState() => _LoanNotesState();
}

class _LoanNotesState extends State<LoanNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );


  }

  Widget getNotesLists()
  {

    return Container(
      child: Card(
        elevation: 3,
        child: ListTile(
            
        ),
      ),
    );

  }
}
