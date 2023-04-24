import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotemp/mapservice/currentlocation.dart';
import 'imagepicker.dart';
import 'package:http/http.dart' as http;
import 'package:country_state_city_picker/country_state_city_picker.dart';


class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

String currLoc = "";
var details = [];
String date_time = "", maddress = "";
var loc = [];

class _UserFormState extends State<UserForm> {
  @override
  void initState() {
    super.initState();
    currentLoc();
  }

  double radius = 10;
  String locationMessage = "Get map location";
  late String lat;
  late String lon;
  TextEditingController schoolname = TextEditingController();
  TextEditingController std = TextEditingController();
  TextEditingController board = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  String countryValue = "India";
  String? stateValue="Chandigarh";
  String? cityValue="Chandigarh";
  TextEditingController pincode = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController schoolwebsite = TextEditingController();
  dynamic postID = "";
  User? user = FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.only(bottomRight:Radius.circular(250)),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.black26, Colors.lightBlueAccent],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft))),
          // backgroundColor: Colors.red.shade600,
          title: const Text("Add School Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: Stack(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            // color: Colors.white54,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('img/formBackimg.jpeg'),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14, top: 10, bottom: 10),
              child: Scrollbar(
                child: Form(
                  // autovalidateMode: true,
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLength: 30,
                        controller: schoolname,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter school name",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          suffixIcon:
                              const Icon(Icons.person, color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLength: 10,
                        controller: std,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter class .... to ....",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          suffixIcon: const Icon(Icons.class_outlined,
                              color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLength: 15,
                        controller: board,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter school board",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          suffixIcon: const Icon(Icons.bookmark_add_rounded,
                              color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLength: 10,
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.length < 10) {
                            return "min length 10 digits";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          suffixIcon: const Icon(Icons.phone_android,
                              color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 5.0, right: 5.0, bottom: 4),
                      //   child: SelectState(
                      //     // style: TextStyle(color: Colors.red),
                      //     onCountryChanged: (value) {
                      //       setState(() {
                      //         countryValue = value;
                      //       });
                      //     },
                      //
                      //     onStateChanged: (value) {
                      //       setState(() {
                      //         stateValue = value;
                      //       });
                      //     },
                      //     onCityChanged: (value) {
                      //       setState(() {
                      //         cityValue = value;
                      //       });
                      //     },
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        // maxLength: 10
                        controller: pincode,
                        keyboardType: TextInputType.phone,
                        // validator: (value) {
                        //   if (value!.length < 10) {
                        //     return "min length 10 digits";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        decoration: InputDecoration(
                          hintText: "Enter pin code",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          suffixIcon: const Icon(Icons.phone_android,
                              color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        // maxLength: 70,
                        maxLines: 1,
                        controller: address,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter school address",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          // suffixIcon: const Icon(Icons.location_city,color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLines: 1,
                        controller: schoolwebsite,
                        decoration: InputDecoration(
                          hintText: "Enter school website",
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          // suffixIcon: const Icon(Icons.location_city_sharp,color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              gradient: const LinearGradient(
                                  colors: <Color>[
                                    Colors.black26,
                                    Colors.lightBlueAccent
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft)),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent),
                              onPressed: () async {
                                // senduserLocation(loc[0], loc[1], maddress, date_time,);
                                currentLoc();
                                date_time = currLoc.split("{}")[0];
                                maddress = currLoc.split("{}")[2];
                                loc = currLoc.split("{}")[1].split(" , ");
                                // print(date_time);
                                // print(maddress);
                                setState(() {
                                  lat = loc[0];
                                  lon = loc[1];
                                  currLoc;
                                  date_time;
                                  locationMessage="$lat \n $lon";
                                  maddress;
                                  loc;
                                });
                              },
                              child: Text(locationMessage,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              gradient: const LinearGradient(
                                  colors: <Color>[
                                    Colors.black26,
                                    Colors.lightBlueAccent
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft)),
                          child: ElevatedButton(
                              onPressed: () async {
                                validate();
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent),
                              child: const Text("Next",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  void validate() {
    if (formkey.currentState!.validate() && cityValue!.isNotEmpty) {
      print("success");
      FirebaseFirestore.instance
          .collection('UserPhoneNumbers')
          .add({'phone-number': phoneNumber.text})
          .then(
            (documentSnapshot) => postID = documentSnapshot.id,
          )
          .whenComplete(() {
            showSnackBar(Colors.green, "uploaded");
            // senduserLocation(loc[0], loc[1], maddress, date_time,);
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a, b) => AddImage(
                      name: schoolname.text,
                      std: std.text,
                      board: board.text,
                      phonenumber: phoneNumber.text,
                      state: stateValue,
                      city: cityValue,
                      pincode: pincode.text,
                      address: address.text,
                      schoolwebsite: schoolwebsite.text,
                      lat: lat,
                      lon: lon,
                      postID: postID),
                  transitionDuration: const Duration(seconds: 0),
                ),
                (route) => false);
          });
    } else {
      print("failed");
      showSnackBar(Colors.red, "failed");
    }
  }

  void currentLoc() async {
    currLoc = await getLoc();
    date_time = currLoc.split("{}")[0];
    maddress = currLoc.split("{}")[2];
    loc = currLoc.split("{}")[1].split(" , ");
  }

  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
