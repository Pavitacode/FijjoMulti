import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostWidget extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> post;

  PostWidget({Key? key, required this.post, required this.uid}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
VideoPlayerController? _controller;
bool _isLiked = false;
bool isFirstLike = false;
int _currentPage = 0;
int likesCount = 0;
bool _showHeartAnimation = false;
  void addViewedPost(String userId, String postId) async {
    print("hola desde addView");
  var url = Uri.parse('https://disbackend.onrender.com/viewed');
  var response = await http.post(
    url,
    body: jsonEncode({
      'user_id': userId,
      'post_id': postId,
    }),
    headers: {'Content-Type': 'application/json'},
  );
   if (response.statusCode != 200) {
    print("error");
   }
}

void addLikedPost(String userId,bool isLiked, String postId) async {
    print("hola desde addView");
  var url = Uri.parse('https://disbackend.onrender.com/addLiked');
  var response = await http.post(
    url,
    body: jsonEncode({
      'userId': userId,
      'liked': isLiked,
      'postId': postId
    }),
    headers: {'Content-Type': 'application/json'},
  );
   if (response.statusCode != 200) {
    print("error");
   }
}

  @override
  void initState() {
    super.initState();
     addViewedPost(widget.uid, widget.post['_id']);

    setState(() {
      likesCount = widget.post['likes'];
    });
    if (!widget.post['isSlider']) {
      _controller = VideoPlayerController.network(widget.post['media'])
        ..initialize().then((_) {
          setState(() {
              _controller?.play();
          });
        });


    }
    else {
          _controller = null;
    }

  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // Image or video occupying the entire screen
      Positioned.fill(
        child: Container(
          color: Colors.black,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.post['isSlider'])
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
              });
            },
            onDoubleTap: () {
              setState(() {
                if (!isFirstLike) {likesCount++; 
                addLikedPost(widget.uid,true,widget.post['_id']);
                }
                isFirstLike = true;
                _showHeartAnimation = true;
                _isLiked = true;
              });
              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _showHeartAnimation = false;
                });
              });
            },
            child: widget.post['isSlider']
                ? Stack(
      children: [
        PageView.builder(
          itemCount: widget.post['media'].length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(
              widget.post['media'][index],
              fit: BoxFit.contain,
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 700,
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / widget.post['media'].length,
          ),
        ),
      ],
    ): _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : Container(),
          ),
        ),
      ),
      // Overlaying content at the bottom
      Positioned(
        bottom: 150,
        left: 10,
        child: Row(
          children: [
            CircleAvatar(
                 backgroundColor: widget.post['photoProfile'] == '' || widget.post['profile'] == null ? 
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white : null,
                      child:  widget.post['photoProfile'] == '' || widget.post['profile'] == null ?   Text(
                        widget.post['username'].substring(0, 1),
                        style: TextStyle(fontSize: 25.0),
                      ): null,
              backgroundImage: widget.post['photoProfile'] == '' || widget.post['profile'] == null ?  null : widget.post['photoProfile'] ,
            ),
            SizedBox(width: 10),
            Text(
              widget.post['username'],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 130,
        left: 10,
        child: Text(
          widget.post['caption'],
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Positioned(
        bottom: 300,
        right: 10,
        child: Column(
          children: [
            IconButton(
              icon: AnimatedCrossFade(
                duration: Duration(milliseconds: 500),
                firstChild:
                    Icon(Icons.favorite_border, size: 30, color: Colors.white),
                secondChild:
                   Icon(Icons.favorite, size: 30, color: Colors.green),
crossFadeState:
    _isLiked ? CrossFadeState.showSecond : CrossFadeState.showFirst,
),
onPressed: () {


   setState(() {
         if (!isFirstLike) {likesCount++;  _showHeartAnimation = true;
         _isLiked = true;
                       Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _showHeartAnimation = false;
                });
              });
                print(widget.uid);
              addLikedPost(widget.uid,true,widget.post['_id']);
              isFirstLike  = true;
         }
         else {likesCount --;
         isFirstLike = !isFirstLike;
        _isLiked = !_isLiked;
        print(widget.uid);
        addLikedPost(widget.uid,false,widget.post['_id']);
         }
               
              });

},
),
Text(likesCount.toString(),
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
IconButton(
icon: Icon(Icons.comment, size: 30, color: Colors.white),
onPressed: () {},
),
Text(widget.post['comments'].toString(),
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
IconButton(
icon: Icon(Icons.share, size: 30, color: Colors.white),
onPressed: () {},
),
Text(widget.post['shares'].toString(),
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
],
),
),
if (_showHeartAnimation) ...[
Positioned.fill(
child: SpinKitPumpingHeart(
color: Colors.green,
size: 80,
),
),
],
],
);
}
}