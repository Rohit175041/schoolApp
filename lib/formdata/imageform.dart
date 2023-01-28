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
  dynamic phonenumber;
  dynamic state;
  dynamic city;
  dynamic address;
  dynamic about;
  dynamic postID;

  AddImage(
      {this.name,
      this.phonenumber,
      this.state,
      this.city,
      this.address,
      this.about,
      this.postID});
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool Uploading = false;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  double progress = 0;
  List<File> _BeCompImag = [];
  List<String> _downloadurls = [];
  List<File?> _aftCompImg = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade600,
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
            Uploading == false
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
            Uploading = true;
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
  Future<void> customCompressed() async {
    for (dynamic imageFile in _BeCompImag) {
      var result = await FlutterImageCompress.compressAndGetFile(
        // imageFile
        imageFile.absolute.path,
        imageFile.path + 'compressed.jpg',
        quality: 80,
        // minHeight: 200,
        // minWidth: 250,
      );
      _aftCompImg.add(result);
    }
    setState(() {});
  }

  //selecting images
  chooseImage() async {
    try {
      _BeCompImag.clear();
      _aftCompImg.clear();
      final List<XFile> pickedFile = await picker.pickMultiImage();

      if (pickedFile.length < 5) {
        pickedFile.clear();
        showSnackBar(Colors.redAccent, "Select atleast 4 images");
        return;
      }
      if (pickedFile.length > 5) {
        pickedFile.clear();
        showSnackBar(Colors.redAccent, "Select maximum 4 images ");
        return;
      }

      if (pickedFile.isNotEmpty) {
        pickedFile.forEach((e) {
          _BeCompImag.add(File(e.path));
        });
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
    // final uploadTask = ref.putFile(file, metaData);
    final uploadTask = ref.putFile(file);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  //uploading image link to firebase cloud
  storeEntry(List<String> imageurl) {
    FirebaseFirestore.instance.collection('State').doc(widget.postID).set({
      'name': widget.name,
      'phonenumber': widget.phonenumber,
      'state': widget.state,
      'city': widget.city,
      'address': widget.address,
      'about': widget.about,
      'uid': user?.uid,
      'Startdate': DateTime.now().microsecondsSinceEpoch,
      'block': 'false',
      'visit': '0',
      "postID": widget.postID,
      'image': imageurl,
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
        'postID': widget.postID,
        'uid': user?.uid,
        'state': widget.state
      }).whenComplete(() {
        showSnackBar(Colors.green, "uploaded successfully");
        _BeCompImag.clear();
        _aftCompImg.clear();
        _downloadurls.clear();
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => HomeScreen(),
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
}
