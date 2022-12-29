// ignore_for_file: unrelated_type_equality_checks, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/Pages/post_room_page.dart';
import 'package:statomo_application/model/post.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/posts.dart';
import 'package:statomo_application/utils/widget_utils.dart';

import '../../model/account.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  String? subject = 'NationalLanguage';
  String? roomID;
  int? status = 0;
  Account? myAccount;

  TextEditingController commentController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount!;
    }

    return Scaffold(
        appBar: WidgetUtils.createAppBar('部屋を作成'),
        body: SingleChildScrollView(
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 100,
                          // ignore: prefer_const_constructors
                          child: Padding(
                            padding: const EdgeInsets.only(bottom:12.0),
                            child: const Text(
                              '部屋名:',
                              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 200,
                          height: 75,
                          child: TextField(
                            controller: roomNameController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: '20文字以内',
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
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 80,
                    child: Row(
                      children: [
                        const Text(
                          '教科:',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 100),
                        SizedBox(
                          width: 120,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue.withOpacity(0.5)),
                            items: const [
                              DropdownMenuItem(
                                  value: 'NationalLanguage',
                                  child: Text('国語系')),
                              DropdownMenuItem(
                                  value: 'Math', child: Text('数学系')),
                              DropdownMenuItem(
                                  value: 'English', child: Text('外国語')),
                              DropdownMenuItem(
                                  value: 'Science', child: Text('理科系')),
                              DropdownMenuItem(
                                  value: 'Society', child: Text('社会系')),
                              DropdownMenuItem(
                                  value: 'Blank', child: Text('その他')),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                subject = value;
                              });
                            },
                            value: subject,
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 80,
                    child: Row(
                      children: [
                        const Text(
                          '人数:',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 100),
                        SizedBox(
                          width: 120,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue.withOpacity(0.5)),
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('1')),
                              DropdownMenuItem(value: 1, child: Text('2')),
                              DropdownMenuItem(value: 2, child: Text('3')),
                              DropdownMenuItem(value: 3, child: Text('4')),
                              DropdownMenuItem(value: 4, child: Text('5')),
                              DropdownMenuItem(value: 5, child: Text('6')),
                              DropdownMenuItem(value: 6, child: Text('7')),
                              DropdownMenuItem(value: 7, child: Text('8')),
                              DropdownMenuItem(value: 8, child: Text('9')),
                              DropdownMenuItem(value: 9, child: Text('10')),
                            ],
                            onChanged: (int? value) {
                              setState(() {
                                status = value;
                              });
                            },
                            value: status,
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Row(
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 100,
                          child: const Text(
                            'コメント:',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 40),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 200,
                          height: 100,
                          child: TextFormField(
                            focusNode: focusNode,
                            maxLines: 4,
                            maxLength: 100,
                            controller: commentController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.blue)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                hintText: '未入力'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             
              const SizedBox(height: 20),
              // ignore: sized_box_for_whitespace
              Container(
                height: 100,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(150, 70),
                    ),
                    child: const Text(
                      '作成',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    onPressed: () async {
                      Post newPost = Post(
                        subject: subject!,
                        status: status!,
                        memo1: commentController.text,
                        postRoomName: roomNameController.text,
                        postAccountId: Authentication.myAccount!.id,
                        createdTime: Timestamp.now(),
                      );
                      if (myAccount != null) {
                        final String? postRoomID =
                            await PostFirestore.createPostRoom(myAccount!,roomNameController.text);
                        final String? postID =
                            await PostFirestore.addPost(newPost);
                        await PostFirestore.posts
                            .doc(postID)
                            .update({'post_room_id': postRoomID});
                        await PostFirestore.postRoomPageCollection
                            .doc(postRoomID)
                            .update({'post_id': postID});
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostRoomPage(roomNameController.text)));
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
