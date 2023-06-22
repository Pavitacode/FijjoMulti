import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImagePreview extends StatelessWidget {
  final List<File> selectedFiles;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final VoidCallback onNext;

  const FullScreenImagePreview({
    Key? key,
    required this.selectedFiles,
    required this.onAdd,
    required this.onDelete,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            child: Center(
              child: Image.file(selectedFiles.last),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                                IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white,),
                  onPressed: onAdd,
                ),
       
              
              ],
            ),
          ),
          if (selectedFiles.length > 1)
          Positioned(
            bottom: 0,
            right:0 ,
            child:   IconButton(icon: Icon(Icons.arrow_forward_ios, color:Colors.white),
                onPressed: onNext,
                ),),
                Positioned(left: 0, right: 0, top:80,  child: Container(color: Colors.black.withOpacity(0.5) ,    alignment: Alignment.topCenter, child:
                Text('Necesitas al menos dos imagenes para poder seguir', style: TextStyle(color:Colors.white),),
                ),)

        ],
      ),
    );
  }
}
