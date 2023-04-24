import 'dart:async';
import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late LocationData _currentPosition;
String _address = "";
late GoogleMapController mapController;
late Marker marker;
Location location = Location();
late CameraPosition _cameraPosition =
const CameraPosition(target: LatLng(0, 0), zoom: 10.0);

LatLng _initialcameraposition = const LatLng(0.5937, 0.9629);

Future<String> getLoc() async {

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return "null";
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return "null";
    }
  }
  String details = "";

  _currentPosition = await location.getLocation();

  DateTime now = DateTime.now();

  details += "";
  details += DateFormat('EEE d MMM kk:mm:ss ').format(now);
print("functio call 2: $_address");
  _initialcameraposition =
      LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
  _getAddress(_currentPosition.latitude!, _currentPosition.longitude!)
      .then((value) {
        print(value);
    // _address = value.first.addressLine;
    _address = value;
  });
  print("function call2");
  details += "{}";
  details += "${_currentPosition.latitude} , ${_currentPosition.longitude}";
  details += "{}";
  details += _address;

  return details;
}

Future<dynamic> _getAddress(double lat, double lang) async {
  print("get address $lat $lang");
  GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: lat,
      longitude: lang,
      googleMapApiKey: "AIzaSyBpqtRFRlIuvGZb8tJhgoGfCr5q0PBKWrM"
  ).whenComplete(() {
    print("completed");
  });
  await Future.delayed(const Duration(seconds: 5));
  //Formated Address
  print("get address $GeoData");
  print(data.address);
  //City Name
  print(data.city);
  //Country Name
  print(data.country);
  //Country Code
  print(data.countryCode);
  //Latitude
  print(data.latitude);
  //Longitude
  print(data.longitude);
  //Postal Code
  print(data.postalCode);
  //State
  print(data.state);
  //Street Number
  print(data.streetNumber);

  // final coordinates = Coordinates(lat, lang);
  // List<Address> add = Geocoder.local.findAddressesFromCoordinates(coordinates);

  return data.address;
}
