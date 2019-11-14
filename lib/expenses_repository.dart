import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ExpensesRepository {
  final String userId;

  ExpensesRepository(this.userId);

  Stream<QuerySnapshot> queryByCategory(int month, String categoryName) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .where("month", isEqualTo: month)
        .where("category", isEqualTo: categoryName)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByMonth(int month) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .where("month", isEqualTo: month)
        .snapshots();
  }

  delete(String documentId) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .document(documentId)
        .delete();
  }

  add(String categoryName, double value, DateTime date, File selectedImage) async {
    var document = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .document();

    await document.setData({
      "category": categoryName,
      "value": value,
      "month": date.month,
      "day": date.day,
      "year": date.year,
    });

    if (selectedImage != null) {
      var imageName = Uuid().v1();
      var imagePath = "/users/$userId/$imageName.jpg";
      final StorageReference storageReference = FirebaseStorage().ref().child(imagePath);

      final StorageUploadTask uploadTask = storageReference.putFile(selectedImage);

      final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
        // You can use this to notify yourself or your user in any kind of way.
        // For example: you could use the uploadTask.events stream in a StreamBuilder instead
        // to show your user what the current status is. In that case, you would not need to cancel any
        // subscription as StreamBuilder handles this automatically.

        // Here, every StorageTaskEvent concerning the upload is printed to the logs.
        print('EVENT ${event.type}');
      });

      // Cancel your subscription when done.
      await uploadTask.onComplete;
      streamSubscription.cancel();

      document.setData({
        "imageUrl": (await storageReference.getDownloadURL()).toString(),
      }, merge: true,);
    }
  }
}
