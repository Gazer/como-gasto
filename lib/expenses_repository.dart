import 'package:cloud_firestore/cloud_firestore.dart';

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

  add(String categoryName, double value, DateTime date) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .document()
        .setData({
      "category": categoryName,
      "value": value,
      "month": date.month,
      "day": date.day,
      "year": date.year,
    });
  }
}
