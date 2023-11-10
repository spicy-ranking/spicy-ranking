import 'dart:typed_data'; // 追加
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spicy_ranking/routing/start_route.dart';

class addMenu extends StatefulWidget {
  const addMenu({super.key});

  @override
  State<addMenu> createState() => addMenuState();
}

class addMenuState extends State<addMenu> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // 追加

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          // 写真表示
          if (_imageBytes != null)
            SizedBox(
              height: 150,
              width: 200,
              child: Image.memory(
                _imageBytes!,
                fit: BoxFit.fill,
              ),
            )
          else
            Container(
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
          const SizedBox(height: 30),

          // 画像選択ボタン
          OutlinedButton(
            onPressed: () async {
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                final List<int> imageBytes = await pickedFile.readAsBytes();
                setState(() {
                  _imageBytes = Uint8List.fromList(imageBytes);
                });
              }
            },
            child: const Text('画像を選択'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StartRoute()));
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
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
