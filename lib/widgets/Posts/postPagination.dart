import 'package:fijjo_multiplatform/widgets/Posts/postContent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../savedValues.dart';

class PostsPage extends StatefulWidget {

  PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<dynamic> _posts = [];

   savedValues postList = savedValues();
  late IOWebSocketChannel _channel;

  @override
  void initState(){
    super.initState();
    getPost(postList.myString);
  }


 




Future<void> getPost(String userId) async {
  // create a new websocket connection http://0.0.0.0:10000
  _channel = IOWebSocketChannel.connect('wss://disbackend.onrender.com/ws');
  // listen for messages from the server
  _channel.stream.listen((message) {
    setState(() {
      // update the posts with the data received from the server
      final message1 = jsonDecode(message);
      postList.myFriendList.addAll(jsonDecode(message));
    });

    // send the userId and sended_posts to the server

  });

  _channel.sink.add(jsonEncode({'id': userId}));
}



  @override
  void dispose() {
    _channel.sink.close();
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
      itemCount: postList.myFriendList.length,
      itemBuilder: (context, index) {
        return PostWidget(post:postList.myFriendList[index], uid: postList.myString,);
      },
    );
  }
}