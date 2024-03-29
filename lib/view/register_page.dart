import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spicy_ranking/routing/start_route.dart';

// ignore: must_be_immutable
class Register extends StatelessWidget {
  //ステップ１
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFc6302c),
        title: const Text('新規登録'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: const Color(0xFFc6302c),
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFc6302c)),
                ),
                hintText: 'メールアドレスを入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: const Color(0xFFc6302c),
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFc6302c)),
                ),
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 34, 12, 6)),
            child: const Text('新規登録'),
            //ステップ２
            onPressed: () async {
              try {
                await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                final userId = FirebaseAuth.instance.currentUser?.uid;
                // FirestoreにユーザーIDを書き込む
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .set({'tap_count': 0, "time": 0});
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StartRoute()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('新規登録が完了しました'),
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('指定したメールアドレスは登録済みです'),
                    ),
                  );
                } else if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('メールアドレスのフォーマットが正しくありません'),
                    ),
                  );
                } else if (e.code == 'operation-not-allowed') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('指定したメールアドレス・パスワードは現在使用できません'),
                    ),
                  );
                } else if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('パスワードは６文字以上にしてください'),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
