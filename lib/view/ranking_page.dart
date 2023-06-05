import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankPage extends StatefulWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  RankPageState createState() => RankPageState();
}

class RankPageState extends State<RankPage> {
  late Future<List<String>> cupNoodleNamesFuture;

  Future<List<String>> getCupNoodleNames() async {
    List<String> cupNoodleNames = [];

    // Firestoreコレクションの参照を作成
    CollectionReference cupNoodleCollection =
        FirebaseFirestore.instance.collection('spicy-cup-noodle');

    // コレクション内の全てのドキュメントを取得
    QuerySnapshot querySnapshot = await cupNoodleCollection.get();

    // 各ドキュメントから"name"フィールドを取り出してリストに追加
    for (var doc in querySnapshot.docs) {
      String name = (doc.data() as Map<String, dynamic>)['name'];
      cupNoodleNames.add(name);
    }

    return cupNoodleNames;
  }

  @override
  void initState() {
    super.initState();
    cupNoodleNamesFuture = getCupNoodleNames();
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
            child: FutureBuilder<List<String>>(
          future: cupNoodleNamesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // データが取得された場合の処理
              List<String> cupNoodleNames = snapshot.data!;
              return ListView.builder(
                itemCount: cupNoodleNames.length,
                itemBuilder: (context, index) {
                  return Text(cupNoodleNames[index]);
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
