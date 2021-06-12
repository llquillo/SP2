import 'package:flutter/material.dart';
import '../common_widgets/page_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:popup_menu/popup_menu.dart';

class Profile extends StatefulWidget {
  final corpus;
  final String userEmail;
  final userID;
  Profile(
      {@required this.corpus, @required this.userEmail, @required this.userID});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PickedFile _profilePic;
  // File croppedPic;
  io.File finalPic;
  Image profilePic;
  final picker = ImagePicker();
  final cropper = ImageCropper();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  bool editEnabled = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  String _password;
  final formKey = new GlobalKey<FormState>();
  PopupMenu picSelect = new PopupMenu();
  GlobalKey picChangeKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.corpus["Name"]);
    emailController = TextEditingController(text: widget.userEmail);
    if (widget.corpus["ProfilePic"] != false) {
      profilePic =
          Image.asset(widget.corpus["ProfilePic"], width: 100, height: 100);
    }
  }

  @override
  Future pickImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 20,
      maxHeight: 500,
      maxWidth: 500,
    );

    setState(() {
      if (pickedFile != null) {
        _profilePic = PickedFile(pickedFile.path);
        cropImage(_profilePic.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> cropImage(source) async {
    io.File croppedPic = await ImageCropper.cropImage(
      sourcePath: source,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: "Crop Image",
        toolbarColor: Colors.white,
        toolbarWidgetColor: Colors.black,
        hideBottomControls: true,
        lockAspectRatio: false,
      ),
    );
    setState(() {
      if (croppedPic != null) {
        finalPic = croppedPic;
        print(widget.userID);
        uploadImageToFirebase();
      } else {
        print("No image");
      }
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = 'profilePic.jpg';
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${widget.userID}/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(finalPic);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FirebaseStorage.instance
        .ref()
        .child(image)
        .getDownloadURL()
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
        height: MediaQuery.of(context).size.width / 5,
        width: MediaQuery.of(context).size.width / 5,
      );
    });
    //login-demo-70531.appspot.com/uploads/6nghawKnRSUYv3HyvEspNgbM1Cf2/profilePic.jpg

    print('m: $m');
    return m;
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
  }

  Widget picChange(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Change profile picture?",
        style: GoogleFonts.robotoMono(
          textStyle: TextStyle(
            color: Colors.black,
            letterSpacing: 0,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        RaisedButton(
            color: Color(0xffF4F7FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            onPressed: () {
              picPopUp();
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        RaisedButton(
            color: Color(0xffF4F7FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
      ],
    );
  }

  Widget editInfo(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Save changes?",
        style: GoogleFonts.robotoMono(
          textStyle: TextStyle(
            color: Colors.black,
            letterSpacing: 0,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        RaisedButton(
            color: Color(0xffF4F7FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            onPressed: () {
              _dialog(context, "pass");
            },
            child: Text(
              'Yes',
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        RaisedButton(
            color: Color(0xffF4F7FA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
      ],
    );
  }

  Future<String> updateUserEmail(String email, String password) async {
    User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.toString().trim(), password: password))
        .user;
    user.updateEmail(emailController.text);

    return user.uid;
  }

  Widget enterPass(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text(
        "Enter password to save changes:",
        style: GoogleFonts.robotoMono(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 14,
            child: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
                color: Color(0xffF4F7FA),
                padding: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                  }
                  print("password: $_password");

                  EmailAuthProvider.credential(
                      email: widget.userEmail, password: _password);

                  updateUserEmail(widget.userEmail, _password);
                  User user = auth.currentUser;
                  DatabaseReference userDB =
                      databaseReference.child('users').child(user.uid);

                  userDB.reference().child("Name").set(nameController.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
                  style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
            RaisedButton(
                color: Color(0xffF4F7FA),
                padding: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }

  Widget pickDialog(context, from) {
    switch (from) {
      case "pic":
        return picChange(context);
        break;
      case "save":
        return editInfo(context);
        break;
      case "pass":
        return enterPass(context);
        break;
    }
  }

  Future<void> _dialog(BuildContext context, String from) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment(0, -1),
              child: Opacity(
                opacity: 0.95,
                child: pickDialog(context, from),
              ));
        });
  }

  void picPopUp() {
    picSelect = PopupMenu(
        backgroundColor: Colors.white,
        maxColumn: 3,
        items: [
          MenuItem(title: "Pic 1", image: Image.asset("images/girl.jpg")),
          MenuItem(title: "Pic 2", image: Image.asset("images/boy.jpg")),
          MenuItem(title: "Pic 3", image: Image.asset("images/girl2.jpg")),
          MenuItem(title: "Pic 4", image: Image.asset("images/boy2.jpg")),
          MenuItem(title: "Pic 5", image: Image.asset("images/girl3.jpg")),
          MenuItem(title: "Pic 6", image: Image.asset("images/boy3.jpg")),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    picSelect.show(widgetKey: picChangeKey);
  }

  void stateChanged(bool isShow) {}

  void onClickMenu(MenuItemProvider item) {
    switch (item.menuTitle) {
      case "Pic 1":
        profilePic = Image.asset("images/girl.jpg", width: 100, height: 100);
        uploadPic("images/girl.jpg");
        break;
      case "Pic 2":
        profilePic = Image.asset("images/boy.jpg", width: 100, height: 100);
        uploadPic("images/boy.jpg");
        break;
      case "Pic 3":
        profilePic = Image.asset("images/girl2.jpg", width: 100, height: 100);
        uploadPic("images/girl2.jpg");
        break;
      case "Pic 4":
        profilePic = Image.asset("images/boy2.jpg", width: 100, height: 100);
        uploadPic("images/boy2.jpg");
        break;
      case "Pic 5":
        profilePic = Image.asset("images/girl3.jpg", width: 100, height: 100);
        uploadPic("images/girl3.jpg");
        break;
      case "Pic 6":
        profilePic = Image.asset("images/boy3.jpg", width: 100, height: 100);
        uploadPic("images/boy3.jpg");
        break;
    }
    setState(() {});
  }

  void onDismiss() {}

  Future<void> uploadPic(String pic) async {
    User user = auth.currentUser;
    DatabaseReference userDB = databaseReference.child('users').child(user.uid);

    await userDB.reference().child("ProfilePic").set(pic);
    // Navigator.pop(context);
    setState(() {
      userDB.once().then((DataSnapshot snapshot) {
        setState(() {
          profilePic = Image.asset(snapshot.value["ProfilePic"],
              width: 100, height: 100);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: _getImage(context, "uploads/${widget.userID}/profilePic.jpg"),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         print(snapshot.data);
    //         // finalPic = snapshot.data;
    //         // profilePic = snapshot.data;
    // return PageTitle(
    //     pageTitle: "Profile",
    //     pageGreeting: " ",
    //     pageChild: _pageContent(context));
    return new Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      ),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9), BlendMode.dstATop),
          )),
          child: Container(
            // color: Colors.yellow,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 8),
                MaterialButton(
                  color: Colors.white,
                  minWidth: 0,
                  padding: profilePic == null
                      ? EdgeInsets.all(
                          (MediaQuery.of(context).size.width / 5) / 2)
                      : EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  key: picChangeKey,
                  // onPressed: pickImage,
                  onPressed: () {
                    _dialog(context, "pic");
                  },
                  child:
                      profilePic == null ? Icon(Icons.add_a_photo) : profilePic,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 14),
                Container(
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 16,
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF1F8FF),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    enabled: editEnabled ? true : false,
                    controller: nameController,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 65),
                Container(
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 16,
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF1F8FF),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    enabled: editEnabled ? true : false,
                    controller: emailController,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                buttons(context),
                SizedBox(height: MediaQuery.of(context).size.height / 26),
                Container(
                  padding: EdgeInsets.all(7),
                  color: Color(0xffFFF0F7),
                  child: Text(
                    widget.userID,
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 50),
                RaisedButton(
                    color: Color(0xffF4F7FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Text(
                      "Copy Account ID",
                      style: GoogleFonts.robotoMono(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.userID));
                      notification("\nAccount ID copied to clipboard! \n");
                    })
              ],
            )),
          )),
    );
    //   } else {
    //     return Dialog(
    //       backgroundColor: Colors.white,
    //       child: Container(
    //         color: Colors.black,
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             SpinKitChasingDots(
    //               size: 40,
    //               color: Colors.white,
    //             ),
    //             SizedBox(width: 10),
    //             Text(
    //               'Loading',
    //               style: GoogleFonts.roboto(
    //                 color: Colors.white,
    //                 fontSize: 23,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //             SizedBox(width: 10),
    //           ],
    //         ),
    //       ),
    //     );
    //   }
    //   return Container(
    //     color: Colors.white,
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //   );
    // });
  }

  Widget buttons(BuildContext context) {
    if (editEnabled) {
      return RaisedButton(
        color: Color(0xffF4F7FA),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Text(
          'Confirm',
          style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
            color: Colors.black,
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
          )),
        ),
        onPressed: () {
          _dialog(context, "save");
          setState(() {
            editEnabled = false;
          });
        },
      );
    } else {
      return RaisedButton(
        color: Color(0xffF4F7FA),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Text(
          'Edit profile',
          style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
            color: Colors.black,
            letterSpacing: 0,
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
          )),
        ),
        onPressed: () {
          setState(() {
            editEnabled = true;
          });
        },
      );
    }
  }

  Widget _pageContent(context) {
    return Container(
        // color: Colors.white,
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Column(
      children: [
        Container(),
        MaterialButton(
          minWidth: 0,
          padding: profilePic == null
              ? EdgeInsets.all((MediaQuery.of(context).size.width / 5) / 2)
              : EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          key: picChangeKey,
          // onPressed: pickImage,
          onPressed: () {
            _dialog(context, "pic");
          },
          child: profilePic == null ? Icon(Icons.add_a_photo) : profilePic,
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 14),
        Container(
          margin: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height / 16,
          child: TextFormField(
            enabled: editEnabled ? true : false,
            controller: nameController,
            textAlign: TextAlign.left,
            style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: 0,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height / 16,
          child: TextFormField(
            enabled: editEnabled ? true : false,
            controller: emailController,
            textAlign: TextAlign.left,
            style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: 0,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 60),
        buttons(context),
        SizedBox(height: MediaQuery.of(context).size.height / 26),
        Container(
          child: Text(widget.userID,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              "Copy Account ID",
              style: GoogleFonts.robotoMono(
                  textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: 0,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              )),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.userID));
              notification("\nAccount ID copied to clipboard! \n");
            })
      ],
    ));
  }
}
