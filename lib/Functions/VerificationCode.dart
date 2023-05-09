import 'dart:async';
import 'dart:convert';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class Post {
  final String id;
  final String imageUrl;
  final String username;
  final String caption;
  bool liked;

  Post({required this.id, required this.imageUrl, required this.username, required this.caption, this.liked = false});
}


class VerificationCodeActivity extends StatefulWidget {

 final String phoneNumber;
  final String email;
  final bool isEmailRegister;
  final VoidCallback onVerificationComplete;
 
  VerificationCodeActivity({required this.phoneNumber, required this.email, required this.isEmailRegister, required this.onVerificationComplete});


  @override
  _VerificationCodeActivityState createState() => _VerificationCodeActivityState();
}

class _VerificationCodeActivityState extends State<VerificationCodeActivity> {

bool _isLoading = true;
String responseIsEmail = '';


  TextEditingController pinCode = TextEditingController();
  String _comingSms = 'Unknown';



  void sendSms(String phoneNumber, String email) async {
    var url = Uri.parse('https://disbackend.onrender.com/OtpSmsSend/');
    var body = json.encode({
      'number': phoneNumber,
      'email': email,
      'isEmailRegister': widget.isEmailRegister
    });
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (widget.isEmailRegister)
      responseIsEmail = response.body;

  }



  Future<bool> verifySms(String phoneNumber, String codeOtp) async {
  var url = Uri.parse('https://disbackend.onrender.com/OtpSmsVerify/');
  var body = json.encode({'number': phoneNumber, 'code': codeOtp});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return response.body == "true";
  }

  void sendSmsCorrespond(String numberl,String email, bool isEmail){
     print(widget.isEmailRegister);
     sendSms(numberl, email);
  }

 Future<bool> verifySmsCorrespond(String numberorEmail, bool isEmail, String codeOtp) async {
  responseIsEmail = responseIsEmail.replaceAll("\"", "");
  print(responseIsEmail.toString() + " " + codeOtp);
    bool verify = !isEmail ? await verifySms(numberorEmail,codeOtp) : responseIsEmail == codeOtp;
    return verify ;
  }

  final errorController = StreamController<ErrorAnimationType>.broadcast();
   final _formKey = GlobalKey<FormState>();
   int clickResend = 0;


    @override
  void initState() {
    super.initState();
    sendSmsCorrespond(widget.phoneNumber,widget.email, widget.isEmailRegister);
    print("este es el numero" + widget.phoneNumber);

     Future.delayed(Duration(seconds: 3), () {
      setState(() => _isLoading = false);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code'),
      ),
      body:_isLoading ?  Center(
              child: CircularProgressIndicator(),
            ) :   Form(key: _formKey, child:          Center(
            
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [   
            Container(
            padding: const EdgeInsets.all(10),
              child:  PinCodeTextField(  
            keyboardType: TextInputType.number,
            appContext: context,
            controller: pinCode,
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveColor: Colors.blue),
            animationDuration: Duration(milliseconds: 300),
            errorAnimationController: errorController,
            
        
              onChanged: (value) {
                setState(() {
                  
                });
              },

              onCompleted: (value) async {

              if (!await verifySmsCorrespond(widget.phoneNumber,widget.isEmailRegister, value)) {
                errorController.add(ErrorAnimationType.shake);
                print("Error el codigo es diferente");
              } else {
                widget.onVerificationComplete();
                 Navigator.of(context).pop();
              }

              },
              validator: (value) {

                if ((value == null || value.isEmpty) && clickResend < 5) {
                  return 'Porfavor entra tu codigo de verificacion';
                        }


                if (clickResend > 4) {
          
                  return 'Llevas muchas solicitudes, intentalo de nuevo mas tarde';
                }
                return null;
                          },
        
                        ),),

                        ElevatedButton(
                                onPressed: 
                                  (){
                              
                                  // Llama a la función para reenviar el SMS con el código
                                  setState(() {
                                    clickResend++;
                                  });
                                 
                                  print(clickResend);
                                 sendSmsCorrespond(widget.phoneNumber,widget.email,widget.isEmailRegister);    
                                
                            
                                },
                                child: Text('Resend'),
                              )
                      ],
                    ),
                  ),
      ),
    );
  }
  



}

