
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:country_codes/country_codes.dart';



class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);




  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;
  

  String _phoneNumber = '';
  String _name = '';
  String _username = '';
  DateTime? _birthDate;
  String _email = '';
  String _password = '';
  String _selectedDialCode = '';
  String _formattedPhoneNumber = '';
  String countryCode = '';
  
@override
void initState() {
  super.initState();
  CountryCodes.init().then((_) {
    final Locale? deviceLocale = CountryCodes.getDeviceLocale();
    if (deviceLocale != null) {
    countryCode = deviceLocale.countryCode.toString();
  // Usa countryCode aquí
    } else {
      countryCode = "";
      // Maneja el caso en el que deviceLocale es nulo
    }
    // Usa countryCode aquí
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
// Progress bar
SizedBox(height: 20),
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Phone number icon
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: _currentPage == 0 ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: Icon(
          Icons.phone,
          color: _currentPage == 0 ? Colors.blue : Colors.grey,
          size: 40,
        ),
      ),
      // Name and username icon
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: _currentPage == 1 ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: Icon(
          Icons.person,
          color: _currentPage == 1 ? Colors.blue : Colors.grey,
          size: 40,
        ),
      ),
      // Birthdate icon
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: _currentPage == 2 ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: Icon(
          Icons.cake,
          color: _currentPage == 2 ? Colors.blue : Colors.grey,
          size: 40,
        ),
      ),
      // Email and password icon
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: _currentPage == 3 ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: Icon(
          Icons.email,
          color:_currentPage == 3 ? Colors.blue : Colors.grey,
          size: 40,
        ),
      ),
      // Profile picture icon
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform:_currentPage == 4 ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: Icon(
          Icons.camera_alt,
          color:_currentPage == 4 ? Colors.blue : Colors.grey,
          size:40,
        ),
      ),
    ],
  ),
),

// Progress bar
Container(
    width:250,
    child:
    LinearProgressIndicator(
    value:(_currentPage +1)/7,
    ),
),
            Expanded(
              child: 
               PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Page 1: Phone number
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [   
            Container(
            padding: const EdgeInsets.all(10),
              child:  IntlPhoneField(           
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PhoneNumber',
              ),
              keyboardType: TextInputType.phone,
              initialValue: countryCode,
              initialCountryCode: countryCode,
              validator: (value) {
              
                if (value?.completeNumber == null || value!.completeNumber.isEmpty) {
                  return 'Please enter your phone number';
                        }
                return null;
                          },
                          onSaved: (value) => _phoneNumber = value!.completeNumber.toString(),
                        ),),
              ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() => _currentPage++);
                              _pageController.nextPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: const Text('Next'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                              setState(() => _currentPage--);
                              _pageController.previousPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          ,
                          child:
                              const Text('Back'),
                        ),
                      ],
                    ),
                  ),
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
                            return null;
                          },
                          onSaved: (value) => _username = value!,
                        ),),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() => _currentPage++);
                              _pageController.nextPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child:
                              const Text('Next'),
                        ),

                        ElevatedButton(
                          onPressed: () {

                              setState(() => _currentPage--);
                              _pageController.previousPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          ,
                          child:
                              const Text('Back'),
                        ),
                      ],
                    ),
                  ),
                  // Page 3: Birthdate
                  Center(
                    child:
                        Column(mainAxisAlignment:
                            MainAxisAlignment.center,
                      children:[
    ElevatedButton(
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
    ElevatedButton(
      onPressed:
          () {
        if (_birthDate !=
                null &&
            DateTime.now()
                    .difference(_birthDate!)
                    .inDays /
                365 >=
            16) {
          setState(() =>
              _currentPage++);
          _pageController.nextPage(
            duration:
                const Duration(milliseconds:
                    300),  curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: const Text('Next'),
                        ),

                        ElevatedButton(
                          onPressed: () {

                              setState(() => _currentPage--);
                              _pageController.previousPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          ,
                          child:
                              const Text('Back'),
                        ),
                      ],
                    ),
                  ),

                  // Page 4: Email and Password
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            Container(
            padding: const EdgeInsets.all(10),
              child:  TextFormField(
                         
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
  
              ),
                          keyboardType:
                              TextInputType.emailAddress,
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
                labelText: 'Password',
  
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
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!
                                .validate()) {
                              _formKey.currentState!.save();
                              setState(() =>
                                  _currentPage++);
                              _pageController.nextPage(
                                duration:
                                    const Duration(milliseconds:
                                        300),
                                curve:
                                    Curves.easeInOut,
                              );
                            }
                          },
                          child:
                              const Text('Next'),
                        ),



                        ElevatedButton(
                          onPressed: () {

                              setState(() => _currentPage--);
                              _pageController.previousPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          ,
                          child:
                              const Text('Back'),
                        ),
                      ],
                    ),
                  ),
                  // Page 5: Profile Picture
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: Implement profile picture selection
                          },
                          child:
                              const Text('Select Profile Picture (Optional)'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement sign up logic
                          },
                          child:
                              const Text('Sign Up'),
                        ),

                        ElevatedButton(
                          onPressed: () {

                              setState(() => _currentPage--);
                              _pageController.previousPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          ,
                          child:
                              const Text('Back'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}