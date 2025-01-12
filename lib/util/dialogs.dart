import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sales_toolkit/components/custom_alert.dart';
import 'package:sales_toolkit/util/consts.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';

class Dialogs {
  showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15.0),
              Text(
                Constants.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                'Are you sure you want to quit?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 130.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Theme.of(context).colorScheme.secondary)
                        ),
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary)
                      ),

                      // side:
                      //     BorderSide(color: Theme.of(context).accentColor),
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      // color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 130.0,
                    child:

                    ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5.0),
                      // ),
                      style: TextButton.styleFrom(
                       foregroundColor: ColorUtils.PRIMARY_COLOR,
                       backgroundColor: ColorUtils.PRIMARY_COLOR
                       //  shape: RoundedRectangleBorder(
                       //    borderRadius: BorderRadius.circular(5.0),
                       //  ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => exit(0),
                      // color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
