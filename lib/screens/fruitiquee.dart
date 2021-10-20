import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class FruitiQee extends StatefulWidget {
  FruitiQee() : super();
  @override
  _FruitiQeeState createState() => _FruitiQeeState();
}

class _FruitiQeeState extends State<FruitiQee> {
  File? _image;
  final picker = ImagePicker();
  List? _output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 6,
        threshold: 0.2,
        imageMean: 0.0,
        imageStd: 255.0,
        asynch: true);
    setState(() {
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/converted_model.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getImage() async {
    // ignore: deprecated_member_use
    var PickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(PickedFile!.path);
    });
    detectImage(_image!);
  }

  takePhoto() async {
    // ignore: deprecated_member_use
    final PickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(PickedFile!.path);
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fruitiquee App',
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fruits.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: _image == null
                  ? Text('No Image', style: TextStyle(fontSize: 20.0))
                  : Image.file(_image!, width: 300, height: 300),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: _output != null
                  ? Text(
                      'Name: ${_output![0]['label']} \nConfidence: ${(_output![0]['confidence'] * 100.0).toString().substring(0, 2) + "%"} ',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold))
                  : Container(),
            ),
            SizedBox(
              height: 25,
            ),
            Material(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: MaterialButton(
                minWidth: 250,
                height: 60,
                textColor: Colors.white,
                child: Text("Picture From Camera",
                    style: TextStyle(fontSize: 20.0)),
                onPressed: takePhoto,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Material(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: MaterialButton(
                minWidth: 250,
                height: 60,
                textColor: Colors.white,
                child: Text("Picture From Gallery",
                    style: TextStyle(fontSize: 20.0)),
                onPressed: getImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
