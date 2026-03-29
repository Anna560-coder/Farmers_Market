import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _queryController = TextEditingController();

  final StabilityAI _ai = StabilityAI();

  //API key for the AI service
  final String apiKey = 'sk-cM2M8aAnSo2vlj0z3jVbLh4IiVCbGCyAjCP7I6Fc7y28Lvay';

  //Set the style for the generated image
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;

  bool isItems = false;

  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatbotScreen),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(l10n.textToImageTitle, style: const TextStyle(fontSize: 30)),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextField(
                controller: _queryController,
                decoration: InputDecoration(
                  hintText: l10n.enterYourQuery,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 15, top: 5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: isItems
                  ? FutureBuilder<Uint8List>(
                      future: _generate(_queryController.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(snapshot.data!),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'No any image generated yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String query = _queryController.text;
                if (query.isNotEmpty) {
                  setState(() {
                    isItems = true;
                  });
                } else {
                  if (kDebugMode) {
                    print('Query is Empty !!');
                  }
                }
              },
              child: Text(l10n.generate),
            ),
          ],
        ),
      ),
    );
  }
}
