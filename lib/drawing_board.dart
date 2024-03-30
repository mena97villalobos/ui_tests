import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawWidget extends StatefulWidget {
  const DrawWidget({super.key});

  @override
  DrawState createState() => DrawState();
}

class DrawState extends State<DrawWidget> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  int strokeCount = 0;
  int testVal = 0;
  List<List<DrawingPoints>> drawablePoints = List.empty(growable: true);
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.none;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text("Guess the Wedding Dress!"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              selectedMode = SelectedMode.none;
                              drawablePoints.clear();
                              strokeCount = 0;
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
                            value: strokeWidth,
                            max: 5.0,
                            min: 0.0,
                            onChanged: (val) {
                              setState(() {
                                strokeWidth = val;
                              });
                            }),
                  ),
                ],
              ),
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/common/dress_template.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: GestureDetector(
          onPanEnd: (details) {
            setState(() {
              strokeCount++;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              testVal++;
              drawablePoints[strokeCount].add(
                DrawingPoints(
                  renderBox.globalToLocal(details.globalPosition),
                  Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor
                    ..strokeWidth = strokeWidth,
                ),
              );
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              drawablePoints.add(List.empty(growable: true));
              drawablePoints[strokeCount].add(
                DrawingPoints(
                  renderBox.globalToLocal(details.globalPosition),
                  Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor
                    ..strokeWidth = strokeWidth,
                ),
              );
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(drawablePoints),
          ),
        ),
      ),
    );
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
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() => selectedColor = pickerColor);
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
          selectedColor = color;
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
