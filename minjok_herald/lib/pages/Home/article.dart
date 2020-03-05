import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class articlepage extends StatefulWidget {
  final DocumentSnapshot post;
  String username;

  articlepage({this.post, this.username});

  @override
  articlepageState createState() => articlepageState();
}

class articlepageState extends State<articlepage> {
  String contents;
  DateTime posttime;
  String time;
  bool comment_state = false;
  String commenttmp = "";
  String message = 'comment';
  FocusNode myFocusNode;

  final _formKey = GlobalKey<FormState>();

  var comments_data = new List();

  void initState() {
    if (widget.username == null) {
      widget.username = '익명';
    }
    comments_data = widget.post.data['comments'];
    contents = widget.post.data["contents"];
    print(contents);
    contents = contents.replaceAll("\\n", "\n\n");
    myFocusNode = FocusNode();
    posttime =
        new DateTime.fromMillisecondsSinceEpoch(widget.post.data["timestamp"]);
    time = posttime.toString();
    int tmp;
    for (int i = 0; i < time.length; i++) {
      if (time[i] == " ") {
        tmp = i;
        break;
      }
    }
    if (comments_data == null) {
      comments_data = ["*divide*"];
    }

    time = time.substring(0, tmp + 1);
    print(time);
  }

  TextEditingController _textFieldController = TextEditingController();
  Widget write_comments() {
    if (comment_state == false) {
      return Container(
          child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      ));
    } else {
      return Container(
          child: Form(
        key: _formKey,
        child: TextFormField(
          focusNode: myFocusNode,
          decoration: InputDecoration(
              hintText: 'comments',
              filled: false,
              suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _onSave();
                    debugPrint('222');
                    comment_state = false;

                    setState(() {});
                  })),
          validator: (value) {
            commenttmp = value;
            if (value.isEmpty) {
              return '내용을 입력해주세요.';
            }
          },
          onSaved: (val) => setState(() {
//              widget.review.title = val;
          }),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 180.0,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                    tag: widget.post.documentID,
                    child: Image.network(
                      widget.post.data["url"],
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 6, 0)),
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(
                            widget.post.data["title"],
                            style: TextStyle(
//                      fontWeight: FontWeight.w600,
                              fontSize: 25,
                              fontFamily: 'NanumSquareRound',
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Text(
                            contents,
                            style: TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontSize: 17,
                                height: 1.5),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
                          write_comments(),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            itemCount: comments_data.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              String tmp = comments_data[index];
                              var arr = tmp.split('*divide*');
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            arr[0],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          subtitle: Text(
                                            arr[1],
                                            style: TextStyle(height: 2),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          )
//                                   ListView.builder(
//                                     padding: const EdgeInsets.all(8),
//                                        itemCount: comments_data.length,
//                                        physics: const NeverScrollableScrollPhysics(),
//                                        itemBuilder: (BuildContext context, index) {
//                                          return ListTile(
//                                          title: Text(comments_data[index]),
//                                        );
//                                      },
//                                   )
                        ],
                      )))
            ]))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          FocusScope.of(context).requestFocus(myFocusNode);
          setState(() {
            if (comment_state == false) {
              comment_state = true;
            } else {
              comment_state = false;
            }
          });
        },
        label: Text(message),
        icon: Icon(Icons.comment),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }

  refresh() async {
    DocumentReference getcomment =
        Firestore.instance.collection('news').document(widget.post.documentID);
    DocumentSnapshot doc = await getcomment.get();
    setState(() {
      print(comments_data);
      comments_data = doc.data['comments'];
      print(comments_data);
    });

    print(comments_data);
  }

  _onSave() async {
    final form = _formKey.currentState;

    if (!form.validate()) {
      return;
    }

    DocumentReference getcomment =
        Firestore.instance.collection('news').document(widget.post.documentID);

    commenttmp = widget.username + '*divide*' + commenttmp;
    comments_data.add(commenttmp);
    print('tmp 값은' + widget.username);
    getcomment.updateData({'comments': comments_data});

    setState(() {
      refresh();
      comments_data;
    });
  }
}
