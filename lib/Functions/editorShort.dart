import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'FilePicker.dart';
import 'ImageGallery.dart';
import 'VideoPlayer.dart';

class TikTokEditorPage extends StatefulWidget {

  const TikTokEditorPage({Key? key}) : super(key: key);

  @override
  _TikTokEditorPageState createState() => _TikTokEditorPageState();
}

class _TikTokEditorPageState extends State<TikTokEditorPage> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final ValueNotifier<String> _currentCase0View = ValueNotifier<String>('home');
  List<File> selectedFiles = [];

  Future<bool> isValidImage(File file) async {
    try {
      final image = await decodeImageFromList(await file.readAsBytes());
      return image != null;
    } catch (e) {
      return false;
    }
  }

  void _pickFiles() async {
    // Muestra el visualizador de archivos personalizado
    List<AssetEntity> selectedAssets = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePickerPage(),
      ),
    );

    if (selectedAssets != null) {
      // Aquí puedes procesar los archivos seleccionados
      for (AssetEntity asset in selectedAssets) {
        final file = await asset.file;
        if (file != null) selectedFiles.add(file);
      }
      // Usa selectedFiles para mostrar los archivos seleccionados
      if (selectedFiles.length == 1 && selectedAssets[0].type == AssetType.video) {
        // Actualiza la vista actual a 'videoPlayer' si se seleccionó un solo video
        _currentCase0View.value = 'videoPlayer';
      } else {
        // Verifica que los archivos de imagen seleccionados sean válidos
        bool areImagesValid = true;
        for (File file in selectedFiles) {
          final isValid = await isValidImage(file);
          if (!isValid) {
            areImagesValid = false;
            break;
          }
        }
        if (areImagesValid) {
          // Actualiza la vista actual a 'imageGallery' si se seleccionaron varias imágenes válidas
          _currentCase0View.value = 'imageGallery';
        } else {
          // Muestra un mensaje de error si se seleccionaron imágenes no válidas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Se seleccionaron imágenes no válidas')),
          );
        }
      }
    } else {
      // El usuario canceló la selección de archivos
    }
  }

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Scaffold(
        backgroundColor: Colors.black,
        body:  ValueListenableBuilder<String>(
                  valueListenable: _currentCase0View,
                  builder: (context, value, child) {
                    switch (value) {
                      case 'home':
                        return Container(
                          padding: const EdgeInsets.all(100),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              _pickFiles();
                            },
                            child: Text('Seleccionar archivos'),
                          ),
                        );
                      case 'videoPlayer':
                        return VideoPlayerPage(file: selectedFiles[0]);
                      case 'imageGallery':
                        return ImageGalleryPage(files: selectedFiles);
                      default:
                        return Container();
                    }
                  },
                ),),],);
            }
          }