import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:statomo_application/Views/Pages/post_room_chat_page.dart';
import 'package:statomo_application/utils/firestore/posts.dart';

import '../../model/account.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';
import '../screen.dart';

class PostRoomPage extends StatefulWidget {
  final String roomName;
  const PostRoomPage(this.roomName, {super.key});

  @override
  State<PostRoomPage> createState() => _PostRoomPageState();
}

class _PostRoomPageState extends State<PostRoomPage> {
  Account? myAccount;
  String? myUid;
  DateTime? _time;
  Timer? _timer;
  String? roomID;
  var count = 0;
  var isRunning = false;

  @override
  void initState() {
    isRunning = true;
    _time = DateTime.utc(0, 0, 0);
    timerIsRun();
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }
    setRoomID();

    super.initState();
  }

  Future<dynamic> setRoomID() async {
    if (myUid != null) {
      roomID = await PostFirestore.getPostRoomId(myUid!);
    }
  }

  void timerIsRun() {
    if (isRunning == true) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (_time != null) {
          setState(() {
            _time = _time!.add(const Duration(seconds: 1));
            count += 1;
            if (roomID == null) {
              setRoomID();
            }
          });
        }
      });
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
      if (roomID != null) {
        PostFirestore.postRoomPageCollection
            .where('joined_user_id', arrayContains: myUid)
            .get()
            .then(
          (QuerySnapshot snapshot) {
            for (var doc in snapshot.docs) {
              roomID = doc.get('roomID');
            }
          },
        );
      }
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: (() async {
          return false;
        }),
        child: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Center(
                        child: Text(
                          widget.roomName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              height: 100,
              child: const Center(child: Text('広告スペース')),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)),
                height: 80,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // ignore: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const Center(
                          child: Text(
                        '現在の勉強時間',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Center(
                        child: _time != null
                            ? Text(DateFormat.Hms().format(_time!),
                                style: const TextStyle(fontSize: 24))
                            : const Text('no_time')),
                  ],
                ),
              ),
            ),
            Expanded(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: PostFirestore.postRoomPageCollection
                        .doc(roomID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<dynamic> joinedId = snapshot.data!['joined_user_id'];
                      List<String> joinedUserIds = [];
                      for (var id in joinedId) {
                        joinedUserIds.add(id);
                      }

                      if (snapshot.hasData) {
                        return FutureBuilder<Map<String, Account>?>(
                            future: UserFirestore.getPostUserMap(joinedUserIds),
                            builder: (context, usersnapshot) {
                              if (usersnapshot.hasData) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1 / 1),
                                  itemCount: joinedId.length,
                                  itemBuilder: (context, index) {
                                    final String id = joinedId[index];
                                    Account joinedAccount =
                                        usersnapshot.data![id]!;

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                color: joinedAccount.id == myUid
                                                    ? Colors.lightBlue
                                                        .withOpacity(0.2)
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                child: Column(
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 5,
                                                                    right: 5,
                                                                    bottom: 10),
                                                            child: Text(
                                                              joinedAccount
                                                                  .name,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                            foregroundImage:
                                                                NetworkImage(
                                                                    joinedAccount
                                                                        .imagePath),
                                                            radius: 25,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                  color: Colors.yellow,
                                );
                              }
                            });
                      } else {
                        return Container(
                          color: Colors.green,
                        );
                      }
                    }),
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: (() async {
                        if (roomID != null) {
                          DocumentSnapshot snapshot = await PostFirestore
                              .postRoomPageCollection
                              .doc(roomID)
                              .get();
                          Map<String, dynamic> data =
                              snapshot.data() as Map<String, dynamic>;
                          String postID = data['post_id'];

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      PostRoomChatPage(postID),
                                      fullscreenDialog: true
                                      ));
                        }
                      }),
                      icon: const Icon(Icons.chat)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.8),
                          minimumSize: const Size(60, 30)),
                      onPressed: () async {
                        isRunning = false;
                        timerIsRun();
                        if (myUid != null && roomID != null) {
                          UserFirestore.updateStudyTime(count, myUid!);
                          PostFirestore.leaveRoom(myAccount!, roomID!);
                          DocumentSnapshot snapshot = await PostFirestore
                              .postRoomPageCollection
                              .doc(roomID)
                              .get();
                          String postID = snapshot.get('post_id');
                          PostFirestore.setStatus(postID, true);
                          // ignore: use_build_context_synchronously
                          pushNewScreen<dynamic>(
                            context,
                            screen: const Screen(),
                            withNavBar: true,
                          );
                        }
                      },
                      child: const Text(
                        '退室',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
