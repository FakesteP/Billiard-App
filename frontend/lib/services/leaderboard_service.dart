// ================================
// lib/services/leaderboard_service.dart - Service Leaderboard
// ================================
import '../models/leaderboard_model.dart';

class LeaderboardService {
  static Future<List<LeaderboardModel>> getLeaderboard() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Mock data - ganti dengan API call
    return [
      LeaderboardModel(
        userId: '2',
        userName: 'John Doe',
        totalPoints: 150,
        gamesPlayed: 12,
        gamesWon: 8,
        winRate: 66.7,
        rank: 1,
      ),
      LeaderboardModel(
        userId: '3',
        userName: 'Jane Smith',
        totalPoints: 130,
        gamesPlayed: 10,
        gamesWon: 6,
        winRate: 60.0,
        rank: 2,
      ),
      LeaderboardModel(
        userId: '4',
        userName: 'Bob Wilson',
        totalPoints: 95,
        gamesPlayed: 8,
        gamesWon: 4,
        winRate: 50.0,
        rank: 3,
      ),
    ];
  }
}

