import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:geolocator/geolocator.dart';

import '../view_models/apiHandler.dart';

class MinifiedRegister extends StatefulWidget {
  @override
  _MinifiedRegisterState createState() => _MinifiedRegisterState();
}

class _MinifiedRegisterState extends State<MinifiedRegister> {

  final ImagePicker _picker = ImagePicker();

  final _globalKey = GlobalKey<FormState>();

  String errorText;
  bool validate = false;
  bool circular = false;
  bool isLoading = false;
  bool vis = true;

  TextEditingController _fullnameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _phoneEditingController = TextEditingController();
  TextEditingController _townEditingController = TextEditingController();

  List<String> professions= ['Select a profession','mechanic','vulcaniser','driver','Market','Gas station'];
  String _selectProfession = '';
  List<Marker> myMarker = [];

  double draggedLatitude;
  double draggedLongitude;


  Completer<GoogleMapController> _controllerGogleMap = Completer();
  GoogleMapController newGoogleController;

  Position currentPosition;
  Position newPosition;
  LatLng draggedLocation;
  var geoLocatior = Geolocator();
  String placedAddress ='';

  String realAddress = '';
  var Dlatitude;
  var Dlongitude;
  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
    currentPosition = position;
    print('this is position ${position}');
    LatLng latLngPosition = LatLng((position.latitude), position.longitude);

    setState(() {
      Dlatitude = position.latitude;
      Dlongitude = position.longitude;
    });

    print('this is DLongs ${Dlatitude} and ${Dlongitude}');

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition,zoom: 14.0);
    newGoogleController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCordinateaddress(position);
    setState(() {
      realAddress = address;
    });
    print('This is your address :: ' + address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var userData = {};
  var ourUserGe = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/singlelogo.png'),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height:159.5,
              width: MediaQuery.of(context).size.width,
              child:     GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: Set.from(myMarker),

                onMapCreated: (GoogleMapController controller){
                  _controllerGogleMap.complete(controller);
                  newGoogleController = controller;

                  locatePosition();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget bottomSheet(){
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      child: Column(
        children: [
          Text('Choose Profile Photo',style: TextStyle(color: Color(0xff43A552),fontSize: 20.0,fontFamily: 'Product Sans'),),
          SizedBox(height: 20.0,),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//                 FlatButton.icon(onPressed: (){takePhoto(ImageSource.camera);}, icon: Icon(Icons.camera,size: 30.0,color:Color(0xff43A552),), label: Text('Camera',style: TextStyle(color: Colors.black,fontSize: 15.0,fontFamily: 'Product Sans'),)),
//                 FlatButton.icon(onPressed: (){takePhoto(ImageSource.gallery);}, icon: Icon(Icons.image,size: 30.0,color:Color(0xff43A552),), label: Text('Gallery',style: TextStyle(color: Colors.black,fontSize: 15.0,fontFamily: 'Product Sans'),)),
// //                FlatButton.icon(onPressed: (){null}, icon: Icon(Icons.clear,size: 30.0,color: Colors.red,), label: Text('Cancel',style: TextStyle(color: Colors.red,fontSize: 15.0,fontFamily: 'Raleway'),)),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget business(){
    return Container(
      height: 100,
      padding: EdgeInsets.all(23),
      child:   DropdownButtonFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff43A552)
              )
          ),
          contentPadding: EdgeInsets.only(top: 13.0),
          prefixIcon: Icon(
            FeatherIcons.briefcase,
            color: Colors.green[600],
            size: 13.0,
          ),
          hintText: 'Select your profession',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontFamily: 'Public Sans',
            fontSize: 14.0,
          ),
        ),
        // hint: Text('Please select your bank'),
        value: professions[0],
        items: professions.map((prof) {
          return DropdownMenuItem(
            child: new Text(prof),
            value: prof,
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectProfession = newValue;
          });
        },
      ),
    );
  }


  imageProfile() {
    return Center(
      child: Stack(
        children: [
          // Container(
          //   height: 90,
          //   child: CircleAvatar(
          //     backgroundColor: Colors.grey[200],
          //     backgroundImage: _imageFile == null ?
          //     // Container(
          //     //     decoration: BoxDecoration(
          //     //         image: DecorationImage(
          //     //           image: AssetImage('assets/images/Vector.png'),
          //     //           fit: BoxFit.cover,
          //     //         ))
          //     // )
          //     AssetImage('assets/images/singlelogo.png') : FileImage(File(_imageFile.path)),
          //     radius: 80,
          //   ),
          // ),
          Positioned(
            top: 38,
            right: 10,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder: (builder) => bottomSheet());
              },
              child: Container(
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Color(0xff43A552)
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _entryField(var editController,String title, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,fontFamily: 'Public Sans'),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) {
                if (value.isEmpty) {
               //   _errorAlert(context, 'Error!!', '${title} cannot be empty');
                  // return "${title} cannot be empty";
                }
                if (title == 'Phone Number' && title.length < 11) {
                 // _errorAlert(context, 'Error!!', 'phone number cannot be  less than 11');
                  // return 'phone number cannot be  less than 11';
                }
                if (title == 'Password' && value.length <= 8) {
               //   _errorAlert(context, 'Error!!', 'Password can\'t be less than 8');
                  // return 'Password can\'t be less than 8';
                }
              },
              obscureText: isPassword && vis,
              controller: editController,
              keyboardType: title == 'Phone Number' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                  errorText: validate ? null : errorText,
                  suffixIcon: isPassword == true
                      ? IconButton(
                    icon: vis
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        vis = !vis;
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff43A552)
                      )
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff43A552)),
                  ),

                  filled: true))
        ],
      ),
    );
  }

  // void _successAlert(BuildContext context, String title,String subtitle){
  //   AchievementView(
  //     context,
  //     title: title,
  //     subTitle: subtitle,
  //     icon: Icon(Icons.insert_emoticon, color: Colors.white,),
  //     typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
  //     color: Colors.green,
  //     alignment: Alignment.topCenter,
  //     duration: Duration(seconds: 3),
  //   )..show();
  // }
  //
  //
  // void _errorAlert(BuildContext context, String title,String subtitle){
  //   AchievementView(
  //     context,
  //     title: title,
  //     subTitle: subtitle,
  //     icon: Icon(Icons.insert_emoticon_rounded, color: Colors.white,),
  //     typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
  //     color: Colors.red,
  //     alignment: Alignment.topCenter,
  //     duration: Duration(seconds: 3),
  //   )..show();
  // }

}