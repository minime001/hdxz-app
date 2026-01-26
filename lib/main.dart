import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('HDXZ Guide App')),
        body: const Center(
          child: Text(
            '🎉 恭喜！你的網頁版 App 成功跑起來了！',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

 
