import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statomo_application/model/account.dart';
import 'package:statomo_application/model/talk_room.dart';
import 'package:statomo_application/utils/firestore/users.dart';
import 'package:statomo_application/utils/shared_prefs.dart';

import '../authentication.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final roomCollection = _firebaseFirestoreInstance.collection("room");
  static final joinedRoomSnapshot = roomCollection
      .where('joined_user_id', arrayContains: SharedPrefs.fetchUid())
      .snapshots();
  static final freeStudyCollection =
      _firebaseFirestoreInstance.collection('free_study');

  static Future<dynamic> createRoom(String myUid, String userUid) async {
    try {
      QuerySnapshot snapshot1 = await roomCollection
          .where('joined_user_id', isEqualTo: [myUid, userUid]).get();
      QuerySnapshot snapshot2 = await roomCollection
          .where('joined_user_id', isEqualTo: [userUid, myUid]).get();
      if (snapshot1.docs.isEmpty && snapshot2.docs.isEmpty) {
        await roomCollection.add({
          'joined_user_id': [userUid, myUid],
          'created_time': Timestamp.now(),
          'last_send_time': Timestamp.now()
        });
        print('トークルーム作成完了');
        return true;
      } else {
        print('トークルームが既にあります');
        return true;
      }
    } catch (e) {
      print('ルームの作成失敗 : $e');
      return false;
    }
  }

  static Future<dynamic> joinedFreeStudy(String myUid, String myName) async {
    try {
      final QuerySnapshot snapshot = await freeStudyCollection
          .where('joined_user_id', isEqualTo: myUid)
          .get();
      // ignore: unnecessary_null_comparison
      if (snapshot.docs.isEmpty) {
        final room = freeStudyCollection.doc();
        await room.set({
          'joined_user_name': myName,
          'joined_user_id': myUid,
          'joined_time': Timestamp.now(),
          'documentID': room.id,
        });
        print('自習室参加完了');
        return;
      } else {
        print('参加済み');
        return;
      }
    } catch (e) {
      print('自習室参加失敗 : $e');
      return;
    }
  }

  static Future<dynamic> deleteFreeStudy(String myUid) async {
    await freeStudyCollection
        .where('joined_user_id', isEqualTo: myUid)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        String documentId = doc.get('documentID');
        print(documentId);
        freeStudyCollection.doc(documentId).delete();
      }
    });
  }

  static Future<List<TalkRoom>?> fetchJoinedRooms(
      QuerySnapshot snapshot) async {
    try {
      String myUid = SharedPrefs.fetchUid()!;

      List<TalkRoom> talkRooms = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> accountIds = data['joined_user_id'];
        late String talkAccountUid;
        for (var id in accountIds) {
          if (id == myUid) continue;
          talkAccountUid = id;
        }
        Account? talkAccount = await UserFirestore.fetchProfile(talkAccountUid);
        // ignore: unnecessary_null_comparison
        if (talkAccount == null) return null;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkAccount: talkAccount,
            lastMessage: data['last_message']);
        talkRooms.add(talkRoom);
      }
      return talkRooms;
    } catch (e) {
      print('ルーム取得失敗: $e');
      return null;
    }
  }

  static Future<TalkRoom?> getTalkRoom(String myUid, String userUid) async {
    try {
      QuerySnapshot snapshot1 = await roomCollection
          .where('joined_user_id', isEqualTo: [myUid, userUid]).get();
      QuerySnapshot snapshot2 = await roomCollection
          .where('joined_user_id', isEqualTo: [userUid, myUid]).get();
      if (snapshot2.docs.isEmpty) {
        for (var doc in snapshot1.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Account? talkAccount = await UserFirestore.fetchProfile(userUid);
          final talkRoom = TalkRoom(
              roomId: doc.id,
              talkAccount: talkAccount,
              lastMessage: data['last_message']);
          return talkRoom;
        }
      } else {
        for (var doc in snapshot2.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Account? talkAccount = await UserFirestore.fetchProfile(userUid);
          final talkRoom = TalkRoom(
              roomId: doc.id,
              talkAccount: talkAccount,
              lastMessage: data['last_message']);
          return talkRoom;
        }
      }
    } catch (e) {
      print('トーク取得失敗:$e');
      return null;
    }
    return null;
  }

  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomId) {
    return roomCollection
        .doc(roomId)
        .collection('message')
        .orderBy('send_time', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(String roomId, String message) async {
    try {
      if (Authentication.myAccount != null) {
        String myAccountId = Authentication.myAccount!.id;
        final messageCollection =
            roomCollection.doc(roomId).collection('message');
        await messageCollection.add({
          'message': message,
          'sender_id': myAccountId,
          'send_time': Timestamp.now(),
        });
        await roomCollection
            .doc(roomId)
            .update({'last_send_time': Timestamp.now()});
      }
    } catch (e) {
      print('メッセージの送信失敗: $e');
    }
  }
}
