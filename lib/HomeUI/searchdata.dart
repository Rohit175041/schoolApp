import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geotemp/HomeUI/HomeScreen.dart';
import 'package:geotemp/HomeUI/SchoolDetails.dart';

class Searchdata extends StatefulWidget {
  const Searchdata({Key? key}) : super(key: key);

  @override
  State<Searchdata> createState() => _SearchdataState();
}

class _SearchdataState extends State<Searchdata> {
  String search = '';
  List searchresult = [];
  void searchFromFirebase(dynamic query) async {
    print(query);
    // final result = await FirebaseFirestore.instance.collection('State')
    //     .where('search',arrayContainsAny: query)
    //     //.orderBy('Startdate',descending: true)
    //     .get();
    // print(query);
    // setState(() {
    // searchresult = result.docs.map((e) => e.data()).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 12,
        backgroundColor: Colors.white,
        title: TextField(
          decoration:  InputDecoration(
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(0),
              //     borderSide: const BorderSide(
              //       color: Colors.black,
              //       // width: 1,
              //     )
              // ),
              hintText: "Search",
            prefixIcon: IconButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                        (route) => false);
              },
                icon: const Icon(Icons.arrow_back)
            ),
            suffixIcon:IconButton(
                onPressed: (){
                  searchresult.clear();
                },
                icon: const Icon(Icons.cancel_outlined)
            ),
          ),
          cursorColor: Colors.black,
          onChanged: (query) {
            setState(() {
              search = query;
            });
          },
          onTap: (){
            IconButton(
              onPressed: (){
              },
                icon: const Icon(Icons.cancel_outlined)
            );
      },
        ),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: 50,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: const [
          //       Card(
          //         child: Text("gfjgdk"),
          //         color: Colors.black,
          //       ),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //       Text("hello"),
          //     ],
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("State")
                  .where('state', isEqualTo: search)
                  // .where('city',isEqualTo: search)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          searchresult.add(snapshot.data!.docs[index].data());
                          return ListTile(
                            onTap: () async {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SchoolDetails(
                                      postID: searchresult[index]['postID'],
                                    ),
                                  ),
                                  (route) => true);
                            },
                            title: Text(
                                "${searchresult[index]['state']}   ${searchresult[index]['city']}"),
                            subtitle: Text(searchresult[index]['address']),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
