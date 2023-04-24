import 'package:flutter/material.dart';
import 'package:geotemp/HomeUI/SchoolDetails.dart';
import 'package:geotemp/HomeUI/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late DocumentSnapshot? _lastDocument = null;
  List<Map<String, dynamic>> list = [];
  bool _isLoadingData = false;
  bool _isMoreData = true;
  int pagelimit = 10;
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
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                // borderRadius: BorderRadius.only(bottomRight:Radius.circular(250)),
                gradient: LinearGradient(
                    colors: <Color>[Colors.black26, Colors.lightBlueAccent],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft))),
        // backgroundColor: const Color(0xFFFF1744),
        title: const Center(child: Text("HomePage")),
        centerTitle: true,
      ),
      drawer: Mydrawer(),
      body: list.isEmpty
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
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return screen1(list[index], index + 1);
                    }),
              ),
              _isLoadingData
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox()
            ]),
    );
  }

  Widget screen1(dynamic data, int n) {
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
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolDetails(
                    postID: data['postID'],
                  ),
                ),
                (route) => true);
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
                          image: NetworkImage(
                            data['image'][0],
                          ),
                          fit: BoxFit.cover),
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data['name']}",
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

  Future<void> paginationData() async {
    if (_isMoreData) {
      setState(() {
        _isLoadingData = true;
      });
      final collectionReference =
          FirebaseFirestore.instance.collection('State');
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (_lastDocument == null) {
        querySnapshot = await collectionReference
            // .where("uid", isEqualTo: user!.uid)
            .limit(pagelimit)
            .get();
      } else {
        querySnapshot = await collectionReference
            // .where('uid', isEqualTo: user!.uid)
            .limit(pagelimit)
            .startAfterDocument(_lastDocument!)
            .get();
      }
      _lastDocument = querySnapshot.docs.last;
      list.addAll(querySnapshot.docs.map((e) => e.data()));
      _isLoadingData = false;
      // print(list.length);
      setState(() {});
      if (querySnapshot.docs.length < 5) {
        _isMoreData = false;
      }
    } else {
      setState(() {
        _isLoadingData = false;
      });
      // print("No More Data");
    }
  }
}
