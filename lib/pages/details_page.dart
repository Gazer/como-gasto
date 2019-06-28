import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context).currentUser();
        var _query = Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('expenses')
            .where("month", isEqualTo: widget.params.month + 1)
            .where("category", isEqualTo: widget.params.categoryName)
            .snapshots();

        return Scaffold(
            appBar: AppBar(
              title: Text(widget.params.categoryName),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var document = data.data.documents[index];

                      return Dismissible(
                        key: Key(document.documentID),
                        onDismissed: (direction) {
                          Firestore.instance
                              .collection('users')
                              .document(user.uid)
                              .collection('expenses')
                              .document(document.documentID)
                              .delete();
                        },
                        child: ListTile(
                          leading: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 40,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 8,
                                child: Text(
                                  document["day"].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$${document["value"]}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.data.documents.length,
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
      },
    );
  }
}
