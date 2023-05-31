import 'package:flutter/material.dart';
import 'package:spicy_ranking/constant/constants.dart';

const List<String> hotChoices = <String>['辛い', '辛くない'];

class DropBoxHotMenu extends StatefulWidget {
  const DropBoxHotMenu({Key? key}) : super(key: key);

  @override
  State<DropBoxHotMenu> createState() => _DropBoxHotMenu();
}

class _DropBoxHotMenu extends State<DropBoxHotMenu> {
  String isSelectedValue = hotChoices.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconSize: 30,
      padding: const EdgeInsets.all(kDefaultPaddin),
      items: hotChoices.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: isSelectedValue,
      onChanged: (String? value) {
        setState(() {
          isSelectedValue = value!;
        });
      },
    );
  }
}
