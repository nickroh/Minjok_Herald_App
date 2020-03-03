import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minjok_herald/pages/Home/article.dart';

class DocumentView extends StatelessWidget {
  final DocumentSnapshot documentData;
  DocumentView(this.documentData);

  Widget _Image() {
    return Image.network(
      documentData.data["url"],
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (documentData.data["url"] != null) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => articlepage(post: documentData)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: <Widget>[
//                    Image.network(
//                      documentData.data["url"],
//                      fit: BoxFit.fill,
//                    ),
                    Hero(
                      tag: documentData.documentID,
                      child: _Image(),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10,2,10,10),

                      title: Text(
                        documentData.data["title"],
                        style: TextStyle(
                            fontSize: 17.5, fontWeight: FontWeight.w400, fontFamily: 'NanumSquareRound'),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
          height: 150,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator;
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10,2,10,10),

                      title: Text(
                        documentData.data["title"],
                        style: TextStyle(
                            fontSize: 17.5, fontWeight: FontWeight.w400),
                      ),


                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }
}

//      height: 150,

//      child: Card(
//        semanticContainer: true,
//        clipBehavior: Clip.antiAliasWithSaveLayer,
//
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(15),
//        ),
//        elevation: 3,
//
//        color: Color.fromRGBO(255, 255, 255, 1.0),
//////        decoration: BoxDecoration(
//////          border: Border.all(color: Colors.grey),
//////          borderRadius: BorderRadius.circular(5.0),
//////        ),
//
////        child: InkWell(
////
////        splashColor: Colors.blue.withAlpha(30),
////        onTap: () {
////        print('Card tapped.');
////        },
//        child: ListTile(
//
//          title: Text(
//              documentData.data["title"],
//              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
//          ),
//
//
//          subtitle: Row(
//            children: <Widget>[
////              Text(documentData.data["price"].toString()),
//              SizedBox(width: 10, height: 10),
////              Text(documentData.data["purchase?"].toString()),
//            ],
//          ),
//        ),
//    )
