import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'core/router/app_router.dart';

void main() {
  // Initialize API client with backend URL
  ApiClient.initialize(baseUrl: AppConstants.apiBaseUrl);
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Insight Store',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}