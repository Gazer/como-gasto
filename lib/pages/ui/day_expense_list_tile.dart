import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DayExpenseListTile extends StatelessWidget {
  const DayExpenseListTile({
    Key key,
    @required this.document,
  }) : super(key: key);

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\$${document["value"]}",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
      subtitle: document['imageUrl'] == null
          ? null
          : Image.network(document['imageUrl']),
    );
  }
}
