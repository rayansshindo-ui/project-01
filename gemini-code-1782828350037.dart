// lib/services/ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Remplace par ton URL d'API ou ta clé secrète de manière sécurisée
  final String _apiKey = "TA_CLE_API_ICI";
  final String _apiUrl = "https://api.openai.com/v1/chat/completions"; 

  Future<String> sendMessageToAI(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4o", // Ou le modèle Gemini selon ton choix
          "messages": [
            {
              "role": "system", 
              "content": "Tu es le compagnon IA intégré d'un nouveau réseau social ultra moderne. Tu es cool, dynamique et tu aides l'utilisateur au quotidien."
            },
            {
              "role": "user", 
              "content": userMessage
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Désolé, mon cerveau a buggé... Réessaie ! (Erreur ${response.statusCode})";
      }
    } catch (e) {
      return "Impossible de me connecter au réseau. Vérifie ta connexion.";
    }
  }
}