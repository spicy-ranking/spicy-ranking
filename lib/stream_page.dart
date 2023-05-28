import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Person {
  final String name;
  final int rate;

  Person({required this.name, required this.rate});

  factory Person.fromMap(Map<String, dynamic> data) {
    return Person(name: data['name'], rate: data['rate']);
  }
}

class StreamPage extends StatelessWidget {
  const StreamPage({super.key});

  // Streamを使用して、モデルクラスから、データを取得するメソッド
  Stream<List<Person>> _fetchPersonsStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore.collection('spicy-cup-noodle').snapshots();
    return stream.map((snapshot) =>
        snapshot.docs.map((doc) => Person.fromMap(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    // ListとPersonクラスを指定する
    return StreamBuilder<List<Person>>(
      // 上で定義したメソッドを使用する
      stream: _fetchPersonsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final persons = snapshot.data!;
        return ListView.builder(
          // Listのデータの数を数える
          itemCount: persons.length,
          itemBuilder: (context, index) {
            // index番目から数えて、０〜３まで登録されているデータを表示する変数
            final person = persons[index];
            return ListTile(
              // Personクラスのメンバ変数を使用する
              title: Text('Name: ${person.name}'),
              subtitle: Text('Rate: ${person.rate}'),
            );
          },
        );
      },
    );
  }
}