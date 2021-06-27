import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './friend_page.dart';

class Friends extends StatefulWidget {
  final friendList;
  final pendingRequest;
  final userID;

  Friends(
      {@required this.friendList,
      @required this.pendingRequest,
      @required this.userID});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  var updatedFriendList;
  var updatedRequestList;
  Map<dynamic, dynamic> points;
  var currentStatus;
  String image;
  String tempName, tempPic;
  int tempStreak, tempTotalXP;

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    List<FriendRequest> requestList = new List();
    List<Friend> friendList = new List();

    if (updatedRequestList != null) {
      if (widget.pendingRequest == false) {
        requestList = [];
      } else if (updatedRequestList != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(updatedRequestList);
        databaseTemp.forEach((key, value) =>
            {requestList.add(FriendRequest(value["UID"], value["Name"]))});
      } else if (updatedRequestList == false) {
        requestList = [];
      }
    } else {
      if (widget.pendingRequest != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(widget.pendingRequest);
        databaseTemp.forEach((key, value) =>
            {requestList.add(FriendRequest(value["UID"], value["Name"]))});
      } else {
        requestList = [];
      }
    }
    if (updatedFriendList != null) {
      Map<dynamic, dynamic> databaseTemp =
          Map<dynamic, dynamic>.from(updatedFriendList);
      databaseTemp.forEach((key, value) => {
            friendList.add(Friend(value["UID"], value["Name"], value["TotalXP"],
                value["Streak"], value["ProfilePic"]))
          });
    } else {
      if (widget.friendList != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(widget.friendList);
        databaseTemp.forEach((key, value) => {
              friendList.add(Friend(value["UID"], value["Name"],
                  value["TotalXP"], value["Streak"], value["ProfilePic"]))
            });
      } else {
        friendList = [];
      }
    }

    for (var i = 0; i < friendList.length; i++) {
      print(i);
      getUpdatedInfo(friendList[i].uid);
      friendList[i].name = tempName;
      friendList[i].profilePic = tempPic;
      friendList[i].streak = tempStreak;
      friendList[i].totalXP = tempTotalXP;
    }
    getUpdate(FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(widget.userID));
  }

  void notification(String notif) {
    showSimpleNotification(
      Text(notif,
          textAlign: TextAlign.left,
          style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ))),
      background: Color(0xffFFAFCC),
      autoDismiss: false,
      trailing: Builder(builder: (context) {
        return FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            textColor: Colors.black,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                ))));
      }),
    );
    setState(() {});
  }

  Future<DataSnapshot> sendRequest(
      String uid, String user, String uidName) async {
    bool flag = false;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(uid);
    FriendRequest friendRequest = new FriendRequest(user, uidName);
    if (widget.pendingRequest == false) {
      flag = true;
    } else {
      databaseReference
          .child('users')
          .child(searchController.text)
          .child('Requests')
          .orderByChild('UID')
          .equalTo(user)
          .once()
          .then((snapshot) => {
                if (snapshot.value != null)
                  {notification("\n Already sent a request to $uidName")}
                else
                  {flag = true}
              });
    }
    if (flag) {
      await userDB
          .reference()
          .child('Requests')
          .push()
          .set(friendRequest.toJSON());
      notification("\n Sent a request to $uidName\n");
    }
  }

  Future<DataSnapshot> acceptRequest(
      String uid, String user, String uidName) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    print(user);
    DatabaseReference userDB = databaseReference.child('users').child(user);
    Friend friend;
    databaseReference.child('users').child(uid).once().then((snapshot) =>
        {pushFriend(uid, friend, user, snapshot, userDB, databaseReference)});

    // deleteQuery.remove()
  }

  Future<DataSnapshot> deleteRequest(String uid, String user) async {
    int count;
    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user)
        .child('Requests')
        .once()
        .then((DataSnapshot snapshot) {
      count = snapshot.value.length;
    });
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user)
        .child('Requests')
        .orderByChild('UID')
        .equalTo(uid)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> children = snapshot.value;
      children.forEach((key, value) {
        if (count > 1) {
          FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(user)
              .child('Requests')
              .child(key)
              .remove();
        } else {
          FirebaseDatabase.instance
              .reference()
              .child('users')
              .child(user)
              .child('Requests')
              .set(false);
        }
      });
    });
    DatabaseReference userDB =
        FirebaseDatabase.instance.reference().child('users').child(user);
    getUpdate(userDB);
  }

  Future<DataSnapshot> pushFriend(
      String uid,
      Friend friend,
      String user,
      DataSnapshot snapshot,
      DatabaseReference userDB,
      DatabaseReference databaseReference) async {
    friend = new Friend(
      uid,
      snapshot.value["Name"],
      snapshot.value["Trophies"]["XP"],
      snapshot.value["Streak"]["Value"],
      snapshot.value["ProfilePic"] == false ? "" : snapshot.value["ProfilePic"],
    );
    Friend friend2;
    await databaseReference
        .child('users')
        .child(user)
        .once()
        .then((DataSnapshot snapshot) {
      friend2 = new Friend(
        user,
        snapshot.value['Name'],
        snapshot.value["Trophies"]["XP"],
        snapshot.value["Streak"]["Value"],
        snapshot.value["ProfilePic"] == false
            ? ""
            : snapshot.value["ProfilePic"],
      );
    });

    int count;

    await userDB.reference().child('Friends').push().set(friend.toJSON());
    await databaseReference
        .child('users')
        .child(user)
        .child('Requests')
        .once()
        .then((DataSnapshot snapshot) {
      count = snapshot.value.length;
    });
    await databaseReference
        .child("users")
        .child(user)
        .child('Requests')
        .orderByChild("UID")
        .equalTo(uid)
        .onChildAdded
        .listen((Event event) {
      if (count > 1) {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(user)
            .child('Requests')
            .child(event.snapshot.key)
            .remove();
      } else {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(user)
            .child('Requests')
            .set(false);
      }
    });

    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(uid)
        .child('Friends')
        .push()
        .set(friend2.toJSON());

    getUpdate(userDB);
  }

  Future<void> getUpdatedInfo(String friend) async {
    print("getupdatedinfo");
    Friend updatedFriend;
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference friendDB = databaseReference.child('users').child(friend);
    DatabaseReference userDB =
        databaseReference.child('users').child(widget.userID);

    await friendDB.once().then((DataSnapshot snapshot) {
      tempName = snapshot.value["Name"];
      tempTotalXP = snapshot.value["Trophies"]["XP"];
      tempStreak = snapshot.value["Streak"]["Value"];
      tempPic = snapshot.value["ProfilePic"];
    });

    updatedFriend =
        new Friend(friend, tempName, tempTotalXP, tempStreak, tempPic);
    int count;
    await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(widget.userID)
        .child('Friends')
        .push()
        .set(updatedFriend.toJSON());

    await databaseReference
        .child('users')
        .child(widget.userID)
        .child('Friends')
        .once()
        .then((DataSnapshot snapshot) {
      count = snapshot.value.length;
    });
    var update;
    update = await databaseReference
        .child("users")
        .child(widget.userID)
        .child('Friends')
        .orderByChild("UID")
        .equalTo(friend)
        .limitToFirst(1)
        .onChildAdded
        .listen((Event event) {
      print("remove");

      print("${event.snapshot.key}");
      remove(event.snapshot.key);
      update.cancel();
    });

    // setState(() {
    //   userDB.once().then((DataSnapshot snapshot) {
    //     setState(() {
    //       updatedFriendList = snapshot.value["Friends"];
    //       updatedRequestList = snapshot.value["Requests"];
    //     });
    //   });
    // });
  }

  void remove(key) {
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(widget.userID)
        .child('Friends')
        .child(key)
        .remove();
  }

  void getUpdate(DatabaseReference userDB) {
    setState(() {
      userDB.once().then((DataSnapshot snapshot) {
        setState(() {
          updatedFriendList = snapshot.value["Friends"];
          updatedRequestList = snapshot.value["Requests"];
        });
      });
    });
  }

  Future<void> getInfo(friend) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(friend);
    await userDB.once().then((DataSnapshot snapshot) {
      points = snapshot.value["Points"];
      currentStatus = snapshot.value["Trophies"];
    });
    print(points);
  }

  Future<void> getPic(friend) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference userDB = databaseReference.child('users').child(friend);
    await userDB.once().then((DataSnapshot snapshot) {
      image = snapshot.value["ProfilePic"];
    });
    print(image);
    // return image;
  }

  @override
  Widget build(BuildContext context) {
    List<FriendRequest> requestList = new List();
    List<Friend> friendList = new List();

    if (updatedRequestList != null) {
      if (widget.pendingRequest == false) {
        requestList = [];
      } else if (updatedRequestList != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(updatedRequestList);
        databaseTemp.forEach((key, value) =>
            {requestList.add(FriendRequest(value["UID"], value["Name"]))});
      } else if (updatedRequestList == false) {
        requestList = [];
      }
    } else {
      if (widget.pendingRequest != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(widget.pendingRequest);
        databaseTemp.forEach((key, value) =>
            {requestList.add(FriendRequest(value["UID"], value["Name"]))});
      }
    }
    if (updatedFriendList != null) {
      if (widget.friendList == false) {
        requestList = [];
      } else if (updatedFriendList != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(updatedFriendList);
        databaseTemp.forEach((key, value) => {
              friendList.add(Friend(value["UID"], value["Name"],
                  value["TotalXP"], value["Streak"], value["ProfilePic"]))
            });
      }
    } else {
      if (updatedFriendList == false) {
        friendList = [];
      } else if (widget.friendList != false) {
        Map<dynamic, dynamic> databaseTemp =
            Map<dynamic, dynamic>.from(widget.friendList);
        databaseTemp.forEach((key, value) => {
              friendList.add(Friend(value["UID"], value["Name"],
                  value["TotalXP"], value["Streak"], value["ProfilePic"]))
            });
      } else {
        friendList = [];
      }
    }
    print(updatedFriendList);
    print(friendList);

    return Scaffold(
        appBar: AppBar(
          title: Text("Social",
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.15,
            child: Column(
              children: [
                Text("Add Friend:",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoMono(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ))),
                Container(
                  height: MediaQuery.of(context).size.height / 11,
                  width: MediaQuery.of(context).size.width / 1.16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: TextField(
                          controller: searchController,
                          style: GoogleFonts.robotoMono(
                              textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                          )),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Input User ID'),
                        ),
                      ),
                      MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(4),
                        minWidth: 0,
                        child: searchController.text == ""
                            ? Icon(Icons.search)
                            : Icon(Icons.person_add),
                        onPressed: () {
                          print(searchController.text);
                          print(searchController.text);
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          User user = auth.currentUser;
                          final databaseReference =
                              FirebaseDatabase.instance.reference();
                          DataSnapshot snapshot;
                          databaseReference
                              .child('users')
                              .child(searchController.text)
                              .once()
                              .then((snapshot) => {
                                    if (snapshot.value != null)
                                      {
                                        sendRequest(searchController.text,
                                            user.uid, snapshot.value["Name"])
                                      }
                                    else
                                      {notification("\n User does not exist\n")}
                                  });
                        },
                      ),
                    ],
                  ),
                ),
                Text("Friends:",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoMono(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ))),
                Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 2.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: friendList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                size: MediaQuery.of(context).size.width / 10,
                              ),
                              Text("No friends to display",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoMono(
                                      textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                  )))
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                            children: [
                              ...friendList.map(
                                (i) => Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: MaterialButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              i.profilePic,
                                              height: 50,
                                              width: 50,
                                            ),
                                            Text(i.name,
                                                style: GoogleFonts.robotoMono(
                                                    textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                )))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.mood),
                                            SizedBox(width: 5),
                                            Text("${i.totalXP}",
                                                style: GoogleFonts.robotoMono(
                                                    textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                )))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.local_fire_department),
                                            SizedBox(width: 5),
                                            Text("${i.streak}",
                                                style: GoogleFonts.robotoMono(
                                                    textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                )))
                                          ],
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await getInfo(i.uid);

                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FriendPage(
                                                    uid: i.uid,
                                                    name: i.name,
                                                    points: points,
                                                    currentStatus:
                                                        currentStatus,
                                                  )),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ))),
                Text("Requests:",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoMono(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ))),
                Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 4.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: requestList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                size: MediaQuery.of(context).size.width / 10,
                              ),
                              Text("No requests to display",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoMono(
                                      textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                  )))
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                            children: [
                              ...requestList.map(
                                (i) => Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: MaterialButton(
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.people),
                                                    SizedBox(width: 10),
                                                    Text(i.name,
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                                textStyle:
                                                                    TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ))),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Container(
                                            child: Row(
                                          children: [
                                            MaterialButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: EdgeInsets.all(5),
                                              minWidth: 0,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                acceptRequest(i.uid,
                                                    widget.userID, i.name);
                                              },
                                            ),
                                            MaterialButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: EdgeInsets.all(5),
                                              minWidth: 0,
                                              child: Icon(
                                                Icons.highlight_remove,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                deleteRequest(
                                                    i.uid, widget.userID);
                                              },
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              )
                            ],
                          ))),
              ],
            ),
          ),
        ));
  }
}

class FriendRequest {
  String uid;
  String name;

  FriendRequest(this.uid, this.name);

  FriendRequest.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["UID"],
        name = snapshot.value["Name"];
  toJSON() {
    return {"UID": uid, "Name": name};
  }
}

class Friend {
  String uid;
  String name;
  int totalXP;
  int streak;
  String profilePic;

  Friend(this.uid, this.name, this.totalXP, this.streak, this.profilePic);

  Friend.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["UID"],
        name = snapshot.value["Name"],
        totalXP = snapshot.value["TotalXP"],
        streak = snapshot.value["Streak"],
        profilePic = snapshot.value["ProfilePic"];
  toJSON() {
    return {
      "UID": uid,
      "Name": name,
      "TotalXP": totalXP,
      "Streak": streak,
      "ProfilePic": profilePic
    };
  }
}
