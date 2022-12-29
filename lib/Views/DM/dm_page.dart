import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/DM/dm_chat_page.dart';
import 'package:statomo_application/Views/Pages/information_page.dart';
import 'package:statomo_application/model/talk_room.dart';
import 'package:statomo_application/utils/firestore/room.dart';
import 'package:statomo_application/utils/shared_prefs.dart';
import 'package:statomo_application/utils/widget_utils.dart';

class DMPage extends StatefulWidget {
  const DMPage({super.key});

  @override
  State<DMPage> createState() => _DMPageState();
}

class _DMPageState extends State<DMPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        appBar: WidgetUtils.createAppBar('チャット'),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('room')
                      .where('joined_user_id',
                          arrayContains: SharedPrefs.fetchUid())
                      .orderBy('joined_user_id')
                      .orderBy('last_send_time', descending: true)
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return FutureBuilder<List<TalkRoom>?>(
                          future: RoomFirestore.fetchJoinedRooms(
                              streamSnapshot.data!),
                          builder: (context, futureSnapshot) {
                            if (futureSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              if (futureSnapshot.hasData) {
                                List<TalkRoom> talkRoom = futureSnapshot.data!;
                                return ListView.builder(
                                    itemCount: talkRoom.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DMChatPage(
                                                            talkRoom[index])));
                                          },
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 3),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InformationPage(
                                                                      talkRoom[
                                                                              index]
                                                                          .talkAccount)));
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      foregroundImage:
                                                          NetworkImage(
                                                              talkRoom[index]
                                                                  .talkAccount
                                                                  .imagePath),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      talkRoom[index]
                                                          .talkAccount
                                                          .name,
                                                      style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      talkRoom[index]
                                                              .talkAccount
                                                              .lastMessage ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey),
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
                                return const Text('トークの取得に失敗しました');
                              }
                            }
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 100,
              child: const Text('広告スペース'),
            ),
          ],
        ),
      ),
    );
  }
}
