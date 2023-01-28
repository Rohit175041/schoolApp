import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import '../HomeUI/SchoolDetails.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late DocumentSnapshot? _lastDocument = null;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _list = [];
  bool _isLoadingData = false;
  bool _isMoreData = true;
  int _pagelimit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    paginationData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        paginationData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 0,
        centerTitle: true,
        backgroundColor: Colors.red.shade600,
        title: Text(user!.uid,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ),
      body: _list.isEmpty
          ? Center(
              child: SizedBox(
                height: 330,
                width: 330,
                child: Lottie.asset('img/noData.json'),
              ),
            )
          : Column(children: [
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _list.length,
                    itemBuilder: (Context, index) {
                      print(_list[index]['uid']);
                      return Screen1(_list[index], index + 1);
                      // return Center(child: Text("${_list[index]['uid']} ${index+1}"),);
                    }),
              ),
              _isLoadingData
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox()
            ]),
    );
  }

  Widget Screen1(dynamic data, int n) {
    return SafeArea(
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
        decoration: BoxDecoration(
            // color: const Color(0xfcf9f8),
            color: Colors.white54,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black12)),
        child: InkWell(
          onTap: () async {
            Navigator.pushAndRemoveUntil(
                context as BuildContext,
                MaterialPageRoute(
                  builder: (context) => SchoolDetails(
                    postID: data['postID'],
                  ),
                ),
                (route) => true);
            // showSnackBar(Colors.green, "deleted");
            // deleteData(data['postID'], data['image'][0].toString());
          },
          // SchoolDetails
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black38,
                        image: DecorationImage(
                            image: NetworkImage(data['image'][0]),
                            fit: BoxFit.cover)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 14, left: 10),
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          // color: Colors.black38,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${data['postID']}",
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                "${data['state']}, ${data['city']}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Text(data1.n)
                            ],
                          ),
                        ]),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //deleting post
  deleteData(id, url) async {
    final storageReference = await FirebaseStorage.instance.refFromURL(url);
    print(storageReference);
    await FirebaseFirestore.instance
        .collection("State")
        .doc(id)
        .delete()
        .whenComplete(() {
      storageReference.delete();
      print("post deleted");
      showSnackBar(Colors.green, "deleted");
    });
  }

  // updateData
  updateData(id, value) async {
    await FirebaseFirestore.instance
        .collection("State")
        .doc(id)
        .update({'name': value});
  }

  Future<void> paginationData() async {
    if (_isMoreData) {
      setState(() {
        _isLoadingData = true;
      });
      final collectionReference =
          FirebaseFirestore.instance.collection('State');
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (_lastDocument == null) {
        _list.clear();
        querySnapshot = await collectionReference
            .where("uid", isEqualTo: user!.uid)
            .limit(_pagelimit)
            .get();
      } else {
        querySnapshot = await collectionReference
            .where('uid', isEqualTo: user!.uid)
            .limit(_pagelimit)
            .startAfterDocument(_lastDocument!)
            .get();
      }
      _lastDocument = querySnapshot.docs.last;
      if (querySnapshot.docs.isNotEmpty) {
        _list.addAll(querySnapshot.docs.map((e) => e.data()));
      }
      _isLoadingData = false;
      print(_list.length);
      setState(() {
        _isLoadingData = false;
      });
      if (querySnapshot.docs.length < 5) {
        _isMoreData = false;
      }
    } else {
      print("No More Data");
    }
  }

  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
