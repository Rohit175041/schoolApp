import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geotemp/Profile/profile.dart';
import '../formdata/UserForm.dart';
import '../phoneauth/login.dart';
import 'dart:math';

import '../test/hyperlink.dart';
import '../youtube/mainDownload.dart';
class Mydrawer extends StatelessWidget{
  int p=0;
  @override
  Widget build(BuildContext context){
    final storage = const FlutterSecureStorage();
    const imageUrl="https://www.pixelstalk.net/wp-content/uploads/2016/06/HD-images-of-nature-download.jpg";
    return Drawer(
      width: 250,
      child: Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors:<Color>[ Colors.black12,Colors.white],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft
            )
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              children:const [
                UserAccountsDrawerHeader(
                  decoration:BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight:Radius.circular(120),topRight: Radius.circular(0)),
                      gradient: LinearGradient(
                          colors:<Color>[ Colors.black12,Colors.black45],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft
                      )
                  ),
                  accountName: Text("Rohit Kumar Singh",style: TextStyle(fontWeight: FontWeight.bold),),
                  accountEmail: Text("Rohit175041@gamil.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.account_box_outlined,color: Colors.white),
                      title:const Text("Profile",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Profile(),
                            ),
                                (route) => true);
                        },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.post_add,color: Colors.white),
                      title:const Text("Post",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserForm(),
                            ),
                                (route) => true);
                      }
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.contact_page_sharp,color: Colors.white),
                      title:const Text("Test",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: () async{
                        FirebaseFirestore.instance.collection('test')
                        .doc("ts")
                            .update({"postid":FieldValue.arrayUnion(["data"])});
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.mic_none,color: Colors.white),
                      title:const Text("Text To Speech",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.cloud_circle,color: Colors.white),
                      title:const Text("Weather",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child:  SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.map_outlined,color: Colors.white),
                      title: const Text("downloader",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const hyperlink(),
                            ),
                                (route) => true);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:Colors.black26
                ),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: ListTile(
                      leading:const Icon(Icons.logout,color: Colors.white),
                      title:const Text("logout",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      ),
                      //subtitle: Text(" "),
                      trailing:const Icon(Icons.more_vert,color: Colors.white),
                      onLongPress: ()async {
                        await storage.deleteAll();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const loginPhone(),
                        ),
                        (route) => false);
                      },
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
// MainScreen