import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ViewModel/CameraViewModel.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CameraViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Camera App')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(viewModel.cameraController!),
          ),
          Consumer<CameraViewModel>(
            builder: (context, viewModel, child) {
              final lastCapturedImage = viewModel.capturedImages.isNotEmpty
                  ? viewModel.capturedImages.last
                  : null;

              return ListTile(
                title: Text('Longitude: ${lastCapturedImage?.longitude ?? '-'}'),
                subtitle: Text('Latitude: ${lastCapturedImage?.latitude ?? '-'}'),
                trailing: Text(
                  lastCapturedImage?.dateTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(lastCapturedImage!.dateTime)
                      : '-',
                ),
                onTap: () {
                  if (lastCapturedImage != null && lastCapturedImage.latitude != null && lastCapturedImage.longitude != null) {
                    final latitude = lastCapturedImage.latitude;
                    final longitude = lastCapturedImage.longitude;
                    _openInGoogleMaps(latitude, longitude);
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final latitude = 0.0; // Replace with actual latitude value
          final longitude = 0.0; // Replace with actual longitude value
          viewModel.takePicture(latitude, longitude);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  void _openInGoogleMaps(double latitude, double longitude) {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    launch(url);
  }
}
