
import 'dart:io';

import 'package:fijjo_multiplatform/Functions/IAAssistant.dart';
import 'package:fijjo_multiplatform/signIn.dart';
import 'package:fijjo_multiplatform/signUp.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




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
  
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  List data = [];
  if (userId != null) data =  await getDataUser(userId);
  runApp(userId == null ? Login() : MyApp(data: data,));


}

class MyApp extends StatefulWidget {
  final List data;

  MyApp({Key? key, required this.data}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HotelScreen(),
    FlightScreen(),
    ProfileScreen(),
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
        primarySwatch: Colors.blue,
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
                  icon: Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
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
                        "U",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      _onItemTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.hotel),
                    title: Text('Hotels'),
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.flight),
                    title: Text('Flights'),
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      _onItemTapped(3);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading:
                        Icon(Icons.settings, color:
                        Theme.of(context).textTheme.caption?.color),
                    title:
                        Text('Settings', style:
                        Theme.of(context).textTheme.caption),
                    onTap:
                        () {
                           _onItemTapped(4);
                      Navigator.pop(context);
                        },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.logout, color:
                        Theme.of(context).textTheme.caption?.color),
                    title:
                        Text('Logout', style:
                        Theme.of(context).textTheme.caption),
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


class HomeScreen extends StatelessWidget {
  final List<String> images = [
    'https://www.example.com/image1.jpg',
    'https://www.example.com/image2.jpg',
    'https://www.example.com/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(images[index]);
              },
            ),
          ),
          Text(
            'Welcome to our Travel App!',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Plan your next trip with us',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class HotelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hotels Screen'),
      ),
    );
  }
}

class FlightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Flights Screen'),
      ),
    );
  }
}

class  SettingsScreen extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
