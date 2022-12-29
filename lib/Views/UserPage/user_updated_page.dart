import 'dart:io';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:statomo_application/Views/Account/loginpage.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/users.dart';
import 'package:statomo_application/utils/shared_prefs.dart';
import 'package:statomo_application/utils/widget_utils.dart';

import '../../model/account.dart';
import '../../utils/function_utils.dart';

class UserUpdatedPage extends StatefulWidget {
  const UserUpdatedPage({super.key});

  @override
  State<UserUpdatedPage> createState() => _UserUpdatedPageState();
}

class _UserUpdatedPageState extends State<UserUpdatedPage> {
  Account? myAccount;
  String? grade;
  String? gender;
  String? prefecture;
  TextEditingController usernameController = TextEditingController();
  TextEditingController desschoolController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage() {
    if (image == null) {
      return NetworkImage(myAccount!.imagePath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      grade = myAccount!.grade;
      gender = myAccount!.gender;
      prefecture = myAccount!.prefecture;
      usernameController = TextEditingController(text: myAccount!.name);
      desschoolController = TextEditingController(text: myAccount!.desSchool);
      userIdController = TextEditingController(text: myAccount!.userId);
      selfIntroductionController =
          TextEditingController(text: myAccount!.selfIntroduction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('ユーザー情報を編集'),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          HitTestBehavior.opaque;
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Row(
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 100,
                          // ignore: prefer_const_constructors
                          child: Center(
                            child: const Text(
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
                            var result =
                                await FunctionUtils.getImageFromGallery();
                            if (result != null) {
                              setState(() {
                                image = File(result.path);
                              });
                            }
                          },
                          child: CircleAvatar(
                            foregroundImage: myAccount?.imagePath != null
                                ? getImage()
                                : NetworkImage(myAccount!.imagePath),
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
                          child: Padding(
                            padding: EdgeInsets.only(bottom:12.0),
                            child: Text(
                              'ユーザー名',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 230,
                        height: 75,
                        child: TextField(
                          controller: usernameController,
                          maxLength: 20,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: '10文字以内',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
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
                        child: const Padding(
                          padding:  EdgeInsets.only(bottom:12.0),
                          child:  Center(
                            child: Text(
                              'ユーザーID',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 230,
                        height: 75,
                        child: TextField(
                          controller: userIdController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            hintText: '英数字20文字以内',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
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
                                // ignore: sort_child_properties_last
                                child: Text('未選択'),
                                value: 'blank'),
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
                        child: const Padding(
                          padding: EdgeInsets.only(bottom:12.0),
                          child: Text(
                            '志望校・目標',
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
                        height: 75,
                        child: TextField(
                          controller: desschoolController,
                          maxLength: 20,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
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
                                    borderSide:
                                        const BorderSide(color: Colors.blue)),
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
                        '更新',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      onPressed: () async {
                        if (usernameController.text.isNotEmpty &&
                            desschoolController.text.isNotEmpty &&
                            selfIntroductionController.text.isNotEmpty) {
                          String imagePath = '';
                          if (image == null) {
                            myAccount?.imagePath != null
                                ? imagePath = myAccount!.imagePath
                                : null;
                          } else {
                            var result = myAccount?.id != null
                                ? await FunctionUtils.uploadImage(
                                    myAccount!.id, image!)
                                : '';
                            imagePath = result;
                          }
                          if (myAccount != null) {
                            Account updateAccount = Account(
                              id: myAccount!.id,
                              name: usernameController.text,
                              userId: userIdController.text,
                              grade: grade!,
                              prefecture: prefecture!,
                              gender: gender!,
                              desSchool: desschoolController.text,
                              selfIntroduction: selfIntroductionController.text,
                              imagePath: imagePath,
                            );
                            Authentication.myAccount = updateAccount;

                            var result =
                                await UserFirestore.updateUser(updateAccount);

                            if (result == true) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, true);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.7),
                            minimumSize: const Size(120, 35)),
                        child: const Text(
                          'ログアウト',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (myAccount != null) {
                            SharedPrefs.deletePref(
                                Authentication.myAccount!.id);
                            Authentication.signOut();
                            pushNewScreen<dynamic>(
                              context,
                              screen: const LoginPage(),
                              withNavBar: false,
                            );
                          } else {
                            pushNewScreen<dynamic>(
                              context,
                              screen: const LoginPage(),
                              withNavBar: false,
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(120, 35),
                        ),
                        child: const Text(
                          'アカウント削除',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (myAccount != null) {
                            UserFirestore.deleteUser(myAccount!.id);
                            Authentication.deleteAuth();
                            pushNewScreen<dynamic>(
                              context,
                              screen: const LoginPage(),
                              withNavBar: false,
                            );
                          } else {
                            pushNewScreen<dynamic>(
                              context,
                              screen: const LoginPage(),
                              withNavBar: false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
