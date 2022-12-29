import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statomo_application/Views/UserPage/user_information_page.dart';

import '../../model/account.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Account? myAccount;
  String? myUid;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserInformationPage()));
                            if (result == true) {
                              setState(() {
                                myAccount = Authentication.myAccount;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 100,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                            radius: 35,
                                            foregroundImage:
                                                myAccount != null
                                                    ? NetworkImage(
                                                        myAccount!.imagePath)
                                                    : null),
                                      ),
                                      Flexible(
                                        // ignore: avoid_unnecessary_containers
                                        child: Container(
                                          child: Column(
                                            children: [
                                              myAccount != null
                                                  ? Text(
                                                      myAccount!.name,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    )
                                                  : const Text('no name'),
                                              myAccount != null
                                                  ? Text(
                                                      '@${myAccount!.userId}')
                                                  : const Text('no userId'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: UserFirestore.users.doc(myUid!).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int myPoint = snapshot.data!.get('my_point');
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Flexible(
                                    child: Container(
                                      height: 80,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Column(
                                          children: [
                                            const Text(
                                              '現在のポイント',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '$myPoint ポイント',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'coming soon...',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
