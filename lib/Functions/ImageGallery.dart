import 'dart:io';
import 'package:flutter/material.dart';

class ImageGalleryPage extends StatelessWidget {
  final List<File> files;
  const ImageGalleryPage({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Image.file(files[index]);
        },
      ),
    );
  }
}