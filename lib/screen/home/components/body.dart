import 'package:flutter/material.dart';
import 'package:spicy_ranking/constants.dart';
import 'categories.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // 水平方向にpaddingが入っている
          padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text("SPICY-RANKING",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
          ),
        Categories()
      ],
    );
  }
}

