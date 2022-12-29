import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/UserPage/post_archive.dart';
import 'package:statomo_application/Views/UserPage/user_updated_page.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/posts.dart';
import 'package:statomo_application/utils/firestore/users.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserUpdatedPageState();
}

class _UserUpdatedPageState extends State<UserInformationPage> {
  Account? myAccount;
  String? subject;
  String? myUid;

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }
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
                    const Text(
                      'ユーザー情報',
                      style: TextStyle(
                        fontSize: 20,
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
                      foregroundImage: myAccount?.imagePath != null
                          ? NetworkImage(myAccount!.imagePath)
                          : null),
                ),
                Expanded(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myAccount?.name != null
                            ? Text(
                                myAccount!.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            : const Text('no name'),
                        myAccount?.userId != null
                            ? Text(
                                '@${myAccount!.userId}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              )
                            : const Text('no userId'),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserUpdatedPage()));
                          if (result == true) {
                            setState(() {
                              myAccount = Authentication.myAccount;
                            });
                          }
                        },
                        child: const Text('編集'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: myAccount?.selfIntroduction != null
                    ? Text(
                        myAccount!.selfIntroduction,
                        style: const TextStyle(fontSize: 16),
                      )
                    : const Text('')),
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
                      .doc(myUid)
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
                                    subject = post.subject == 'NationalLanguage'
                                        ? '国語系'
                                        : post.subject == 'Math'
                                            ? '数学系'
                                            : post.subject == 'English'
                                                ? '外国語'
                                                : post.subject == 'Science'
                                                    ? '理科系'
                                                    : post.subject == 'Society'
                                                        ? '社会系'
                                                        : 'その他';
                                    if (myAccount != null) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostArchive(post)));
                                        },
                                        child: Container(
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
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                // ignore: avoid_unnecessary_containers
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            '部屋名 : ',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          Text(
                                                            post.postRoomName,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "教科 : ",
                                                            style: TextStyle(
                                                                fontSize: 20),
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
                                                                          : subject == '社会系'
                                                                              ? const Color.fromARGB(255, 167, 153, 33)
                                                                              : subject == '外国語'
                                                                                  ? Colors.red
                                                                                  : subject == '理科系'
                                                                                      ? Colors.lightGreen
                                                                                      : Colors.grey)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'コメント:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(post.memo1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
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
            // ignore: sized_box_for_whitespace
            Container(height: 100,
            child: const Text('広告スペース'),
            )
          ],
        ),
      ),
    );
  }
}
