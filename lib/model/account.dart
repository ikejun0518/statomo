import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String imagePath;
  String selfIntroduction;
  String userId;
  String grade;
  String gender;
  String desSchool;
  String prefecture;
  String lastMessage;
  int myPoint;
  int todayStudyTime;
  int lastStudyTime;
  int weeklyStudyTime;
  Timestamp? createdTime;
  Timestamp? updatedTime;

  Account({
    this.id = '',
    this.name = '',
    this.imagePath = '',
    this.selfIntroduction = '',
    this.userId = '',
    this.grade = '',
    this.gender = '',
    this.desSchool = '',
    this.prefecture = '',
    this.lastMessage = '',
    this.myPoint = 0,
    this.todayStudyTime = 0,
    this.lastStudyTime = 0,
    this.weeklyStudyTime = 0,
    this.createdTime,
    this.updatedTime,
  });
}
