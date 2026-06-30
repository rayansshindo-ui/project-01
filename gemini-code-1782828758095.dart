// lib/views/components/video_post_widget.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPostWidget extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String description;

  const VideoPostWidget({
    Key? key,
    required this.videoUrl,
    required this.username,
    required this.description,
  }) : super(key: key);

  @override
  _VideoPostWidgetState createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialisation de la vidéo à partir d'une URL internet
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true); // Lecture en boucle
        _controller.play(); // Lancement automatique
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Très important pour libérer la mémoire vive
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Le lecteur vidéo plein écran
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
        ),

        // 2. Les informations de la vidéo (Overlay en bas à gauche style TikTok)
        Positioned(
          bottom: 20,
          left: 16,
          right: 80, // On laisse de la place pour les boutons d'interactions à droite
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${widget.username}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // 3. Boutons d'interaction à la X / TikTok (À droite)
        Positioned(
          bottom: 40,
          right: 16,
          child: Column(
            children: [
              _buildActionButton(Icons.favorite, "2.4K"),
              const SizedBox(height: 16),
              _buildActionButton(Icons.comment, "142"),
              const SizedBox(height: 16),
              _buildActionButton(Icons.share, "Partager"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 35),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}