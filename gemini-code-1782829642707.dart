// lib/views/camera_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialisation des capteurs disponibles sur le smartphone
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _initController(_cameras![_selectedCameraIndex]);
    }
  }

  Future<void> _initController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high, // Bonne qualité sans saturer l'espace de stockage
      enableAudio: true,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print("Erreur d'initialisation caméra : $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Gérer l'enregistrement de la vidéo
  void _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isRecording) {
      // Arrêt de l'enregistrement
      XFile videoFile = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      
      // Ici, le fichier `videoFile.path` contient ta vidéo enregistrée.
      // On affiche une petite notification de succès pour le test
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vidéo enregistrée avec succès ! Prête à être publiée.")),
      );
      Navigator.pop(context); // Retour à l'écran précédent
    } else {
      // Lancement de l'enregistrement
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  // Switcher entre la caméra avant et arrière
  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    _initController(_cameras![_selectedCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Le flux de la caméra en plein écran (ajusté aux dimensions du téléphone)
          Transform.scale(
            scale: 1 / (_controller!.value.aspectRatio * MediaQuery.of(context).size.aspectRatio),
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),

          // 2. Bouton Retour (Fermer)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. Bouton Switch Caméra (Tourner l'appareil)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white, size: 30),
              onPressed: _switchCamera,
            ),
          ),

          // 4. Barre d'action en bas (Le gros bouton d'enregistrement)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.white, // Devient rouge quand on enregistre
                      shape: _isRecording ? BoxShape.rectangle : BoxShape.circle, // Devient un carré de stop
                      borderRadius: _isRecording ? BorderRadius.circular(8) : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          if (_isRecording)
            const Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
                    SizedBox(width: 6),
                    Text("ENREGISTREMENT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}