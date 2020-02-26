import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:minjok_herald/pages/Home/Listview.dart';
import 'dart:async';
import 'package:minjok_herald/pages/auth/authentication.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mainpage extends StatefulWidget {
  mainpage({Key key, this.auth, this.userId, this.onSignedOut, this.username})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String username;

  @override
  State<StatefulWidget> createState() => new _mainpageState();
}

class _mainpageState extends State<mainpage>{

  final Firestore database = Firestore.instance; // firebase 에서 데이터 로드
//  String activetag = 'main'; // default 페이지 main 그냥 로드

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Stream maindata;
  Stream pressdata;
  Future mydata;

  bool _isEmailVerified = false;
  int selectedIndex = 0;
  int currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
    _pageController = PageController();

    maindata = getmain();
    pressdata = getpress();

  }


  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }
  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }
  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => currentIndex = index);
          },
          children: <Widget>[
            main_page(),
            Container(color: Colors.white,),
            press_page(),
            setting_page()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Main'),
              icon: Icon(Icons.home),
              activeColor: Colors.red
          ),
          BottomNavyBarItem(
              title: Text('Me'),
              icon: Icon(Icons.apps),
              activeColor: Colors.green
          ),
          BottomNavyBarItem(
              title: Text('Press'),
              icon: Icon(Icons.chat_bubble),
              activeColor: Colors.blue
          ),
          BottomNavyBarItem(
              title: Text('Setting'),
              icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
  Container article_list(){

  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }


  Stream<QuerySnapshot> getmain() {
    var firestore = Firestore.instance;
    return firestore.collection('news').where('tags', arrayContains: 'main').orderBy('timestamp').limit(30).snapshots();
  }

  Stream<QuerySnapshot> getpress() {
    var firestore1 = Firestore.instance;
    return firestore1.collection('news').where('tags', arrayContains: 'press').orderBy('timestamp').limit(30).snapshots();
  }


  @override
  Widget main_page(){

    return new Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Minjok Herald",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )),

              ),
            ];
          },
          body: Container(
            padding: EdgeInsets.all(16),
            child: new Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Minjok Herald ',
                        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black)
//                children: <TextSpan>[
//                  TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
//                  TextSpan(text: ' world!'),
//                ],
                    ),
                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top: 70.0),
                  child: StreamBuilder(
                      stream: maindata,
                      builder: (context, snapshot){

                        if(!snapshot.hasData){
                          return _buildWaitingScreen();
                        } else{
                          List<DocumentSnapshot> documents = snapshot.data.documents;

                          return ListView(
                            padding:EdgeInsets.only(top: 20.0),
                            children:
                            documents.map((eachDocument) => DocumentView(eachDocument)).toList(),
                          );
                        }
                      }),
                ),
              ],
            ),

          ),
          ),
        );


//    return new Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//            expandedHeight: 200.0,
//            floating: false,
//            pinned: true,
//            flexibleSpace: FlexibleSpaceBar(
//              title: Text('Minjok Herald'),
//              background: Image.network('https://wallpaperset.com/w/full/4/9/8/29756.jpg',
//              fit: BoxFit.cover,),
//            ),
//          ),
//          SliverFillRemaining(
//            child: new Container(
//              padding: EdgeInsets.all(16),
//              child: new Stack(
//                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.only(top: 30.0),
//                    child: RichText(
//                      text: TextSpan(
//                          text: 'Minjok Herald ',
//                          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black)
////                children: <TextSpan>[
////                  TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
////                  TextSpan(text: ' world!'),
////                ],
//                      ),
//                    ),
//
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(top: 70.0),
//                    child: StreamBuilder(
//                        stream: maindata,
//                        builder: (context, snapshot){
//
//                          if(!snapshot.hasData){
//                            return _buildWaitingScreen();
//                          } else{
//                            List<DocumentSnapshot> documents = snapshot.data.documents;
//
//                            return ListView(
//                              padding:EdgeInsets.only(top: 20.0),
//                              children:
//                              documents.map((eachDocument) => DocumentView(eachDocument)).toList(),
//                            );
//                          }
//                        }),
//                  ),
//                ],
//              ),
//
//            ),
//          )
//        ],
//      ),
//    );

  }

  Widget press_page(){
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: StreamBuilder(
          stream: pressdata,
          builder: (context, snapshot){

            if(!snapshot.hasData){
              return _buildWaitingScreen();
            } else{
              List<DocumentSnapshot> documents = snapshot.data.documents;

              return ListView(
                padding:EdgeInsets.only(top: 20.0),
                children: documents.map((eachDocument) => DocumentView(eachDocument)).toList(),
              );
            }
          }),
    );
  }


  Widget setting_page(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        //visible: _dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'First',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'Second',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print(maindata),
          ),
          SpeedDialChild(
              child: Icon(Icons.clear),
              backgroundColor: Colors.red,
              label: '로그아웃',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => {
                _signOut()
              }
          ),
        ],
      ),
    );
  }

}