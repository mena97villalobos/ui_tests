import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_tests/local_notifications_service.dart';
import 'package:uuid/uuid.dart';

class TakePictureScreen extends StatefulWidget {
  final String username;
  final String notificationTitle;
  final String notificationCTA;
  final String cameraButtonCTA;
  final String submitCTA;
  final String retakeCTA;
  final String snackbarMessage;

  const TakePictureScreen({
    super.key,
    required this.username,
    required this.notificationTitle,
    required this.notificationCTA,
    required this.cameraButtonCTA,
    required this.submitCTA,
    required this.retakeCTA,
    required this.snackbarMessage,
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
      notifications.showNotificationAndroid(
        widget.notificationTitle,
        widget.notificationCTA,
      );
    } else if (Platform.isIOS) {
      notifications.showNotificationIos(
        widget.notificationTitle,
        widget.notificationCTA,
      );
    }
  }

  Future _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => cameras.first),
        ResolutionPreset.max,
    );
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
                    label: Text(widget.cameraButtonCTA),
                    onPressed: () async {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();

                      if (!context.mounted) return;
                      await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            submitCTA: widget.submitCTA,
                            retakeCTA: widget.retakeCTA,
                            snackbarMessage: widget.snackbarMessage,
                            username: widget.username,
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
  final String submitCTA;
  final String retakeCTA;
  final String snackbarMessage;
  final String username;
  final XFile image;

  const DisplayPictureScreen({
    super.key,
    required this.image,
    required this.submitCTA,
    required this.retakeCTA,
    required this.snackbarMessage,
    required this.username,
  });

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
                            SnackBar(content: Text(snackbarMessage)),
                          ),
                        )
                        .then((value) => Navigator.of(context).pop());
                  },
                  label: Text(submitCTA),
                  icon: const Icon(Icons.check),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text(retakeCTA),
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
    final storageRef =
        FirebaseStorage.instance.ref("images/$username-${uuid.v4()}.png");
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
