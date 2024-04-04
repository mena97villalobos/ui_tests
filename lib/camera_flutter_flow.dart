// Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    this.width,
    this.height,
    required this.username,
    required this.notificationTitle,
    required this.notificationCTA,
    required this.cameraButtonCTA,
    required this.submitCTA,
    required this.retakeCTA,
    required this.snackbarMessage,
  });

  final double? width;
  final double? height;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
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
    final storageRef = FirebaseStorage.instance.ref("images/$username-${uuid.v4()}.png");
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

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void showNotificationAndroid(String title, String value) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Wedding Invitation',
        channelDescription: 'Wedding Invitation',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notificationId = 1;
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        notificationId, title, value, notificationDetails,
        payload: 'Not present');
  }

  void showNotificationIos(String title, String value) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      presentAlert: true,
      // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge: true,
      // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
      true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    );

    int notificationId = 1;

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        notificationId, title, value, platformChannelSpecifics,
        payload: 'Not present');
  }
}