import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

// camera_view_model.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


import '../model/CameraImageModel.dart';

class CameraViewModel with ChangeNotifier {
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  List<CameraImageModel> capturedImages = [];

  CameraViewModel() {
    _initCamera();
  }

  CameraController? get cameraController => _cameraController;

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      notifyListeners();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void takePicture(double latitude, double longitude) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final imagePath = '${appDir.path}/captured_${DateTime.now().millisecondsSinceEpoch}.png';

        // Capture the image and get the image file
        final XFile imageFile = await _cameraController!.takePicture();

        // Save the image to the desired location
        imageFile.saveTo(imagePath).then((savedFile) {
          // `savedFile` is the File object representing the saved image
          final dateTime = DateTime.now();
          capturedImages.add(CameraImageModel(
            imagePath: imagePath,
            latitude: latitude,
            longitude: longitude,
            dateTime: dateTime,
          ));
          notifyListeners();
        }).catchError((error) {
          print('Error saving picture: $error');
        });
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

