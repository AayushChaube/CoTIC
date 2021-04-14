import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

export 'package:provider/provider.dart';

abstract class HospitalDatabaseBase {
  Stream<List<PostModel>> getPostsLists();

  Future<void> createPosts(PostModel postModel);

  Future<String> uploadHealthWorkerImage(String path, File image);

  Future<void> createHealthWorker(
    String uid,
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
    DateTime created_At,
    String hospitalId,
    String profile_image,
    String mobile,
  );
}

class HospitalDatabase implements HospitalDatabaseBase {
  @override
  Stream<List<PostModel>> getPostsLists() async* {
    final String currentId = await FirebaseAuth.instance.currentUser.uid;
    final Stream<QuerySnapshot> posts = await FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("created", descending: true)
        .snapshots();
    yield* posts.map(
        (event) => event.docs.map((e) => PostModel.fromMap(e.data())).toList());
  }

  Future<void> createPosts(PostModel postModel) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postModel.id)
        .set(postModel.toMap());
  }

  Future<void> createHealthWorker(
    String uid,
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
    DateTime created_At,
    String hospitalId,
    String profile_image,
    String mobile,
  ) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Hospitals")
        .doc(hospitalId)
        .get();

    await FirebaseFirestore.instance.collection("Health Workers").doc(uid).set({
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "gender": gender,
      "created_At": DateTime.now(),
      "hospital_Id": hospitalId,
      "hospital_name": documentSnapshot.data()["hospital_name"],
      "profile_image": profile_image,
      "mobile": mobile,
    });
  }

  Future<String> uploadHealthWorkerImage(String path, File image) async {
    var snapshot =
        await FirebaseStorage.instance.ref().child(path).putFile(image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl ?? "";
  }
}
