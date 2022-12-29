import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/Search/search_page.dart';
import 'package:statomo_application/Views/screen.dart';

import '../../model/account.dart';
import '../../model/post.dart';
import '../../utils/firestore/posts.dart';
import '../../utils/firestore/users.dart';
import '../time_line/room_page.dart';
import '../Pages/call_page.dart';

class SearchPageAll extends StatefulWidget {
  final String sub;

  const SearchPageAll({Key? key, required this.sub}) : super(key: key);

  @override
  State<SearchPageAll> createState() => _SearchPageAllState();
}

class _SearchPageAllState extends State<SearchPageAll> {
  String? subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Screen()));
                    }),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey)),
                    icon: const Icon(Icons.home),
                    label: const Text(''),
                  ),
                  Expanded(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            icon: const Icon(Icons.wifi_calling_3),
                            label: const Text(''),
                            onPressed: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CallPage()));
                            }),
                          ),
                          TextButton.icon(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            icon: const Icon(Icons.search),
                            label: const Text(''),
                            onPressed: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchPage()));
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: PostFirestore.posts
                        .where('subject', isEqualTo: widget.sub)
                        .snapshots(),
                    builder: (context, searchSnapshot) {
                      if (searchSnapshot.hasData) {
                        List<String> postAccountIds = [];
                        // ignore: avoid_function_literals_in_foreach_calls
                        searchSnapshot.data!.docs.forEach((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          if (!postAccountIds
                              .contains(data['post_account_id'])) {
                            postAccountIds.add(data['post_account_id']);
                          }
                        });
                        return FutureBuilder<Map<String, Account>?>(
                            future:
                                UserFirestore.getPostUserMap(postAccountIds),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.hasData &&
                                  userSnapshot.connectionState ==
                                      ConnectionState.done) {
                                return ListView.builder(
                                  itemCount: searchSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        searchSnapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;
                                    Post post = Post(
                                      id: searchSnapshot.data!.docs[index].id,
                                      subject: data['subject'],
                                      status: data['status'],
                                      memo1: data['memo1'],
                                      postAccountId: data['post_account_id'],
                                      createdTime: data['created_time'],
                                    );
                                    Account postAccount =
                                        userSnapshot.data![post.postAccountId]!;
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
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RoomPage(post)));
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
                                            CircleAvatar(
                                              radius: 32,
                                              foregroundImage: NetworkImage(
                                                  postAccount.imagePath),
                                            ),
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
                                                    Text(
                                                      postAccount.name,
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
                                                        Text(
                                                          '@${postAccount.userId}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        Text(
                                                          post.status
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .lightGreen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
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
                                                        Text(post.subject,
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
                                                                                      : Colors.grey,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'コメント:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(post.memo1),
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
                                  },
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
