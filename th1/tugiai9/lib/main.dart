import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PopMenuListScreen(),
    );
  }
}

class PopMenuListScreen extends StatelessWidget {
  const PopMenuListScreen({super.key});

  final List<String> names = const [
    'Liam',
    'Noah',
    'Oliver',
    'William',
    'Elijah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pop Menu with List'),
        centerTitle: true, // <-- THÊM DÒNG NÀY ĐỂ CĂN GIỮA TIÊU ĐỀ
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          final name = names[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(name),
          );
        },
      ),
    );
  }
}