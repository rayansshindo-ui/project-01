// lib/main.dart (Mise à jour avec l'Easter Egg)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'views/feed_screen.dart';
import 'views/chat_screen.dart';
import 'services/rayan_facts.dart'; // On importe tes anecdotes !

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  String _currentFact = RayanFacts.getRandomFact(); // Premier fact au démarrage

  final List<Widget> _screens = [
    const FeedScreen(),
    const ChatScreen(),
    const Center(child: Text("Profil", style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentFact = RayanFacts.getRandomFact(); // On change de phrase WTF à chaque clic !
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Écrans principaux
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          // L'EASTER EGG : Le bandeau de punchlines tout en haut de l'application
          Positioned(
            top: 50, // Juste en dessous de la caméra / encoche de l'iPhone
            left: 20,
            right: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300), // Effet de transition fluide
              child: Container(
                key: ValueKey<String>(_currentFact),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purpleAccent.withOpacity(0.4), width: 1),
                ),
                child: Row(
                  children: [
                    const Text("💡 ", style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(
                        _currentFact,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Barre de navigation en bulle (inchangée mais connectée)
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
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

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index), // Appelle la nouvelle fonction qui rafraîchit le fact
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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