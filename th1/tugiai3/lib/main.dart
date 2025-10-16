import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichText Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RichTextExample(),
    );
  }
}

class RichTextExample extends StatelessWidget {
  const RichTextExample({super.key});

  // Mở email, số điện thoại hoặc link ngoài
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RichText',
          style: TextStyle(
            color: Colors.white, // 👈 đổi màu chữ thành trắng
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng 1
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello ',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'World',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dòng 2 có emoji 👋
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello ',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'World ',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  WidgetSpan(
                    child: Text('👋', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact me via Email
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  const TextSpan(text: 'Contact me via: '),
                  WidgetSpan(
                    child: Icon(Icons.email, color: Colors.blue, size: 20),
                  ),
                  TextSpan(
                    text: ' Email',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl('mailto:example@email.com');
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Call me
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  const TextSpan(
                    text: 'Call Me: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '+1234987654321',
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl('tel:+1234987654321');
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Blog link
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  const TextSpan(text: 'Read My Blog '),
                  TextSpan(
                    text: 'HERE',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl('https://flutter.dev');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
