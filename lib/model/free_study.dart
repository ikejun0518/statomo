import 'package:cloud_firestore/cloud_firestore.dart';

class FreeStudy {
  String documentID;
  String joinedUserID;
  String joinedUserName;
  Timestamp? joinedTime;

  FreeStudy({
    this.documentID = '',
    this.joinedUserID = '',
    this.joinedTime,
    this.joinedUserName = '',
  });
}
