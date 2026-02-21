import 'package:flutter/material.dart';
import 'package:website/router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  // Use path URL strategy so `go_router` produces clean URLs (no #)
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
