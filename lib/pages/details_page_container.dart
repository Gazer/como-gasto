import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../expenses_repository.dart';
import 'details_page.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPageContainer extends StatelessWidget {
  final DetailsParams params;

  const DetailsPageContainer({Key key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<ExpensesRepository>(context);
    final query = db.queryByCategory(params.month + 1, params.categoryName);

    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
        if (data.hasData) {
          return DetailsPage(
            categoryName: params.categoryName,
            documents: data.data.documents,
            onDelete: (documentId) {
              db.delete(documentId);
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
