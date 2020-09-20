import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:node_js_image_upload/imgbbResponseModel.dart';
import '';

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
  Dio dio = new Dio();
  ImgbbResponseModel imgbbResponse;
  void _incrementCounter() async {
    print('upload image');
    FormData formData = FormData.fromMap({
      "key" : imgBBkey,
      "image" : imageString
    });
    print('form data set');

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData
    );
    print('response');
    imgbbResponse = ImgbbResponseModel.fromJson(response.data);
    print('response converting');
    setState(() {
      delay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: delay ? Text('') : CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(
            imgbbResponse.data.displayUrl
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final imgBBkey = 'eda9abc46fc3adaaa77c1da20bdaa057';
final imageString = 'https://imgur.com/4NH3806.png';