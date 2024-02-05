import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/_pages/user_model.dart';

class DataBaseUtiles {
  static CollectionReference<MyUser> getUserCollectioon() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromJson(snapshot.data()!),
            toFirestore: (user, options) => user.toJson());
  }

  static Future<void> registerUser(MyUser user) async {
    return getUserCollectioon().doc(user.id).set(user);
  }

  static Future<MyUser?> getUser(String userId) async {
    var documentSnapshot = await getUserCollectioon().doc(userId).get();
    return documentSnapshot.data();
  }
}
