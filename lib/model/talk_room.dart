import 'account.dart';

class TalkRoom {
  String roomId;
  Account talkAccount;
  String? lastMessage;

  TalkRoom({
    required this.roomId,
    required this.talkAccount,
    this.lastMessage
  });
}
