import 'dart:async';

import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Assistant extends StatelessWidget {
  const Assistant({Key? key}) : super(key: key);

  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);




  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState() ;
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _cursorTimer;
  bool _cursorVisible = true;
  bool ifResponse = true;
  String model = 'x';
  String IAResponse = '';

String currentMessage = "";

  Future<String> testAi(String message) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/testAIFIJJO/');
  var body = json.encode({'message': message, 'model': model});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['message']}');
  return responseFinal['message'].toString();

  } catch (e) {
    return "Error: Vuelve a intentarlo";
  }
  
  }


 // Agrega un AnimationController para controlar la animación del cursor
  late final AnimationController _cursorAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  )..repeat(reverse: true);

  // Agrega un Animation para cambiar la opacidad del cursor
  late final Animation<double> _cursorAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(_cursorAnimationController);

  @override
  void dispose() {
    // No olvides deshacerte del AnimationController cuando ya no lo necesites
    _cursorAnimationController.dispose();
    super.dispose();
  } 

  void _showMessage() {
   final words = IAResponse.split(' ');
  for (int i = 0; i < words.length; i++) {
    Future.delayed(Duration(milliseconds: 100 * i), () {
      setState(() {
        currentMessage += words[i] + ' ';
      });

      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
    });
  }


  ifResponse = true;
  
}



@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Que lo haga la IA',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Prompt',
            ),
          ),
        ),

              ElevatedButton(
            child: const Text('Pedir'),
            onPressed: ifResponse ? () async{


               
              setState((){IAResponse = "";
              currentMessage = "";
              ifResponse = false;
              });
              print(nameController.text);
              print(passwordController.text);
              String tmpString = await testAi(nameController.text);
              print(tmpString); 
              setState(() {
                IAResponse = tmpString;
              });

              _showMessage();

            } : null,
          ),
       Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller:  _scrollController,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxHeight: 10000,
                  ),
                  child:
           
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children:[
                          TextSpan(text: currentMessage),
                          // Agrega un TextSpan para el cursor
                          WidgetSpan(
                            child:
                              FadeTransition(
                                opacity:_cursorAnimation,
                                child:
                                  Container(width:1.5,height:18,color:Colors.black)
                              )
                          )
                        ]
                      ),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}