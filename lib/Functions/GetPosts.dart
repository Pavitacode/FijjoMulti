
import 'dart:io';

import 'package:fijjo_multiplatform/Functions/FilePicker.dart';
import 'package:fijjo_multiplatform/Functions/IAAssistant.dart';
import 'package:fijjo_multiplatform/signIn.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




class PostList {
  static final PostList _singleton = PostList._internal();

  factory PostList() {
    return _singleton;
  }

  PostList._internal();

  List<dynamic> _myList = [];

  List<dynamic> get myList => _myList;

  set myList(List<dynamic> value) {
    _myList = value;
  }

  String _myString = "";

  String get myString => _myString;

  set myString(String value) {
    _myString = value;
  }
}