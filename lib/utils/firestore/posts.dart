import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/account.dart';
import '../../model/post.dart';
import '../authentication.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts =
      _firestoreInstance.collection('posts');

  static final postRoomPageCollection =
      _firestoreInstance.collection('post_room');

  static Future<String?> addPost(Post newPost) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      final CollectionReference _userPosts = _firestoreInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_posts');

      var result = await posts.add({
        'post_account_id': newPost.postAccountId,
        'subject': newPost.subject,
        'status': newPost.status,
        'memo1': newPost.memo1,
        'post_room_name': newPost.postRoomName,
        'created_time': Timestamp.now(),
      });
      _userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
        'joined_user_id': [],
      });
      print('投稿完了');
      return result.id;
    } on FirebaseException catch (e) {
      print('投稿エラー: $e');
      return null;
    }
  }

  static Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    List<Post> postList = [];
    try {
      await Future.forEach(ids, (String id) async {
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
            id: doc.id,
            subject: data['subject'],
            status: data['status'],
            postAccountId: data['post_account_id'],
            postRoomName: data['post_room_name'],
            createdTime: data['created_time']);
        postList.add(post);
      });
      return postList;
    } on FirebaseException catch (e) {
      print('自分の投稿取得エラー: $e');
      return null;
    }
  }

  static Future<String?> createPostRoom(
      Account myAccount, String postRoomName) async {
    try {
      final QuerySnapshot snapshot = await postRoomPageCollection
          .where('joined_user_id', arrayContains: myAccount.id)
          .get();

      if (snapshot.docs.isEmpty) {
        final postRoom = postRoomPageCollection.doc();
        await postRoom.set({
          'post_room_name': postRoomName,
          'joined_user_id': [myAccount.id],
          'created_time': Timestamp.now(),
          'roomID': postRoom.id
        });

        print('ルーム作成完了');
        return postRoom.id;
      } else {
        print('ルーム参加済み');
      }
    } catch (e) {
      print('ルーム作成失敗 : $e');
      return null;
    }
    return null;
  }

  static Future<dynamic> joinedPostRoom(
      Account myAccount, String roomID) async {
    try {
      final QuerySnapshot snapshot = await postRoomPageCollection
          .where('joined_user_id', arrayContains: myAccount.id)
          .get();
      if (snapshot.docs.isEmpty) {
        await postRoomPageCollection.doc(roomID).update({
          'joined_user_id': FieldValue.arrayUnion([myAccount.id])
        });
        DocumentSnapshot postRoomsnapshot =
            await postRoomPageCollection.doc(roomID).get();
        String postID = await postRoomsnapshot.get('post_id');
        DocumentSnapshot postsnapshot = await posts.doc(postID).get();
        String postAccountID = await postsnapshot.get('post_account_id');
        // ignore: no_leading_underscores_for_local_identifiers
        final CollectionReference _userPosts = _firestoreInstance
            .collection('users')
            .doc(postAccountID)
            .collection('my_posts');
        await _userPosts.doc(postID).update({
          'joined_user_id': FieldValue.arrayUnion([myAccount.id])
        });
      }
      print('ルーム参加完了');
    } catch (e) {
      print('ルーム参加失敗:$e');
    }
  }

  static Future<dynamic> setStatus(String postID, bool plusminus) async {
    DocumentSnapshot postSnapshot = await PostFirestore.posts.doc(postID).get();
    int status = postSnapshot.get('status');
    if (plusminus == true) {
      await PostFirestore.posts.doc(postID).update({'status': status + 1});
    } else {
      await PostFirestore.posts.doc(postID).update({'status': status - 1});
    }
  }

  static Future<String?> getPostRoomId(String myUid) async {
    try {
      String? roomID;
      await postRoomPageCollection
          .where('joined_user_id', arrayContains: myUid)
          .get()
          .then(
        (QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            roomID = doc.get('roomID');
          }
        },
      );
      return roomID;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> sendMessageRoom(String postId, String message) async {
    try {
      if (Authentication.myAccount != null) {
        String myAccountId = Authentication.myAccount!.id;
        final messageCollection =
            posts.doc(postId).collection('message');
        await messageCollection.add({
          'message': message,
          'sender_id': myAccountId,
          'send_time': Timestamp.now(),
          'name' : Authentication.myAccount!.name,
          'image_path' : Authentication.myAccount!.imagePath
        });
      }
    } catch (e) {
      print('メッセージの送信失敗: $e');
    }
  }

  static Stream<QuerySnapshot> fetchMessageSnapshotRoom(String postId) {
    return posts
        .doc(postId)
        .collection('message')
        .orderBy('send_time', descending: true)
        .snapshots();
  }


  static Future<dynamic> leaveRoom(Account myAccount, String roomID) async {
    try {
      String myUid = myAccount.id;
      DocumentSnapshot snapshot =
          await PostFirestore.postRoomPageCollection.doc(roomID).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> accountIds = data['joined_user_id'];
      String postID = data['post_id'];
      if (accountIds.length == 1) {
        postRoomPageCollection.doc(roomID).delete();
        posts.doc(postID).update({'post_room_id': null});
      } else {
        await postRoomPageCollection.doc(roomID).update({
          'joined_user_id': FieldValue.arrayRemove([myUid])
        });
      }
      print('退室完了');
    } catch (e) {
      print('退室失敗 : $e');
    }
  }

  static Future<dynamic> deletePosts(String accountId) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final CollectionReference _userPosts = _firestoreInstance
        .collection('users')
        .doc(accountId)
        .collection('my_posts');

    var snapshot = await _userPosts.get();
    // ignore: avoid_function_literals_in_foreach_calls
    snapshot.docs.forEach((doc) async {
      await posts.doc(doc.id).delete();
      _userPosts.doc(doc.id).delete();
    });
  }
}
