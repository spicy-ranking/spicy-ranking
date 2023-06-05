import 'package:cloud_firestore/cloud_firestore.dart';

// Firestoreコレクションの参照を作成
CollectionReference cupNoodleCollection =
    FirebaseFirestore.instance.collection('spicy-cup-noodle');

// "CupNoodleNames"という名前のリストを取得する関数
Future<List<String>> getCupNoodleNames() async {
  List<String> cupNoodleNames = [];

  // コレクション内の全てのドキュメントを取得
  QuerySnapshot querySnapshot = await cupNoodleCollection.get();

  // 各ドキュメントから"name"フィールドを取り出してリストに追加
  querySnapshot.docs.forEach((doc) {
    String name = (doc.data() as Map<String, dynamic>)['name'];
    cupNoodleNames.add(name);
  });

  return cupNoodleNames;
}
