// lib/services/rayan_facts.dart
import 'dart:math';

class RayanFacts {
  static const List<String> _facts = [
    "Rayan chante tellement bien sous la douche qu'il se prend parfois (souvent) pour Beyoncé.",
    "Un jour, Rayan a regardé un clip de Drill à l'envers. Depuis, le producteur lui doit de l'argent.",
    "Rayan n'utilise pas l'IA. C'est l'IA qui vient lui demander des conseils pour percer sur TikTok.",
    "Quand Rayan code sur son iPhone 8+, la batterie se recharge par la seule force de son esprit.",
    "Si Rayan lance un concept sur Nova Production, Mark Zuckerberg prend des notes en scred.",
    "Rayan peut faire une passe décisive à lui-même en faisant le tour de la Terre en moins de 3 secondes.",
    "Beyoncé a une affiche de Rayan qui chante sous la douche dans sa propre salle de bain."
  ];

  // Fonction pour récupérer un fact au hasard
  static String getRandomFact() {
    final random = Random();
    return _facts[random.nextInt(_facts.length)];
  }
}