import 'package:cloud_firestore/cloud_firestore.dart';

class PostRoom {
  String roomID;
  String joinedUserID;
  String joinedUserName;
  Timestamp? joinedTime;

  PostRoom({
    this.roomID = '',
    this.joinedUserID = '',
    this.joinedTime,
    this.joinedUserName = '',
  });
}