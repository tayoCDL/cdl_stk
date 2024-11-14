import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


class DropDownComponent extends StatelessWidget {
  const DropDownComponent({
    Key key,
    @required this.items,
    @required this.label,
    @required this.selectedItem,
    @required this.validator,
         this.popUpDisabled,
    this.onChange


  }) : super(key: key);

  final List<String> items;
  final String label;
  final String selectedItem;
  final Function validator;
  final Function onChange;
  final Function popUpDisabled;
  @override
  Widget build(BuildContext context) {

   return DropdownSearch<String>(
      mode: Mode.BOTTOM_SHEET,
      items: items,
      validator: validator,
      selectedItem: selectedItem,
      showSelectedItems: true,
      popupItemDisabled: popUpDisabled,
      dropdownSearchDecoration: InputDecoration(
        hintText: label,
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1.5,
            color:  Colors.grey,
          ),
        ),
        // contentPadding:
        // const EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChange,
      showSearchBox: true,

      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(

        //  labelStyle: theme.textTheme.bodyText1,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2.0,
              color:  Color(0xFFECEBEF),
            ),
          ),
          // hintStyle: theme.textTheme.bodyMedium!.copyWith(
          //   color:  const Color(0xFF607288),
          // ),
          border: const OutlineInputBorder(),
          labelText: label,

        ),
      ),

    );

  }
}

