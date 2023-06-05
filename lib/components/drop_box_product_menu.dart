import 'package:flutter/material.dart';
import 'package:spicy_ranking/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const  List<String> choices = <String>['ピーヤング 激辛春雨END', 'ペヤング 激辛焼きそばEND', 
'三養食品 ブルダック炒め麺', '蒙古タンメン中本 北極ラーメン 激辛味噌', '蒙古タンメン中本 辛旨味噌'];

class DropdownButtonProductMenu extends StatefulWidget {
  const DropdownButtonProductMenu({Key? key}) : super(key: key);

  @override
  State<DropdownButtonProductMenu> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonProductMenu> {
  String isSelectedValue = "test1";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('spicy-cup-noodle').snapshots(),
      builder: (context, snapshot){
        List<DropdownMenuItem> foodItems = [];
        if(!snapshot.hasData){
          const CircularProgressIndicator();
        } else {
          final foods = snapshot.data?.docs.toList();
          for (var food in foods!){
            foodItems.add(
              DropdownMenuItem(
                value: food.id,
                child: Text(food['name'],),
              ),
            );
          }
        }
        return DropdownButton(
        iconSize: 30,
        padding: const EdgeInsets.all(kDefaultPaddin),
        items: foodItems,
        value: isSelectedValue,
        onChanged: (foodValue) {
          setState(() {
            isSelectedValue = foodValue!;
          });
        },
      );
      }
    );
    
  }
}

