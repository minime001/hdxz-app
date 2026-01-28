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
        useMaterial3: true,
        // 設定全域字體顏色為深咖啡色，模仿遊戲質感
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(618149811)),
          bodyMedium: TextStyle(color: Color(618149811)),
        ),
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
  final List<Map<String, dynamic>> items = [
    {"name": "螢光小魚", "category": "魚類", "obtained": false, "icon": Icons.sailing},
    {"name": "彩虹陸龜", "category": "魚類", "obtained": false, "icon": Icons.waves},
    {"name": "藍色小鳥", "category": "鳥類", "obtained": false, "icon": Icons.flutter_dash},
    {"name": "紫光珊瑚魚", "category": "魚類", "obtained": false, "icon": Icons.water},
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
      // 1. 背景改為淡藍色漸層
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
          ),
        ),
        child: Column(
          children: [
            // 自定義標題列
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '心動小鎮全圖鑑',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 2. 圖鑑列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF7), // 奶油米白色
                      borderRadius: BorderRadius.circular(20), // 大圓角
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFE0D8C3), width: 1), // 淡淡的邊框
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // 左側圖示區域
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EAD6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(items[index]['icon'], color: Colors.blueGrey, size: 30),
                          ),
                          const SizedBox(width: 15),
                          // 中間文字區域
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D4037),
                                  ),
                                ),
                                Text(
                                  items[index]['category'],
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // 右側勾選按鈕 (仿遊戲綠色勾選框)
                          GestureDetector(
                            onTap: () => _toggleObtained(index),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: items[index]['obtained'] ? const Color(0xFF81C784) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE0D8C3), width: 2),
                              ),
                              child: items[index]['obtained']
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
