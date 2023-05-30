import 'package:flutter/material.dart';
import 'package:spicy_ranking/constant/constants.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["ranking", "input"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext content) {
    return SizedBox(
        height: 25,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) => buildCategory(index)));
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      // タップしたカテゴリーが選択される
      onTap: (() {
        setState(() {
          selectedIndex = index;
        });
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      selectedIndex == index ? kTextColor : kTextLightColor)),
          Container(
            margin: const EdgeInsets.only(top: kDefaultPaddin / 4),
            height: 2,
            width: 30,
            color: selectedIndex == index ? Colors.black : Colors.transparent,
          )
        ]),
      ),
    );
  }
}
