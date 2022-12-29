import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/model/account.dart';
import 'package:statomo_application/utils/firestore/room.dart';

import '../../model/post.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/posts.dart';
import '../../utils/firestore/users.dart';
import '../DM/dm_chat_page.dart';

class InformationPage extends StatefulWidget {
  final Account poatAccount;
  const InformationPage(this.poatAccount, {super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String? postAccountId;
  String? subject;
  Account? myAccount;
  @override
  Widget build(BuildContext context) {
    postAccountId = widget.poatAccount.id;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (() {
                          Navigator.pop(context, true);
                        }),
                        icon: const Icon(Icons.arrow_back)),
                    Text(
                      widget.poatAccount.name,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                      radius: 40,
                      foregroundImage:
                          NetworkImage(widget.poatAccount.imagePath)),
                ),
                Column(
                  children: [
                    Text(
                      widget.poatAccount.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${widget.poatAccount.userId}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.local_post_office),
                          color: Colors.lightBlue,
                          onPressed: () async {
                            if (Authentication.myAccount != null &&
                                postAccountId != null) {
                              myAccount = Authentication.myAccount;
                              var result = await RoomFirestore.createRoom(
                                  myAccount!.id, postAccountId!);
                              if (result == true) {
                                final talkRoom =
                                    await RoomFirestore.getTalkRoom(
                                        myAccount!.id, postAccountId!);
                                if (talkRoom != null) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DMChatPage(talkRoom)));
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              widget.poatAccount.selfIntroduction,
              style: const TextStyle(fontSize: 16),
            )),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.blue,
                    width: 3,
                  ),
                )),
                child: const Center(
                    child: Text(
                  '投稿履歴',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ))),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: UserFirestore.users
                      .doc(postAccountId)
                      .collection('my_posts')
                      .orderBy('created_time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> myPostIds =
                          List.generate(snapshot.data!.docs.length, (index) {
                        return snapshot.data!.docs[index].id;
                      });
                      return FutureBuilder<List<Post>?>(
                          future: PostFirestore.getPostsFromIds(myPostIds),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Post post = snapshot.data![index];
                                    subject = post.subject ==
                                            'NationalLanguage'
                                        ? '国語系'
                                        : post.subject == 'Math'
                                            ? '数学系'
                                            : post.subject == 'English'
                                                ? '外国語'
                                                : post.subject == 'Science'
                                                    ? '理科系'
                                                    : post.subject ==
                                                            'Society'
                                                        ? '社会系'
                                                        : 'その他';
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: index == 0
                                              ? const Border(
                                                  top: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                )),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 32,
                                              foregroundImage:
                                                  // ignore: unnecessary_null_comparison
                                                  NetworkImage(widget
                                                      .poatAccount
                                                      .imagePath)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            // ignore: avoid_unnecessary_containers
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // ignore: unnecessary_null_comparison
                                                  Text(
                                                    widget.poatAccount.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // ignore: unnecessary_null_comparison
                                                      Text(
                                                        '@${widget.poatAccount.userId}',
                                                        style:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Text(
                                                          "教科 : ",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                      Text(subject!,
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: subject ==
                                                                      '国語系'
                                                                  ? Colors
                                                                      .black
                                                                  : subject ==
                                                                          '数学系'
                                                                      ? Colors
                                                                          .lightBlue
                                                                      : subject ==
                                                                              '社会系'
                                                                          ? const Color.fromARGB(
                                                                              255,
                                                                              167,
                                                                              153,
                                                                              33)
                                                                          : subject == '外国語'
                                                                              ? Colors.red
                                                                              : Colors.lightGreen)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        '一言メモ:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        snapshot.data![index]
                                                            .memo1,
                                                        style:
                                                            const TextStyle(
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Container(
                                  color: Colors.red,
                                );
                              }
                            }
                          });
                    } else {
                      return Container(
                        color: Colors.blue,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
