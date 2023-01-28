import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SchoolDetails.dart';

class Search extends SearchDelegate {
  List searchresult = [];
  String? search;
  List suggestionList = [];
  final myController = TextEditingController();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            myController.clear();
            suggestionList.clear();
            query = '';
            print("query");
          },
          icon: const Icon(Icons.clear))
    ];
    // throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("close");
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          itemCount: 15,
                // itemCount: snapshot.data!.docs.length,
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
    );
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print("listbuilder");
    return ListView.builder(
      // itemCount: suggestionList.length,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("hello"),
          // title: Text("${suggestionList[index]["postID"]}"),
          // onTap: () {
          //   query=suggestionList.elementAt(index) as String;
          // }
        );
      },
    );
    // throw UnimplementedError();
  }
}
