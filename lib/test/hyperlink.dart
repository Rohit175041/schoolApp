import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


// SchoolDetails
class hyperlink extends StatefulWidget {
  const hyperlink({Key? key}) : super(key: key);

  @override
  State<hyperlink> createState() => _hyperlinkState();
}

class _hyperlinkState extends State<hyperlink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.redAccent,
        title: const Text("hyperlink"),
      ),
      body: Center(
       child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10))),
            onPressed: ()async{
              launchUrl(Uri.parse('https://flutter.dev/'));
            },
            child: const Text(
              "Hyper Link",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
