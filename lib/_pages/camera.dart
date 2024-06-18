import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RealTimeDetection extends StatefulWidget {
  final CameraDescription camera;
  static String routeName = "camera";

  RealTimeDetection({required this.camera});

  @override
  _RealTimeDetectionState createState() => _RealTimeDetectionState();
}

class _RealTimeDetectionState extends State<RealTimeDetection> {
  CameraController? _controller;
  Timer? _timer;
  int drowsyCount = 0;
  int seatbeltCount = 0;
  int distractedCount = 0;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});

      // Start taking pictures every 5 seconds
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _takePictureAndPredict();
      });
    }).catchError((e) {
      print('Error initializing camera: $e');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndPredict() async {
    if (_controller!.value.isTakingPicture) {
      return;
    }

    try {
      final image = await _controller!.takePicture();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.6:5000/predict'), // Use your Flask API URL
      );

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      print('Sending image to API...');

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successful prediction, parse the JSON response
        var jsonResponse = await response.stream.bytesToString();
        var result = json.decode(jsonResponse);

        // Update counts based on the prediction
        if (result['drowsy_labels'].contains('closed eyes')) {
          drowsyCount++;
        }
        if (result['distracted']) {
          distractedCount++;
        }
        if (result['seatbelt']) {
          seatbeltCount++;
        }

        setState(() {
          _result = jsonResponse;
        });

        print('Prediction result: $jsonResponse');
      } else {
        setState(() {
          _result = 'Error: ${response.reasonPhrase}';
        });
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
  }

  void endJourney() {
    // Navigate back to the home page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Detection'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _result,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: endJourney,
            child: Text('End Journey'),
          ),
        ],
      ),
    );
  }
}
