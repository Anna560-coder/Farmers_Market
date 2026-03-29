import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageChat extends StatefulWidget {
  const ImageChat({super.key});

  @override
  State<ImageChat> createState() => _ImageChatState();
}

class _ImageChatState extends State<ImageChat> {
  PlatformFile? pickedImage;
  String responseImage = '';

  bool isLoading = false;

  final promptController = TextEditingController();

  //Replace your "YOUR_API_KEY" with your actual API key
  final apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyAj-7YslyYA97MCABTbgjyGyqX03R_DYgI";

  //Picks an image file from the device using file picker
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
      });
    }
  }

  Future<void> generateResponse() async {
    if (pickedImage == null || pickedImage!.bytes == null) return;

    setState(() {
      isLoading = true;
      responseImage = '';
      promptController.clear();
    });

    try {
      //Create a request payload
      final requestPayload = {
        "contents": [
          {
            "parts": [
              {"text": promptController.text},
              {
                "inlineData": {
                  "mimeType": pickedImage!.extension == 'png'
                      ? "image/png"
                      : "image/jpeg",
                  "data": base64.encode(pickedImage!.bytes!),
                },
              },
            ],
          },
        ],
      };

      //Send a post request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        responseImage =
            result['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            'No Text Found';
      } else {
        responseImage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      responseImage = 'Error: ${e.toString()}';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Chat Bot',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: pickedImage == null
                  ? Container(
                      height: 340,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Select an Image',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.memory(
                            pickedImage!.bytes!,
                            height: 340,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: pickImage,
                          child: Text(
                            'Select New Image',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: promptController,
              decoration: InputDecoration(
                hintText: 'Enter your prompt',
                prefixIcon: const Icon(Icons.pending, color: Colors.black),
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: generateResponse,
              child: Text(
                'Generate Answer',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 30),

            isLoading
                ? Center(child: CircularProgressIndicator())
                : Text(
                    responseImage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
