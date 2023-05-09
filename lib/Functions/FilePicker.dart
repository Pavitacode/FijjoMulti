import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';


class SelectIcon extends StatefulWidget {
  final bool isSelected;
  const SelectIcon({Key? key, required this.isSelected}) : super(key: key);

  @override
  _SelectIconState createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SelectIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Icon(
            Icons.check_circle,
            color: Colors.blue,
          )
        : Icon(
            Icons.crop_square_sharp,
            color: Colors.blue,
          );
  }
}


class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<Widget> imageList = [];
  List<bool> isSelectedList = [];
  List<int> selectedImages = [];
  int currentPage = 0;
  int? lastPage;


  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
    if (currentPage == lastPage) return;
    fetchAllImages();
  }

  fetchAllImages() async {
    lastPage = currentPage;
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return PhotoManager.openSetting();

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      onlyAll: true,
    );

    List<AssetEntity> photos = await albums[0].getAssetListPaged(
      page: currentPage,
      size: 24,
    );

    List<Widget> temp = [];
    List<bool> selectedList = List.generate(photos.length, (index) => false);

    for (int index = 0; index < photos.length; index++) {
      final asset = photos[index];
      bool isSelected = false;

      temp.add(
        FutureBuilder(
          future: asset.thumbnailDataWithSize(
            const ThumbnailSize(200, 200),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
  onTap: () {
    setState(() {
      if (selectedImages.contains(index)) {
        selectedImages.remove(index);
        isSelected = false;
    
      } else if (selectedImages.length < 40) {
        selectedImages.add(index);
           isSelected = true;
     
      }

      
    });
  },
  child: Stack(
    children: [
      Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          image: DecorationImage(
            image: MemoryImage(snapshot.data as Uint8List),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
        Positioned(
          right: 5,
          bottom: 5,
          child: isSelected
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.crop_square_sharp,
                  color: Colors.blue,
                  ),
        ),
    ],
  ),
)

              );
            }
            return const SizedBox();
          },
        ),
      );
    }

    setState(() {
      imageList.addAll(temp);
      currentPage++;
    });
  }

  void showSelectedImagesCount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Imágenes seleccionadas'),
          content: Text('Has seleccionado ${selectedImages.length} imágenes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    fetchAllImages();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Seleccionar Imagenes',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: NotificationListener(
          onNotification: (ScrollNotification scroll) {
            handleScrollEvent(scroll);
            return true;
          },
          child: GridView.builder(
            itemCount: imageList.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:
                    3),
            itemBuilder: (_, index) {
              return imageList[index];
            },
          ),
        ),
      ),
      floatingActionButton:selectedImages.isNotEmpty
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.pop(context, selectedImages),
            label:
                const Text('Seleccionar estas imágenes'),
          )
        : null,
    );
  }
}