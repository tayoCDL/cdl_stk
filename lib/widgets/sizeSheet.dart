import 'package:flutter/material.dart';

Future<void> showSizeSheet(BuildContext context, double leftMargin,
    double rightMargin, double bottomMargin, Widget widget,{Color colors=Colors.white , bool dismissible = true}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<void>(
    isDismissible: dismissible,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Wrap(
              children: [
                Container(
                  margin: EdgeInsets.only(left: leftMargin, right: rightMargin, bottom: bottomMargin),
                  padding: MediaQuery.of(context).viewInsets,
                  decoration: BoxDecoration(
                    color: colors,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:  Radius.circular(30)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: widget,
                    ),
                  ),
                ),
              ],
            );
          });
    },
  );
}
