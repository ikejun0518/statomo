import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:statomo_application/model/talk_room.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/room.dart';
import 'package:statomo_application/utils/widget_utils.dart';

import '../../model/account.dart';
import '../../model/message.dart';

class DMChatPage extends StatefulWidget {
  final TalkRoom talkRoom;
  const DMChatPage(this.talkRoom, {super.key});

  @override
  State<DMChatPage> createState() => _DMChatPageState();
}

class _DMChatPageState extends State<DMChatPage> {
  String? myUid;
  Account? myAccount;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }
    return Scaffold(
      appBar: WidgetUtils.createAppBar(widget.talkRoom.talkAccount.name),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.lightBlue.withOpacity(0.3),
              child: StreamBuilder<QuerySnapshot>(
                  stream: RoomFirestore.fetchMessageSnapshot(
                      widget.talkRoom.roomId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const RangeMaintainingScrollPhysics(),
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            final Message message = Message(
                                message: data['message'],
                                isMe: myUid == data['sender_id'] ? true : false,
                                sendTime: data['send_time']);
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: index == 0 ? 10 : 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                textDirection: message.isMe
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 3),
                                    child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: message.isMe
                                              ? Colors.lightBlue
                                              : Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        child: Text(
                                          message.message,
                                          style: const TextStyle(fontSize: 16),
                                        )),
                                  ),
                                  Text(intl.DateFormat('HH:mm')
                                      .format(message.sendTime.toDate())),
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
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    await RoomFirestore.sendMessage(
                        widget.talkRoom.roomId, controller.text);
                    controller.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          // ignore: sized_box_for_whitespace
          Container(
            height: 100,
            child: const Text('広告スペース'),
          ),
        ],
      ),
    );
  }
}
