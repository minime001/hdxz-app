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
      theme: ThemeData(primarySwatch: Colors.orange, useMaterialDesign: true),
      home: const HomePage(),
    );
  }
}

// 1. 定義圖鑑的資料格式
class Entry {
  final String name;
  final String category;
  final String location;
  final String time;
  final String weather;
  final String imageUrl;

  Entry({
    required this.name,
    required this.category,
    required this.location,
    required this.time,
    required this.weather,
    required this.imageUrl,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. 這裡放你的圖鑑資料 (範例)
    final List<Entry> entries = [
      Entry(name: '歐洲鱸魚', category: '魚類', location: '橡木鼻海灘', time: '全天', weather: '任何天氣', imageUrl: 'https://placehold.co/100x100?text=Fish'),
      Entry(name: '大樺斑蝶', category: '蟲類', location: '森林郊區', time: '白天', weather: '晴天', imageUrl: 'https://placehold.co/100x100?text=Bug'),
      Entry(name: '信天翁', category: '鳥類', location: '海邊礁石', time: '清晨', weather: '多雲', imageUrl: 'https://placehold.co/100x100?text=Bird'),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('心動小鎮圖鑑 📖'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.phishing), text: '魚類'),
              Tab(icon: Icon(Icons.bug_report), text: '蟲類'),
              Tab(icon: Icon(Icons.flutter_dash), text: '鳥類'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(entries, '魚類'),
            _buildList(entries, '蟲類'),
            _buildList(entries, '鳥類'),
          ],
        ),
      ),
    );
  }

  // 3. 建立列表的工具
  Widget _buildList(List<Entry> allEntries, String category) {
    final filtered = allEntries.where((e) => e.category == category).toList();
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(item.imageUrl), // 圖片路徑
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('地點：${item.location}\n時間：${item.time}\n天氣：${item.weather}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

