import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Buttons',
      debugShowCheckedModeBanner: false,
      home: const AppButtonsPage(),
    );
  }
}

class AppButtonsPage extends StatelessWidget {
  const AppButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Buttons'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nút primary
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: const RoundedRectangleBorder(), // không bo góc
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "AppButton.primary()",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nút primary disabled
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[100],
                  shape: const RoundedRectangleBorder(), // không bo góc
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "AppButton.primary() - disabled",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nút outlined
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.indigoAccent, width: 1.5),
                  shape: const RoundedRectangleBorder(), // không bo góc
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "AppButton.outlined()",
                  style: TextStyle(color: Colors.indigoAccent, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nút gradient
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigoAccent, Colors.blueGrey],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(), // không bo góc
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "AppButton.gradient()",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nút accentGradient
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.green],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(), // không bo góc
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "AppButton.accentGradient()",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // AppTextButton
            TextButton(
              onPressed: () {},
              child: const Text(
                "AppTextButton()",
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 8),

            // AppTextButton disabled
            TextButton(
              onPressed: null,
              child: const Text(
                "disabled AppTextButton()",
                style: TextStyle(
                    color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
