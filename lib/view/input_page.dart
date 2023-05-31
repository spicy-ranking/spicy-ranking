import 'package:flutter/material.dart';
import 'package:spicy_ranking/constant/constants.dart';
import 'package:spicy_ranking/components/drop_box_hot_menu.dart';
import '../components/drop_box_product_menu.dart';

class Input extends StatelessWidget {
  const Input({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              // 水平方向にpaddingが入っている
              padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: Text("Input",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
          const DropdownButtonProductMenu(),
          const Padding(
              // 水平方向にpaddingが入っている
              padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: Text("は",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
          const DropdownButtonProductMenu(),
          const Padding(
              // 水平方向にpaddingが入っている
              padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: Text("よりも",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
          const DropBoxHotMenu(),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {/* ボタンが押された時の処理 */},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('送信'))),
          )
        ],
      )
    );
    
  }
}
