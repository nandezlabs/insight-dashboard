import 'package:flutter/material.dart';
import 'package:insight_ui/insight_ui.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: EmptyState(
          icon: Icons.analytics_outlined,
          title: 'Analytics Coming Soon',
          message: 'Advanced analytics and reporting will be available here',
        ),
      ),
    );
  }
}
