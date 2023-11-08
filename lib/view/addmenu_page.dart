import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:spicy_ranking/routing/start_route.dart';



// ignore: camel_case_types
class addMenu extends StatefulWidget {
  const addMenu({super.key});

  @override
  State<addMenu> createState() => addMenuState();
}

class addMenuState extends State<addMenu> {
  final ImagePicker _picker = ImagePicker();
  File? _file;

  // // カメラから写真を取得するメソッド
  // Future getImageFromCamera() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = XFile(pickedFile.path);
  //     }
  //   });
  // }

  // // ギャラリーから写真を取得するメソッド
  // Future getImageFromGarally() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = XFile(pickedFile.path);
  //     }
  //   });
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 商品の写真を追加
          const SizedBox(height: 30),
          //写真表示
          if(_file != null) 
          Image(
            image:FileImage(_file!) ,
            width:  300,
            height: 200,
          )
          
          else Container(
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
          //画像選択ボタン
          OutlinedButton(
                  onPressed: () async {
                    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
                    _file = File(_image!.path);
                    setState(() {});
                  },
                  child: const Text('画像を選択')
                ) ,
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
                            MaterialPageRoute(builder: (context) => const StartRoute()),
                          );
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
