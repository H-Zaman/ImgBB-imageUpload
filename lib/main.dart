import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:node_js_image_upload/imgbbResponseModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = new Dio();
  ImgbbResponseModel imgbbResponse;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }


  void uploadingImageViaImageUrl() async {
    setState(() {
      loading = true;
    });
    FormData formData = FormData.fromMap({
      "key" : imgBBkey,
      "image" : imageString
    });

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData
    );
    if(response.statusCode != 400){
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      setState(() {
        delay = false;
        loading = false;
      });
    } else{
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  void uploadImageFile(File _image) async {
    setState(() {
      loading = true;
    });
    ByteData bytes = await rootBundle.load(_image.path);
    var buffer = bytes.buffer;
    var m = base64.encode(Uint8List.view(buffer));

    FormData formData = FormData.fromMap({
      "key" : imgBBkey,
      "image" :m
    });

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData,
    );
    print(response.data);
    if(response.statusCode != 400){
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      setState(() {
        delay = false;
        loading = false;
      });
    } else{
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            RaisedButton(
              onPressed: () async{
                await getImage();
                uploadImageFile(_image);
              },
              child: _image == null ? Text(txt) : Container(
                height: 100,
                width: 100,
                child: Image.file(_image)),
            ),
            SizedBox(height: 50,),
            delay ? Text(txt) : CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                  imgbbResponse.data.displayUrl
              ),
            ),
            Spacer(),
            Text(imageString)
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadingImageViaImageUrl,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final imgBBkey = 'eda9abc46fc3adaaa77c1da20bdaa057';
final imageString = 'https://imgur.com/4NH3806.png';