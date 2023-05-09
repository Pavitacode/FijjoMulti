import 'package:fijjo_multiplatform/main.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions/countries.dart';
import 'Functions/phoneField.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String _title = 'SignIn';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
  String? errorCodeText;
  String _phoneNumber = '';
  static const _initialCountryCode = 'US';
    var _country =
       countries.firstWhere((element) => element.code == _initialCountryCode);
  bool traditionalLogin = true;
  String? passwordError;
  bool _obscureText = true;
  
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  List userData = [];
  Future<List> loginPost(String credential,String password) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/SignInandSignUp/');
  var body = json.encode({'credential': credential, 'password': password,"isRegister":false});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['data']}');
  return [responseFinal];

  } catch (e) {
    return ['Error al realizar la peticion con el servidor'];
  }
  
  }
  @override
  Widget build(BuildContext context) {
    return 
    Center(
  child:  Form(
    key: _formKey1,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
   

        
         Container(
         
            padding: const EdgeInsets.all(10),
            child: traditionalLogin ?   TextFormField(
              autovalidateMode:AutovalidateMode.onUserInteraction  ,
              controller: nameController,
              decoration:  InputDecoration(
           
                labelText: 'Email/Username',
 prefixIcon: Icon(Icons.email),
    // Usar un borde redondeado para el campo
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    // Usar un estilo de texto personalizado para la etiqueta

    labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0),
    // Usar un estilo de texto personalizado para el texto de error
    errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
    // Usar un color de relleno para el campo
    fillColor: Colors.grey[200],
    filled: true,
               errorText: usernameError,
              ),

              validator: (value) {
              if (value == null || value.isEmpty) {
                  return 'Please enter your Email/Phone or Username';
                            }
                            return null;

                          },
                          onSaved: (value) => credential = value.toString(),
            ) : 
            IntlPhoneField(           
                decoration: InputDecoration(
                   prefixIcon: Icon(Icons.email),
    // Usar un borde redondeado para el campo
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              // Usar un estilo de texto personalizado para la etiqueta
              labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0),
              // Usar un estilo de texto personalizado para el texto de error
              errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
              // Usar un color de relleno para el campo
              fillColor: Colors.grey[200],
              filled: true,
                errorText : errorCodeText,
        
                labelText: 'PhoneNumber',
              ),
              keyboardType: TextInputType.phone,
              initialValue: _phoneNumber,
            
              onSaved: (value) async {credential = value!.completeNumber.toString();
              },


              onCountryChanged: (country) => _country = country  ,

              onChanged: (value) async { 
                
                errorCodeText = null;
               credential = value.completeNumber.toString();
              

               },

            validator: (value) {
                                      print("test: $value");
        if ( value != null) {
          return value.number.length >= _country.minLength &&
                  value.number.length <= _country.maxLength
              ? null
              : "Numero invalido";
        }



        return null;
      },


         ),),
             
          TextButton(
            onPressed: () {
              setState(() {
                traditionalLogin = !traditionalLogin;
              });
            },
            child:
                 Text(traditionalLogin ? 'Iniciar sesion con el numero de celular' : 'Iniciar sesion con los metodos tradicionales', style: TextStyle(fontSize: 15)),
          ),

Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
                decoration: InputDecoration(
  
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    // Usar un estilo de texto personalizado para la etiqueta

    labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0),
    // Usar un estilo de texto personalizado para el texto de error
    errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
    // Usar un color de relleno para el campo
    fillColor: Colors.grey[200],
    filled: true,
                labelText: 'Password',
                errorText: passwordError,
                  prefixIcon: Icon(Icons.lock,),
                   suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
        ),
        obscureText: _obscureText,
         
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
                const Text('Forgot Password?', style: TextStyle(fontSize: 15)),
          ),
          Container(
            height: 50,
            width: 500,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
                ElevatedButton(child:

                    const Text('Login'), 
                      style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
                     onPressed:

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

                   Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpForm()),
    );
              //signup screen
            }),
          ], mainAxisAlignment:
              MainAxisAlignment.center)
      ],
    ),
  ),
);
  }
}