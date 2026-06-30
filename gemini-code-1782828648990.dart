// Extrait des changements principaux dans lib/views/chat_screen.dart
// Remplace le corps (body) de ton ancien écran par un StreamBuilder :

@override
Widget build(BuildContext context) {
  final String currentUserId = "user_id_actuel"; // À remplacer par l'ID de l'utilisateur connecté
  final String chatId = "salon_ia_ou_ami_id"; // L'ID unique de la conversation

  return Scaffold(
    backgroundColor: const Color(0xFF121212),
    appBar: AppBar(/* ... même code qu'avant ... */),
    body: Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: _chatService.getMessages(chatId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Une erreur est survenue", style: TextStyle(color: Colors.white)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data ?? [];

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  bool isMe = message.senderId == currentUserId;
                  return _buildMessageBubble(message.text, isMe);
                },
              );
            },
          ),
        ),
        _buildInputArea(),
      ],
    ),
  );
}