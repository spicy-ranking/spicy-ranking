import 'package:flutter/material.dart';
//import 'package:spicy_ranking/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search_choices/search_choices.dart';

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
            .collection('spicy-instant-noodle-expriment')
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
                  value: food['name'],
                  child: Text(
                    food['name'],
                  ),
                ),
              );
            }
          }
          return SearchChoices.single(
            items: foodItems,
            value: isSelectedValue,
            hint: "商品名を一つ選んでください",
            searchHint: "商品名を一つ選んでください",
            onChanged: (foodValue) {
              setState(() {
                isSelectedValue = foodValue!;
                firstProductName = foodValue; // 値を代入
                widget.onProductChanged?.call(firstProductName!);
              });
            },
            doneButton: "選択",
            displayItem: (item, selected) {
              return (Row(children: [
                selected
                    ? const Icon(
                        Icons.radio_button_checked,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                      ),
                const SizedBox(width: 7),
                Expanded(
                  child: item,
                ),
              ]));
            },
            isExpanded: true,
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
            .collection('spicy-instant-noodle-expriment')
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
                    value: food['name'],
                    child: Text(
                      food['name'],
                    )),
              );
            }
          }
          return SearchChoices.single(
            items: foodItems,
            value: isSelectedValue,
            hint: "商品名を一つ選んでください",
            searchHint: "商品名を一つ選んでください",
            onChanged: (foodValue) {
              setState(() {
                isSelectedValue = foodValue!;
                secondProductName = foodValue; // 値を代入
                widget.onProductChanged?.call(secondProductName!);
              });
            },
            doneButton: "選択",
            displayItem: (item, selected) {
              return (Row(children: [
                selected
                    ? const Icon(
                        Icons.radio_button_checked,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                      ),
                const SizedBox(width: 7),
                Expanded(
                  child: item,
                ),
              ]));
            },
            isExpanded: true,
          );
        });
  }
}

// 残りのコードは変更なし
