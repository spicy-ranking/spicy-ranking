import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLogin extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'メールアドレスを入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('ログイン'),
            onPressed: () async {
              try {
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ログインしました'),
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('メールアドレスのフォーマットが正しくありません'),
                    ),
                  );
                } else if (e.code == 'user-disabled') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('現在指定したメールアドレスは使用できません'),
                    ),
                  );
                } else if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('指定したメールアドレスは登録されていません'),
                    ),
                  );
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('パスワードが間違っています'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}