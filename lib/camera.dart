import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_tests/local_notifications_service.dart';
import 'package:uuid/uuid.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void initNotifications() async {
    final notifications = LocalNotificationService();
    await notifications.init();
    if (Platform.isAndroid) {
      notifications.showNotificationAndroid("B&G Wedding", "Take a picture!");
    } else if (Platform.isIOS) {
      notifications.showNotificationIos("B&G Wedding", "Take a picture!");
    }
  }

  Future _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.max);
    return await _controller.initialize();
  }

  @override
  void initState() {
    initNotifications();
    _initializeControllerFuture = _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FloatingActionButton.extended(
                    label: const Text("Take it!"),
                    onPressed: () async {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();

                      if (!context.mounted) return;
                      await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            image: image,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final XFile image;

  const DisplayPictureScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: _getImage(image.path),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _saveImage(image)
                        .then(
                          (_) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Thank you for sharing this moment with us!'),
                        ),
                      ),
                    )
                        .then((value) => Navigator.of(context).pop());
                  },
                  label: const Text('I Like it!'),
                  icon: const Icon(Icons.check),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text('Let\'s Retake it!'),
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<UploadTask> _saveImage(XFile image) async {
    var uuid = const Uuid();
    final storageRef = FirebaseStorage.instance.ref("images/${uuid.v4()}.png");
    storageRef.child(image.name);
    if (kIsWeb) {
      return image.readAsBytes().then((value) => storageRef.putData(value));
    } else {
      return storageRef.putFile(File(image.path));
    }
  }

  Image _getImage(String path) {
    if (kIsWeb) {
      return Image.network(path);
    } else {
      return Image.file(File(path));
    }
  }
}