import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
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

  Stream news;

  bool _isEmailVerified = false;
  int selectedIndex = 0;
  int currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
    _pageController = PageController();

    getmainpage();
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
            Container(color: Colors.white,),
            Container(color: Colors.white,),
            Container(color: Colors.white,),
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

  Widget main_page(){
    return Container(
      child: new RefreshIndicator(
        onRefresh: _refresh_mainpage,
      )
    );
  }

  Future _refresh_mainpage() async {
    await getmainpage();
    setState(() {

    });
  }

  Future getmainpage() async{
    Query query =
        database.collection('news').where('tags', arrayContains: 'main');

    news = query.snapshots().map((list) => list.documents.map((doc)=> doc.data));

    setState(() {

    });
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
            onTap: () => print('SECOND CHILD'),
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