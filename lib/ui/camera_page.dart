import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:naymat_khaana/BlocApp.dart';
import 'package:naymat_khaana/ui/result_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget{
@override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
  bool _isPermissionGranted = false;
  late final Future<void> _future;

  CameraController? _cameraController;
  final _textRecognizer = TextRecognizer();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
  }

  void _startCamera(){
    if (_cameraController != null){
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera(){
    if (_cameraController != null){
      _cameraController?.dispose();
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async{
    _cameraController = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false
    );
    await _cameraController?.initialize();
    if (!mounted){
      return;
    }
    setState(() {});
  }

  Future<void>  _scanImage() async{

    if (_cameraController == null) return;

    final navigator = Navigator.of(context);
    try{
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      Navigator.pop(context,recognizedText.text);
      // await Navigator.pop(context, recognizedText.text);
      // await navigator.push(
      //     MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text), )
      // );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred when scanning text.')));
    }
  }

  void _initCameraController(List<CameraDescription> cameras){
    if (_cameraController != null)
      return;

    //select the first rear camera
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++){
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back){
        camera = current;
        break;
      }
    }

    if (camera != null){
      _cameraSelected(camera);
    }
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    //TODO: Control camera flow
    if ((_cameraController == null) || (!_cameraController!.value.isInitialized)){
      return;
    }
    if (state == AppLifecycleState.inactive){
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController!= null &&
        _cameraController!.value.isInitialized){
      _startCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }
  // @override
  // Widget build(BuildContext context) {

    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot){
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    _initCameraController(snapshot.data!);
                    return Center(child: CameraPreview(_cameraController!));
                    }
                  else {
                    return const LinearProgressIndicator();
                  }
                  },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('Text recognition sample'),
              ),
              backgroundColor: _isPermissionGranted? Colors.transparent:null,
              body: _isPermissionGranted?
              Column(
                children: [
                  Expanded(
                    child: Container()
                  ),
                  Container(
                    padding:  EdgeInsets.only(bottom: 30.0),
                    child:  Center(
                      child: ElevatedButton(
                        onPressed: _scanImage,
                        child: Text('Scan text')
                      )
                    )
                  ),
                ]
              ):
              Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Text(
                     'Camera permission denied',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )

          ],
        );
      },
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }


