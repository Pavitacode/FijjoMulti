import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
class CameraPreviewWithTap extends StatefulWidget {
  final CameraController controller;

  CameraPreviewWithTap({required this.controller});

  @override
  _CameraPreviewWithTapState createState() => _CameraPreviewWithTapState();
}

class _CameraPreviewWithTapState extends State<CameraPreviewWithTap>
    with SingleTickerProviderStateMixin {
  Offset? tapPosition;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Duración de la animación
    );
    _animation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          tapPosition = details.localPosition;
        });
        // Convierte las coordenadas locales a coordenadas globales
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset globalOffset = box.localToGlobal(tapPosition!);

        // Convierte las coordenadas globales a coordenadas de la cámara
        final double x = globalOffset.dx / box.size.width;
        final double y = globalOffset.dy / box.size.height;

        // Enfoca la cámara en las coordenadas de la cámara
        widget.controller.setExposurePoint(Offset(x, y));
        _animationController.forward(from: 0.0);
        Timer(const Duration(seconds: 2), () { // Duración antes de que desaparezca el círculo
          if (mounted) {
          setState(() {
            tapPosition = null;
          });}
        });
      },
      child: Stack(
        children: [
          Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
          child:
          CameraPreview(widget.controller),),
          if (tapPosition != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => CustomPaint(
                size: Size.infinite,
                painter: TapCirclePainter(tapPosition!, _animation.value),
              ),
            ),
            
        ],
      ),
    );
  }
}

class TapCirclePainter extends CustomPainter {
  final Offset tapPosition;
  final double radius;

  TapCirclePainter(this.tapPosition, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(tapPosition, radius, paint);
    canvas.drawCircle(tapPosition, radius / 2.5, paint..style = PaintingStyle.fill); // Tamaño del círculo pequeño
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
