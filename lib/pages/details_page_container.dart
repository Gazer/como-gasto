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

class DetailsPageContainer extends StatefulWidget {
  final DetailsParams params;

  const DetailsPageContainer({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageContainerState createState() => _DetailsPageContainerState();
}

class _DetailsPageContainerState extends State<DetailsPageContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesRepository>(
      builder: (BuildContext context, ExpensesRepository db, Widget child) {
        var _query = db.queryByCategory(
            widget.params.month + 1, widget.params.categoryName);

        return StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return DetailsPage(
                  categoryName: widget.params.categoryName,
                  documents: data.data.documents,
                  onDelete: (documentId) {
                    db.delete(documentId);
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            });
      },
    );
  }
}