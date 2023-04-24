import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:geotemp/mapservice/MapUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SchoolDetails extends StatefulWidget {
  dynamic postID;
  SchoolDetails({super.key, required this.postID});
  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('State')
            .doc(widget.postID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // print('No data');
            return const Center(child: CircularProgressIndicator());
          } else {
            return screen(snapshot.data);
          }
        },
      ),
    );
  }

  Widget screen(dynamic data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //image
          image(data),
          //School details
          schooldetails(data),
          //contact details
          contactdetails(data),
          //for more info
          formoreinfo(data),
        ],
      ),
    );
  }

  Widget image(dynamic data) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: Colors.black38,
            image: DecorationImage(
                image: NetworkImage(data['image'][0]), fit: BoxFit.cover)),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, right: 14, left: 10),
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: <Color>[Colors.black26, Colors.lightBlueAccent],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft),
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                  onPressed: () {
                    // _launcher;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,
                      size: 20, color: Colors.white),
                ),
              ),
            ),
          ]),
        ],
      ),
    ]);
  }

  Widget schooldetails(dynamic data) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "School Details",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                "${data['name']}",
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Class ${data['class']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: <Color>[
                            Colors.black26,
                            Colors.lightBlueAccent
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Text(
                      "Admission ${data['admission']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Affiliated to CBSE Board",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 5)
          ],
        ),
      ),
    );
  }

  Widget contactdetails(dynamic data) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Contact Details",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Mobile No : ${data['phonenumber']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: <Color>[
                            Colors.black26,
                            Colors.lightBlueAccent
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft),
                      borderRadius: BorderRadius.circular(10)),
                  // color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Text(
                      "Pin Code:${data['pincode']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${data['state']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: <Color>[
                            Colors.black26,
                            Colors.lightBlueAccent
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                    child: Text(
                      "${data['city']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${data['address']}",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget formoreinfo(dynamic data) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "School Profile",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'For more information ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'click here',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launchUrlString("https://${data['about']}");
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.06,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: <Color>[Colors.black26, Colors.lightBlueAccent],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft)),
              child: ElevatedButton(
                  onPressed: () async {
                    _openMap(data['location'][0], data['location'][1]);
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent),
                  child: const Text("Map location",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white))),
            ),
          ),
        )
      ],
    );
  }

  // map location
  Future<void> _openMap(dynamic lat, dynamic lon) async {
    String googleurl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    await canLaunch(googleurl)
        ? await launch(googleurl)
        : throw "could not launch $googleurl";
    await canLaunchUrlString(googleurl)
        ? await launchUrlString(googleurl)
        : throw "could not launch $googleurl";
  }
}
