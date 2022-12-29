import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/UserPage/user_information_page.dart';
import 'package:statomo_application/model/account.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/users.dart';
import 'package:statomo_application/utils/widget_utils.dart';
import 'package:intl/intl.dart' as intl;

import '../../model/message.dart';
import '../../model/post.dart';
import '../../utils/firestore/posts.dart';
import '../Pages/information_page.dart';

class PostArchive extends StatefulWidget {
  final Post post;
  const PostArchive(this.post, {super.key});

  @override
  State<PostArchive> createState() => _PostArchiveState();
}

class _PostArchiveState extends State<PostArchive> {
  Account? myAccount;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
    }
    return Scaffold(
        appBar: WidgetUtils.createAppBar(widget.post.postRoomName),
        body: Column(
          children: [
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
                  '参加アカウント',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ))),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: UserFirestore.users
                    .doc(myAccount!.id)
                    .collection('my_posts')
                    .doc(widget.post.id)
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
                            return ListView.builder(
                                itemCount: joinedId.length,
                                itemBuilder: (context, index) {
                                  final String id = joinedId[index];
                                  Account joinedAccount =
                                      usersnapshot.data![id]!;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: InkWell(
                                      onTap: () {
                                        joinedAccount.id == myAccount!.id
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
                                                            joinedAccount)));
                                      },
                                      child: Container(
                                        height: 80,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.lightBlue
                                                .withOpacity(0.2)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                foregroundImage: NetworkImage(
                                                    joinedAccount.imagePath),
                                                radius: 30,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  // ignore: avoid_unnecessary_containers
                                                  child: Container(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 16.0,
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Text(
                                                      joinedAccount.name,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                ),
                                                Expanded(
                                                  // ignore: avoid_unnecessary_containers
                                                  child: Container(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Text(
                                                      '@${joinedAccount.userId}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: size.height * 0.4,
              child: Column(children: [
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
                      'チャット履歴',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ))),
                Expanded(
                  child: Container(
                    color: Colors.lightBlue.withOpacity(0.3),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: PostFirestore.fetchMessageSnapshotRoom(
                            widget.post.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                physics:
                                    const RangeMaintainingScrollPhysics(),
                                reverse: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
                                  final Message message = Message(
                                      message: data['message'],
                                      isMe:
                                          myAccount!.id == data['sender_id']
                                              ? true
                                              : false,
                                      sendTime: data['send_time'],
                                      name: data['name'],
                                      imagePath: data['image_path']);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: index == 0 ? 10 : 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      textDirection: message.isMe
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 3),
                                          child: Row(
                                            children: [
                                              message.isMe == false
                                                  ? CircleAvatar(
                                                      foregroundImage:
                                                          NetworkImage(message
                                                              .imagePath),
                                                      radius: 20,
                                                    )
                                                  : const SizedBox(
                                                      height: 1,
                                                      width: 1,
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    message.isMe == false
                                                        ? Text(message.name)
                                                        : const Text(''),
                                                    Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15),
                                                          color: message
                                                                  .isMe
                                                              ? Colors
                                                                  .lightBlue
                                                              : Colors
                                                                  .white,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10,
                                                                vertical:
                                                                    6),
                                                        child: Text(
                                                          message.message,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      16),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(intl.DateFormat('HH:mm')
                                            .format(
                                                message.sendTime.toDate())),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return const Center(
                            child: Text('メッセージがありません'),
                          );
                        }),
                  ),
                ),
              ]),
            ),
            // ignore: sized_box_for_whitespace
            Container(height: 100,
            child: const Text('広告スペース'),)
          ],
        ));
  }
}
