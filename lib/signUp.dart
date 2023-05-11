import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Functions/GetPosts.dart';
import 'Functions/VerificationCode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions/countries.dart';
import 'Functions/phoneField.dart';
import 'main.dart';



class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);



  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>  {

  PostList postList = PostList();
  final _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _codeController = TextEditingController();
  int clickResend= 0;
  String _phoneNumber = '';
bool isTagExistEmail = false;
bool isTagExistPhone = false;
bool isTagExistuserName = false;
String? errorCodeText ;
bool isBadFormattedEmail = false;
String? errorCodeTextEmail;
String? errorCodeTextUserName;
  int _clickResend = 0;
  late Timer _timer;
bool isPasswordAccepted = false;
  int clickContinue = 0;
  bool isLoadingEmail = false;
  bool isLoadingUserName = false;
   bool isLoadingPhone = false;
  int click = 0;
String? errorCodeTextPassword;
String? errorCodeTextPasswordConfirm;
  bool isSendMsg = false;
  bool passwordCoincide = false;
  String _name = '';
  String _username = '';
  DateTime? _birthDate;
  String _firstpassword = '';
  String _password = '';
  String _selectedDialCode = '';
  String _formattedPhoneNumber = '';
  String countryCode = '';
  bool isSend = true;
  String? errorCodeTextBirthDay;
  String codeVerification = '';
  String tmpNumber = '';
  bool registerWithCorreo = false;
  String tmpEmail = '';
  String email = '';
  bool _hasMinimumLength = false;
  bool _hasNumberAndCharacter =  false;
  bool _hasSpecialCharacter = false;
  bool  isAgeAccepted = true;
  bool birthdayisEmpty = false;
  bool _hasContainUpperCases = false;
  String evaluatedPredictionStrengthPassword = '';
  bool _obscureText = true;

    static const _initialCountryCode = 'US';
    var _country =
       countries.firstWhere((element) => element.code == _initialCountryCode);




  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();


String _passwordStrength = "";

Future<String> predictionStrengthPassword(String password) async{
 try {
  var url = Uri.parse('https://disbackend.onrender.com/strengthPassword');
  var body = json.encode({'password': password});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: $responseFinal ');
  return responseFinal;

  } catch (e) {
    return "Error al realizar la peticion con el servidor";
  }

}



String evaluatePasswordStrength(String password)  {
  setState(() {
    _hasMinimumLength = password.length >= 10;
    _hasNumberAndCharacter = password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[a-z]')); 
    _hasContainUpperCases = password.contains(RegExp(r'[A-Z]'));
    _hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
  });

  return !_hasMinimumLength
      ? "Demasiado debil"
      : !_hasContainUpperCases
          ? "Aceptable"
          : _hasNumberAndCharacter && !_hasSpecialCharacter && _hasContainUpperCases
              ? "Superior"
              : "Excelente";
}

    Future<List> registerPost(String? email, String? phone,String password, String userName, String name,String birthDate) async {
      if (email == null) email = '';
      else if (phone == null) phone = '';
  try {
  var url = Uri.parse('https://disbackend.onrender.com/SignInandSignUp/');
  var body = json.encode({'email': email,'phone': phone,'name': name, 'birthDay': birthDate,'credential': '', 'userName': userName, 'password': password,"isRegister":true});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['data']}  ErrorMessage: ${responseFinal['message']}');
  return [responseFinal];

  } catch (e) {
    return ['Error al realizar la peticion con el servidor'];
  }
  
  }

   Future<bool> userExist(String credential,String typeCredential ) async {
  print(credential);

  var url = Uri.parse('https://disbackend.onrender.com/ConfirmUserNoExist/');
  var body = json.encode({'typeCredential':typeCredential,'credential': credential});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: $responseFinal');
   return responseFinal;
  

  }




  @override
  Widget build(BuildContext context) {

    return  Scaffold(
     
      appBar: AppBar(title: const Text('SignUp'),
  ),
      body: 
       Column(
          children: [
            Expanded(child: 
         
Stepper(
        type: StepperType.horizontal,
        currentStep: _currentPage,


        onStepTapped: (int step) => setState(() => _currentPage = step),
        onStepContinue : () async{ 
          print(tmpEmail);

              setState(() {
              if (isTagExistPhone) errorCodeText = "Ya existe una cuenta con este numero";
              else if (isTagExistEmail) errorCodeTextEmail = "Ya existe una cuenta con este correo";
              else if (isTagExistuserName) errorCodeTextUserName = "Ya existe una cuenta con este nombre de usuario";
                isPasswordAccepted = _hasMinimumLength;
              errorCodeTextPassword = !isPasswordAccepted && _firstpassword.isNotEmpty ? "La contraseña es: $_passwordStrength" : null;
              errorCodeTextPasswordConfirm = !passwordCoincide && _password.isNotEmpty ? "La contraseña no coincide" : null;
      

          
              if (tmpNumber == _phoneNumber && tmpEmail == email) {isSendMsg = true; print("este es isSendMsg: $isSendMsg, este es tmpNumber: $tmpNumber, este es Number: $_phoneNumber, este es tmpEmail: $tmpEmail, este es email: $email");
              }  });
          if (_currentPage == 0) {

            if (_formKey1.currentState!.validate() && !isTagExistEmail && !isTagExistPhone){
              print(isTagExistPhone);

                _formKey1.currentState!.save();
                print("este es el numero: ${_phoneNumber}, este es el correo: ${email} ");
          
            if (!isSendMsg) {
              print(isSendMsg);
     
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
 
          }}
          

      else  if (_currentPage == 1){
              if (_formKey2.currentState!.validate() && !isTagExistuserName){
                _formKey2.currentState!.save();
              setState(() => {
          _currentPage += 1
          
          });
          }
            } 

          else if (_currentPage == 2){
              if (_formKey3.currentState!.validate() && isPasswordAccepted && passwordCoincide){
                _formKey3.currentState!.save();
       
              List data  =  await registerPost(email, _phoneNumber, _password, _username, _name, DateFormat.yMd().format(_birthDate!));
                print("bye");
                  print(data[0]['data']['userName']);
                  String id  = data[0]['data']['_id'] == null ? "" : data[0]['data']['_id'] ;
                  print(data[0]['isError']);
                  if (data[0]['isError'] == false){
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('userId', id);
                postList.myString = id.toString();
                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyApp(data: data),
                                      ),
                                    );
                                }
                        }
            } 


        },
        

        onStepCancel:
            _currentPage > 0 ? () => setState(() => _currentPage -= 1) : null,
        
controlsBuilder: (BuildContext context, ControlsDetails details) {
 return Container(
   child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: <Widget>[
       ElevatedButton(
         onPressed: details.onStepCancel,
         child: Padding(
           padding: EdgeInsets.all(16.0),
           child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
         ),
         style: ElevatedButton.styleFrom(
           shape: CircleBorder(),
           primary: Colors.grey,
           elevation: 5.0,
         ),
       ),
       ElevatedButton(
         onPressed: details.onStepContinue,
         child: Padding(
           padding: EdgeInsets.all(16.0),
           child: Icon(Icons.arrow_forward_ios_outlined),
         ),
         style: ElevatedButton.styleFrom(
           shape: CircleBorder(),
           primary: Colors.blue,
           elevation: 5.0,
         ),
       ),
     ],
   ),
 );
},

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
  autovalidateMode: AutovalidateMode.onUserInteraction,
  decoration: InputDecoration(
    errorText: errorCodeTextEmail,
    suffix: isLoadingEmail
        ? SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        : isTagExistEmail && !isLoadingEmail
            ? Icon(
                Icons.close,
                color: Colors.red,
                size: 18.0,
              )
            : Icon(
                Icons.check,
                color: Colors.green,
                size: 18.0,
              ),
    // Usar un icono de Material Icons para el prefijo
    prefixIcon: Icon(Icons.email),
    // Usar un borde redondeado para el campo
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    // Usar un estilo de texto personalizado para la etiqueta
    labelText: 'Email',
    labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0),
    // Usar un estilo de texto personalizado para el texto de error
    errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
    // Usar un color de relleno para el campo
    fillColor: Colors.grey[200],
    filled: true,
  ),
  initialValue: email,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (isBadFormattedEmail) return 'Invalid Email';
    return null;
  },
  onSaved: (value) {
    email = value.toString();
  },
  onChanged: (value) async {
    errorCodeTextEmail = null;
    email = value.toString();
    bool tmp = await userExist(email.trim().toLowerCase(), "email");
    bool tmp2 = false;
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      tmp2 = true;
    }
    setState(() {
      isLoadingEmail = true;
      isTagExistEmail = tmp || tmp2 ? true : false;
      isBadFormattedEmail = tmp2;
      isLoadingEmail = false;
    });
  },
) :  IntlPhoneField(           
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
                                suffix: isLoadingPhone ? SizedBox( width: 18.0, height: 18.0,  child: CircularProgressIndicator(strokeWidth: 2.0,), ): isTagExistPhone && !isLoadingPhone ? Icon(Icons.close, color: Colors.red, size:18.0) : 
                Icon(Icons.check, color: Colors.green, size:18.0),
                labelText: 'PhoneNumber',
              ),
              keyboardType: TextInputType.phone,
              initialValue: _phoneNumber,
              isTagExistPhone: isTagExistPhone,
              onSaved: (value) async {_phoneNumber = value!.completeNumber.toString();
               bool tmp = await userExist(value.completeNumber.trim().toLowerCase(),"phone");
                bool tmp2 = false;
  
              setState(() {isSendMsg = false;
              if (!_formKey1.currentState!.validate()) tmp2 = true;
                            isLoadingPhone = true;
                           isTagExistPhone = tmp || tmp2 ? true : false;
                           isLoadingPhone= false;  
                });
            
              },


              onCountryChanged: (country) => _country = country  ,

              onChanged: (value) async { 
                
                errorCodeText = null;
               _phoneNumber = value.completeNumber.toString();
              
               bool tmp = await userExist(value.completeNumber.trim().toLowerCase(),"phone");
                bool tmp2 = false;
  
              setState(() {isSendMsg = false;
              if (!_formKey1.currentState!.validate()) tmp2 = true;
                            isLoadingPhone = true;
                           isTagExistPhone = tmp || tmp2 ? true : false;
                           isLoadingPhone= false;  
                      
                });
            print("Desde el signup: $isTagExistPhone");
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


         ),),TextButton(
  onPressed: () {
    setState(() {registerWithCorreo = !registerWithCorreo; 
    if (registerWithCorreo) {_phoneNumber = ""; isTagExistPhone = false;} 
    else {email = ""; isTagExistEmail = false;} 
    } );
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
            content: Form(key: _formKey2 , child:
              

                  // Page 2: Name and Username
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                                    Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                         
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
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration:InputDecoration(
                   suffix: isLoadingUserName ? SizedBox( width: 18.0, height: 18.0,  child: CircularProgressIndicator(strokeWidth: 2.0,), ): isTagExistuserName && !isLoadingUserName ? Icon(Icons.close, color: Colors.red, size:18.0) : 
                Icon(Icons.check, color: Colors.green, size:18.0),
                  errorText: errorCodeTextUserName,
                border: OutlineInputBorder(),
                labelText: 'UserName',
  
              ),
                
                initialValue: _username,
                validator: (value) {
                        if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
    
                            return null;

                       
                          },
                          onSaved: (value) async{  

                            errorCodeTextUserName =  null;
                            _username = value! ;
                            bool tmp = await userExist(_username.trim().toLowerCase(),"userName");
                          bool tmp2 = false;
                          
                        
                 setState(() {  isLoadingUserName = true;
                            tmp2 = value.isEmpty ? true : false;
                            isTagExistuserName = tmp || tmp2 ? true : false;
                          
                           isLoadingUserName = false;  

                           });
                          
                          },
                          onChanged: (value) async {
                 
                              errorCodeTextUserName =  null;
                            _username = value ;
                            bool tmp = await userExist(_username.trim().toLowerCase(),"userName");
                          bool tmp2 = false;
                          
                        
                 setState(() {  isLoadingUserName = true;
                            tmp2 = value.isEmpty ? true : false;
                            isTagExistuserName = tmp || tmp2 ? true : false;
                          
                           isLoadingUserName = false;  

                           });
                          },
                        ), 
                        
                        
                        ),
Container(
  padding: const EdgeInsets.all(10),
  child: TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    readOnly: true,
    controller: TextEditingController(
        text: _birthDate == null
            ? ''
            : DateFormat.yMd().format(_birthDate!)),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Fecha de nacimiento',
     errorText: errorCodeTextBirthDay,
      prefixIcon: Icon(Icons.cake),
    ),
    onTap: () async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (selectedDate != null) {
        setState(() {
          _birthDate = selectedDate;
          birthdayisEmpty = false;
          isAgeAccepted =
              DateTime.now().difference(_birthDate!).inDays / 365 >= 6;
        });

        errorCodeTextBirthDay = !isAgeAccepted ? "You must be at least 6 years old to sign up" : null ;
      }
    },
    validator: (value) {
      if (value!.isEmpty) {
        return 'You cannot leave this field empty';
      } else if (!isAgeAccepted) {
        return 'You must be at least 6 years old to sign up';
      }
      return null;
    },
  ),
),
                      ],
                    ),
                  ),),
            isActive: _currentPage >= 1,
            state:
                _currentPage >= 1 ? StepState.complete : StepState.disabled,
      
          ),
          Step(
            title: Text('Password'),
            content: // Page 4: Password and PasswordConfirm
            Form(key: _formKey3 , child:
               Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
       Container(
  padding: const EdgeInsets.all(10),
  child: TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      errorText: errorCodeTextPassword,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: !_hasMinimumLength
              ? Colors.purple
              : !_hasContainUpperCases
                  ? Colors.yellow
                  : _hasNumberAndCharacter && _hasContainUpperCases &&  !_hasSpecialCharacter
                      ? Colors.green
                      : Colors.blue,
        ),
      ),
      labelText: 'Password',
      labelStyle: _firstpassword.isNotEmpty
          ? TextStyle(
              color: !_hasMinimumLength
                  ? Colors.purple
                  : !_hasContainUpperCases
                      ? Colors.amber
                      : _hasNumberAndCharacter && _hasContainUpperCases &&  !_hasSpecialCharacter
                          ? Colors.green
                          : Colors.blue,
            )
          : null,
      prefixIcon: Icon(Icons.lock, color: _firstpassword.isNotEmpty ? !_hasMinimumLength
              ? Colors.purple
              : !_hasContainUpperCases
                  ? Colors.amber
                  :  _hasNumberAndCharacter && _hasContainUpperCases &&  !_hasSpecialCharacter
                      ? Colors.green
                      : Colors.blue: null,),
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,   color: _firstpassword.isNotEmpty ? !_hasMinimumLength
              ? Colors.purple
              : !_hasContainUpperCases
                  ? Colors.amber
                  : _hasNumberAndCharacter && _hasContainUpperCases &&  !_hasSpecialCharacter
                      ? Colors.green
                      : Colors.blue : null,),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    ),
    obscureText: _obscureText,
    initialValue: _firstpassword,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      return null;
    },
    onChanged: (value)  async{
      errorCodeTextPassword = null;
      String tmpPrediction =  await predictionStrengthPassword(value);
      setState(()  {
        _firstpassword = value;
        _passwordStrength = evaluatePasswordStrength(value);
        evaluatedPredictionStrengthPassword = tmpPrediction;
        passwordCoincide = _firstpassword == _password && _firstpassword.isNotEmpty;
      });
    },
    onSaved: (value) => _firstpassword = value!,
  ),
),
Container(
  alignment: Alignment.centerLeft,
  padding: const EdgeInsets.only(left:10),
  child: Text(
    _firstpassword.isNotEmpty ? _passwordStrength : '',
    style: TextStyle(
      color: !_hasMinimumLength
          ? Colors.purple
          : !_hasContainUpperCases
              ? Colors.amber
              : _hasNumberAndCharacter && _hasContainUpperCases &&  !_hasSpecialCharacter
                  ? Colors.green
                  : Colors.blue,
    ),
  ),
),

              Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,         
                decoration:  InputDecoration(
                   prefixIcon: Icon(Icons.lock),
                errorText: errorCodeTextPasswordConfirm,
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
                          onChanged: (value) {
               
                            errorCodeTextPasswordConfirm = null;
                            _password = value;
                            setState(() {
                              passwordCoincide =  _firstpassword == _password && _firstpassword.isNotEmpty;
                            });
                           
                          },
                          onSaved: (value) =>
                              _password = value!,
                        ),),
Container(
  margin: EdgeInsets.only(top: 16.0),
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Estándares de seguridad',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8.0),      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 4.0),
              Text("Mínimo 8 caracteres"),
            ],
          ),
          _hasMinimumLength
              ? CircleAvatar(
                  backgroundColor: Colors.green,
                  child:Icon(Icons.check, color: Colors.white, size: 17.00),
                  radius: 10.0,
                )
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  child:  Icon(Icons.close, color: Colors.white, size: 17.00,),
                  radius: 10.0,
                ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 4.0),
              Text("Contiene números y caracteres"),
            ],
          ),
          _hasNumberAndCharacter
              ? CircleAvatar(
                  backgroundColor: Colors.green,
                  child:  Icon(Icons.check, color: Colors.white,size: 17.00),
                  radius: 10.0,
                )
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  child:  Icon(Icons.close, color: Colors.white, size: 17.00),
                  radius: 10.0,
                ),
        ],
      ),
            Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children:[
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 4.0),
          Text("Contiene letras mayusculas"),],),
          _hasContainUpperCases
              ? CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white, size: 17.00),
                  radius: 10.0,
                )
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  child:Icon(Icons.close, color: Colors.white, size: 17.00),
                  radius: 10.0,
                ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children:[
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 4.0),
          Text("Contiene caracteres especiales"),],),
          _hasSpecialCharacter
              ? CircleAvatar(
                  backgroundColor: Colors.green,
                  child:  Icon(Icons.check, color: Colors.white,size: 17.00),
                  radius: 10.0,
                )
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 17.00),
                  radius: 10.0,
                ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children:[
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 4.0),
              Text("Las contraseñas coinciden"),
            ],
          ),
          passwordCoincide
              ? CircleAvatar(
                  backgroundColor: Colors.green,
                  child:  Icon(Icons.check, color: Colors.white, size: 17.00),
                  radius: 10.0,
                )
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  child:  Icon(Icons.close, color: Colors.white,size: 17.00),
                  radius: 10.0,
                
                ),
        ],
      ),
      Container(
      margin: EdgeInsets.only(top: 16.0),
      child:

 Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Flexible( child:
          Text(evaluatedPredictionStrengthPassword) 
   ),  ],
 ),),
    ],
  ),
)
                      ],
                    ),
                    
                  ),
                  
                  
                  ),
                  
            isActive: _currentPage >= 2,
            state:
                _currentPage >= 2 ? StepState.complete : StepState.disabled,
     
          )

        ],
      ),)

    
       ],
        ),
      );
  }
}