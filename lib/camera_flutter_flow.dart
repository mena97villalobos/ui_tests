import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'flutter_flow/flutter_flow_theme.dart';

class TakePictureScreen extends StatefulWidget {
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
  final String username;
  final String notificationTitle;
  final String notificationCTA;
  final String cameraButtonCTA;
  final String submitCTA;
  final String retakeCTA;
  final String snackbarMessage;

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
                CustomCameraPreview(_controller),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton.extended(
                  backgroundColor: Colors.amber,
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
        return Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).primary,));
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
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
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
                    label: Text(submitCTA, style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Mirage',
                      letterSpacing: 0,
                      useGoogleFonts: false,
                      color: FlutterFlowTheme.of(context).primary,
                    ),),
                    icon: const Icon(Icons.check),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      iconColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Text(retakeCTA, style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Mirage',
                      letterSpacing: 0,
                      useGoogleFonts: false,
                      color: FlutterFlowTheme.of(context).primary,
                    ),),
                    icon: const Icon(Icons.cancel_outlined),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      iconColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ],
              )
            ],
          ),
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

class CustomCameraPreview extends StatelessWidget {
  /// Creates a preview widget for the given camera controller.
  const CustomCameraPreview(this.controller, {super.key});

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return controller.value.isInitialized
        ? ValueListenableBuilder<CameraValue>(
      valueListenable: controller,
      builder: (BuildContext context, Object? value, Widget? child) {
        return Center(
          child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.8,
              child: AspectRatio(
                aspectRatio: _isLandscape()
                    ? controller.value.aspectRatio
                    : (1 / controller.value.aspectRatio),
                child: controller.buildPreview(),
              )),
        );
      },
    )
        : Container();
  }

  bool _isLandscape() {
    return <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ].contains(_getApplicableOrientation());
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.previewPauseOrientation ??
        controller.value.lockedCaptureOrientation ??
        controller.value.deviceOrientation);
  }
}