import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spicy_ranking/routing/start_route.dart';

class UserLogin extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: Colors.blueGrey[400],
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                hintText: 'メールアドレスを入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: Colors.blueGrey[400],
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[400],
            ),
            child: const Text('ログイン'),
            onPressed: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StartRoute()),
                  );
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
