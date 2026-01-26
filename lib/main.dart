import 'package:flutter/material.dart';

void main() {
  runApp(const HeartopiaGuide());
}

class HeartopiaGuide extends StatelessWidget {
  const HeartopiaGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterialDesign: true,
      ),
      home: const HomePage(),
    );
  }
}

// 定義圖鑑資料格式
class Entry {
  final String name;
  final String category;
  final String location;
  final String time;
  final String weather;
  bool isCollected;

  Entry({
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
  String _searchQuery = "";
  
  // 這裡是你的圖鑑資料清單
  final List<Entry> entries = [
    Entry(name: '歐洲鱸魚', category: '魚類', location: '城郊湖畔', time: '全天', weather: '雨天/彩虹'),
    Entry(name: '鰲蝦', category: '魚類', location: '溫泉山-火山湖', time: '全天', weather: '任何天氣'),
    Entry(name: '小斑蜻魚', category: '魚類', location: '河畔', time: '全天', weather: '雨天/彩虹'),
    Entry(name: '蝴蝶酥飽藏蝴蝶', category: '蟲類', location: '風車花田', time: '全天', weather: '任何天氣'),
    Entry(name: '孔雀蛱蝶', category: '蟲類', location: '漁村花海', time: '06:00-18:00', weather: '微風'),
    Entry(name: '知更鳥', category: '鳥類', location: '中心城區', time: '全天', weather: '任何天氣'),
    Entry(name: '燕鷗', category: '鳥類', location: '海邊礁石', time: '彩虹限定', weather: '彩虹'),
  ];

  @override
  Widget build(BuildContext context) {
    // 計算進度
    int collectedCount = entries.where((e) => e.isCollected).length;
    double progress = entries.isEmpty ? 0 : collectedCount / entries.length;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('心動小鎮圖鑑進度 📖'),
          backgroundColor: Colors.orange.shade100,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                // 1. 進度條
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: LinearProgressIndicator(value: progress, minHeight: 10)),
                      const SizedBox(width: 12),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // 2. 地區搜尋框
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '🔎 輸入地區 (如: 溫泉山、花田)...',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                // 3. 分類分頁
                const TabBar(
                  tabs: [Tab(text: '魚類'), Tab(text: '蟲類'), Tab(text: '鳥類')],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildList('魚類'),
            _buildList('蟲類'),
            _buildList('鳥類'),
          ],
        ),
      ),
    );
  }

  // 建立符合條件的列表
  Widget _buildList(String category) {
    // 同時過濾「類別」與「地區搜尋字串」
    final filtered = entries.where((e) {
      return e.category == category && e.location.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('找不到該地區的生物...'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: item.isCollected ? Colors.orange.shade50 : null,
          child: CheckboxListTile(
            title: Text(item.name, style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: item.isCollected ? TextDecoration.lineThrough : null,
              color: item.isCollected ? Colors.grey : Colors.black,
            )),
            subtitle: Text('📍 ${item.location}\n⏰ ${item.time} | ☁️ ${item.weather}'),
            value: item.isCollected,
            onChanged: (bool? value) {
              setState(() {
                item.isCollected = value ?? false;
              });
            },
            secondary: Icon(
              category == '魚類' ? Icons.phishing : (category == '蟲類' ? Icons.bug_report : Icons.flutter_dash),
              color: item.isCollected ? Colors.grey : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
