
import 'dart:io';

import 'package:fijjo_multiplatform/widgets/FilePicker.dart';
import 'package:fijjo_multiplatform/widgets/IAAssistant.dart';
import 'package:fijjo_multiplatform/signIn.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




class savedValues {
  static final savedValues _singleton = savedValues._internal();

  factory savedValues() {
    return _singleton;
  }

  savedValues._internal();

  List<dynamic> _myFriendList = [];

  List<dynamic> get myFriendList => _myFriendList;

  set myFriendList(List<dynamic> value) {
    _myFriendList = value;
  }


    List<dynamic> _bestPlacesList = [];

  List<dynamic> get bestPlacesList => _bestPlacesList;

  set bestPlacesList(List<dynamic> value) {
    _bestPlacesList = value;
  }

  String _myString = "";

  String get myString => _myString;

  set myString(String value) {
    _myString = value;
  }
}