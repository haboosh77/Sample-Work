


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier{
File? image;
bool isPicAvail=false;
String PickerError='';
String error ='';
//shop data
double? shoplatitude;
double? shoplongitude;
String? shopeAdress;
String? placeN;
String? email;

  Future<File?> PickImage() async {

  final imageFile=  await ImagePicker().pickImage(source: ImageSource.gallery);
  if(imageFile!=null) {

   this.image = File(imageFile.path);

   notifyListeners();
  }else{
    this.PickerError='NO image selected';
    print('NO image selected');
    notifyListeners();
  }
return this.image;
  }
  Future getCurrentAddress()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shoplatitude=_locationData.latitude;
    this.shoplongitude=_locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(_locationData.latitude,_locationData.longitude);
  var  _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var shopAddress  = _addresses.first;
  this.shopeAdress=shopAddress.addressLine;
    this..placeN=shopAddress.featureName;
    notifyListeners();
    return shopAddress;
  }

  Future<UserCredential?> registerVendor( email, password)async
  {UserCredential? userCredential;
  this.email=email;
  notifyListeners();
    try {
       userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error='The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error='The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }


  Future<void> savedatatodb({
  String? url,String? shopeName,String? mobail,String? dialog
})async {
    User? user=FirebaseAuth.instance.currentUser;
    DocumentReference _vendors=FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set({
      'uid':user.uid,
      'shopName':shopeName,
      'mobail':mobail,
      'email':this.email,
      'dialog':dialog,
      'address':'${this.placeN}:${this.shopeAdress}',
      'location':GeoPoint(this.shoplatitude!,this.shoplongitude!),
      'shopOpen':true,//later
      'rating':0.00,//later
      'totalRting':0,//later
      'isTopPicked':true,//later
    });


  }
}