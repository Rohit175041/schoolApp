import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geotemp/HomeUI/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AddImage extends StatefulWidget {
  dynamic name;
  dynamic std;
  dynamic board;
  dynamic phonenumber;
  dynamic state;
  dynamic city;
  dynamic pincode;
  dynamic address;
  dynamic schoolwebsite;
  dynamic lat;
  dynamic lon;
  dynamic postID;

  AddImage(
      {super.key,
      this.name,
      this.phonenumber,
      this.std,
      this.board,
      this.state,
      this.city,
      this.address,
      this.schoolwebsite,
      this.postID,
      this.lon,
      this.lat,
      this.pincode});
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool uploading = false;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  double progress = 0;
  final List<File> _beCompImag = [];
  final List<String> _downloadurls = [];
  final List<File?> _aftCompImg = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.only(bottomRight:Radius.circular(250)),
                gradient: LinearGradient(
                    colors: <Color>[Colors.black26, Colors.lightBlueAccent],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft))),
        // backgroundColor: Colors.red.shade600,
        centerTitle: true,
        title: const Text('Upload Image'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                chooseImage();
              }),
        ],
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('img/bacgFormImg.jpeg'),
                    fit: BoxFit.cover)),
          ),
          uploading == false
              ? Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: _aftCompImg.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Image.file(
                            File(_aftCompImg[index]!.path),
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                )
              : Stack(children: [
                  Center(
                      child: CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 15.0,
                    percent: progress,
                    animation: true,
                    animationDuration: 2000,
                    center: Text(
                      "${progress * 100}%",
                      style: const TextStyle(
                          fontSize: 20, color: Colors.redAccent),
                    ),
                    footer: const Text(
                      "Uploading...",
                      style: TextStyle(fontSize: 20, color: Colors.redAccent),
                    ),
                  )),
                ])
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            uploading = true;
          });
          if (_aftCompImg != null) {
            for (int i = 0; i < _aftCompImg.length; i++) {
              String url = await uploadFile(_aftCompImg[i]!);
              setState(() {
                progress = i / _aftCompImg.length;
              });
              _downloadurls.add(url);
              if (i == _aftCompImg.length - 1) {
                storeEntry(_downloadurls);
              }
            }
          } else {
            showSnackBar(Colors.red, "Select Images");
          }
        },
        heroTag: 'uniqueTag',
        backgroundColor: Colors.red,
        autofocus: true,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [Icon(Icons.cloud_upload_outlined), Text(' upload')],
        ),
      ),
    );
  }

  //Compressing images
  Future<void> customCompressed({quality = 35, percentage = 10}) async {
    for (dynamic imageFile in _beCompImag) {
      var result = await FlutterImageCompress.compressAndGetFile(
        // imageFile
        imageFile.absolute.path,
        imageFile.path + 'compressed.jpg',
        quality: 35,
        // minHeight: 200,
        // minWidth: 250,
      );
      _aftCompImg.add(result);
    }
    setState(() {});
  }

  //selecting images or file picker
  chooseImage() async {
    try {
      _beCompImag.clear();
      _aftCompImg.clear();
      final List<XFile> pickedFile = await picker.pickMultiImage();

      if (pickedFile.length > 2) {
        uploading = false;
        pickedFile.clear();
        _beCompImag.clear();
        _aftCompImg.clear();
        showSnackBar(Colors.redAccent, "Select maximum 1 images ");
        return;
      }

      if (pickedFile.isNotEmpty) {
        for (var e in pickedFile) {
          _beCompImag.add(File(e.path));
        }
        customCompressed();
        setState(() {});
      }
    } catch (e) {
      showSnackBar(Colors.red, e.toString());
      Future.delayed(const Duration(seconds: 1));
      return chooseImage();
    }
  }

  //uploading image to firebase storage
  Future<String> uploadFile(File file) async {
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef.child(
        'picture/${user!.uid}/${widget.postID}/${DateTime.now().microsecondsSinceEpoch}.jpeg');
    final uploadTask = ref.putFile(file, metaData);
    // final uploadTask = ref.putFile(file);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  //uploading image link to firebase cloud
  storeEntry(List<String> imageurl) {
    List<String> indexsearch = [];
    String s = "";
    for (int j = 0; j < widget.city.toString().length; j++) {
      s += widget.city[j];
      indexsearch.add(s.toLowerCase());
    }
    FirebaseFirestore.instance.collection('State').doc(widget.postID).set({
      'name': widget.name,
      'class': widget.std,
      'board': widget.board,
      'phonenumber': widget.phonenumber,
      'state': widget.state,
      'city': widget.city,
      'pincode': widget.pincode,
      'address': widget.address,
      'about': widget.schoolwebsite,
      'uid': user?.uid,
      'Startdate': DateTime.now(),
      'rating': '0',
      'block': 'false',
      'visit': '0',
      'class': widget.std,
      'admission': 'closed',
      "postID": widget.postID,
      'image': imageurl,
      'searchindex': indexsearch,
      'location': [widget.lat, widget.lon],
      'search': [
        widget.state.toString().toUpperCase(),
        widget.city.toString().toUpperCase(),
        widget.address.toString().toUpperCase(),
        widget.postID,
      ]
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user!.uid)
          .collection('userIDs')
          .doc(widget.postID)
          .set({
        'phonenumber': widget.phonenumber,
        'postID': widget.postID,
        'uid': user?.uid,
      }).whenComplete(() {
        showSnackBar(Colors.green, "uploaded successfully");
        _beCompImag.clear();
        _aftCompImg.clear();
        _downloadurls.clear();
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const HomeScreen(),
              transitionDuration: const Duration(seconds: 0),
            ),
            (route) => false);
      });
    });
  }

  //notification to users
  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void dispose() {
    super.dispose();
  }
}
