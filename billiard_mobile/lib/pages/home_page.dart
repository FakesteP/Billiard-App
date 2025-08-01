import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../services/statistics_service.dart';
import 'table_list_page.dart';
import 'booking_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation; // Statistics data
  Map<String, dynamic>? _dashboardStats;
  Map<String, dynamic>? _userStats;
  Map<String, dynamic>? _tablesStats;
  bool _isLoadingStats = true;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    // Load statistics data
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      setState(() {
        _isLoadingStats = true;
      });

      // Initialize with default values
      Map<String, dynamic> dashboardStats = {
        'availableTables': 0,
        'totalTables': 0,
        'todayBookings': 0,
        'activeBookings': 0,
      };
      Map<String, dynamic> tablesStats = {
        'availableTables': 0,
        'totalTables': 0,
      };
      Map<String, dynamic>? userStats;

      // Try to load dashboard stats (public)
      try {
        final result = await StatisticsService.getDashboardStats();
        if (result != null) {
          dashboardStats = result;
        }
      } catch (e) {
        print('Error loading dashboard stats: $e');
      }

      // Try to load tables stats (public)
      try {
        final result = await StatisticsService.getAvailableTablesStats();
        if (result != null) {
          tablesStats = result;
        }
      } catch (e) {
        print('Error loading tables stats: $e');
      }

      // Load user stats (protected) - only if user is logged in
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isLoggedIn) {
        try {
          userStats = await StatisticsService.getUserStats();
        } catch (e) {
          print('Error loading user stats: $e');
          // Set default user stats if loading fails
          userStats = {
            'totalBookings': 0,
            'totalHours': 0,
            'completedBookings': 0,
          };
        }
      } else {
        // Set default user stats for non-logged in users
        userStats = {
          'totalBookings': 0,
          'totalHours': 0,
          'completedBookings': 0,
        };
      }

      if (mounted) {
        setState(() {
          _dashboardStats = dashboardStats;
          _tablesStats = tablesStats;
          _userStats = userStats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      print('Error loading statistics: $e');
      if (mounted) {
        setState(() {
          // Set fallback data
          _dashboardStats = {
            'availableTables': 0,
            'totalTables': 0,
            'todayBookings': 0,
            'activeBookings': 0,
          };
          _tablesStats = {
            'availableTables': 0,
            'totalTables': 0,
          };
          _userStats = {
            'totalBookings': 0,
            'totalHours': 0,
            'completedBookings': 0,
          };
          _isLoadingStats = false;
        });

        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to load statistics. Using offline mode.'),
            backgroundColor: AppTheme.warningColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final role = authProvider.role;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withOpacity(0.9),
              AppTheme.surfaceColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: RefreshIndicator(
                    onRefresh: _loadStatistics,
                    color: AppTheme.primaryColor,
                    backgroundColor: AppTheme.cardColor,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Enhanced Header with welcome message
                          _buildEnhancedHeader(authProvider),

                          // Quick Stats Cards
                          _buildQuickStats(role), // Main Navigation Section
                          _buildMainNavigation(context, role),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor.withOpacity(0.9),
            AppTheme.surfaceColor.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.accentColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_bar,
                        color: AppTheme.textPrimary,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Billiard Club',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, ${authProvider.username ?? "User"}! 👋',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.errorColor,
                  ),
                  onPressed: () {
                    _showLogoutDialog(authProvider);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.2),
                  AppTheme.accentColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  authProvider.role == 'admin'
                      ? Icons.admin_panel_settings
                      : Icons.person,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  authProvider.role == 'admin'
                      ? '👑 Admin Dashboard'
                      : '🎯 Customer Portal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(String? role) {
    if (_isLoadingStats) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildLoadingStatCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingStatCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingStatCard()),
          ],
        ),
      );
    }

    // Get statistics values based on role and available data with safe null checks
    String availableTablesValue = '0';
    String bookingsValue = '0';
    String thirdStatValue = '0';

    try {
      if (role == 'admin') {
        // Admin sees: Total Tables, Total Bookings, Active Bookings
        availableTablesValue = (_tablesStats?['totalTables'] ?? 0).toString();
        bookingsValue = (_dashboardStats?['todayBookings'] ?? 0).toString();
        thirdStatValue = (_dashboardStats?['activeBookings'] ?? 0).toString();
      } else {
        // Customer sees: Available Tables, My Bookings, Hours Played
        availableTablesValue =
            (_tablesStats?['availableTables'] ?? 0).toString();
        bookingsValue = (_userStats?['totalBookings'] ?? 0).toString();
        thirdStatValue = (_userStats?['totalHours'] ?? 0).toString();
      }
    } catch (e) {
      print('Error displaying statistics: $e');
      // Keep default values of '0'
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: role == 'admin' ? 'Total Tables' : 'Available Tables',
              value: availableTablesValue,
              icon: Icons.table_restaurant,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: role == 'admin' ? 'Today\'s Bookings' : 'My Bookings',
              value: bookingsValue,
              icon: Icons.event_available,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: role == 'admin' ? 'Active Bookings' : 'Hours Played',
              value: thirdStatValue,
              icon: role == 'admin' ? Icons.pending_actions : Icons.access_time,
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStatCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.cardColor.withOpacity(0.5),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.borderColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.hourglass_empty,
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 24,
            width: 40,
            decoration: BoxDecoration(
              color: AppTheme.borderColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            width: 60,
            decoration: BoxDecoration(
              color: AppTheme.borderColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMainNavigation(BuildContext context, String? role) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (role == 'admin') ...[
            _buildNavigationCard(
              context,
              title: 'Kelola Meja',
              subtitle: 'Manage all billiard tables',
              icon: Icons.table_restaurant,
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              title: 'Lihat Booking',
              subtitle: 'View and manage all bookings',
              icon: Icons.calendar_today,
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingListPage()),
                );
              },
            ),
          ] else ...[
            _buildNavigationCard(
              context,
              title: 'Lihat Meja',
              subtitle: 'Browse available tables',
              icon: Icons.visibility,
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              title: 'Booking Saya',
              subtitle: 'View your reservations',
              icon: Icons.bookmark,
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingListPage()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor.withOpacity(0.9),
            AppTheme.surfaceColor.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.textPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: AppTheme.errorColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
                // Navigation will be handled automatically by AuthWrapper
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        );
      },
    );
  }
}
