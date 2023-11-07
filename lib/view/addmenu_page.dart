import 'package:flutter/material.dart';

// ignore: camel_case_types
class addMenu extends StatelessWidget {
  const addMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 商品の写真を追加
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              // 画像を選択するためのアクション
              onTap: () {
                // 画像を選択するロジックを実装
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 商品名のテキストフィールド
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '商品名',
              ),
            ),
          ),
          // 送信ボタン
          ElevatedButton(
            onPressed: () async {
              // 送信ボタンが押されたときの処理
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('登録完了'),
                    content: const Text('商品追加リクエストがされました'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.brown), // ボタンの背景色を茶色に変更
            ),
            child: const Text('商品追加をリクエスト'),
          ),
        ],
      ),
    );
  }
}
