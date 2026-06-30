// lib/views/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Liste fictive de miniatures pour la grille de vidéos (style TikTok / YouTube)
  final List<String> _dummyGridImages = const [
    "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500", // Studio / Micro
    "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500", // Concert / Light
    "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500", // DJ / Platines
    "https://images.unsplash.com/photo-1516280440614-37939bbacd6a?w=500", // Chanteur
    "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=500", // Abstrait néon
    "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=500", // Clavier / Prod
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110), // Espace pour ne pas être caché par la bulle de navigation
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // 1. Photo de profil & Pseudo
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://via.placeholder.com/150"), // Remplacer par l'avatar de l'user
                backgroundColor: Colors.purpleAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                "Rayan SShindo",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "@rayan_sshindo",
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
              
              const SizedBox(height: 24),

              // 2. Compteurs de Statistiques (Abonnés, Likes...)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem("1.2M", "Abonnés"),
                  _buildStatDivider(),
                  _buildStatItem("148", "Abonnements"),
                  _buildStatDivider(),
                  _buildStatItem("5.4M", "Likes"),
                ],
              ),

              const SizedBox(height: 24),

              // 3. Biographie / Description de l'agence
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Manager de Nova production 🎬\nProducteur & Créateur de contenu. Parfois Beyoncé sous la douche. 👑🎤",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.4),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Bouton d'action "Modifier le profil"
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Modifier le profil", style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              // 5. Onglets de navigation de la grille (Publications / Vidéos Likées)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: const Icon(Icons.grid_on_rounded, color: Colors.white), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.favorite_border_rounded, color: Colors.grey), onPressed: () {}),
                ],
              ),
              const Divider(color: Color(0xFF1F1F1F), height: 1),

              // 6. Grille des publications (Mélange TikTok / Insta / YouTube Grid)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Laissé au SingleChildScrollView parent
                itemCount: _dummyGridImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 colonnes comme sur Insta/TikTok
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.75, // Format vertical allongé pour les miniatures vidéo
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      image: DecorationImage(
                        image: NetworkImage(_dummyGridImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: const [
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 2),
                              Text("12.5K", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper pour construire un bloc de statistique
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // Petit séparateur vertical entre les stats
  Widget _buildStatDivider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}