import 'package:flutter/material.dart';
import 'package:stocker/models/query_params.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<String> items;
  final QueryParam thisQueryParam;
  final String defaultVal;
  final Function update;
  final double? width;

  const CustomDropdownMenu(
      {required this.items,
      required this.thisQueryParam,
      required this.update,
      required this.defaultVal,
      this.width = 110,
      super.key});

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.defaultVal;
    widget.update(widget.thisQueryParam, selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: selectedItem,
      width: widget.width,
      onSelected: (String? item) {
        setState(() {
          selectedItem = item!;
          widget.update(widget.thisQueryParam, selectedItem);
        });
      },
      textStyle: const TextStyle(fontSize: 14),
      inputDecorationTheme: InputDecorationTheme(
        isCollapsed: true,
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).highlightColor,
        contentPadding: const EdgeInsets.only(left: 10),
      ),
      dropdownMenuEntries:
          widget.items.map<DropdownMenuEntry<String>>((String item) {
        return DropdownMenuEntry<String>(
          value: item,
          label: item,
        );
      }).toList(),
    );
  }
}
