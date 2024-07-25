import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

class DrawingBoard extends StatefulWidget {
  final String colorSelectionCTA;
  final String saveColorCTA;
  final String userName;
  final String drawingSharedMessage;

  const DrawingBoard({
    super.key,
    required this.colorSelectionCTA,
    required this.saveColorCTA,
    required this.userName,
    required this.drawingSharedMessage,
  });

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final _drawingBoardKey = GlobalKey();
  Color _selectedColor = Colors.white;
  Color _pickerColor = Colors.white;
  double _strokeWidth = 3.0;
  int _strokeCount = 0;
  final _screenShotController = ScreenshotController();

  List<List<DrawingPoints>> drawablePoints = List.empty(growable: true);
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.none;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanEnd: (details) {
            setState(() {
              _strokeCount++;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              drawablePoints[_strokeCount].add(
                DrawingPoints(
                  renderBox.globalToLocal(details.globalPosition),
                  Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = _selectedColor
                    ..strokeWidth = _strokeWidth,
                ),
              );
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              drawablePoints.add(List.empty(growable: true));
              drawablePoints[_strokeCount].add(
                DrawingPoints(
                  renderBox.globalToLocal(details.globalPosition),
                  Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = _selectedColor
                    ..strokeWidth = _strokeWidth,
                ),
              );
            });
          },
          child: Screenshot(
            controller: _screenShotController,
            child: CustomPaint(
              key: _drawingBoardKey,
              size: Size.infinite,
              painter: DrawingPainter(drawablePoints),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.album),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.strokeWidth) {
                                  selectedMode = SelectedMode.none;
                                } else {
                                  selectedMode = SelectedMode.strokeWidth;
                                }
                              });
                            }),
                        IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.color_lens),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.color) {
                                  selectedMode = SelectedMode.none;
                                } else {
                                  selectedMode = SelectedMode.color;
                                }
                              });
                            }),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.undo),
                          onPressed: _strokeCount > 0
                              ? () {
                                  setState(() {
                                    // Undo
                                    selectedMode = SelectedMode.none;
                                    drawablePoints.removeAt(--_strokeCount);
                                  });
                                }
                              : null,
                        ),
                        IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                selectedMode = SelectedMode.none;
                                drawablePoints.clear();
                                _strokeCount = 0;
                              });
                            }),
                        IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              setState(() {
                                selectedMode = SelectedMode.none;
                                _saveDrawing().then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(widget.drawingSharedMessage),
                                    ),
                                  ),
                                );
                              });
                            }),
                      ],
                    ),
                    Visibility(
                      visible: selectedMode != SelectedMode.none,
                      child: (selectedMode == SelectedMode.color)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _getColorList(),
                            )
                          : Slider(
                              value: _strokeWidth,
                              max: 5.0,
                              min: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  _strokeWidth = val;
                                });
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _saveDrawing() async {
    const uuid = Uuid();
    final fileName = "${widget.userName}-${uuid.v4()}.png";
    final byteData = await _screenShotController.capture();
    final pngBytes = byteData!.buffer.asUint8List();
    final storageRef =
        FirebaseStorage.instance.ref("games/guess-dress/$fileName");
    storageRef.child(fileName);
    return storageRef.putData(pngBytes);
  }

  List<Widget> _getColorList() {
    List<Widget> listWidget = List.empty(growable: true);
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text(widget.colorSelectionCTA),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: _pickerColor,
                  onColorChanged: (color) {
                    _pickerColor = color;
                  },
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  child: Text(widget.saveColorCTA),
                  onPressed: () {
                    setState(() => _selectedColor = _pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 2.0),
            color: color,
          ),
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.pointsList);

  List<List<DrawingPoints>> pointsList;

  @override
  void paint(Canvas canvas, Size size) {
    for (var points in pointsList) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(
            points[i].points, points[i + 1].points, points[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints(this.points, this.paint);
}

enum SelectedMode { strokeWidth, color, none }
