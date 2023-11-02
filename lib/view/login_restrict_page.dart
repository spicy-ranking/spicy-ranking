import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLogin_restrict extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン者限定の機能です'),
        automaticallyImplyLeading: false
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login', arguments: 'login');
              },
              child: const Text('ログインはこちらから')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/regis', arguments: 'regis');
              },
              child: const Text('新規登録はこちらから'))
        ],
      ),
    );
  }
}