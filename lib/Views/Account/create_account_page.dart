import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';
import '../../utils/function_utils.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String? grade = 'blank';
  String? gender = 'blank';
  String? prefecture = 'blank';

  TextEditingController usernameController = TextEditingController();
  TextEditingController desschoolController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  bool _check1 = true;
  bool _check2 = true;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          HitTestBehavior.opaque;
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  height: 100,
                  child: const Center(
                      child: Text(
                    'スタともへようこそ！',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Row(
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 100,
                          child: const Center(
                            child: Text(
                              'ユーザー画像',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var result = await FunctionUtils.getImageFromGallery();
                            if(result != null) {
                              setState(() {
                                image = File(result.path);
                              });
                            }
                          },
                          child: CircleAvatar(
                            foregroundImage:
                                image == null ? null : FileImage(image!),
                            radius: 40,
                            child: const Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            'ユーザー名',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 230,
                        height: 60,
                        child: TextField(
                          controller: usernameController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            hintText: '20文字以内',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            'ユーザーID',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 230,
                        height: 60,
                        child: TextField(
                          controller: userIdController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            hintText: '英数字20文字以内',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            '学年',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        height: 47,
                        width: 230,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'blank',
                                child: Text('未選択')),
                            DropdownMenuItem(value: 'gb', child: Text('小学1年生')),
                            DropdownMenuItem(value: 'gc', child: Text('小学2年生')),
                            DropdownMenuItem(value: 'gd', child: Text('小学3年生')),
                            DropdownMenuItem(value: 'ge', child: Text('小学4年生')),
                            DropdownMenuItem(value: 'gf', child: Text('小学5年生')),
                            DropdownMenuItem(value: 'gg', child: Text('小学6年生')),
                            DropdownMenuItem(value: 'gh', child: Text('中学1年生')),
                            DropdownMenuItem(value: 'gi', child: Text('中学2年生')),
                            DropdownMenuItem(value: 'gj', child: Text('中学3年生')),
                            DropdownMenuItem(value: 'gk', child: Text('高校1年生')),
                            DropdownMenuItem(value: 'gl', child: Text('高校2年生')),
                            DropdownMenuItem(value: 'gm', child: Text('高校3年生')),
                            DropdownMenuItem(value: 'gn', child: Text('大学1年生')),
                            DropdownMenuItem(value: 'go', child: Text('大学2年生')),
                            DropdownMenuItem(value: 'gp', child: Text('大学3年生')),
                            DropdownMenuItem(value: 'gq', child: Text('大学4年生')),
                            DropdownMenuItem(value: 'gr', child: Text('浪人生')),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              grade = value;
                            });
                          },
                          value: grade,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            '性別',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        height: 47,
                        width: 230,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'blank',
                                child: Text('未選択')),
                            DropdownMenuItem(value: 'male', child: Text('男')),
                            DropdownMenuItem(value: 'female', child: Text('女')),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              gender = value;
                            });
                          },
                          value: gender,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            '志望校',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 230,
                        height: 40,
                        child: TextField(
                          controller: desschoolController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      child: Row(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 100,
                        child: const Center(
                          child: Text(
                            '都道府県',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        height: 47,
                        width: 230,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'blank',
                                child: Text('未選択')),
                            DropdownMenuItem(value: 'hk', child: Text('北海道')),
                            DropdownMenuItem(value: 'am', child: Text('青森')),
                            DropdownMenuItem(value: 'ak', child: Text('秋田')),
                            DropdownMenuItem(value: 'iw', child: Text('岩手')),
                            DropdownMenuItem(value: 'yg', child: Text('山形')),
                            DropdownMenuItem(value: 'mg', child: Text('宮城')),
                            DropdownMenuItem(value: 'hu', child: Text('福島')),
                            DropdownMenuItem(value: 'ik', child: Text('茨城')),
                            DropdownMenuItem(value: 'tg', child: Text('栃木')),
                            DropdownMenuItem(value: 'gm', child: Text('群馬')),
                            DropdownMenuItem(value: 'st', child: Text('埼玉')),
                            DropdownMenuItem(value: 'tk', child: Text('東京')),
                            DropdownMenuItem(value: 'tb', child: Text('千葉')),
                            DropdownMenuItem(value: 'kw', child: Text('神奈川')),
                            DropdownMenuItem(value: 'ng', child: Text('新潟')),
                            DropdownMenuItem(value: 'nn', child: Text('長野')),
                            DropdownMenuItem(value: 'yn', child: Text('山梨')),
                            DropdownMenuItem(value: 'gf', child: Text('岐阜')),
                            DropdownMenuItem(value: 'tm', child: Text('富山')),
                            DropdownMenuItem(value: 'ik', child: Text('石川')),
                            DropdownMenuItem(value: 'hi', child: Text('福井')),
                            DropdownMenuItem(value: 'so', child: Text('静岡')),
                            DropdownMenuItem(value: 'ac', child: Text('愛知')),
                            DropdownMenuItem(value: 'me', child: Text('三重')),
                            DropdownMenuItem(value: 'sg', child: Text('滋賀')),
                            DropdownMenuItem(value: 'kt', child: Text('京都')),
                            DropdownMenuItem(value: 'nr', child: Text('奈良')),
                            DropdownMenuItem(value: 'wy', child: Text('和歌山')),
                            DropdownMenuItem(value: 'os', child: Text('大阪')),
                            DropdownMenuItem(value: 'hg', child: Text('兵庫')),
                            DropdownMenuItem(value: 'oy', child: Text('岡山')),
                            DropdownMenuItem(value: 'hi', child: Text('広島')),
                            DropdownMenuItem(value: 'sn', child: Text('島根')),
                            DropdownMenuItem(value: 'tt', child: Text('鳥取')),
                            DropdownMenuItem(value: 'yt', child: Text('山口')),
                            DropdownMenuItem(value: 'kg', child: Text('香川')),
                            DropdownMenuItem(value: 'ts', child: Text('徳島')),
                            DropdownMenuItem(value: 'em', child: Text('愛媛')),
                            DropdownMenuItem(value: 'kc', child: Text('高知')),
                            DropdownMenuItem(value: 'ho', child: Text('福岡')),
                            DropdownMenuItem(value: 'sg', child: Text('佐賀')),
                            DropdownMenuItem(value: 'ns', child: Text('長崎')),
                            DropdownMenuItem(value: 'km', child: Text('熊本')),
                            DropdownMenuItem(value: 'oi', child: Text('大分')),
                            DropdownMenuItem(value: 'mz', child: Text('宮崎')),
                            DropdownMenuItem(value: 'ks', child: Text('鹿児島')),
                            DropdownMenuItem(value: 'on', child: Text('沖縄')),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              prefecture = value;
                            });
                          },
                          value: prefecture,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: sized_box_for_whitespace
                  child: Container(
                      height: 160,
                      child: Row(
                        children: [
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 100,
                            child: const Center(
                              child: Text(
                                '自己紹介',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 230,
                            height: 200,
                            child: TextField(
                              controller: selfIntroductionController,
                              maxLines: 6,
                              maxLength: 200,
                              decoration: InputDecoration(
                                hintText: '200文字以内',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.blue)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 100),
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'eメールアドレス',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        hintText: 'example@email.com',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'パスワード',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: _check1,
                      controller: passController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_check1
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _check1 = !_check1;
                            });
                          },
                        ),
                        hintText: '英数字8～16文字',
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: _check2,
                      controller: checkController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_check2
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _check2 = !_check2;
                            });
                          },
                        ),
                        hintText: 'もう一度入力してください',
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 100,
                  child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(200, 70),
                      ),
                      child: const Text(
                        'アカウント作成',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      onPressed: () async {
                        if (usernameController.text.isNotEmpty &&
                            desschoolController.text.isNotEmpty &&
                            selfIntroductionController.text.isNotEmpty &&
                            image != null) {
                          var result = await Authentication.signUp(
                              email: emailController.text,
                              pass: passController.text);
                          if (result is UserCredential) {
                            String imagePath =
                                await FunctionUtils.uploadImage(result.user!.uid, image!);
                            Account newAccount = Account(
                              id: result.user!.uid,
                              name: usernameController.text,
                              userId: userIdController.text,
                              grade: grade!,
                              prefecture: prefecture!,
                              gender: gender!,
                              desSchool: desschoolController.text,
                              selfIntroduction: selfIntroductionController.text,
                              imagePath: imagePath,
                              myPoint: 0,
                            );
                            // ignore: no_leading_underscores_for_local_identifiers
                            var _result =
                                await UserFirestore.setUser(newAccount);
                            if (_result == true) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
