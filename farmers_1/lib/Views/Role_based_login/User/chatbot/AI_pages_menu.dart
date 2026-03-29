import 'package:farmers_1/Views/Role_based_login/User/chatbot/imageChat_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';

// Import your AI pages
import 'chatbot_screen.dart';
import 'geminichatbot_screen.dart';

class AIPagesMenu extends StatelessWidget {
  const AIPagesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);

    final features = [
      {
        "title": l10n.textToImage,
        "subtitle": l10n.generateImageFromText,
        "icon": Icons.image,
        "page": const ChatbotScreen(),
        "color": Colors.blue,
      },
      {
        "title": l10n.aiChatbot,
        "subtitle": l10n.converseWithGemini,
        "icon": Icons.support_agent,
        "page": GeminichatbotScreen(),
        "color": Colors.green,
      },
      {
        "title": l10n.imagePrompt,
        "subtitle": l10n.askAiAboutImages,
        "icon": Icons.photo_library,
        "page": const ImageChat(),
        "color": Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ai Features",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => feature["page"] as Widget),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: (feature["color"] as Color).withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          feature["icon"] as IconData,
                          size: 32,
                          color: feature["color"] as Color,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature["title"] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feature["subtitle"] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
