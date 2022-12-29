import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:statomo_application/Views/Pages/post_room_page.dart';
import 'package:statomo_application/model/account.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/posts.dart';
import 'package:statomo_application/utils/widget_utils.dart';

import '../../model/post.dart';

class RoomPage extends StatefulWidget {
  final Post post;
  const RoomPage(this.post, {super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String? roomID;
  String? subject;
  Account? myAccount;
  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount!;
    }
    subject = widget.post.subject == 'NationalLanguage'
        ? '国語系'
        : widget.post.subject == 'Math'
            ? '数学系'
            : widget.post.subject == 'English'
                ? '外国語'
                : widget.post.subject == 'Science'
                    ? '理科系'
                    : widget.post.subject == 'Society'
                        ? '社会系'
                        : 'その他';
    return Scaffold(
      appBar: WidgetUtils.createAppBar('部屋に参加する'),
      body: Column(
        children: [
          Expanded(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          '教科:',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 100),
                        SizedBox(
                          width: 120,
                          child: Text(subject!,style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:subject ==
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
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Row(children: [
                      const Text(
                        '人数:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 100),
                      SizedBox(
                        width: 120,
                        child: Text('あと${widget.post.status}人',style: TextStyle(fontSize: 20, color: widget.post.status > 2 ? Colors.lightGreen : Colors.red),),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Row(
                      children: [
                        const Text(
                          'コメント:',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 40),
                        Flexible(
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            width: 200,
                            child: Text(widget.post.memo1,style:const TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
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
                        '参加',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      onPressed: () async {
                        DocumentSnapshot snapshot =
                            await PostFirestore.posts.doc(widget.post.id).get();
                        roomID = snapshot.get('post_room_id');
                        if (myAccount != null && roomID != null) {
                          await PostFirestore.joinedPostRoom(myAccount!, roomID!);
                          await PostFirestore.setStatus(widget.post.id, false);
                          String roomName = snapshot.get('post_room_name');
                          // ignore: use_build_context_synchronously
                          pushNewScreen<dynamic>(context,
                              screen: PostRoomPage(roomName), withNavBar: false);
                        }
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ),
          // ignore: sized_box_for_whitespace
          Container(height: 100,
          child: const Text('広告スペース'),)
        ],
      ),
    );
  }
}
