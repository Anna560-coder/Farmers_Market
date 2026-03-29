import 'package:farmers_1/Views/Role_based_login/User/chatbot/model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';
import 'package:farmers_1/Core/Services/translation_service.dart';
import 'package:farmers_1/Core/Provider/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminichatbotScreen extends ConsumerStatefulWidget {
  const GeminichatbotScreen({super.key});

  @override
  ConsumerState<GeminichatbotScreen> createState() =>
      _GeminichatbotScreenState();
}

class _GeminichatbotScreenState extends ConsumerState<GeminichatbotScreen> {
  TextEditingController promptController = TextEditingController();
  static const apiKey = "AIzaSyBbj1DjiR2lTmVf3rUJlyTj7UP_wHNyCs8";
  final model = GenerativeModel(model: "gemini-2.0-flash", apiKey: apiKey);

  final List<ModelMessage> prompt = [];
  bool _isLoading = false;

  List<String> getFaqQuestions(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);
    return [
      l10n.bestCropsSeason,
      l10n.preventPests,
      l10n.storeMaize,
      l10n.improveSoil,
      l10n.fertilizersVegetables,
      l10n.livestockWinter,
      l10n.plantTomatoes,
      l10n.waterCrops,
    ];
  }

  Future<void> sendMessage([String? predefined]) async {
    final message = predefined ?? promptController.text;

    if (message.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      promptController.clear();
      prompt.add(
        ModelMessage(
          isPrompt: true,
          message: message,
          originalMessage: message,
          time: DateTime.now(),
        ),
      );
    });

    try {
      final currentLanguage = ref.read(languageProvider);

      final englishMessage = await TranslationService.translateToEnglish(
        text: message,
        sourceLanguage: currentLanguage,
      );

      final content = [Content.text(englishMessage)];
      final response = await model.generateContent(content);

      // Get AI response in English
      final englishResponse = response.text ?? 'I couldn\'t understand that.';

      final translatedResponse =
          await TranslationService.translateToAppLanguage(
            text: englishResponse,
            targetLanguage: currentLanguage,
          );

      setState(() {
        prompt.add(
          ModelMessage(
            isPrompt: false,
            message: translatedResponse,
            originalMessage: englishResponse,
            time: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        final l10n = AppLocalizationsHelper.of(context);
        prompt.add(
          ModelMessage(
            isPrompt: false,
            message: l10n.couldNotUnderstand,
            originalMessage: l10n.couldNotUnderstand,
            time: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);
    final faqQuestions = getFaqQuestions(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(
          l10n.aiChatbot,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (prompt.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.mostAskedQuestions,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: faqQuestions.map((q) {
                            return Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () => sendMessage(q),
                                child: Text(
                                  q,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (prompt.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: prompt.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == prompt.length && _isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final message = prompt[index];
                  return chatBubble(
                    isPrompt: message.isPrompt,
                    message: message.message,
                    originalMessage: message.originalMessage,
                    date: DateFormat('hh:mm a').format(message.time),
                  );
                },
              ),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: promptController,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          hintText: l10n.enterQuestion,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        onSubmitted: (_) => sendMessage(),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isLoading ? null : () => sendMessage(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: (_isLoading ? Colors.grey : Colors.green)
                                .shade200,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatBubble({
    required bool isPrompt,
    required String message,
    String? originalMessage,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isPrompt
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isPrompt) const SizedBox(width: 50),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPrompt ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (originalMessage != null && originalMessage != message)
                    Text(
                      originalMessage,
                      style: TextStyle(
                        fontSize: 13,
                        color: isPrompt ? Colors.white70 : Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),

                  if (originalMessage != null && originalMessage != message)
                    const SizedBox(height: 6),

                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPrompt ? Colors.white : Colors.black87,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPrompt ? Colors.white70 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPrompt) const SizedBox(width: 50),
        ],
      ),
    );
  }
}
