// lib/views/feed_screen.dart
import 'package:flutter/material.dart';
import 'components/video_post_widget.dart';
import 'chat_screen.dart'; // On importe l'écran de chat pour pouvoir y aller au clic

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

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
      body: Stack(
        children: [
          // 1. Le défilement des vidéos en plein écran
          PageView.builder(
            scrollDirection: Axis.vertical,
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

          // 2. La barre supérieure transparente (Header à la TikTok)
          Positioned(
            top: 50, // Aligné sous l'encoche du téléphone
            left: 20,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Titre ou Logo de ton application
                const Text(
                  "NovaSpace",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                
                // Icône Messenger / Chat à droite
                IconButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded, // Icône épurée style moderne
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    // Animation de transition vers le Chat
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}