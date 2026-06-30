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
  bool _isLandscape = false; // Permet de savoir si c'est un format YouTube

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          // Si le ratio est supérieur à 1.0, la vidéo est plus large que haute (Format Paysage / YouTube)
          _isLandscape = _controller.value.aspectRatio > 1.0;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Fond et Lecteur Vidéo
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
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
        ),

        // 2. Interface conditionnelle (TikTok vs YouTube)
        if (!_isLandscape) ...[
          // --- STYLE TIKTOK (Vidéo Verticale) ---
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
          ),
        ] else ...[
          // --- STYLE YOUTUBE (Vidéo Horizontale) ---
          // Petit macaron indicatif "Format Long"
          Positioned(
            top: 110,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.youtube_searched_for, size: 16, color: Colors.white),
                  SizedBox(width: 5),
                  Text("Format Long", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          
          // Barre de progression de lecture en bas pour les vidéos longues
          Positioned(
            bottom: 110, // Rehaussé pour ne pas chevaucher la bulle de navigation principale
            left: 20,
            right: 20,
            child: Column(
              children: [
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true, // Permet de glisser le doigt pour avancer/reculer la vidéo
                  colors: const VideoProgressColors(
                    playedColor: Colors.purpleAccent,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ],
            ),
          ),
        ],

        // 3. Légende commune (Pseudo + Description) placée en bas de l'écran
        Positioned(
          bottom: _isLandscape ? 130 : 20, // S'ajuste pour laisser de la place à la barre YouTube
          left: 16,
          right: 80,
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