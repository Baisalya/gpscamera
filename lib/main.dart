import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'View/CameraScreen.dart';
import 'ViewModel/CameraViewModel.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CameraViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CameraScreen(),
      ),
    );
  }
}

