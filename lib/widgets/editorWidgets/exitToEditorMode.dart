
import 'dart:async';

import 'package:flutter/material.dart';

class ExitToEditorMode extends StatefulWidget {
  final Completer<List> completer;

  ExitToEditorMode({required this.completer});

  @override
  _ExitToEditorModeState createState() => _ExitToEditorModeState();
}

class _ExitToEditorModeState extends State<ExitToEditorMode> {
  @override
  Widget build(BuildContext context) {
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
                'Salir al modo de edición',
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
            child: Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.delete_outline_rounded),
                      label: Text('Borrar'),
                      style:ElevatedButton.styleFrom(primary:
                        Colors.red,onPrimary:
                        Colors.white,),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon:
                        Icon(Icons.save_alt_rounded),
                      label:
                        Text('Guardar y salir'),
                      style:ElevatedButton.styleFrom(primary:
                        Colors.blue,onPrimary:
                        Colors.white,),
                    ),
                  ],
                ),
                SizedBox(height:
                  20,),
                ElevatedButton.icon(
                  onPressed:
                    (){},
                  icon:
                    Icon(Icons.close_rounded),
                  label:
                    Text('Cancelar'),
                  style:ElevatedButton.styleFrom(primary:
                    Color(0xFF2C2C2E),onPrimary:
                    Colors.white,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
