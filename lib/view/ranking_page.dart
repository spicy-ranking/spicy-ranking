import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food { //Foodクラス
  final String name;
  final int rate;

  Food({required this.name, required this.rate});

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(name: data['name'], rate: data['rate']);
  }
}

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  // Streamを使用して、モデルクラスから、レート降順にデータを取得するメソッド
  Stream<List<Food>> _fetchFoodsStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore.collection('spicy-cup-noodle').orderBy('rate', descending: true).snapshots();
    return stream.map((snapshot) =>
        snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 500,
          width: 100, // 画像の幅を指定
          child: Image.asset('images/red_bar.png'),
        ),
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
                  return Text('No.${index + 1} ${food.name}, ${food.rate}');
                },
              );
            } else if (snapshot.hasError) {
              // エラーが発生した場合の処理
              return Text('エラーが発生しました');
            } else {
              // データがまだ取得されていない場合の処理
              return CircularProgressIndicator();
            }
          },
        ))
      ],
    );
  }
}
