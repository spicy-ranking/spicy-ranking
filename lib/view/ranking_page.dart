import 'package:flutter/material.dart';
import 'package:spicy_ranking/components/drop_box_product_menu.dart';

class RankPage extends StatelessWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 500,
          child: Image.asset('images/red_bar.png'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: choices.length,
            itemBuilder: (context, index) {
              return Text(choices[index]);
            },
          ),
        )
      ],
    );
  }
}
