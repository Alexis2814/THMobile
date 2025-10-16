import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Course UI',
      debugShowCheckedModeBanner: false,
      home: const FlutterCoursePage(),
    );
  }
}

class FlutterCoursePage extends StatefulWidget {
  const FlutterCoursePage({super.key});

  @override
  State<FlutterCoursePage> createState() => _FlutterCoursePageState();
}

class _FlutterCoursePageState extends State<FlutterCoursePage> {
  bool showVideos = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Flutter",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh khóa học (background)
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/images/images.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Flutter Complete Course",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),

            const Text(
              "Created by Dear Programmer",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600, // ✅ chữ đậm hơn
              ),
            ),
            const SizedBox(height: 2),

            const Text(
              "55 Videos",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600, // ✅ chữ đậm hơn
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showVideos = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      showVideos ? Colors.purple : Colors.purple[100],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Videos",
                      style: TextStyle(
                        color: showVideos ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showVideos = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      !showVideos ? Colors.purple : Colors.purple[100],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: !showVideos ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
              showVideos ? const VideosList() : const DescriptionSection(),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------
// Tab: Videos
// -----------------------------
class VideosList extends StatelessWidget {
  const VideosList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("videos"),
      children: const [
        VideoItem(
          title: "Introduction to Flutter",
          duration: "20 min 50 sec",
          highlight: true, // ✅ video đặc biệt
        ),
        VideoItem(
          title: "Installing Flutter on Windows",
          duration: "20 min 50 sec",
        ),
        VideoItem(
          title: "Setup Emulator on Windows",
          duration: "20 min 50 sec",
        ),
        VideoItem(
          title: "Creating Our First App",
          duration: "20 min 50 sec",
        ),
      ],
    );
  }
}

// -----------------------------
// Tab: Description
// -----------------------------
class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey("description"),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "This Flutter Complete Course is designed for both beginners and experienced developers. "
            "You will learn how to build cross-platform apps using Flutter framework with hands-on projects "
            "and real-world examples. Topics include widgets, state management, API integration, "
            "and UI design best practices.",
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
      ),
    );
  }
}

// -----------------------------
// Widget hiển thị từng video
// -----------------------------
class VideoItem extends StatelessWidget {
  final String title;
  final String duration;
  final bool highlight;

  const VideoItem({
    super.key,
    required this.title,
    required this.duration,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: highlight ? Colors.purple[300] : Colors.purple[100],
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.play_arrow,
              color: highlight ? Colors.white : Colors.purple,
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: highlight ? 17 : 16,
                    fontWeight:
                    highlight ? FontWeight.bold : FontWeight.w600,
                    color: Colors.black, // ✅ tất cả đều màu đen
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600, // ✅ đậm hơn
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
