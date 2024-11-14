import 'package:flutter/material.dart';
import 'package:simple_image_cropper/simple_image_cropper.dart';



class Demo extends StatefulWidget {
  Demo({Key key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
   ImageProvider _image;
  final GlobalKey<SimpleImageCropperState> cropKey = GlobalKey();

  @override
  void initState() {
    _image = AssetImage('assets/images/newBg.png');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.crop),
          onPressed: () async {
            Image image = await cropKey.currentState?.cropImage();
            if (image != null) {
              setState(() => _image = image.image);
            }
          },
        ),
        body: Container(
            height: size.height,
            width: size.width,
            child: SimpleImageCropper(
              key: cropKey,
              height: size.height,
              width: size.width,
              image: _image,
            )));
  }
}