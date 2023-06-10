import 'package:flutter/material.dart';
import 'package:spicy_ranking/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DropdownButtonProductMenu1 extends StatefulWidget {
  final ValueChanged<String>? onProductChanged; // コールバック関数の型を修正
  const DropdownButtonProductMenu1({Key? key, this.onProductChanged})
      : super(key: key);

  @override
  State<DropdownButtonProductMenu1> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonProductMenu1> {
  String? isSelectedValue;
  String? firstProductName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('spicy-cup-noodle')
            .snapshots(),
        builder: (context, snapshot) {
          List<DropdownMenuItem<String>> foodItems = []; // 型を指定
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // CircularProgressIndicatorを返す
          } else {
            final foods = snapshot.data?.docs.toList();
            for (var food in foods!) {
              foodItems.add(
                DropdownMenuItem(
                  value: food.id,
                  child: Text(
                    food['name'],
                  ),
                ),
              );
            }
          }
          return DropdownButton<String>(
            iconSize: 30,
            padding: const EdgeInsets.all(kDefaultPaddin),
            items: foodItems,
            value: isSelectedValue,
            onChanged: (foodValue) {
              setState(() {
                isSelectedValue = foodValue!;
                firstProductName = foodValue; // 値を代入
                widget.onProductChanged?.call(firstProductName!);
              });
            },
          );
        });
  }
}

class DropdownButtonProductMenu2 extends StatefulWidget {
  final ValueChanged<String>? onProductChanged; // コールバック関数の型を修正
  const DropdownButtonProductMenu2({Key? key, this.onProductChanged})
      : super(key: key);

  @override
  State<DropdownButtonProductMenu2> createState() =>
      _DropdownButtonMenuState2();
}

class _DropdownButtonMenuState2 extends State<DropdownButtonProductMenu2> {
  String? isSelectedValue;
  String? secondProductName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('spicy-cup-noodle')
            .snapshots(),
        builder: (context, snapshot) {
          List<DropdownMenuItem<String>> foodItems = []; // 型を指定
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // CircularProgressIndicatorを返す
          } else {
            final foods = snapshot.data?.docs.toList();
            for (var food in foods!) {
              foodItems.add(
                DropdownMenuItem(
                  value: food.id,
                  child: Text(
                    food['name'],
                  ),
                ),
              );
            }
          }
          return DropdownButton<String>(
            iconSize: 30,
            padding: const EdgeInsets.all(kDefaultPaddin),
            items: foodItems,
            value: isSelectedValue,
            onChanged: (foodValue) {
              setState(() {
                isSelectedValue = foodValue!;
                secondProductName = foodValue; // 値を代入
                widget.onProductChanged?.call(secondProductName!);
              });
            },
          );
        });
  }
}

// 残りのコードは変更なし
