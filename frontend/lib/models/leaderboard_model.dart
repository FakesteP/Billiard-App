// ================================
// lib/models/leaderboard_model.dart - Model Leaderboard
// ================================
class LeaderboardModel {
  final String userId;
  final String userName;
  final int totalPoints;
  final int gamesPlayed;
  final int gamesWon;
  final double winRate;
  final int rank;

  LeaderboardModel({
    required this.userId,
    required this.userName,
    required this.totalPoints,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.winRate,
    required this.rank,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userId: json['user_id'],
      userName: json['user_name'],
      totalPoints: json['total_points'],
      gamesPlayed: json['games_played'],
      gamesWon: json['games_won'],
      winRate: json['win_rate'].toDouble(),
      rank: json['rank'],
    );
  }
}
