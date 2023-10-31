import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:spicy_ranking/routing/login_judge.dart';
import 'package:spicy_ranking/view/signup_page.dart';


class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
          child: Text('未サインイン時に表示するサインイン画面です。'),
        ),
      );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('サインイン済み時に表示するホーム画面です。'),
        ),
      );
}

class CreateAccountPage extends StatelessWidget {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
    // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              const Text("アカウント登録"),
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                   {
                    newUserEmail = value;
                  };
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード（６文字以上）"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                   {
                    newUserPassword = value;
                  };
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );

                    // 登録したユーザー情報
                    final User user = result.user!;
                    {
                      infoText = "登録OK:${user.email}";
                    };
                  } catch (e) {
                    // 登録に失敗した場合
                     {
                      infoText = "登録NG:${e.toString()}";
                    };
                  }
                },
                child: const Text("ユーザー登録"),
              ),

             const SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  {
                    loginUserEmail = value;
                  };
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                   {
                    loginUserPassword = value;
                  };
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                     {
                      infoText = "ログインOK：${user.email}";
                    };
                  } catch (e) {
                    // ログインに失敗した場合
                     {
                      infoText = "ログインNG：${e.toString()}";
                    };
                  }
                },
                child: Text("ログイン"),
              ),


              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}

class SignInPageState extends StatelessWidget {
    // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
             const SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                   {
                    loginUserEmail = value;
                  };
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                   {
                    loginUserPassword = value;
                  };
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                    {
                      infoText = "ログインOK：${user.email}";
                    };
                  } catch (e) {
                    // ログインに失敗した場合
                     {
                      infoText = "ログインNG：${e.toString()}";
                    };
                  }
                },
                child: Text("ログイン"),
              ),
              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}