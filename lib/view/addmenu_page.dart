import 'dart:io';
import 'dart:typed_data'; // 追加
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addMenu extends StatefulWidget {
  const addMenu({super.key});

  @override
  State<addMenu> createState() => addMenuState();
}

class addMenuState extends State<addMenu> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // 追加

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('requests');

  String imageUrl = '';
  String name = '';

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
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 34, 12, 6),
            ),
            onPressed: () async {
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                final List<int> imageBytes = await pickedFile.readAsBytes();
                setState(() {
                  _imageBytes = Uint8List.fromList(imageBytes);
                });
              }
              String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages = referenceRoot.child('requests');

              Reference referenceImageToUpload =
                  referenceDirImages.child('$uniqueFileName.jpg');
              try {
                //Store the file(webはできない)
                await referenceImageToUpload.putFile(File(pickedFile!.path));
                //Success: get the download URL
                imageUrl = await referenceImageToUpload.getDownloadURL();
              } catch (error) {
                //Some error occurred
                debugPrint(error.toString());
              }
            },
            child: const Text('画像を選択', style: TextStyle(color: Colors.white)),
          ),

          // 商品名のテキストフィールド
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: const InputDecoration(
                labelText: '商品名',
              ),
            ),
          ),

          // 送信ボタン
          ElevatedButton(
            onPressed: () async {
              // 送信ボタンが押されたときの処理
              if (imageUrl.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please upload an image')));
                return;
              }
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name')));
                return;
              }

              // 送信処理
              _reference.add({
                'imageUrl': imageUrl,
                'name': name,
              });

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('登録完了'),
                    content: const Text('商品追加リクエストがされました'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                  const Color.fromARGB(255, 34, 12, 6)),
            ),
            child: const Text('商品追加をリクエスト'),
          ),
        ],
      ),
    );
  }
}
