import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  //Foodクラス
  final String name;
  final int rate;
  final String image;

  Food({required this.name, required this.rate, required this.image});

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(name: data['name'], rate: data['rate'], image: data['image']);
  }
}

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  // Streamを使用して、モデルクラスから、レート降順にデータを取得するメソッド
  Stream<List<Food>> _fetchFoodsStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore
        .collection('spicy-instant-noodle-expriment')
        .orderBy('rate', descending: true)
        .snapshots();
    return stream.map((snapshot) =>
        snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: 500,
        //   width: 100, // 画像の幅を指定
        //   child: Image.asset('images/red_bar.png'),
        // ),
        Expanded(
            child: StreamBuilder<List<Food>>(
          stream: _fetchFoodsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // データが取得された場合の処理
              final foods = snapshot.data!;
              return ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return ListTile(
                    leading: CircleAvatar(
                      // ランキング順位
                      backgroundColor: Colors.red[900 - 100 * (index ~/ 1.5)],
                      child: Text("${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    title: Text(food.name), // ランキングアイテムの名前
                    subtitle: Text('レート: ${food.rate}'), // ランキングアイテムの詳細情報
                    onTap: () {
                      //画像
                    },
                    trailing: food.image != ''
                        ? Image.asset('images/${food.image.toString()}')
                        : Image.asset('images/404.jpeg'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // エラーが発生した場合の処理
              return const Text('エラーが発生しました');
            } else {
              // データがまだ取得されていない場合の処理
              return const CircularProgressIndicator();
            }
          },
        ))
      ],
    );
  }
}
