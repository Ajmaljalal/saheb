import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';

class DropDownPicker extends StatefulWidget {
  final onChange;
  final value;
  final List items;
  final String hintText;
  final bool search;
  final String label;
  DropDownPicker({
    this.onChange,
    this.value,
    this.items,
    this.search,
    this.hintText,
    this.label,
  });

  @override
  _DropDownPickerState createState() => _DropDownPickerState();
}

class _DropDownPickerState extends State<DropDownPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.only(top: 5.0),
      child: FindDropdown(
        showSearchBox: widget.search,
        searchBoxDecoration: InputDecoration(
          hintText: widget.hintText.toString(),
        ),
        label: widget.label,
        labelStyle: TextStyle(
          fontSize: 0.0,
          height: 0.0,
        ),
        items: widget.items,
        onChanged: (value) {
          widget.onChange(value);
        },
        selectedItem: widget.value.toString(),
        dropdownBuilder: (BuildContext context, item) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
