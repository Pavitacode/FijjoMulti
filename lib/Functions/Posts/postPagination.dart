import 'package:fijjo_multiplatform/Functions/Posts/postContent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../GetPosts.dart';

class PostsPage extends StatefulWidget {

  PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<dynamic> _posts = [];

   PostList postList = PostList();
  // late IOWebSocketChannel _channel;

  // @override
  // Future<void> initState() async {
  //   super.initState();
  //   // create a new websocket connection
  //   _channel = IOWebSocketChannel.connect('wss://disbackend.onrender.com/ws');
  //   // listen for messages from the server
  //   _channel.stream.listen((message) {
  //     setState(() {
  //       // update the posts with the data received from the server
  //       final message1 = jsonDecode(message);
  //      _posts.addAll(jsonDecode(message));
  //     });
  //   });
  //   // send the userId to the server
  //   String? userId = await userIdReturn();
  //   _channel.sink.add(jsonEncode({'user': userId}));
  // }


 





Future<void> getPost(String userId) async{
    print(userId);
    var url = Uri.parse('https://disbackend.onrender.com/posts');
    var body = json.encode({
      'userId': userId,
    });
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${json.decode(response.body)}');
    setState(() {
       postList.myList.addAll(json.decode(response.body));
    });


  }

  void getPostsRegularly(Duration interval,String userId) async {
  while (true) {
    await getPost(userId);
    await Future.delayed(interval);
  }
}

  @override
  void initState()  {
    print(postList.myString );


  
  print("cerrado");
   getPostsRegularly(Duration(seconds: 10), postList.myString );
    super.initState();
  }

  @override
  void dispose() {
    // close the websocket connection when the widget is disposed

    print("Se cerro");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(

  //       onPageChanged: (index) {
  //   if ((index == _posts.length - 3 && _posts.length > 2) || ((_posts.length == 2 || _posts.length == 1) && (index == _posts.length -2 || index == _posts.length -1))) {
  //     // hacer una nueva petición al servidor para obtener más posts
  //     // getPost();
  //   }
  // },
      scrollDirection: Axis.vertical,
      itemCount: postList.myList.length,
      itemBuilder: (context, index) {
        return PostWidget(post:postList.myList[index], uid: postList.myString,);
      },
    );
  }
}