import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// List<dynamic>p=firebase().getSeedID() as List;
class firebase {
  // Future<List<DocumentSnapshot>> getSeedID() async {
  User? user = FirebaseAuth.instance.currentUser;
    Future<List<dynamic>> getSeedID() async {
      var data = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user!.uid)
          .collection("userIDs")
          .orderBy("state", descending: false)
          .get();
      var productList = data.docs;
      print("Data length: ${productList.length}");
      List<dynamic> lst = [];
      for (var doc in data.docs) {
        // print(doc.id);
        var productId = await FirebaseFirestore.instance
            .collection('State')
            .doc(doc.id)
            .get();
        if (productId != null) {
          lst.add(productId.data());
        }
      }
      // print(lst[1]);
      return lst;
    }
  }

