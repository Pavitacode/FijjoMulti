import 'package:fijjo_multiplatform/main.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> 24f2173da8fa50d13d9e31d44ea227f6f5820513

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
  String password = '';
  String credential = '';
  String? usernameError;
  String? passwordError;
  
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  List userData = [];
<<<<<<< HEAD
  Future<List> loginPost(String credential,String password) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/SignIn/');
  var body = json.encode({'credential': credential, 'password': password,"isRegister":false});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['data']}');
  return [responseFinal];
=======
  Future<List> Login(String credential,String password) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/LOGIN/');
  var body = json.encode({'credential': credential, 'password': password});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['message']}');
  return responseFinal;
>>>>>>> 24f2173da8fa50d13d9e31d44ea227f6f5820513

  } catch (e) {
    return ['Error al realizar la peticion con el servidor'];
  }
  
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(key: _formKey1,child: ListView(
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
            child: TextFormField(
              controller: nameController,
              decoration:  InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email/Phone or Username',

               errorText: usernameError,
              ),

              validator: (value) {
              if (value == null || value.isEmpty) {
                  return 'Please enter your Email/Phone or Username';
                            }
                            return null;

                          },
                          onSaved: (value) => credential = value.toString(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
                decoration: InputDecoration(
  
                border: OutlineInputBorder(),
                labelText: 'Password',
                errorText: passwordError,
  
              ),
                  obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            return null;


                          },
                          onSaved: (value) => password = value.toString(),

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
<<<<<<< HEAD
                        () async {
                  passwordError = null;
                  usernameError = null;
                if (_formKey1.currentState!.validate()){

                _formKey1.currentState!.save();
                  print(credential);
                  print(password);
                  List data = await loginPost(credential,password);
                  print(data[0]['data']['userName']);
                  String id  = data[0]['data']['_id'] == null ? "" : data[0]['data']['_id'] ;
                  print(data[0]['isError']);
                  if (data[0]['isError'] == false){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('userId', id);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(data: data),
                        ),
                      );
                  }

                 else {
                  setState(() {
                    if (data[0]['typeError'] == 'username') {
                      usernameError = 'Invalid Email/Phone or Username';
                    } else if (data[0]['typeError'] == 'password') {
                      passwordError = 'Invalid Password';
                    }
                  });
                }
                  }
=======
                        () {
                  print(nameController.text);
                  print(passwordController.text);
                  Login(nameController.text,passwordController.text);
>>>>>>> 24f2173da8fa50d13d9e31d44ea227f6f5820513
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
    ),);
  }
}