import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sales_toolkit/util/router.dart';

class LoanDraft extends StatefulWidget {
  const LoanDraft({Key key}) : super(key: key);

  @override
  _LoanDraftState createState() => _LoanDraftState();
}


class _LoanDraftState extends State<LoanDraft> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Unpublished Loans',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: (){},
              child: publishStatus(Color(0xff077DBB).withOpacity(0.1),'Publish to NX360')
            ),
          )
        ],

      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 30,),

                Slidables(),

              ],
            ),
          ),
      ),
    );
  }

  Widget publishStatus(Color statusColor,String status) {
    return Container(
      width: 100,

      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(child: Text(status,style: TextStyle(color: Color(0xff077DBB),fontWeight: FontWeight.bold,fontSize: 9),)),
    );
  }

Widget LoanTiles(){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xffFAFAFA),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('123556',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
              Text('')
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('N500,000',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                Text('2022-01-20')
              ],
          )
        ],
      ),
    ),
  );
}


Widget Slidables(){
    return       Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFFf7d5d5),
            foregroundColor: Colors.red,
            icon: Icons.delete,
            
            label: 'Delete',
          ),
          SlidableAction(
             onPressed: doNothing,
            backgroundColor: Color(0xFFe7f3fd),
            foregroundColor: Colors.blue,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xffFAFAFA),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('123556',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                  Text('')
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('N500,000',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  Text('2022-01-20')
                ],
              )
            ],
          ),
        ),
      ),
    );
}
}

void doNothing(BuildContext context) {
  print('hello');
}