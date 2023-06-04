// DBから持ってくるドキュメントが持っているフィールドを扱うクラスを定義

import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  Food(DocumentSnapshot doc) {
    name = doc['name'];
  }

  String name;
}