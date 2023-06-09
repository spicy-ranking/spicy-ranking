import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History { //履歴クラス
  final String hot; //辛いもの
  final String cold; //辛くないもの
  final int good; //賛成数
  final int bad; //反対数

  History({required this.hot, required this.cold, required this.good, required this.bad});

  factory History.fromMap(Map<String, dynamic> data) {
    return History(hot: data['hot'], cold: data['cold'], good: data['good'], bad: data['bad']);
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Streamを使用して、モデルクラスから、データを取得するメソッド
  Stream<List<History>> _fetchHistorysStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore.collection('history').snapshots();
    return stream.map((snapshot) =>
        snapshot.docs.map((doc) => History.fromMap(doc.data())).toList());
  }


  @override
  Widget build(BuildContext context) {
    // ListとHistoryクラスを指定する
    return StreamBuilder<List<History>>(
      // 上で定義したメソッドを使用する
      stream: _fetchHistorysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final historys = snapshot.data!;
        return ListView.builder(
          // Listのデータの数を数える
          itemCount: historys.length,
          itemBuilder: (context, index) {
            // index番目から数えて、０〜末尾まで登録されているデータを表示する変数
            final history = historys[index];
            return ListTile(
              // Historyクラスのメンバ変数を使用する
              title: Text('hot: ${history.hot}'),
              subtitle: Text('cold: ${history.cold}'),
              leading: const Icon(Icons.account_circle),
              trailing: Wrap(
                spacing: 20,
                children:[
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    color:Colors.red,
                    onPressed:(){}//good + 1
                  ),
                  IconButton(
                    icon: const Icon(Icons.thumb_down),
                    color:Colors.blue,
                    onPressed: (){}//bad + 1)
                  )
                ]
              )
            );
          },
        );
      },
    );
  }
}