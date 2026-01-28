import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HdxzGuideApp());
}

class HdxzGuideApp extends StatelessWidget {
  const HdxzGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心動小鎮圖鑑',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 你可以在這裡繼續增加魚類或鳥類的資料
  final List<Map<String, dynamic>> items = [
    {"name": "螢光小魚", "category": "魚類", "obtained": false},
    {"name": "彩虹陸龜", "category": "魚類", "obtained": false},
    {"name": "藍色小鳥", "category": "鳥類", "obtained": false},
    {"name": "紫光珊瑚魚", "category": "魚類", "obtained": false},
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var item in items) {
        item['obtained'] = prefs.getBool(item['name']) ?? false;
      }
    });
  }

  Future<void> _toggleObtained(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      items[index]['obtained'] = !items[index]['obtained'];
      prefs.setBool(items[index]['name'], items[index]['obtained']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('心動小鎮全圖鑑'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(items[index]['category']),
            trailing: Checkbox(
              value: items[index]['obtained'],
              onChanged: (_) => _toggleObtained(index),
            ),
          );
        },
      ),
    );
  }
}
