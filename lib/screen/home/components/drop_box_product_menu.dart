import 'package:flutter/material.dart';
import 'package:spicy_ranking/constants.dart';

const  List<String> choices = <String>['ピーヤング 激辛春雨END', 'ペヤング 激辛焼きそばEND', 
'三養食品 ブルダック炒め麺', '蒙古タンメン中本 北極ラーメン 激辛味噌', '蒙古タンメン中本 辛旨味噌'];

class DropdownButtonProductMenu extends StatefulWidget {
  const DropdownButtonProductMenu({Key? key}) : super(key: key);

  @override
  State<DropdownButtonProductMenu> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonProductMenu> {
  String isSelectedValue = choices.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconSize: 30,
      padding: const EdgeInsets.all(kDefaultPaddin),
      items: choices.map<DropdownMenuItem<String>>((String list) {
        return DropdownMenuItem<String>(
          value: list,
          child: Text(list),
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

