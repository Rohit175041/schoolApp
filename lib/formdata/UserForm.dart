import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'imageform.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  double radius = 10;
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  String countryValue="India";
  String? stateValue;
  String? cityValue;
  TextEditingController address = TextEditingController();
  TextEditingController about = TextEditingController();
  dynamic postID = "";
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red.shade600,
          title: const Text("Form",
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
                    fit: BoxFit.cover
                )
            ),
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
                        controller: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
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
                          hintText: "Phone Number",
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 4),
                        child: SelectState(
                          // style: TextStyle(color: Colors.red),
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },

                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        autofocus: false,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        showCursor: true,
                        maxLength: 70,
                        maxLines: 2,
                        controller: address,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Address",
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
                        maxLines: 5,
                        controller: about,
                        decoration: InputDecoration(
                          hintText: "About ....",
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
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radius))),
                            onPressed: () async {
                              validate();
                            },
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      )
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
          .add({'phonenumber': phoneNumber.text})
          .then(
            (documentSnapshot) => postID = documentSnapshot.id,
          )
          .whenComplete(() {
            showSnackBar(Colors.green, "uploaded");
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a, b) => AddImage(
                      name: name.text,
                      phonenumber: phoneNumber.text,
                      state: stateValue,
                      city: cityValue,
                      address: address.text,
                      about: about.text,
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

  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
