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
      title: '心動小鎮全圖鑑',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'PingFang TC', // 使用繁體中文常用字體
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
  // 魚類與鳥類資料清單
  final List<Map<String, dynamic>> items = [
    {
      "name": "螢光小魚",
      "category": "魚類",
      "obtained": false,
      "imgUrl": "https://cdn-icons-png.flaticon.com/512/2275/2275033.png"
    },
    {
      "name": "藍色小魚",
      "category": "魚類",
      "obtained": false,
      "imgUrl": "https://cdn-icons-png.flaticon.com/512/404/404803.png"
    },
    {
      "name": "藍色小鳥",
      "category": "鳥類",
      "obtained": false,
      "imgUrl": "https://cdn-icons-png.flaticon.com/512/2613/2613143.png"
    },
    {
      "name": "彩色陸龜",
      "category": "魚類",
      "obtained": false,
      "imgUrl": "https://cdn-icons-png.flaticon.com/512/2809/2809774.png"
    },
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF81D4FA), Color(0xFFB3E5FC)],
          ),
        ),
        child: Column(
          children: [
            // 頂部標題列 (已移除左上角箭頭)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  children: [
                    // 這裡原本的 Icon 和 SizedBox 已經被刪除了
                    const Text(
                      '心動小鎮全圖鑑',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2))],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 圖鑑卡片列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE0D5B1), width: 2.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Row(
                      children: [
                        // 左側圖示區
                        Container(
                          width: 85,
                          height: 85,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0E1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              items[index]['imgUrl'],
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                            ),
                          ),
                        ),
                        
                        // 中間文字資訊
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index]['name'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF5D4037),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                items[index]['category'],
                                style: TextStyle(fontSize: 15, color: Colors.brown.withOpacity(0.6), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // 右側勾選框
                        GestureDetector(
                          onTap: () => _toggleObtained(index),
                          child: Container(
                            width: 65,
                            height: 65,
                            margin: const EdgeInsets.only(right: 18),
                            decoration: BoxDecoration(
                              color: items[index]['obtained'] ? const Color(0xFF7CB342) : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE0D5B1), width: 3),
                            ),
                            child: items[index]['obtained']
                                ? const Icon(Icons.check, color: Colors.white, size: 40)
                                : null,
                          ),
                        ),
                      ],
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
