
// ================================
// lib/models/news_model.dart - Model Berita
// ================================
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final DateTime createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      author: json['author'],
      publishedAt: DateTime.parse(json['published_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
