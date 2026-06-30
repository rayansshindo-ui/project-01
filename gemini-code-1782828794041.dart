// lib/views/feed_screen.dart
import 'package:flutter/material.dart';
import 'components/video_post_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  // Liste de test (URLs fictives ou réelles de vidéos verticales)
  final List<Map<String, String>> dummyVideos = const [
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-lighting-1234-large.mp4",
      "user": "NovaProduction",
      "desc": "Teaser de notre prochain clip Drill ! Ça sort vendredi 🚀🔥 #drill #music"
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-taking-photos-with-a-smartphone-34354-large.mp4",
      "user": "Rayan_S",
      "desc": "Nouvelle fonctionnalité IA de l'application en cours de dev. Donnez vos avis en comms !"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical, // Défilement du bas vers le haut (TikTok style)
        itemCount: dummyVideos.length,
        itemBuilder: (context, index) {
          final video = dummyVideos[index];
          return VideoPostWidget(
            videoUrl: video["url"]!,
            username: video["user"]!,
            description: video["desc"]!,
          );
        },
      ),
    );
  }
}