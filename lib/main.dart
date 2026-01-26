import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HeartopiaGuide());
}

class HeartopiaGuide extends StatelessWidget {
  const HeartopiaGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterialDesign: true),
      home: const HomePage(),
    );
  }
}

class Entry {
  final String id; // 用於儲存狀態的唯一 ID
  final String name;
  final String category;
  final String location;
  final String time;
  final String weather;
  bool isCollected;

  Entry({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.time,
    required this.weather,
    this.isCollected = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // 圖鑑原始資料
  List<Entry> entries = [
    // 魚類
    Entry(id: 'f1', name: '歐洲鱸魚', category: '魚類', location: '城郊湖畔', time: '全天', weather: '雨天/彩虹'),
    Entry(id: 'f2', name: '鰲蝦', category: '魚類', location: '溫泉山-火山湖', time: '全天', weather: '任何天氣'),
    Entry(id: 'f3', name: '小斑蜻魚', category: '魚類', location: '河畔', time: '全天', weather: '雨天/彩虹'),
    // 蟲類
    Entry(id: 'b1', name: '棒棒糖飽藏蜻蜓', category: '蟲類', location: '草原湖水邊', time: '全天', weather: '任何天氣'),
    Entry(id: 'b2', name: '蝴蝶酥飽藏蝴蝶', category: '蟲類', location: '風車花田', time: '全天', weather: '任何天氣'),
    Entry(id: 'b3', name: '孔雀蛱蝶', category: '蟲類', location: '漁村花海', time: '06:00-18:00', weather: '微風'),
    // 鳥類
    Entry(id: 'v1', name: '知更鳥', category: '鳥類', location: '中心城區', time: '全天', weather: '任何天氣'),
    Entry(id: 'v2', name: '燕鷗', category: '鳥類', location: '海邊礁石', time: '彩虹限定', weather: '彩虹'),
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // 讀取儲存的勾選紀錄
  _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var entry in entries) {
        entry.isCollected = prefs.getBool(entry.id) ?? false;
      }
    });
  }

  // 儲存勾選紀錄
  _saveProgress(String id, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(id, value);
  }

  @override
  Widget build(BuildContext context) {
    int total = entries.length;
    int collected = entries.where((e) => e.isCollected).length;
    double progress = total > 0 ? collected / total : 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('心動小鎮全圖鑑 📖'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // 1. 進度條區塊
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(value: progress, minHeight: 8),
                      ),
                      const SizedBox(width: 10),
                      Text('${(progress * 100).toInt()}% ($collected/$total)'),
                    ],
                  ),
                ),
                // 2. 地區搜尋框
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '輸入地區搜尋（例：溫泉山、花田）...',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: _searchQuery.isNotEmpty 
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                            setState(() { _searchController.clear(); _searchQuery = ""; });
                          }) 
                        : null,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                // 3. 分類分頁
                const TabBar(
                  tabs: [
                    Tab(text: '魚類'),
                    Tab(text: '蟲類'),
                    Tab(text: '鳥類'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildFilteredList('魚類'),
            _buildFilteredList('蟲類'),
            _buildFilteredList('鳥類'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredList(String category) {
    // 同時過濾：類別 + 地區關鍵字
    final filtered = entries.where((e) {
      bool matchCategory = e.category == category;
      bool matchLocation = e.location.contains(_searchQuery);
      return matchCategory && matchLocation;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('找不到該地區的生物喔！'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          color: item.isCollected ? Colors.teal.shade50 : null,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CheckboxListTile(
            title: Text(item.name, style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: item.isCollected ? TextDecoration.lineThrough : null,
            )),
            subtitle: Text('📍 ${item.location}\n⏰ ${item.time} | ☁️ ${item.weather}'),
            value: item.isCollected,
            onChanged: (bool? value) {
              setState(() {
                item.isCollected = value ?? false;
                _saveProgress(item.id, item.isCollected);
              });
            },
            secondary: CircleAvatar(child: Text(item.name[0])),
          ),
        );
      },
    );
  }
}
