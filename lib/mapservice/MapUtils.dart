import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap() async {
    String googleUrl = "https://www.google.com/maps/search/hostals nearby";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMap2(dynamic latitude, dynamic longitude) async {
    String googleurl =
        'https://www.google.com/maps/search/?api=1&query=$longitude,$longitude';
    await canLaunch(googleurl)
        ? await launch(googleurl)
        : throw "could not launch $googleurl";
    await canLaunchUrlString(googleurl)
        ? await launchUrlString(googleurl)
        : throw "could not launch $googleurl";
  }
}
