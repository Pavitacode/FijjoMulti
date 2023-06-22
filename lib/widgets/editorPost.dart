
import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';

import 'FilePicker.dart';
import 'ImageGallery.dart';

import 'VideoPlayer.dart';


class EditorPost extends StatefulWidget {
  final String currentCase;
  final List<File> selectedFiles;
  EditorPost({Key? key, required this.currentCase, required this.selectedFiles}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<EditorPost> {
  List<CameraDescription>? cameras;
  var firstCamera;
  bool isRecording = false;




//   Future<bool> isValidImage(File file) async {
//   try {
//     final image = await decodeImageFromList(await file.readAsBytes());
//     return image != null;
//   } catch (e) {
//     return false;
//   }
// }

final ValueNotifier<String> _currentCase0View = ValueNotifier<String>('');
List<File> selectedFiles = [];

// void _pickFiles() async {
//   // Muestra el visualizador de archivos personalizado
//   List<AssetEntity> selectedAssets = await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ImagePickerPage(),
//     ),
//   );

//   if (selectedAssets != null) {
//     // Aquí puedes procesar los archivos seleccionados
 
//     for (AssetEntity asset in selectedAssets) {
//       final file = await asset.file;
//       if (file != null) selectedFiles.add(file);
//     }
//     // Usa selectedFiles para mostrar los archivos seleccionados
//     if (selectedFiles.length == 1 && selectedAssets[0].type == AssetType.video) {
//       // Actualiza la vista actual a 'videoPlayer' si se seleccionó un solo video
//       _currentCase0View.value = 'videoPlayer';
//     } else {
//       // Verifica que los archivos de imagen seleccionados sean válidos
//       bool areImagesValid = true;
//       for (File file in selectedFiles) {
//         final isValid = await isValidImage(file);
//         if (!isValid) {
//           areImagesValid = false;
//           break;
//         }
//       }
//       if (areImagesValid) {
//         // Actualiza la vista actual a 'imageGallery' si se seleccionaron varias imágenes válidas
//         _currentCase0View.value = 'imageGallery';
//       } else {
//         // Muestra un mensaje de error si se seleccionaron imágenes no válidas
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Se seleccionaron imágenes no válidas')),
//         );
//       }
//     }
//   } else {
//     // El usuario canceló la selección de archivos
//   }

  
// }



  @override
  void initState() {
    super.initState();
    

   _currentCase0View.value = widget.currentCase;
   selectedFiles = widget.selectedFiles;
   print(selectedFiles);
  }


  @override
  Widget build(BuildContext context) {
    return 
ValueListenableBuilder<String>(
                  valueListenable: _currentCase0View,
                  builder: (context, value, child) {
                    switch (value) {
                      case 'videoPlayer':
                        return VideoPlayerPage(file: selectedFiles[0]);
                      case 'imageGallery':
                        return ImageGalleryPage(files: selectedFiles);
                      default:
                        return Container();
                    }
                  },
                );
  }
}


