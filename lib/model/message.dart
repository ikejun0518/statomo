import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String name;
  String imagePath;
  bool isMe;
  Timestamp sendTime;

  Message({required this.message, required this.isMe, required this.sendTime, this.name = '', this. imagePath = ''});
}
