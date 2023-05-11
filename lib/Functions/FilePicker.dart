import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

<<<<<<< HEAD

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


=======
>>>>>>> new-branch
class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

<<<<<<< HEAD
class _ImagePickerPageState extends State<ImagePickerPage> {
  List<Widget> imageList = [];
  List<bool> isSelectedList = [];
  List<int> selectedImages = [];
  int currentPage = 0;
  int? lastPage;

=======
class _ImagePickerPageState extends State<ImagePickerPage>
    with SingleTickerProviderStateMixin {
  List<AssetEntity> photos = [];
  List<int> selectedImages = [];
  int currentPage = 0;
  int? lastPage;
  bool isVideoSelected = false;
  late TabController _tabController;
  int _currentTabIndex = 0;
>>>>>>> new-branch

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

<<<<<<< HEAD
    List<AssetEntity> photos = await albums[0].getAssetListPaged(
=======
    List<AssetEntity> newPhotos = await albums[0].getAssetListPaged(
>>>>>>> new-branch
      page: currentPage,
      size: 24,
    );

<<<<<<< HEAD
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
=======
    setState(() {
      photos.addAll(newPhotos);
>>>>>>> new-branch
      currentPage++;
    });
  }

<<<<<<< HEAD
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
=======
  @override
  void initState() {
    fetchAllImages();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AssetEntity> filteredPhotos = photos;
    if (_currentTabIndex == 1)
      filteredPhotos = photos.where((asset) => asset.type == AssetType.image).toList();
    if (_currentTabIndex == 2)
      filteredPhotos = photos.where((asset) => asset.type == AssetType.video && asset.videoDuration.inSeconds <= 600).toList();

    if (_currentTabIndex == 0)
      filteredPhotos = photos.where((asset) => asset.type != AssetType.video || asset.videoDuration.inSeconds <= 600).toList();

      
>>>>>>> new-branch
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Seleccionar Imagenes',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
<<<<<<< HEAD
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
=======
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.green,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          tabs: [
            Tab(text: 'Todos'),
            Tab(text: 'Imágenes'),
            Tab(text: 'Videos'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child:
            NotificationListener(
          onNotification:
              (ScrollNotification scroll) {
            handleScrollEvent(scroll);
            return true;
          },
          child:
              GridView.builder(itemCount:
                  filteredPhotos.length, gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:
                      3), itemBuilder:
                  (_, index) {
                final asset =
                    filteredPhotos[index];
                int duracion =
                    asset.videoDuration.inSeconds;
                int minutos =
                    duracion ~/ 60;
                int segundos =
                    duracion % 60;
                String tiempo =
                    '$minutos:${segundos.toString().padLeft(2, '0')}';

                return Stack(
                  children: [
                    FutureBuilder(
                      future:
                          asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                      builder:
                          (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return GestureDetector(
                            onTap:
                                () {
                              setState(() {
                                if (asset.type ==
                                    AssetType.video) {
                                  selectedImages.clear();
                                  isVideoSelected =
                                      true;
                                } else if (isVideoSelected) {
                                  selectedImages.clear();
                                  isVideoSelected =
                                      false;
                                }
                                if (selectedImages.contains(index)) {
                                  selectedImages.remove(index);
                                } else if (selectedImages.length < 40 ||
                                    isVideoSelected) {
                                  selectedImages.add(index);
                                }
                              });
                            },
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image:
                                MemoryImage(snapshot.data as Uint8List),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),),);
                    }
                    return const SizedBox();
                  },
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: selectedImages.contains(index)
                      ? const Icon(Icons.check_circle,color:
                      Colors.blue,)
                      : const Icon(Icons.crop_square_sharp,color:
                      Colors.blue,),
                ),
                if (asset.type == AssetType.video)
                  Positioned(
                    right: 5,
                    top: 5,
                    child:
                        const Icon(Icons.videocam,color:
                        Colors.white,),
                  ),

                  if (asset.type == AssetType.video)
              Positioned(
                right: 90,
                top: 100,
                child: Text(
                  tiempo,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ],
            );
          },),),),
      floatingActionButton:selectedImages.length >= 2
          ? FloatingActionButton.extended(onPressed:
          () {
          List<AssetEntity> selectedAssets =
              selectedImages.map((index) => photos[index]).toList();
          Navigator.pop(context, selectedAssets);
          } ,label:
          Text(isVideoSelected ? 'Seleccionar este video' : 'Seleccionar estas imágenes'),)
          : null,
>>>>>>> new-branch
    );
  }
}