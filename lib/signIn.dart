import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

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
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List userData = [];
  Future<List> Login(String credential,String password) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/LOGIN/');
  var body = json.encode({'credential': credential, 'password': password});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['message']}');
  return responseFinal;

  } catch (e) {
    return ['Error al realizar la peticion con el servidor'];
  }
  
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'FIJJO',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
  
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child:
                const Text('Forgot Password', style: TextStyle(fontSize: 15)),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
                ElevatedButton(child:
                    const Text('Login'), onPressed:
                        () {
                  print(nameController.text);
                  print(passwordController.text);
                  Login(nameController.text,passwordController.text);
                }),
          ),
          Row(children:
              <Widget>[
            const Text('Does not have account?'),
            TextButton(child:
                const Text('Sign up', style:
                    TextStyle(fontSize:
                        20)), onPressed:
                            () {

                   Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpForm()),
    );
              //signup screen
            }),
          ], mainAxisAlignment:
              MainAxisAlignment.center)
        ],
      ),
    );
  }
}