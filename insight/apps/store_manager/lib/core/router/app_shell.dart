import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_ui/insight_ui.dart';
import '../providers/auth_provider.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_NavigationTab> _tabs = [
    _NavigationTab(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/overview',
    ),
    _NavigationTab(
      label: 'Forms',
      icon: Icons.description_outlined,
      selectedIcon: Icons.description,
      route: '/forms',
    ),
    _NavigationTab(
      label: 'Analytics',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      route: '/analytics',
    ),
    _NavigationTab(
      label: 'Goals',
      icon: Icons.flag_outlined,
      selectedIcon: Icons.flag,
      route: '/goals',
    ),
    _NavigationTab(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _getInitialIndex(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getInitialIndex() {
    for (int i = 0; i < _tabs.length; i++) {
      if (widget.currentRoute.startsWith(_tabs[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      final newIndex = _getInitialIndex();
      if (_tabController.index != newIndex) {
        _tabController.index = newIndex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.insights,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Store Manager',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          // User info and logout
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, color: AppColors.textPrimary),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder: (context) {
              final authState = ref.watch(authProvider);
              return [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.user?.fullName ?? 'User',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        authState.user?.email ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              onTap: (index) {
                context.go(_tabs[index].route);
              },
              tabs: _tabs.map((tab) {
                final isSelected = _tabController.index == _tabs.indexOf(tab);
                return Tab(
                  icon: Icon(
                    isSelected ? tab.selectedIcon : tab.icon,
                    size: 20,
                  ),
                  text: tab.label,
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: widget.child,
    );
  }
}

class _NavigationTab {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  _NavigationTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}
