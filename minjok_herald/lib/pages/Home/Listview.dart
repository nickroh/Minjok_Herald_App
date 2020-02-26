import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentView extends StatelessWidget {

  final DocumentSnapshot documentData;
  DocumentView(this.documentData);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      height: 150,

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,

        color: Color.fromRGBO(255, 255, 255, 1.0),
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey),
//          borderRadius: BorderRadius.circular(5.0),
//        ),
        child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
        print('Card tapped.');
        },
        child: ListTile(
          title: Text(
              documentData.data["title"],
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
          ),



          subtitle: Row(
            children: <Widget>[
//              Text(documentData.data["price"].toString()),
              SizedBox(width: 10, height: 10),
//              Text(documentData.data["purchase?"].toString()),
            ],
          ),
        ),
      ),
    ));
  }
}