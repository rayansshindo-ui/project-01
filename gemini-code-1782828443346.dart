// lib/views/chat_screen.dart

import 'package:flutter/material.dart';
import '../services/ai_service.dart'; // On importe le service IA codé juste avant

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = []; // Liste locale pour stocker les messages
  final TextEditingController _textController = TextEditingController();
  final AIService _aiService = AIService();
  bool _isTyping = false; // Pour afficher un indicateur quand l'IA réfléchit

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    String userText = _textController.text.trim();
    _textController.clear();

    // 1. Ajouter le message de l'utilisateur à l'écran
    setState(() {
      _messages.insert(0, {"text": userText, "isMe": true});
      _isTyping = true;
    });

    // 2. Envoyer le message à l'IA et attendre la réponse
    String aiResponse = await _aiService.sendMessageToAI(userText);

    // 3. Ajouter la réponse de l'IA à l'écran
    setState(() {
      _messages.insert(0, {"text": aiResponse, "isMe": false});
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fond sombre style moderne / TikTok
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              child: const Icon(Icons.bolt, color: Colors.white), // Icône du compagnon IA
            ),
            const SizedBox(width: 12),
            const Text(
              "Compagnon IA",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Zone d'affichage des messages
          Expanded(
            child: ListView.builder(
              reverse: true, // Pour commencer le scroll par le bas comme WhatsApp
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message['text'], message['isMe']);
              },
            ),
          ),
          
          // Indicateur visuel pendant que l'IA écrit
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("L'IA est en train d'écrire...", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),

          // Barre d'outils de saisie (input)
          _buildInputArea(),
        ],
      ),
    );
  }

  // Widget pour générer les bulles de discussion
  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF007AFF) : const Color(0xFF2C2C2E), // Bleu iOS pour l'user, Gris pour l'IA
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Widget pour le champ de texte et le bouton d'envoi
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF1F1F1F),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Discute avec l'IA ou tes amis...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton