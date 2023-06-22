import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fijjo_multiplatform/widgets/editorPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'FilePicker.dart';
import 'ImageGallery.dart';
import 'VideoPlayer.dart';
import 'cameraPreview.dart';
import 'customAlerts/customAlert.dart';
import 'editorWidgets/picturePreview.dart';
import 'editorWidgets/temporizerWidget.dart';

class EditorPage extends StatefulWidget {
  final VoidCallback onDiscardPost;

  EditorPage({Key? key, required this.onDiscardPost}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<EditorPage> {
  bool isPostEdit = false;
  int _currentImageIndex = 0;
  bool _showPreview = false;
  FlashMode _flashMode = FlashMode.off;
  double _zoom = 1.0; // Variable para almacenar el valor del zoom
  List<CameraDescription>? cameras;
  var firstCamera;
  bool isRecording = false;
  int recordingTime = 0;
  Timer? timer;
  Timer? timer2;
  AssetEntity? _latestMediaFile;
  int _currentCameraIndex = 0;

  void _onSwitchCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % cameras!.length;
    final camera = cameras![_currentCameraIndex];
    _controller = CameraController(camera, ResolutionPreset.ultraHigh);
    await _controller!.initialize();
    // Establece el nivel de zoom de la cámara al valor almacenado en la variable _zoom
    await _controller!.setZoomLevel(_zoom);
    setState(() {});
  }

  void _onToggleFlash() async {
    if (_flashMode == FlashMode.off) {
      _flashMode = FlashMode.torch;
    } else {
      _flashMode = FlashMode.off;
    }
    await _controller?.setFlashMode(_flashMode);
    setState(() {});
  }

  void deleteVideosfromList() {
    // tu lista de archivos
    if (selectedFiles.isNotEmpty) {
      int i = 0;
      for (i; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        final path = file.path;
        final extension = path.split('.').last;

        if (['mp4', 'avi', 'mov', 'wmv'].contains(extension)) {
          selectedFiles.removeAt(i);
        } else {
          // El primer archivo no es un archivo de video
        }
      }
    }
  }

  Future<void> instatiateCameras() async {
    cameras = await availableCameras();
    firstCamera = cameras!.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.ultraHigh,
    );
    await _controller!.initialize();
    // Establece el nivel de zoom de la cámara al valor almacenado en la variable _zoom
    await _controller!.setZoomLevel(_zoom);
  }

  Future<bool> isValidImage(File file) async {
    try {
      final image =
          await decodeImageFromList(await file.readAsBytes());
      return image != null;
    } catch (e) {
      return false;
    }
  }

  final ValueNotifier<String> _currentCase0View =
      ValueNotifier<String>('home');
  List<File> selectedFiles = [];

  void _pickFiles() async {
    deleteVideosfromList();
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
        final type = await asset.type;

        if (type == AssetType.video) {
          selectedFiles.clear();
        }

        if (file != null) selectedFiles.add(file);
      }

      // Usa selectedFiles para mostrar los archivos seleccionados
      if (selectedFiles.length == 1 &&
          selectedAssets[0].type == AssetType.video) {
        // Actualiza la vista actual a 'videoPlayer' si se seleccionó
        // Actualiza la vista actual a 'videoPlayer' si se seleccionó un solo video
        File tmpFile = selectedFiles[0];
        selectedFiles.clear();
        selectedFiles.add(tmpFile);
        _currentCase0View.value = 'videoPlayer';
      } else {
        // Verifica que los archivos de imagen seleccionados sean válidos
        bool areImagesValid = true;
        for (File file in selectedFiles) {
          final isValid = await isValidImage(file);
          if (!isValid) {
            selectedFiles.remove(file);
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPost(
            currentCase: _currentCase0View.value,
            selectedFiles: selectedFiles),
      ),
    );
  }

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  void onRecStart() async {
    selectedFiles.clear();
    setState(() => isRecording = true);
    await _controller!.startVideoRecording();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => recordingTime++);
      if (recordingTime >= 180) timer.cancel();
    });
  }

  void onRecEnd() async {
    XFile videoFile = await _controller!.stopVideoRecording();
    timer?.cancel();
    recordingTime = 0;
    print("lista desde el clear $selectedFiles");
    selectedFiles.add(File(videoFile.path));
    _currentCase0View.value = 'videoPlayer';
    setState(() {
      isRecording = false;
      isPostEdit = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPost(
            currentCase: _currentCase0View.value,
            selectedFiles: selectedFiles),
      ),
    );
    print(_currentCase0View.value);
  }
Future<void> _getLatestMediaFile() async {
  // Solicita permiso para acceder a las fotos y videos
  final permitted = await PhotoManager.requestPermissionExtend();
  if (permitted == PermissionState.authorized) {
    // Obtiene la lista de álbumes
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: true,
    );

    // Encuentra el álbum que contiene las imágenes y videos
    final allMediaAlbum = albums.firstWhere((element) => element.isAll);

    // Obtiene la lista completa de activos del álbum
    final media = await allMediaAlbum.getAssetListRange(
      start: 0,
      end: allMediaAlbum.assetCount,
    );

    // Ordena la lista de activos por fecha de creación en orden descendente
    media.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    // Establece el último archivo multimedia
    setState(() {
      _latestMediaFile = media.first;
    });
  }
}


  double _timerValue = 0;

  Widget _buildTimerOptionButton(String label,
      {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _timerValue = double.parse(label.split(' ').first);
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.grey[400] : Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  int CountTimer = 0;
  int timeToRecFromTimer = 0;
  bool isTemporizer = false;
  int counter = 0;

  @override
  void initState() {
        _getLatestMediaFile();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _initializeControllerFuture = instatiateCameras();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Muestra la alerta personalizada aquí
        final result = isPostEdit
            ? await showDialog<bool>(
                context: context,
                builder: (context) => MyCustomAlertDialog())
            : null;

        // Si el usuario elige descartar el post, devuelve true para permitir que la navegación continúe
        // Si el usuario elige continuar con el post, devuelve false para cancelar la navegación
        if (result == true) {
          widget.onDiscardPost();
          return true;
        } else if (result == null) {
          widget.onDiscardPost();
          Navigator.of(context).pop(true);
        }

        // Si el usuario elige continuar con el post, devuelve false para cancelar la navegación
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onScaleUpdate: (details) {
                      // Actualiza el valor del zoom
                      setState(() {
                        _zoom = details.scale;
                      });
                      // Aplica el zoom a la vista previa de la cámara
                      _controller!.setZoomLevel(_zoom);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CameraPreviewWithTap(controller: _controller!),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            // Coloca otros widgets encima de la vista previa de la cámara aquí
         
              Positioned(
                top: 10,
                left: 10,
                child: !isRecording ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () async {
                      final result = isPostEdit
                          ? await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => MyCustomAlertDialog())
                          : null;
                      // Si el usuario elige descartar el post, devuelve true para permitir que la navegación continúe
                      // Si el usuario elige continuar con el post, devuelve false para cancelar la navegación
                      if (result == true) {
                        widget.onDiscardPost();
                        Navigator.of(context).pop(true);
                      } else if (result == null) {
                        widget.onDiscardPost();
                        Navigator.of(context).pop(true);
                      }
                    },
                  ),
                ): Container(),
              ),
           
              Positioned(
                
                top: 300,
                right: 10,
                child: !isRecording ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius:
BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.flip_camera_android),
                        color: Colors.white,
                        onPressed: _onSwitchCamera,
                      ),
                      IconButton(
                        icon: Icon(Icons.timer),
                        color: Colors.white,
                        onPressed: () async {
                          var completer = Completer<List>();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                ShowTemporizador(completer: completer),
                          );
                          var result = await completer.future;
                          setState(() {
                            CountTimer = result[0];
                            timeToRecFromTimer = result[1];
                            isTemporizer = result[2];
                            print(CountTimer);
                          });
                        },
                      ),
                      IconButton(
                        icon: _flashMode == FlashMode.off
                            ? Icon(Icons.flash_off)
                            : Icon(Icons.flash_on),
                        color: Colors.white,
                        onPressed: _onToggleFlash,
                      ),
                      if (_isExpanded) ...[
                        IconButton(
                          icon: Icon(Icons.speed),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.filter),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.brightness_6),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                      IconButton(
                        icon: Icon(_isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        color: Colors.white,
                        onPressed: () =>
                            setState(() => _isExpanded = !_isExpanded),
                      ),
                    ],
                  ),
                ): Container(),
              ),
            Positioned(
              bottom: 50,
              left:
                  MediaQuery.of(context).size.width / 2 - 35,
              child: GestureDetector(
                             
                onTap: () async {
                  print("Click");
                  if (!isRecording) {
                    deleteVideosfromList();
                    print("hola");
                    final imageFile =
                        await _controller!.takePicture();
                    _currentCase0View.value = 'imageGallery';
                    setState(() {
                      isPostEdit = true;
                      selectedFiles.add(File(imageFile.path));
                      _showPreview = true;
                      print(
                          "hola desde el onTap del setState, response: $_showPreview y este es el resultado de selectedFiles : $selectedFiles");
                    });
                  }
                },
                onLongPressStart:
                    (details) async{
                      print("Inicio");
           selectedFiles.clear();
    setState(() => isRecording = true);
    print(isRecording);
    await _controller!.startVideoRecording();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => recordingTime++);
      if (recordingTime >= 180) timer.cancel();
    });
                },

                   onLongPressEnd:
                    (details)async {
                      print("Deteniendo");
 XFile videoFile = await _controller!.stopVideoRecording();
    timer?.cancel();
    recordingTime = 0;
    print("lista desde el clear $selectedFiles");
    selectedFiles.add(File(videoFile.path));
    _currentCase0View.value = 'videoPlayer';
    setState(() {
      isRecording = false;
      isPostEdit = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPost(
            currentCase: _currentCase0View.value,
            selectedFiles: selectedFiles),
      ),
    );
    print(_currentCase0View.value);
                },

                child:
                    Column(children: [
                  Text(
                    !isRecording
                        ? ''
                        : '${recordingTime ~/ 60}:${(recordingTime % 60).toString().padLeft(2, '0')}',
                    style:
                        TextStyle(color:
                            Colors.white),
                  ),
                  SizedBox(height:
                      20),
                  Stack(
                    alignment:
                        Alignment.center,
                    children:
[
                      if (isRecording)
                        SizedBox(
                          height: isRecording ? 70 : 60,
                          width: isRecording ? 70 : 60,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              isRecording
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            backgroundColor:
                                isRecording
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.2),
                            value: recordingTime == 0
                                ? null
                                : recordingTime /
                                    (3 * 60).toDouble(),
                            strokeWidth: 20,
                          ),
                        ),
                      AnimatedContainer(
                        duration:
                            Duration(milliseconds: 100),
                        height: isRecording ? 70 : 60,
                        width: isRecording ? 70 : 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.white, width: 3),
                        ),
                        child: isRecording
                            ? Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration:
                                      BoxDecoration(
                                          shape:
                                              BoxShape.circle,
                                          color:
                                              Colors.red),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  SizedBox(height:
                      10),
                ]),
              ),
            ),
            if (!isRecording)
              Positioned(
                bottom: 65,
                left: 50,
                child:
                    GestureDetector(
                  onTap:
                      _pickFiles,
                  child:
                      Column(children: [
                    FutureBuilder<Uint8List?>(
                      future:
                          _latestMediaFile?.thumbnailDataWithSize(const ThumbnailSize(50, 50)),
                      builder:
                          (context, snapshot) {
                        return Container(
                          width:
                              50,
                          height:
                              50,
                          decoration:
                              BoxDecoration(
                            border:
                                Border.all(color: Colors.white),
                            shape:
                                BoxShape.rectangle,
                            image:
                                DecorationImage(
                              image:
                                  (snapshot.hasData && snapshot.data is Uint8List)
                                      ? MemoryImage(snapshot.data as Uint8List)
                                      : AssetImage('assets/book.png') as ImageProvider,
                              fit:
                                  BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ),
            if (_showPreview && selectedFiles.isNotEmpty)
              FullScreenImagePreview(
                selectedFiles:
                    selectedFiles,
                onAdd: () {
                  setState(() =>
                      _showPreview = false);
                },
                onDelete: () {
                  setState(() {
                    selectedFiles.removeLast();
                    _showPreview = false;
                  });
                },
                onNext: () {
                  print("hola");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EditorPost(
                        currentCase:
                            _currentCase0View.value,
                        selectedFiles:
                            selectedFiles,
                      ),
                    ),
                  );
                },
              ),
            if (isTemporizer)
              TemporizerWidget(
                time: CountTimer,
                onFinish: () async {
                  setState(() {
                    isTemporizer = false;
                    onRecStart();
                    timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
                      counter++;
                      if (counter > timeToRecFromTimer) {
                        onRecEnd();
                        timer2!.cancel();
                        counter = 0;
                      }
                    });
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
