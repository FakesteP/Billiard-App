// ================================
// lib/services/news_service.dart - Service Berita
// ================================
import '../models/news_model.dart';

class NewsService {
  static Future<List<NewsModel>> getLatestNews() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Mock data - ganti dengan API call
    return [
      NewsModel(
        id: '1',
        title: 'Tournament Bilyar Nasional 2024',
        content: 'Tournament bilyar terbesar di Indonesia akan segera dimulai bulan depan...',
        imageUrl: 'https://example.com/news1.jpg',
        author: 'Admin',
        publishedAt: DateTime.now().subtract(Duration(days: 1)),
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      NewsModel(
        id: '2',
        title: 'Tips Bermain Bilyar untuk Pemula',
        content: 'Berikut adalah beberapa tips dasar untuk pemain bilyar pemula...',
        imageUrl: 'https://example.com/news2.jpg',
        author: 'Pro Player',
        publishedAt: DateTime.now().subtract(Duration(days: 3)),
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }
}

