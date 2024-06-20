import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  int totalFrames = 0;
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer _seatbeltAudioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isSeatbeltPlaying = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getUserId();
  }

  void _getUserId() {
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User is not logged in');
    }
  }

  void _initializeCamera() {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});

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
    _audioPlayer.dispose();
    _seatbeltAudioPlayer.dispose();
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
        Uri.parse('http://192.168.1.3:5000/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      print('Sending image to API...');

      var response = await request.send().timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var result = json.decode(jsonResponse);

        totalFrames++;

        if (result['drowsy_labels'].contains('closed eyes')) {
          drowsyCount++;
        }

        if (result['distracted_labels'].contains('distracted')) {
          distractedCount++;
        }

        if (result['seatbelt_labels'].contains('noSeatbelt')) {
          seatbeltCount++;
          if (seatbeltCount > 5) {
            _playSeatbeltAlarm();
          }
        } else {
          seatbeltCount = 0;
          _stopSeatbeltAlarm();
        }

        if (drowsyCount > 1 || distractedCount > 3) {
          _playSound();
        } else {
          _stopSound();
        }

        print('Prediction result: $jsonResponse');
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

  void _updateUserPercentages() async {
    if (userId == null) {
      print('User ID is not available');
      return;
    }

    int totalEvents = drowsyCount + seatbeltCount + distractedCount;

    double drowsyPercentage = totalEvents == 0 ? 0 : (drowsyCount / totalEvents) * 100;
    double noSeatBeltPercentage = totalEvents == 0 ? 0 : (seatbeltCount / totalEvents) * 100;
    double distractedPercentage = totalEvents == 0 ? 0 : (distractedCount / totalEvents) * 100;

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'drowsyPercentage': drowsyPercentage,
      'noSeatBeltPercentage': noSeatBeltPercentage,
      'distractedPercentage': distractedPercentage,
    }).catchError((e) {
      print('Failed to update user percentages: $e');
    });
  }

  Future<void> _playSound() async {
    if (!_isPlaying) {
      _isPlaying = true;
      _audioPlayer = AudioPlayer();
      await _audioPlayer.play(AssetSource('drowsy_alarm.mp3'));
      _audioPlayer.onPlayerComplete.listen((event) {
        _isPlaying = false;
      });
    }
  }

  Future<void> _stopSound() async {
    if (_isPlaying) {
      try {
        await _audioPlayer.stop();
      } catch (e) {
        print('Error stopping audio player: $e');
      } finally {
        _audioPlayer.release();
        _isPlaying = false;
      }
    }
  }

  Future<void> _playSeatbeltAlarm() async {
    if (!_isSeatbeltPlaying) {
      _isSeatbeltPlaying = true;
      _seatbeltAudioPlayer = AudioPlayer();
      await _seatbeltAudioPlayer.play(AssetSource('seatbelt_alarm.mp3'));
      _seatbeltAudioPlayer.onPlayerComplete.listen((event) {
        _isSeatbeltPlaying = false;
      });
    }
  }

  Future<void> _stopSeatbeltAlarm() async {
    if (_isSeatbeltPlaying) {
      try {
        await _seatbeltAudioPlayer.stop();
      } catch (e) {
        print('Error stopping seatbelt audio player: $e');
      } finally {
        _seatbeltAudioPlayer.release();
        _isSeatbeltPlaying = false;
      }
    }
  }

  void endJourney() {
    _updateUserPercentages();
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
          ElevatedButton(
            onPressed: endJourney,
            child: Text('End Journey'),
          ),
        ],
      ),
    );
  }
}
