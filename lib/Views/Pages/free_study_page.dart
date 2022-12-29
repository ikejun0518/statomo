import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:statomo_application/Views/screen.dart';
import 'package:statomo_application/model/account.dart';
import 'package:statomo_application/utils/authentication.dart';
import 'package:statomo_application/utils/firestore/room.dart';
import 'package:statomo_application/utils/firestore/users.dart';

import '../../model/free_study.dart';

class FreeStudyPage extends StatefulWidget {
  const FreeStudyPage({super.key});

  @override
  State<FreeStudyPage> createState() => _FreeStudyPageState();
}

class _FreeStudyPageState extends State<FreeStudyPage> {
  Account? myAccount;
  String? myUid;
  DateTime? _time;
  Timer? _timer;
  var count = 0;
  var isRunning = false;

  @override
  void initState() {
    isRunning = true;
    _time = DateTime.utc(0, 0, 0);
    timerIsRun();
    super.initState();
  }

  void timerIsRun() {
    if (isRunning == true) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (_time != null) {
          setState(() {
            _time = _time!.add(const Duration(seconds: 1));
            count += 1;
          });
        }
      });
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  void timer(Timer timer) {
    if (_time != null) {
      setState(() {
        _time = _time!.add(const Duration(seconds: 1));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
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
                  const Text(
                    '自習室',
                    style: TextStyle(fontSize: 24),
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
              child: Column(
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: RoomFirestore.freeStudyCollection
                            .orderBy('joined_time', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 3 / 2),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final doc = snapshot.data!.docs[index];
                                final Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;
                                final FreeStudy freeStudy = FreeStudy(
                                    joinedUserName: data['joined_user_name'],
                                    joinedUserID: data['joined_user_id'],
                                    joinedTime: data['joined_time'],
                                    documentID: data['documentID']);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Flexible(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                              color: myUid != null && data['joined_user_id'] == myUid ? Colors.lightBlue.withOpacity(0.2) : Colors.white
                                              ),
                                      child: Center(
                                        child: Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25, left: 5, right: 5),
                                                child: Text(
                                                    freeStudy.joinedUserName),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      minimumSize: const Size(60, 30)),
                  onPressed: () async {
                    isRunning = false;
                    timerIsRun();
                    if (myUid != null) {
                      UserFirestore.updateStudyTime(count, myUid!);
                      RoomFirestore.deleteFreeStudy(myUid!);
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
            ),
          ]),
        ),
      ),
    );
  }
}
