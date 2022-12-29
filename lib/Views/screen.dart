import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'UserPage/my_page.dart';
import 'DM/dm_page.dart';
import 'time_line/time_line_page_all.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final pageList = [const TimeLinePageAll(), const DMPage(), const MyPage()];
  // ignore: prefer_final_fields
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: PersistentTabView(context,
            controller: _controller,
            screens: pageList,
            navBarStyle: NavBarStyle.style1,
            items: [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.view_timeline),
                title: 'タイムライン',
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.chat),
                title: 'チャット',
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.emoji_events),
                title: 'マイページ',
              ),
            ]),
      ),
    );
  }
}
