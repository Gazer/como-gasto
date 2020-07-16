import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamWidget extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Widget Function(BuildContext) empty;
  final Widget Function(BuildContext) loading;
  final Widget Function(BuildContext, QuerySnapshot) done;

  const StreamWidget(
      {Key key, this.stream, this.empty, this.loading, this.done})
      : super(key: key);

  @override
  Widget build(BuildContext _) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
        if (data.connectionState == ConnectionState.active) {
          if (data.data.documents.length > 0) {
            return done(context, data.data);
          } else {
            return empty(context);
          }
        }

        return loading(context);
      },
    );
  }
}
