
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


import 'Functions/GetPosts.dart';
import 'Functions/Posts/postPagination.dart';




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


void main() async{
  PostList postList = PostList();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print(userId);
  postList.myString = userId.toString();
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

  List<dynamic> _posts = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



    final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BlogsScreens(),
    HotelScreen(),
    FlightScreen(),
    SettingsScreen(),
  ];

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
                 Navigator.push(
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
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.green,
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

void _pickFiles() async {
  // Muestra el visualizador de archivos personalizado
  List<File> selectedFiles = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImagePickerPage(),
    ),
  );

  if (selectedFiles != null) {
    // Aquí puedes procesar los archivos seleccionados
  } else {
    // El usuario canceló la selección de archivos
  }
}

  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
    PostsPage? _postsPage;
    @override
  void initState() {
    
    super.initState();
   _postsPage = PostsPage();
  }



  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body:  ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, value, child) {
              switch (value) {
                case 0:
                  return Center(child:  ElevatedButton(
  onPressed: () {
_pickFiles();
  } ,
  child: Text('Seleccionar archivos'),
));
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
          child: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
          ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Home Screen', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class HotelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Hotels Screen', style: TextStyle(color: Colors.white),),
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
