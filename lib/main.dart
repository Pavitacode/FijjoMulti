
import 'dart:io';

import 'package:fijjo_multiplatform/widgets/FilePicker.dart';
import 'package:fijjo_multiplatform/widgets/IAAssistant.dart';
import 'package:fijjo_multiplatform/widgets/cameraView.dart';
import 'package:fijjo_multiplatform/signIn.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palette_generator/palette_generator.dart';

import 'widgets/savedValues.dart';
import 'widgets/ImageGallery.dart';
import 'widgets/Posts/postPagination.dart';
import 'widgets/VideoPlayer.dart';




Future<List> getDataUser(String id) async {
  try {
  var url = Uri.parse('https://disbackend.onrender.com/getUserData/');
  var body = json.encode({'id': id});
  var response = await http.post(url, body: body);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal['data']}');
  return [responseFinal];

  } catch (e) {
    return ['Error al realizar la peticion con el servidor'];
  }
  
}

Future<List> getBestPlaces() async {

  var url = Uri.parse('https://disbackend.onrender.com/bestPlaces');

  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  final responseFinal = json.decode(utf8.decode(response.bodyBytes));
  print('Response body: ${responseFinal}');
  return responseFinal;
  } 




void main() async{
  savedValues _savedValues = savedValues();

  _savedValues.bestPlacesList = await getBestPlaces();
  print(_savedValues.bestPlacesList);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print(userId);
  _savedValues.myString = userId.toString();
  List data = [];
  if (userId != null) data =  await getDataUser(userId);
  print(data);
  runApp(userId == null ? Login() : MyApp(data: data));


}

class MyApp extends StatefulWidget {
  final List data;

  MyApp({Key? key, required this.data}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  savedValues _savedValues = savedValues();




  List<dynamic> _posts = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();





  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


    void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar sesión"),
          content: Text("¿Seguro que quieres cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () async{
                Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId');
                 Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

        final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(bestPlaces: _savedValues.bestPlacesList),
    TrackScreen(),
    BlogsScreens(),
    HotelScreen(),
    FlightScreen(),
    SettingsScreen(),
  ];
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.black
        
      
      ),
      home: Scaffold(
      
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.menu, color:Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.notifications, color:Colors.white,),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        drawer:   Drawer(
          backgroundColor: Colors.black,
          child: PageTransitionSwitcher(
            
            transitionBuilder:
                (child, primaryAnimation, secondaryAnimation) =>
                    SharedAxisTransition(
              child: child,
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            ),
            child: Builder(
  
              builder: (context) => ListView(
                key: ValueKey(_selectedIndex),
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(widget.data[0]['data']['userName']),
                    accountEmail: Text(widget.data[0]['data']['email'] == '' ? widget.data[0]['data']['phone'] : widget.data[0]['data']['email']),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: Text(
                        widget.data[0]['data']['userName'].substring(0, 1),
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ListTile(
                    
                    leading: Icon(Icons.home,color:Colors.white),
                    title: Text('Home', style: TextStyle(color:Colors.white),),
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                                    ListTile(
                    
                    leading: Icon(Icons.location_pin,color:Colors.white),
                    title: Text('Track locations', style: TextStyle(color:Colors.white),),
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chrome_reader_mode,color:Colors.white),
                    title: Text('Blogs',style: TextStyle(color:Colors.white),),
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.hotel,color: Colors.white),
                    title: Text('Hotels',style: TextStyle(color:Colors.white)),
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.flight,color: Colors.white),
                    title: Text('Flights',style: TextStyle(color:Colors.white)),
                    onTap: () {
                      _onItemTapped(3);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.white,thickness:2),
                  ListTile(
                    leading:
                        Icon(Icons.settings, color:
                        Colors.white),
                    title:
                        Text('Settings', style: TextStyle(color: Colors.white)
                      ),
                    onTap:
                        () {
                           _onItemTapped(4);
                      Navigator.pop(context);
                        },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.logout, color:
                        Colors.white,),
                    title:
                        Text('Logout', style:
                        TextStyle(color: Colors.white)),
                    onTap:
                        () {
         Navigator.pop(context);
    _showLogoutDialog(context);
                        },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class BlogsScreens extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogsScreens> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(2);


    PostsPage? _postsPage;
    @override
  void initState() {
    
    super.initState();

   _currentIndex.addListener(() {
    if (_currentIndex.value == 0) {
  
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditorPage(
          onDiscardPost: () {
        // Actualiza _currentIndex a 2 cuando el usuario elige descartar el post
        _currentIndex.value = 2;
      },
        )),
      );
    }
  });
   _postsPage = PostsPage();
  }



@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Scaffold(
        backgroundColor: Colors.black,
        body: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, child) {
            switch (value) {
              case 0:
                return Container();
              case 1:
                return Center(child: _postsPage);
              case 2:
                return Center(child: Text("GlobalBlog", style: TextStyle(color: Colors.white),));
              default:
                return Container();
            }
          },
        ),
      ),

      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child:   CustomBottomNavigationBar(
          currentIndex:   _currentIndex,
        ) 
      ),
    ],
  );
} 
  

}

class CustomBottomNavigationBar extends StatefulWidget {
   final ValueNotifier<int> currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}


class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
 
  @override
  void initState() {
    super.initState();
    // Escucha los cambios en el valor de currentIndex y actualiza el estado del widget en consecuencia
    widget.currentIndex.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // Deja de escuchar los cambios en el valor de currentIndex cuando el widget se desecha
    widget.currentIndex.removeListener(() => setState(() {}));
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.bottomCenter,
        child: Center(
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.people),
                  onPressed: () {
                    setState(() {
                     widget.currentIndex.value = 1;
                    });
                  },
                  color: widget.currentIndex.value == 1 ? Colors.blue : Colors.grey,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        widget.currentIndex.value = 0;
                      });
                    },
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.public),
                  onPressed: () {
                    setState(() {
                      widget.currentIndex.value = 2;
                    });
                  },
                  color:widget.currentIndex.value == 2 ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
class HomeScreen extends StatelessWidget {
   final List bestPlaces;

  HomeScreen({required this.bestPlaces}); 
  @override
  Widget build(BuildContext context) {
    print(bestPlaces);
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Encuentra tu próximo destino',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.blueGrey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Destinos populares',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                       TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllDestinationsScreen(bestPlaces: bestPlaces),
                            ),
                          );
                        },
                        child: Text(
                          'Ver todos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                   Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {

                            return DestinationCard(
                              imageUrl: bestPlaces[index]['Image'],
                              country: bestPlaces[index]['Country'],
                              title: bestPlaces[index]['City'],
                              reviews: bestPlaces[index]['Reviews'],
                              average_review: bestPlaces[index]['AverageReview'],
                              average_price: bestPlaces[index]['AveragePrice'],
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Ofertas especiales',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          SpecialOfferCard(
                            imageUrl: 'https://media.staticontent.com/media/pictures/ecc404e8-9a99-46b0-a56a-ead992b5166e',
                            title: 'Paquetes de playa',
                            description: 'Hasta 30% de descuento',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'https://wiwatour.com/wp-content/uploads/2021/02/sierra-nevada-de-santa-marta-1.jpg',
                            title: 'Aventuras en la montaña',
                            description: 'Reserva ahora y ahorra',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'https://www.zoegoesplaces.com/wp-content/uploads/2022/06/Comuna-13-Medellin_Cover.jpg',
                            title: 'Escapadas urbanas',
                            description: 'Explora las ciudades',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
enum SortOption { alphabetical, mostVisited, style, leastVisited,highestPrice,lowestPrice }
enum FilterOption { all, country, destinationType, price }
class AllDestinationsScreen extends StatefulWidget {
  final List bestPlaces;

  AllDestinationsScreen({required this.bestPlaces});

  @override
  _AllDestinationsScreenState createState() => _AllDestinationsScreenState();
}

class _AllDestinationsScreenState extends State<AllDestinationsScreen> {
  SortOption _sortOption = SortOption.mostVisited;
  late List countryList;
  late List _sortedBestPlaces;
  final GlobalKey _sortKey = GlobalKey();
  FilterOption _filterOption = FilterOption.all;
  List filterCountry = [];
  final GlobalKey _filterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _sortedBestPlaces = List.from(widget.bestPlaces);
   
    countryList = widget.bestPlaces.map((place) => place['Country']).toSet().toList()..sort();
    print("HOLA: COUNTRYLIST $countryList");
  }

void _sorterBestPlaces() {
  switch (_sortOption) {
    case SortOption.alphabetical:
      setState(() {
        _sortedBestPlaces = _filterOption == FilterOption.country ? List.from(filterCountry) : List.from(widget.bestPlaces);
        _sortedBestPlaces.sort((a, b) => a['City'].compareTo(b['City']));
      });
      break;
    case SortOption.mostVisited:
      setState(() {
        _sortedBestPlaces = _filterOption == FilterOption.country ? List.from(filterCountry) : List.from(widget.bestPlaces);
        _sortedBestPlaces.sort((a, b) => b['Reviews'].compareTo(a['Reviews']));
      });
      break;
    case SortOption.leastVisited:
      setState(() {
        _sortedBestPlaces = _filterOption == FilterOption.country ? List.from(filterCountry) : List.from(widget.bestPlaces);
        _sortedBestPlaces.sort((a, b) => a['Reviews'].compareTo(b['Reviews']));
      });
      break;


    case SortOption.highestPrice:
      setState(() {
        _sortedBestPlaces = _filterOption == FilterOption.country ? List.from(filterCountry) : List.from(widget.bestPlaces);
        _sortedBestPlaces.sort((a, b) => b['AveragePrice'].compareTo(a['AveragePrice']));
      });
      break;

    case SortOption.lowestPrice:
      setState(() {
        _sortedBestPlaces = _filterOption == FilterOption.country ? List.from(filterCountry) : List.from(widget.bestPlaces);
        _sortedBestPlaces.sort((a, b) => a['AveragePrice'].compareTo(b['AveragePrice']));
      });
      break;


    case SortOption.style:
      // No action yet
      break;
  }
}



void _filterBestPlaces() {
  switch (_filterOption) {
    case FilterOption.all:
      setState(() {
        _sortedBestPlaces = List.from(widget.bestPlaces);
      });
      break;
    case FilterOption.country:
      // No action needed here as filtering by country is handled in the _showCountryMenu method
      break;
    case FilterOption.price:
      // No action yet
      break;
    case FilterOption.destinationType:
      // No action yet
      break;
  }
}




  String get sorterText {
    switch (_sortOption) {
      case SortOption.alphabetical:
        return 'Orden alfabético';
      case SortOption.mostVisited:
        return 'Más visitados';
      case SortOption.leastVisited:
        return 'Menos visitados';
      case SortOption.style:
        return 'Más compatibles con tu estilo';
      case SortOption.highestPrice:
        return 'Mayor precio';
       case SortOption.lowestPrice:
        return 'Menor precio';
    }
  }

  String get filterText {
    switch (_filterOption) {
      case FilterOption.all:
        return 'Todos';
      case FilterOption.country:
        return 'Pais';
      case FilterOption.price:
        return 'Precio';
      case FilterOption.destinationType:
        return 'Tipo de destino';
    }
  }



  void _showSorterMenu() {
    final RenderBox renderBox = _sortKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox.size.height,
        position.dx,
        position.dy,
      ),
      items: [
        PopupMenuItem<SortOption>(
          value: SortOption.alphabetical,
          child: Text('Orden alfabético'),
        ),
        PopupMenuItem<SortOption>(
          value: SortOption.mostVisited,
          child: Text('Más visitados'),
        ),
                PopupMenuItem<SortOption>(
          value: SortOption.leastVisited,
          child: Text('Menos visitados'),
        ),
        PopupMenuItem<SortOption>(
          value: SortOption.style,
          child: Text('Más compatibles con tu estilo'),
        ),
                PopupMenuItem<SortOption>(
          value: SortOption.highestPrice,
          child: Text('Mayor precio'),
        ),
                        PopupMenuItem<SortOption>(
          value: SortOption.lowestPrice,
          child: Text('Menor precio'),
        ),
      ],
    ).then((SortOption? result) {
      if (result != null) {
        setState(() {
          _sortOption = result;
        });
        _sorterBestPlaces();
      }
    });
  }

void _showFilterMenu() {
  final RenderBox renderBox = _filterKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height,
      position.dx,
      position.dy,
    ),
    items: [
      PopupMenuItem<FilterOption>(
        value: FilterOption.all,
        child: Text('Todos'),
      ),
      PopupMenuItem<FilterOption>(
        value: FilterOption.country,
        child: Text('País'),
      ),
      PopupMenuItem<FilterOption>(
        value: FilterOption.price,
        child: Text('Precio'),
      ),
      PopupMenuItem<FilterOption>(
        value: FilterOption.destinationType,
        child: Text('Tipo de destino'),
      ),
    ],
  ).then((FilterOption? result) {
    if (result != null) {
      if (result == FilterOption.country) {
        // Show country selection menu
        _showCountryMenu();
      } else {
        setState(() {
          _filterOption = result;
        });
        _filterBestPlaces();
      }
    }
  });
}

void _showCountryMenu() {
  final RenderBox renderBox = _filterKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height,
      position.dx,
      position.dy,
    ),
    items: countryList.map((country) => PopupMenuItem<String>(
          value: country,
          child: Text(country),
        )).toList(),
  ).then((String? result) {
    if (result != null) {
      // Set filter option to country and filter by selected country
      setState(() {
        _filterOption = FilterOption.country;
         filterCountry =  widget.bestPlaces.where((place) => place['Country'] == result).toList();
        _sortedBestPlaces = widget.bestPlaces.where((place) => place['Country'] == result).toList();
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos los destinos populares'),
      ),
      body: Column(
        children:[
Padding(
  padding: const EdgeInsets.all(2),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          IconButton(
            key: _sortKey,
            onPressed: () => _showSorterMenu(),
            icon: Icon(Icons.sort_by_alpha_rounded, color: Colors.white),
          ),
          Text('Ordenar por:', style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
      Text(sorterText, style: TextStyle(fontSize: 16, color: Colors.white)),
    ],
  ),
),
Padding(
  padding: const EdgeInsets.all(2),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          IconButton(
            key: _filterKey,
            onPressed: () => _showFilterMenu(),
            icon: Icon(Icons.tune, color: Colors.white),
          ),
          Text('Filtrar por:', style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
      Text(filterText, style: TextStyle(fontSize: 16, color: Colors.white)),
    ],
  ),
),

          Expanded(child:
            GridView.count(crossAxisCount:
              3,children:
                List.generate(_sortedBestPlaces.length,(index){
                  return GestureDetector(onTap:
                    (){
                      Navigator.push(context,
                        MaterialPageRoute(builder:(context) =>
                          DestinationDetailsScreen(imageUrl:_sortedBestPlaces[index]['Image'],title:_sortedBestPlaces[index]['City'],country:_sortedBestPlaces[index]['Country'],reviews: _sortedBestPlaces[index]['Reviews'], average_review: _sortedBestPlaces[index]['AverageReview'], average_price: _sortedBestPlaces[index]['AveragePrice'],)));
                    },child:
                      Padding(padding:
                        const EdgeInsets.all(5),child:
                          Container(decoration:
                            BoxDecoration(borderRadius:
                              BorderRadius.circular(10),image:
                                DecorationImage(image:
                                  NetworkImage(_sortedBestPlaces[index]['Image']),fit:
                                    BoxFit.cover)),child:
                                      Stack(children:[
                                        Positioned(bottom:
                                          0,left:
                                            0,right:
                                              0,child:
                                                Container(decoration:
                                                  BoxDecoration(color:
                                                    Colors.black.withOpacity(0.7),borderRadius:
                                                      BorderRadius.only(bottomLeft:
                                                        Radius.circular(10),bottomRight:
                                                          Radius.circular(10))),child:
                                                            Padding(padding:
                                                              const EdgeInsets.all(8.0),child:
                                                                Text(_sortedBestPlaces[index]['City'],style:
                                                                  TextStyle(fontSize:
                                                                    16,fontWeight:
                                                                      FontWeight.bold,color:
                                                                        Colors.white))))),
                                      ]))));
                })))
        ]
      ),
    );
  }
}


class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String country;
  final int reviews;
  final double average_review;
  final double average_price;
  DestinationCard({
    required this.imageUrl,
    required this.title,
    required this.country,
    required this.reviews,
    required this.average_review,
    required this.average_price
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetailsScreen(imageUrl: imageUrl, title: title, country: country, reviews: reviews, average_review: average_review, average_price: average_price,),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String country;
  final int reviews;
  final double average_review;
  final double average_price;

  DestinationDetailsScreen({
    required this.imageUrl,
    required this.title,
    required this.country,
    required this.reviews,
    required this.average_review,
    required this.average_price
  });

  @override
  _DestinationDetailsScreenState createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen>
    with SingleTickerProviderStateMixin {
  late PaletteGenerator paletteGenerator;
  bool isPaletteGenerated = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLiked = false;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _updatePaletteGenerator();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.imageUrl),
    );
    setState(() {
      isPaletteGenerated = true;
    });
  }

 void _showBottomSheet(BuildContext context, int reviews) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < widget.average_review.floor()
                          ? Icons.star
                          : (index < widget.average_review
                              ? Icons.star_half
                              : Icons.star_border),
                      color: Colors.yellow[700],
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.average_review.toStringAsFixed(1),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Número de reseñas: $reviews',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Precio aproximado: ${widget.average_price}\$',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  IconButton(
                    icon:
                      Icon(Icons.favorite, color:
                        isLiked ? Colors.red : Colors.grey),
                    onPressed:
                      () => setState(() => isLiked = !isLiked)),
                  IconButton(icon:
                    Icon(Icons.star, color:
                      isFavorited ? Colors.amber : Colors.grey),
                    onPressed:
                      () => setState(() => isFavorited = !isFavorited)),
                  ElevatedButton(onPressed:(){},child:
                    Text('Ver sitio'),style:
                      ElevatedButton.styleFrom(backgroundColor:
                        Colors.grey[700],foregroundColor:
                          Colors.white,shape:
                            RoundedRectangleBorder(borderRadius:
                              BorderRadius.circular(20)),padding:
                                EdgeInsets.symmetric(horizontal:
                                  30,vertical:
                                    15),elevation:
                                      5)),
                  ElevatedButton(onPressed:(){},child:
                    Text('Ver reseñas'),style:
                      ElevatedButton.styleFrom(backgroundColor:
                        Colors.grey[700],foregroundColor:
                          Colors.white,shape:
                            RoundedRectangleBorder(borderRadius:
                              BorderRadius.circular(20)),padding:
                                EdgeInsets.symmetric(horizontal:
                                  30,vertical:
                                    15),elevation:
                                      5))
                ]
              )
            ],
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body:
        isPaletteGenerated
          ? Stack(children:[
              Container(decoration:
                BoxDecoration(gradient:
                  LinearGradient(begin:
                    Alignment.topCenter,end:
                      Alignment.bottomCenter,colors:[
                        paletteGenerator.dominantColor?.color ?? Colors.blue,
                        paletteGenerator.vibrantColor?.color ?? Colors.black])),
              ),
              Center(child:
                Column(mainAxisAlignment:
                  MainAxisAlignment.center,children:[
                    Container(height:
                      300,width:
                        300,decoration:
                          BoxDecoration(borderRadius:
                            BorderRadius.circular(20),image:
                              DecorationImage(image:
                                NetworkImage(widget.imageUrl),fit:
                                  BoxFit.cover))),
                    SizedBox(height:
                      20),
                    Text(widget.title,style:
                      TextStyle(fontSize:
                        30,fontWeight:
                          FontWeight.bold,color:
                            Colors.white)),
                    SizedBox(height:
                      10),
                    Text(widget.country,style:
                      TextStyle(fontSize:
                        20,color:
                          Colors.white)),
                  ])
              ),
              Positioned(bottom :20,right :20,child:FloatingActionButton(onPressed :() =>_showBottomSheet(context, widget.reviews),child :ScaleTransition(scale:_animation,child :Icon(Icons.arrow_upward_rounded, color: Colors.black,)),backgroundColor :Colors.white))
            ])
          : Center(child:CircularProgressIndicator()),
    );
  }
}


class SpecialOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  SpecialOfferCard({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoteles'),
      ),
      body: ListView(
        children: [
          HotelCard(
            image: 'assets/hotel1.jpg',
            name: 'Hotel 1',
            location: 'Ubicación 1',
          ),
          HotelCard(
            image: 'assets/hotel2.jpg',
            name: 'Hotel 2',
            location: 'Ubicación 2',
          ),
          HotelCard(
            image: 'assets/hotel3.jpg',
            name: 'Hotel 3',
            location: 'Ubicación 3',
          ),
          // Agregar más tarjetas de hotel según sea necesario
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;

  const HotelCard({
    Key? key,
    required this.image,
    required this.name,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  location,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estacionamientos'),
      ),
      body: ListView(
        children: [
          ParkingCard(
            image: 'assets/parking1.jpg',
            name: 'Estacionamiento 1',
            location: 'Ubicación 1',
          ),
          ParkingCard(
            image: 'assets/parking2.jpg',
            name: 'Estacionamiento 2',
            location: 'Ubicación 2',
          ),
          ParkingCard(
            image: 'assets/parking3.jpg',
            name: 'Estacionamiento 3',
            location: 'Ubicación 3',
          ),
          // Agregar más tarjetas de estacionamiento según sea necesario
        ],
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;

  const ParkingCard({
    Key? key,
    required this.image,
    required this.name,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  location,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EntertainmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zonas de entretenimiento'),
      ),
      body: ListView(
        children: [
          EntertainmentCard(
            image: 'assets/entertainment1.jpg',
            name: 'Zona de entretenimiento 1',
            location: 'Ubicación 1',
          ),
          EntertainmentCard(
            image: 'assets/entertainment2.jpg',
            name: 'Zona de entretenimiento 2',
            location: 'Ubicación 2',
          ),
          EntertainmentCard(
            image: 'assets/entertainment3.jpg',
            name: 'Zona de entretenimiento 3',
            location: 'Ubicación 3',
          ),
          // Agregar más tarjetas de zonas de entretenimiento según sea necesario
        ],
      ),
    );
  }
}

class EntertainmentCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;

  const EntertainmentCard({
    Key? key,
    required this.image,
    required this.name,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  location,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class TrackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Track Screen', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}


class FlightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Flights Screen', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class  SettingsScreen extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Settings', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Profile Screen', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
