import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types, must_be_immutable
class UserLogin_restrict extends StatelessWidget {

  UserLogin_restrict({super.key});

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン者限定の機能です'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Center(
          child: Column(children: [
        const SizedBox(height: 30),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/login', arguments: 'login');
          },
          child: const Text('ログインはこちらから',
              style: TextStyle(color: Colors.blueGrey)),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/regis', arguments: 'regis');
            },
            child: const Text('新規登録はこちらから',
                style: TextStyle(color: Colors.blueGrey)))
      ])),
    );
  }
}
