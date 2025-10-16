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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RichTextExample(),
    );
  }
}

class RichTextExample extends StatefulWidget {
  const RichTextExample({super.key});

  @override
  State<RichTextExample> createState() => _RichTextExampleState();
}

class _RichTextExampleState extends State<RichTextExample> {
  bool isExpanded = true;

  // Hàm mở link (web, mail, call)
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Rich Text Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  const TextSpan(
                    text:
                    "Flutter is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. First described in 2015, ",
                  ),
                  const TextSpan(
                    text: "Flutter",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: " was released in May 2017.\n\nContact on ",
                  ),
                  TextSpan(
                    text: "+910000210056",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl("tel:+910000210056");
                      },
                  ),
                  const TextSpan(text: ". Our email address is "),
                  TextSpan(
                    text: "test@examplemail.org",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl("mailto:test@examplemail.org");
                      },
                  ),
                  const TextSpan(text: ".\nFor more details check "),
                  TextSpan(
                    text: "https://www.google.com",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl("https://www.google.com");
                      },
                  ),
                  const TextSpan(text: "\n\n"),
                  TextSpan(
                    text: isExpanded ? "Read less" : "Read more",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
