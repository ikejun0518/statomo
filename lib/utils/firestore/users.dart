import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statomo_application/utils/firestore/posts.dart';

import '../../model/account.dart';
import '../authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'grade': newAccount.grade,
        'gender': newAccount.gender,
        'des_school': newAccount.desSchool,
        'prefecture': newAccount.prefecture,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
        'documentID': newAccount.id,
        'study_time': 0,
        'my_point': newAccount.myPoint,
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザー登録エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
          id: uid,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          prefecture: data['prefecture'],
          desSchool: data['des_school'],
          gender: data['gender'],
          grade: data['grade'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']);

      Authentication.myAccount = myAccount;

      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー: $e');
      return false;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'user_id': updateAccount.userId,
        'image_path': updateAccount.imagePath,
        'prefecture': updateAccount.prefecture,
        'des_school': updateAccount.desSchool,
        'gender': updateAccount.gender,
        'grade': updateAccount.grade,
        'self_introduction': updateAccount.selfIntroduction,
        'updated_time': Timestamp.now(),
      });
      print('ユーザー情報更新完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー更新エラー: $e');
      return false;
    }
  }

  static Future<Map<String, Account>?> getPostUserMap(
      List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          prefecture: data['prefecture'],
          desSchool: data['des_school'],
          gender: data['gender'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time'],
        );
        map[accountId] = postAccount;
      });
      return map;
    } on FirebaseException catch (e) {
      print('投稿ユーザーの取得エラー:$e');
      return null;
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    final snapshot = await users.get();
    return snapshot.docs;
  }

  static Future<Account> fetchProfile(String uid) async {
    final snapshot = await users.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Account account = Account(
      id: uid,
      name: data['name'],
      userId: data['user_id'],
      imagePath: data['image_path'],
      prefecture: data['prefecture'],
      desSchool: data['des_school'],
      gender: data['gender'],
      selfIntroduction: data['self_introduction'],
      createdTime: data['created_time'],
      updatedTime: data['updated_time'],
    );

    return account;
  }

  static Future<dynamic> updateStudyTime(var count, String myUid) async {
    try {
      DocumentSnapshot snapshot = await UserFirestore.users.doc(myUid).get();
      // ignore: no_leading_underscores_for_local_identifiers
      int _myPoint = snapshot.get('my_point');
      // ignore: no_leading_underscores_for_local_identifiers
      int _count = snapshot.get('study_time');
      // ignore: unnecessary_null_comparison
      if (_count != null && _myPoint != null) {
        await UserFirestore.users
            .doc(myUid)
            .update({'study_time': _count + count});
        await UserFirestore.users
            .doc(myUid)
            .update({'my_point': (_count + count) ~/ 900});
      } else {
        await UserFirestore.users.doc(myUid).update({'study_time': count});
        await UserFirestore.users.doc(myUid).update({'my_point': count ~/ 900});
      }
      print('更新完了');
    } catch (e) {
      print('更新エラー：$e');
    }
  }

  static Future<int> getMyPoint(String myUid) async {
    DocumentSnapshot snapshot = await UserFirestore.users.doc(myUid).get();
    int myPoint = snapshot.get('my_point');
    return myPoint;
  }

  static Future<dynamic> deleteUser(String accountId) async {
    print(accountId);
    await users.doc(accountId).delete();
    PostFirestore.deletePosts(accountId);
  }
}
