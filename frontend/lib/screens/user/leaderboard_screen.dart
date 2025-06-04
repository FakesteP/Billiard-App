// ================================
// lib/screens/user/leaderboard_screen.dart - Leaderboard Top Players
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/user_model.dart';
import '../../services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<UserModel> topPlayers = [];
  bool isLoading = true;
  String selectedPeriod = 'all_time'; // all_time, monthly, weekly

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  _loadLeaderboard() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final players = await LeaderboardService.getLeaderboard();
      setState(() {
        topPlayers = players;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading leaderboard: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Period Filter
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Periode:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedPeriod = value;
                        });
                        _loadLeaderboard();
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'all_time',
                        child: Text('Sepanjang Masa'),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text('Bulan Ini'),
                      ),
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text('Minggu Ini'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Leaderboard Content
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : topPlayers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada data leaderboard',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _loadLeaderboard(),
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: topPlayers.length,
                          itemBuilder: (context, index) {
                            final player = topPlayers[index];
                            final rank = index + 1;
                            return _buildLeaderboardCard(player, rank);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(UserModel player, int rank) {
    Color rankColor;
    IconData rankIcon;
    
    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = Icons.looks_one;
        break;
      case 2:
        rankColor = Colors.grey[400]!;
        rankIcon = Icons.looks_two;
        break;
      case 3:
        rankColor = Colors.brown;
        rankIcon = Icons.looks_3;
        break;
      default:
        rankColor = Colors.grey[600]!;
        rankIcon = Icons.person;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: rank <= 3 ? 4 : 2,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: rank <= 3 ? BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              rankColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ) : null,
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: rank <= 3 
                ? Icon(
                    rankIcon,
                    color: rankColor,
                    size: 24,
                  )
                : Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: rankColor,
                      ),
                    ),
                  ),
            ),
            SizedBox(width: 16),
            
            // Player Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
            SizedBox(width: 16),
            
            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.sports_esports,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${player.gamesPlayed ?? 0} games',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score/Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${player.totalScore ?? 0}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                Text(
                  'points',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            // Trophy for top 3
            if (rank <= 3) ...[
              SizedBox(width: 8),
              Icon(
                Icons.emoji_events,
                color: rankColor,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}