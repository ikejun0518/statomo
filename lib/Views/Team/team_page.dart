import 'package:flutter/material.dart';
import 'package:statomo_application/Views/Team/user_add_page.dart';

import '../../model/account.dart';
import '../../model/team.dart';
import '../../utils/widget_utils.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Team myteam = Team(
    name: 'スタとも',
    teamId: 'Statomo',
  );
  List teamMember = [
    Account(
      id: '1',
      name: '池田',
      selfIntroduction: 'こんにちは',
      userId: 'ikeda',
      imagePath:
          'https://cdn.icon-icons.com/icons2/2596/PNG/512/check_one_icon_155665.png',
      todayStudyTime: 300,
      lastStudyTime: 240,
      weeklyStudyTime: 1215,
    ),
    Account(
      id: '2',
      name: '青嶋',
      selfIntroduction: 'こんにちは',
      userId: 'aoshima',
      imagePath:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Circle-icons-computer.svg/512px-Circle-icons-computer.svg.png?20160314153535',
      todayStudyTime: 360,
      lastStudyTime: 300,
      weeklyStudyTime: 1520,
    )
  ];

  // ignore: non_constant_identifier_names
  List<dynamic> TotalStudyTime() {
    var total = 0;
    List<dynamic> totalList = [];
    for (int i = 0; i < teamMember.length; i++) {
      int studytime = teamMember[i].weeklyStudyTime;
      total += studytime;
    }

    int totalh = (total / 60).floor();
    int totalm = total % 60;
    totalList.add(totalh);
    totalList.add(totalm);

    return totalList;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> totalList0 = TotalStudyTime();
    return Scaffold(
      appBar: WidgetUtils.createAppBar('チーム ${myteam.name}'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.center,
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: Text('今週の総勉強時間: ${totalList0[0]} h ${totalList0[1]} m',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: ListView.builder(
                itemCount: teamMember.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              foregroundImage:
                                  NetworkImage(teamMember[index].imagePath),
                            ),
                            Text(
                              teamMember[index].name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 250,
                                  child: Text(
                                      '今日の勉強時間: ${teamMember[index].todayStudyTime} 分',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '昨日の勉強時間: ${teamMember[index].lastStudyTime} 分',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '今週の勉強時間: ${teamMember[index].weeklyStudyTime} 分',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserAddPage()));
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
