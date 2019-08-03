import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:como_gasto/pages/ui/day_expense_list_tile.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String categoryName;
  final List<DocumentSnapshot> documents;
  final Function(String) onDelete;

  const DetailsPage({Key key, this.categoryName, this.documents, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          var document = documents[index];

          return Dismissible(
            key: Key(document.documentID),
            onDismissed: (direction) {
              onDelete(document.documentID);
            },
            child: new DayExpenseListTile(document: document),
          );
        },
      ),
    );
  }
}
