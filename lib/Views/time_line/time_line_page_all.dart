import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:statomo_application/Views/Pages/call_page.dart';
import 'package:statomo_application/Views/Pages/free_study_page.dart';
import 'package:statomo_application/Views/Search/search_page.dart';
import 'package:statomo_application/Views/UserPage/user_information_page.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/posts.dart';
import 'package:statomo_application/utils/firestore/room.dart';
import 'package:statomo_application/utils/firestore/users.dart';

import '../../model/account.dart';
import '../../model/post.dart';
import '../../utils/shared_prefs.dart';
import '../Pages/information_page.dart';
import 'room_page.dart';

class TimeLinePageAll extends StatefulWidget {
  const TimeLinePageAll({super.key});

  @override
  State<TimeLinePageAll> createState() => _TimeLinePageAllState();
}

class _TimeLinePageAllState extends State<TimeLinePageAll> {
  Account? myAccount;
  String? myUid;
  String? subject;
  int length = 0;

  @override
  void initState() {
    myUid = SharedPrefs.fetchUid();
    if (myUid != null) {
      UserFirestore.getUser(myUid!);
    }
    if (Authentication.myAccount != null) {
      setState(() {
        myAccount = Authentication.myAccount;
        myUid = Authentication.myAccount!.id;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 75,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: FloatingActionButton(
                          heroTag: "hero1",
                          onPressed: (() {
                            pushNewScreen<dynamic>(
                              context,
                              screen: const CallPage(),
                              withNavBar: false,
                            );
                          }),
                          child: const Icon(Icons.wifi_calling_3)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: FloatingActionButton(
                          heroTag: "hero2",
                          onPressed: (() {
                            pushNewScreen<dynamic>(
                              context,
                              screen: const SearchPage(),
                              withNavBar: false,
                            );
                          }),
                          child: const Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: RoomFirestore.freeStudyCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        length = snapshot.data!.docs.length;
                      }
                      String stlength = length.toString();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '自習室 $stlength 人自習中',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: OutlinedButton(
                              onPressed: (() async {
                                if (myUid != null) {
                                  RoomFirestore.joinedFreeStudy(
                                      myUid!, Authentication.myAccount!.name);
                                  pushNewScreen<dynamic>(
                                    context,
                                    screen: const FreeStudyPage(),
                                    withNavBar: false,
                                  );
                                }
                              }),
                              child: const Text('参加'),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              Expanded(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: PostFirestore.posts
                          .where('post_room_id', isNull: false)
                          .orderBy('post_room_id')
                          .orderBy('created_time', descending: true)
                          .snapshots(),
                      builder: (context, postSnapshot) {
                        if (postSnapshot.hasData) {
                          List<String> postAccountIds = [];
                          // ignore: avoid_function_literals_in_foreach_calls
                          postSnapshot.data!.docs.forEach((doc) {
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
                                    itemCount: postSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> data =
                                          postSnapshot.data!.docs[index].data()
                                              as Map<String, dynamic>;
                                      Post post = Post(
                                        id: postSnapshot.data!.docs[index].id,
                                        subject: data['subject'],
                                        status: data['status'],
                                        memo1: data['memo1'],
                                        postRoomName: data['post_room_name'],
                                        postAccountId: data['post_account_id'],
                                        createdTime: data['created_time'],
                                      );
                                      Account postAccount = userSnapshot
                                          .data![post.postAccountId]!;
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  postAccount.id == myUid
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const UserInformationPage()))
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InformationPage(
                                                                      postAccount)));
                                                },
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  foregroundImage: NetworkImage(
                                                      postAccount.imagePath),
                                                ),
                                              ),
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // ignore: sized_box_for_whitespace
                                                      Container(
                                                        height: 22,
                                                        child: Expanded(
                                                          // ignore: avoid_unnecessary_containers
                                                          child: Container(
                                                            child: Text(
                                                              postAccount.name,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize: 18),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
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
                                                                        overflow: TextOverflow.ellipsis
                                                          ),
                                                          // ignore: avoid_unnecessary_containers
                                                          Container(
                                                            child: Row(
                                                                children: [
                                                                  post.status >
                                                                          0
                                                                      ? const Text(
                                                                          '現在募集中!!',
                                                                          style: TextStyle(
                                                                              color: Colors.lightGreen,
                                                                              fontWeight: FontWeight.bold),
                                                                        )
                                                                      : const Text(
                                                                          ''),
                                                                  post.status > 0 ?
                                                                  Text(
                                                                    'あと${post.status}人',
                                                                    style: TextStyle(
                                                                        color: post.status >
                                                                                2
                                                                            ? Colors
                                                                                .lightGreen
                                                                            : Colors
                                                                                .red,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ) : const Text('募集停止中',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                                                ]),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text('部屋名 : ',style: TextStyle(fontSize: 20),),
                                                          Expanded(
                                                            // ignore: avoid_unnecessary_containers
                                                            child: Container(
                                                              child: Text(post.postRoomName,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
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
                                                          Expanded(
                                                            // ignore: avoid_unnecessary_containers
                                                            child: Container(
                                                              child: Text(post.memo1,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis),
                                                            ),
                                                          ),
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
              // ignore: sized_box_for_whitespace
              Container(
                height: 100,
                child: const Text('広告スペース'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
