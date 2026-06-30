// lib/main.dart
import 'dart:ui'; // Indispensable pour l'effet de flou (ImageFilter)
import 'package:flutter/material.dart';
import 'views/feed_screen.dart';
import 'views/chat_screen.dart';

void main() {
  runApp(const SuperApp());
}

class SuperApp extends StatelessWidget {
  const SuperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ChatScreen(),
    const Center(child: Text("Profil", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Stack permet de superposer la barre de navigation au-dessus des écrans
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          
          // La fameuse Barre de navigation en bulle style iOS / Telegram
          Positioned(
            left: 20,
            right: 20,
            bottom: 30, // On la décolle du bas de l'écran pour l'effet flottant
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // Bords très arrondis (style bulle)
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Effet flou translucide iPhone
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Fond semi-transparent
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15), // Fin contour brillant
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home_rounded, 0),
                      _buildNavItem(Icons.chat_bubble_rounded, 1),
                      _buildNavItem(Icons.person_rounded, 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget personnalisé pour chaque bouton de la bulle
  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Si l'onglet est sélectionné, on peut lui mettre un léger fond lumineux
          color: isSelected ? Colors.purpleAccent.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.purpleAccent : Colors.white.withOpacity(0.6),
          size: 28,
        ),
      ),
    );
  }
}