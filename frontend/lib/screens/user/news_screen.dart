import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsList = [
      {
        'title': 'Turnamen Billiard Nasional 2025',
        'content':
            'Turnamen billiard nasional akan diadakan pada bulan Juli 2025 di Jakarta. Segera daftarkan diri Anda!'
      },
      {
        'title': 'Tips Akurasi Break Shot',
        'content':
            'Latihan break shot secara rutin dapat meningkatkan peluang kemenangan Anda di setiap pertandingan.'
      },
      {
        'title': 'Aturan Baru Billiard Dunia',
        'content':
            'Federasi billiard dunia mengumumkan beberapa perubahan aturan untuk musim kompetisi mendatang.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billiard News'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(news['content']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
