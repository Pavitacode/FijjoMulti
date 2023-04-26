import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 1: Phone number
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _phoneNumber = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _currentPage++);
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
            // Page 2: Name
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _currentPage++);
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child:
                      const Text('Next'),
                ),
              ],
            ),// Page 3: Username
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _currentPage++);
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child:
                      const Text('Next'),
                ),
              ],
            ),
            // Page 4: Birthdate
            Column(
           children: [
    ElevatedButton(
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          setState(() => _birthDate = selectedDate);
        }
      },
      child: Text(_birthDate == null
          ? 'Select Birthdate'
          : 'Birthdate: ${DateFormat.yMd().format(_birthDate!)}'),
    ),
    if (_birthDate != null &&
        DateTime.now().difference(_birthDate!).inDays / 365 < 16)
      Text(
        'You must be at least 16 years old to sign up',
        style: TextStyle(color: Colors.red),
      ),
    ElevatedButton(
      onPressed: () {
        if (_birthDate != null &&
            DateTime.now().difference(_birthDate!).inDays / 365 >= 16) {
          setState(() => _currentPage++);
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: const Text('Next'),
    ),
  ],
),
            // Page 5: Email
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _currentPage++);
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
              ],
            ),// Page 6: Password
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => _currentPage++);
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
              ],
            ),
            // Page 7: Profile Picture
            Column(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}