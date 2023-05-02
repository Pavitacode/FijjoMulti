


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:country_codes/country_codes.dart';


import 'Functions/VerificationCode.dart';




class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {


  final _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _codeController = TextEditingController();
  int clickResend= 0;
  String _phoneNumber = '';

  int _clickResend = 0;
  late Timer _timer;
  int clickContinue = 0;
  int click = 0;
  bool isSendMsg = false;
  String _name = '';
  String _username = '';
  DateTime? _birthDate;
  String _email = '';
  String _password = '';
  String _selectedDialCode = '';
  String _formattedPhoneNumber = '';
  String countryCode = '';
  bool isSend = true;
  String codeVerification = '';
  String tmpNumber = '';
  bool registerWithCorreo = false;
  String tmpEmail = '';
  String email = '';
  

@override
void initState() {
  super.initState();
 
}

  final _formKey1 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: 
       Column(
          children: [
            Expanded(child: 
         
Stepper(
        type: StepperType.horizontal,
        currentStep: _currentPage,
        onStepTapped: (int step) => setState(() => _currentPage = step),
        onStepContinue : (){ 

              setState(() {
                if (tmpNumber == _phoneNumber && tmpEmail == email) isSendMsg = true;
              });
          if (_currentPage == 0) {
            if (_formKey1.currentState!.validate()){

                _formKey1.currentState!.save();
                print("este es el numero: ${_phoneNumber}, este es el correo: ${email} ");
          
            if (!isSendMsg ) {
     
            clickContinue++;
            print("este es temporal number" + tmpNumber);
            if (_phoneNumber.isNotEmpty || email.isNotEmpty){
             
            // Navegar a la actividad de código de verificación
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerificationCodeActivity(
         phoneNumber: _phoneNumber,
         email: email,
         isEmailRegister: registerWithCorreo,
      onVerificationComplete: () {
        setState(() {_currentPage += 1;
        tmpNumber  = _phoneNumber;
        tmpEmail = email;
        } );
      },
              )),
            );
          }}else {
          _currentPage += 1;

          }
          
          }}else if (_currentPage < 2) {
            setState(() => {
          _currentPage += 1
          

            } );
          }
        },

        onStepCancel:
            _currentPage > 0 ? () => setState(() => _currentPage -= 1) : null,
        steps: [
          Step(
            title: Text('Cuenta'), // Page 1: Phone number and Email
            content:  Form(key: _formKey1 , child: 
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [   
            Container(
            padding: const EdgeInsets.all(10),
              child: registerWithCorreo ? TextFormField(  
                keyboardType: TextInputType.emailAddress,
              
                decoration: const InputDecoration(
  
                border: OutlineInputBorder(),
                labelText: 'Email',
  
              ),
                          initialValue: email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                          final RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                            return null;


                          },
                          onSaved: (value) => email = value.toString(),
                           onChanged: (value) { email = value.toString();
              setState(() =>isSendMsg = false);
               },
                        ) :  IntlPhoneField(           
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PhoneNumber',
              ),
              keyboardType: TextInputType.phone,
              initialValue: _phoneNumber,
              onSaved: (value) {_phoneNumber = value!.completeNumber.toString();
              setState(() =>isSendMsg = false); },
              onChanged: (value) { value.completeNumber.toString();
              setState(() =>isSendMsg = false);
               },
              validator: (value) {
                if (value == null || value.completeNumber.isEmpty) {
                  return 'Por favor ingresa un número de teléfono';
                }
                return null;
              },         ),), TextButton(
  onPressed: () {
    setState(() => registerWithCorreo = !registerWithCorreo);
  },
  child: Text('Usar  ${!registerWithCorreo ? 'mi correo' : 'mi numero telefonico'} para registrarme'),
)

                      ],
                    ), 
                  ),),
            isActive: _currentPage >= 0,
            state:
                _currentPage >= 0 ? StepState.complete : StepState.disabled,

                
        
          ),
          Step(
            title: Text('User Info'),
            content: 
              

                  // Page 2: Name and Username
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                                    Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                         
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
  
              ),
                          initialValue: _name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) => _name = value!,
                        ),),
                                    Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                         
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
  
              ),

                initialValue: _username,
                validator: (value) {
                        if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                        else {
                            return null;
                        }
                       
                          },
                          onSaved: (value) => _username = value!,
                        ), 
                        
                        
                        ),ElevatedButton(
      onPressed:
          () async {
        final selectedDate =
            await showDatePicker(
          context:
              context,
          initialDate:
              DateTime.now(),
          firstDate:
              DateTime(1900),
          lastDate:
              DateTime.now(),
        );
        if (selectedDate !=
            null) {
          setState(() =>
              _birthDate =
                  selectedDate);
        }
      },
      child:
          Text(_birthDate ==
                  null
              ? 'Select Birthdate'
              : 'Birthdate:${DateFormat.yMd().format(_birthDate!)}'),
    ),
    if (_birthDate !=
            null &&
        DateTime.now()
                .difference(_birthDate!)
                .inDays /
            365 <
        16)
      Text(
        'You must be at least16 years old to sign up',
        style:
            TextStyle(color:
                Colors.red),
      ),
                      ],
                    ),
                  ),
            isActive: _currentPage >= 1,
            state:
                _currentPage >= 1 ? StepState.complete : StepState.disabled,
      
          ),
          Step(
            title: Text('Password'),
            content: // Page 4: Password and PasswordConfirm
               Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                         
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
  
              ),
                          obscureText: true,
                          initialValue: _email,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) =>
                              _email = value!,
                        ),),
              Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                         
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PasswordConfirm',
  
              ),
                          obscureText: true,
                          initialValue: _password,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) =>
                              _password = value!,
                        ),),
    
                      ],
                    ),
                  ),
                  
            isActive: _currentPage >= 2,
            state:
                _currentPage >= 2 ? StepState.complete : StepState.disabled,
     
          ),


        ],
      ),)

    
       ],
        ),
      ); 
  }
}