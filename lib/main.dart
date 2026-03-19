import 'package:flutter/material.dart';
import 'input_screen.dart';

void main() {
  runApp(const EventPlannerApp());
}

class EventPlannerApp extends StatelessWidget {
  const EventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Event Planner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const InputScreen(title: 'Event Configuration'),
    );
  }
}