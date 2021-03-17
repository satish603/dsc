import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc/ui/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsc/ui/widgets/custom_shape.dart';
import 'package:dsc/ui/widgets/customappbar.dart';
import 'package:dsc/ui/widgets/responsive_ui.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dsc/ui/widgets/textformfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<firebase_storage.UploadTask> _uploadTasks = [];
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  bool signingup = false;
  // var name, email, photoUrl, uid, emailVerified, phnum;
  String _email, name, phnum;

  Future<String> getdata() async {
    FirebaseFirestore.instance
        .collection('channels')
        .doc('1fyyIIbwKiRhBm84JMYXZla7mmA3')
        .get()
        .then((docSnap) {
      var fname = ['name']; //var channelName = snapshot['name'];
      assert(fname is String);
      print("Write print hello fire base is connected");
      return fname;
    });
  }

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
    if (file == null) {
      EdgeAlert.show(context,
          title: 'No file was selected',
          description: "Please select image to upload",
          gravity: EdgeAlert.BOTTOM,
          icon: Icons.error,
          backgroundColor: Colors.blue[400]);

      return null;
    }

    firebase_storage.UploadTask uploadTask;
    final User user = auth.currentUser;
    final uid = user.uid;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User_image')
        .child('/$uid.jpg');

  
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    print(url);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }

  void _removeTaskAtIndex(int index) {
    setState(() {
      _uploadTasks = _uploadTasks..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
<<<<<<< Updated upstream
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[300], Colors.yellowAccent],
            ),
          ),
=======
>>>>>>> Stashed changes
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.yellowAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.yellowAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () async {
                PickedFile file =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                firebase_storage.UploadTask task = await uploadFile(file);
                if (task != null) {
                  setState(() {
                    _uploadTasks = [..._uploadTasks, task];
                  });
                }
                print('Adding photo');
              },
              child: Icon(
                Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.blue[900],
              )),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            // phoneTextFormField(),
            // SizedBox(height: _height / 60.0),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return Text(
      "$phnum"
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
        keyboardType: TextInputType.emailAddress,
        icon: Icons.email,
        hint: "Email ID",
        userTyped: (val) {
          _email = val;
        });
  }

  Widget TextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Contact No",
      userTyped: (val) {
        phnum = val;
      },
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.blue[400],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: _large ? 12 : (_medium ? 13 : 10)),
          ),
        ],
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (name != null) {
          setState(() {
            signingup = true;
          });
          try {
            // final newUser =
            // await auth.createUserWithEmailAndPassword(email: _email);
            // password: _password);
            // Map <String,dynamic> data= {"name":name.text,"email":email.text,"contact":phnum.text};
            //   FirebaseFirestore.instance.collection("users").doc("collection").set(data);

            // if (newUser != null) {
            final User user = auth.currentUser;
            final uid = user.uid;
            /* firestore.collection("users").add({
                "name": name,
                "email": _email,
                "contact": phnum,
                "uid": uid
              }).then((value) {
                print(value.id);
                print(uid);
              });*/
            firestore.collection("users").doc('$uid').set({
              "name": name,
              // "email": _email,
              "contact": phnum,
              "uid": uid,
              "photo": "gs://dscsolution-80cbc.appspot.com/User_image/$uid.jpg"
            }, SetOptions(merge: true));
            // .doc("collection")
            // .set(data);
            // .collection("users")
            // .doc("collection")
            // .set(data);
            // User updateUser = FirebaseAuth.instance.currentUser;
            // updateUser.updateProfile(displayName: name);
            // updateUser.updateProfile(photoURL: url);
            // updateUser.uid;
            // updateUser.displayName;
            // updateUser.phoneNumber;
            // await newUser.user.updateProfile(info);

            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => Dashboard()));
            // }
          } catch (e) {
            setState(() {
              signingup = false;
            });
            EdgeAlert.show(context,
                title: 'Signup Failed',
                description: e.toString(),
                gravity: EdgeAlert.BOTTOM,
                icon: Icons.error,
                backgroundColor: Colors.blue[400]);
          }
        } else {
          EdgeAlert.show(context,
              title: 'Update Failed',
              description: 'All fields are required. ',
              gravity: EdgeAlert.BOTTOM,
              icon: Icons.error,
              backgroundColor: Colors.blue[400]);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 2.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.blue[900], Colors.blueAccent[100]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'UPDATE PROFILE',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }
} //end of signup
