import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/Account/create_account_page.dart';
import 'package:statomo_application/utils/firestore/room.dart';
import 'package:statomo_application/utils/shared_prefs.dart';

import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';
import '../screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _check = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: 100,
              child: const Center(
                  child: Text(
                'スタとも',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              // ignore: sized_box_for_whitespace
              child: Container(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'eメールアドレス'),
                ),
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              width: 300,
              child: TextField(
                obscureText: _check,
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'パスワード',
                  suffixIcon: IconButton(
                    icon:
                        Icon(_check ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _check = !_check;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            RichText(
                text:
                    TextSpan(style: const TextStyle(color: Colors.black), children: [
              const TextSpan(text: 'アカウントをお持ちでない方は'),
              TextSpan(
                  text: 'こちら',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccountPage()));
                    })
            ])),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton(
                onPressed: (() async {
                  var result = await Authentication.emailSignIn(
                      email: emailController.text, pass: passController.text);
                  if (result is UserCredential) {
                    // ignore: no_leading_underscores_for_local_identifiers
                    var _result = await UserFirestore.getUser(result.user!.uid);
                    await SharedPrefs.setPrefsInstance();
                    if (_result == true) {
                      SharedPrefs.setUid(result.user!.uid);
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Screen()));
                    }
                  }
                }),
                child: const Text('emailでログイン'))
          ],
        ),
      ),
    );
  }
}
