import 'dart:async';

import 'package:flutter/material.dart';


class TemporizerWidget extends StatefulWidget {
  final int time;
  final VoidCallback onFinish;

  const TemporizerWidget({Key? key, required this.time, required this.onFinish})
      : super(key: key);

  @override
  _TemporizerWidgetState createState() => _TemporizerWidgetState();
}
class _TemporizerWidgetState extends State<TemporizerWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _timeLeft = 0;
  late AnimationController _animationController;
  late Animation<double> _fontSizeAnimation;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _animationController.forward(from: 0);
        } else {
          _timer.cancel();
          widget.onFinish();
        }
      });
    });

    // Inicializa el AnimationController y la animación
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fontSizeAnimation = Tween<double>(begin: 100, end: 120).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _fontSizeAnimation,
        builder: (context, child) {
          return Text(
            '$_timeLeft',
            style: TextStyle(fontSize: _fontSizeAnimation.value, color: Colors.white),
          );
        },
      ),
    );
  }
}



class ShowTemporizador extends StatefulWidget {

final Completer<List> completer;

ShowTemporizador({required this.completer});


  @override
  _ShowTemporizadorState createState() => _ShowTemporizadorState();
}

class _ShowTemporizadorState extends State<ShowTemporizador> {
  double _currentSliderValue = 0;
  int _selectedButtonIndex = 0;
  int temporizerTime = 0;
  bool isTemporizer = false;

  @override
  Widget build(BuildContext context) {
    double sliderWidth = MediaQuery.of(context).size.width - 48;
    double textPosition = (_currentSliderValue / 180) * sliderWidth;
    textPosition = textPosition < 0 ? 0 : textPosition;
    textPosition = textPosition > sliderWidth ? sliderWidth : textPosition;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
     
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 50),
              Text(
                'Temporizador',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 1;
                      temporizerTime =  3;
                    });
                  },
                  child: Text('3s'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        _selectedButtonIndex == 1 ? Colors.blue : Color(0xFF2C2C2E),
                    onPrimary: Colors.white,
                  ),
                ),
              
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 2;
                      temporizerTime = 10;
                    });
                  },
                  child: Text('10s'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        _selectedButtonIndex == 2 ? Colors.blue : Color(0xFF2C2C2E),
                    onPrimary: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 3;
                      temporizerTime = 20;
                    });
                  },
                  child: Text('20s'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        _selectedButtonIndex == 3 ? Colors.blue : Color(0xFF2C2C2E),
                    onPrimary: Colors.white,
                  ),
                )
,],),),
 SizedBox(height: 20),
Padding(padding:
EdgeInsets.symmetric(horizontal:
16),child:
      Text('Arrastra el control deslizante para modificar cuando se detiene la grabación',style:
      TextStyle(color:
      Colors.white),),),
      
  SizedBox(height: 20,),
Stack(
  alignment: Alignment.centerLeft,

  children: [
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue,
        inactiveTrackColor:
            Colors.blue.withOpacity(0.24), // Cambia el color a azul con opacidad

        thumbColor:
            Colors.blue, // Cambia el color del icono del slider a azul
      ),
      child: Slider(
        value:_currentSliderValue,min:
    0.0,max:
    180,divisions:
    180,onChanged:(double value){
    setState((){_currentSliderValue=value;});
    },),),Positioned(
  left: textPosition + 10,
  bottom: 35,
  child: 
 Text(
      '${_currentSliderValue.round()}s',
      style: TextStyle(color: Colors.white),
    ),
  ),

],),
 // Agrega un espaciado de 20 píxeles
ElevatedButton(
  onPressed: () {
    isTemporizer =true;
  widget.completer.complete([temporizerTime, _currentSliderValue.toInt(), isTemporizer]);
  Navigator.pop(context);
  },
  child: Text('Iniciar'),
  style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
  ),
),
      ],),);}}