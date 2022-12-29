import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String postAccountId;
  String subject;
  String memo1;
  String postRoomId;
  String postRoomName;
  int status;
  bool camera;
  bool mic;
  Timestamp? createdTime;

  Post(
      {this.id = '',
      this.postAccountId = '',
      this.subject = '',
      this.memo1 = '',
      this.postRoomId = '',
      this.postRoomName = '',
      this.status = 0,
      this.camera = true,
      this.mic = true,
      this.createdTime});
}
