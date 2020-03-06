import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:minjok_herald/pages/Home/Listview.dart';
import 'dart:async';
import 'package:minjok_herald/pages/auth/authentication.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mainpage extends StatefulWidget {
  mainpage({Key key, this.auth, this.userId, this.onSignedOut, this.username, this.userEmail})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  String username;
  String userEmail;

  @override
  State<StatefulWidget> createState() => new _mainpageState();
}

class _mainpageState extends State<mainpage>{

  final Firestore database = Firestore.instance; // firebase 에서 데이터 로드
//  String activetag = 'main'; // default 페이지 main 그냥 로드

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Stream maindata;
  Stream pressdata;
  Stream mydata;

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
    mydata = getmydata();

    if(widget.username == null){
      widget.username = ' ';
    }
    if(widget.userEmail == null){
      widget.userEmail=' ';
    }




    print('current user'+widget.userEmail);
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
              title: Text('Legislative'),
              icon: Icon(Icons.check),
              activeColor: Colors.red
          ),
          BottomNavyBarItem(
              title: Text('Judicial'),
              icon: Icon(Icons.check),
              activeColor: Colors.green
          ),
          BottomNavyBarItem(
              title: Text('Executive'),
              icon: Icon(Icons.check),
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

  Stream<QuerySnapshot> getmydata() {
    var firestore1 = Firestore.instance;
    return firestore1.collection('news').where('tags', arrayContains: 'press').orderBy('timestamp').limit(30).snapshots();
  }


  @override
  Widget main_page(){

    return new Scaffold(
        body: SafeArea(

          child:NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
//                  leading: IconButton(
//                      icon: Icon(Icons.menu),
//                      onPressed: null
//                  ),
                  expandedHeight: 200.0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Press 2020-1",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500
                          )),
                      background: Image.network(
                        "https://blog.malwarebytes.com/wp-content/uploads/2019/12/Washington-DC-Capitol-building-900x506.jpg",
                        fit: BoxFit.cover,
                      )
//                        background: Image.asset(
//                          'assets/test.png',
//                          fit: BoxFit.cover,
//                        ),
                  ),

                ),

              ];

            },
            body: Container(
              padding: EdgeInsets.all(3),
              child: new Stack(
                children: <Widget>[
                  Container(
//                  padding: EdgeInsets.only(top: 30.0),
//                  child: RichText(
//                    text: TextSpan(
//                        text: 'Minjok Herald ',
//                        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black)
////                children: <TextSpan>[
////                  TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
////                  TextSpan(text: ' world!'),
////                ],
//                    ),
//                  ),

                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.0),
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
                              documents.map((eachDocument) => DocumentView(eachDocument, widget.username)).toList(),
                            );
                          }
                        }),
                  ),
                ],
              ),

            ),
          ),


          ),
      drawer:Drawer(
        // column holds all the widgets in the drawer
        child: Column(
          children: <Widget>[
            Expanded(
              // ListView contains a group of widgets that scroll inside the drawer
              child: ListView(
                children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: new Text(
                    widget.username,
                    style: new TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white, height: 2
                    ),
                  ),
                  accountEmail: new Text(
                      widget.userEmail,
                      style: new TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white
                  )
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer

                widget.auth.getCurrentUser().then((user) {
                  if (user != null) {
                    widget.username = user?.displayName;
                    widget.userEmail = user?.email;
                  }
                });
                print(widget.userEmail);

                Navigator.pop(context);
              },
            ),
                ],
              ),
            ),
            // This container holds the align
            Container(
              // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                                leading: Icon(Icons.cancel),
                                title: Text('Log Out'),

                                onTap: (){
                                  _signOut();
                                }
                            ),


                            ListTile(
                                leading: Icon(Icons.help),
                                title: Text('Help and Feedback'))
                          ],
                        )
                    )
                )
            )
          ],
        ),
      )
 //     Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
//        child: ListView(
//          // Important: Remove any padding from the ListView.
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//
//            UserAccountsDrawerHeader(
//              accountName: new Text(
//                widget.username
//              ),
//              accountEmail: new Text(
//                  widget.userEmail,
//
//                  style: new TextStyle(
//                    fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white
//              )
//              ),
//            ),
//            ListTile(
//              title: Text('Item 1'),
//              onTap: () {
//                // Update the state of the app
//                // ...
//                // Then close the drawer
//                Navigator.pop(context);
//              },
//            ),
//            ListTile(
//              title: Text('Item 2'),
//              onTap: () {
//                // Update the state of the app
//                // ...
//                // Then close the drawer
//                Navigator.pop(context);
//              },
//            ),
//
//          ],
//        ),
//

//        ),
        );



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
                children: documents.map((eachDocument) => DocumentView(eachDocument , widget.username)).toList(),
              );
            }
          }),
    );
  }


  Widget setting_page(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize'),
      ),
//
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}


// mainpage 위젯 폐기물
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


// setting page speed dial 폐기물
//floatingActionButton: SpeedDial(
//        // both default to 16
//        marginRight: 18,
//        marginBottom: 20,
//        animatedIcon: AnimatedIcons.menu_close,
//        animatedIconTheme: IconThemeData(size: 22.0),
//        // this is ignored if animatedIcon is non null
//        // child: Icon(Icons.add),
//        //visible: _dialVisible,
//        // If true user is forced to close dial manually
//        // by tapping main button and overlay is not rendered.
//        closeManually: false,
//        curve: Curves.bounceIn,
//        overlayColor: Colors.black,
//        overlayOpacity: 0.5,
//        onOpen: () => print('OPENING DIAL'),
//        onClose: () => print('DIAL CLOSED'),
//        tooltip: 'Speed Dial',
//        heroTag: 'speed-dial-hero-tag',
//        backgroundColor: Colors.white,
//        foregroundColor: Colors.black,
//        elevation: 8.0,
//        shape: CircleBorder(),
//        children: [
//          SpeedDialChild(
//              child: Icon(Icons.accessibility),
//              backgroundColor: Colors.red,
//              label: 'First',
//              labelStyle: TextStyle(fontSize: 18.0),
//              onTap: () => print('FIRST CHILD')
//          ),
//          SpeedDialChild(
//            child: Icon(Icons.brush),
//            backgroundColor: Colors.blue,
//            label: 'Second',
//            labelStyle: TextStyle(fontSize: 18.0),
//            onTap: () => print(maindata),
//          ),
//          SpeedDialChild(
//              child: Icon(Icons.clear),
//              backgroundColor: Colors.red,
//              label: '로그아웃',
//              labelStyle: TextStyle(fontSize: 18.0),
//              onTap: () => {
//                _signOut()
//              }
//          ),
//        ],
//      ),