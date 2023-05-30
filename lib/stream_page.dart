import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Food {
  final String name;
  final int rate;

  Food({required this.name, required this.rate});

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(name: data['name'], rate: data['rate']);
  }
}

class StreamPage extends StatelessWidget {
  const StreamPage({super.key});

  // Streamを使用して、モデルクラスから、データを取得するメソッド
  Stream<List<Food>> _fetchFoodsStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore.collection('spicy-cup-noodle').snapshots();
    return stream.map((snapshot) =>
        snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    // ListとFoodクラスを指定する
    return StreamBuilder<List<Food>>(
      // 上で定義したメソッドを使用する
      stream: _fetchFoodsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final foods = snapshot.data!;
        return ListView.builder(
          // Listのデータの数を数える
          itemCount: foods.length,
          itemBuilder: (context, index) {
            // index番目から数えて、０〜末尾まで登録されているデータを表示する変数
            final food = foods[index];
            return ListTile(
              // Foodクラスのメンバ変数を使用する
              title: Text('Name: ${food.name}'),
              subtitle: Text('Rate: ${food.rate}'),
            );
          },
        );
      },
    );
  }
}