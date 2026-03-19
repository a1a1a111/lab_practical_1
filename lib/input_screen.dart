import 'package:flutter/material.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});
  final String title;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _themeController = TextEditingController();
  final _durationController = TextEditingController(text: '2');
  final _budgetController = TextEditingController(text: '500');
  int _participants = 50;
  String _location = 'Hall';

  void _onGenerate() {
    // Task 1: Collect all 5 parameters
    final data = {
      'theme': _themeController.text.isEmpty ? 'General Event' : _themeController.text,
      'duration': double.tryParse(_durationController.text) ?? 2.0,
      'budget': double.tryParse(_budgetController.text) ?? 500.0,
      'participants': _participants,
      'location': _location,
    };
    Navigator.push(context, MaterialPageRoute(builder: (c) => ResultScreen(eventData: data)));
  }

  @override
  void dispose() {
    _themeController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.orange : Colors.grey.shade300,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          ['Event Details', 'Configuration', 'Preview'][step - 1],
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade100, Colors.pink.shade200],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Step Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStepIndicator(1, true),
              _buildStepIndicator(2, false),
              _buildStepIndicator(3, false),
            ],
          ),
          const SizedBox(height: 30),
          
          // Section 1: Event Details
          _buildSectionHeader('Event Details'),
          const SizedBox(height: 15),
          const Text('Event Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _themeController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.celebration),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 15),
          const Text('Budget (RM)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _budgetController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.attach_money),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),
          const Text('Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            initialValue: _location,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: ['Hall', 'Classroom', 'Outdoor Area'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setState(() => _location = v!),
          ),
          const SizedBox(height: 30),
          
          // Section 2: Event Configuration
          _buildSectionHeader('Event Configuration'),
          const SizedBox(height: 15),
          const Text('Duration (hours)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _durationController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.schedule),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),
          const Text('Number of Participants', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("$_participants People", style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          CounterWidget(onChanged: (v) => setState(() => _participants = v), initial: _participants),
          const SizedBox(height: 30),
          
          // Action Button
          Center(
            child: ElevatedButton(
              onPressed: _onGenerate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Generate Plan", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final int initial;
  const CounterWidget({super.key, required this.onChanged, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(icon: const Icon(Icons.remove), onPressed: () => onChanged(initial - 1)),
      Text("$initial People"),
      IconButton(icon: const Icon(Icons.add), onPressed: () => onChanged(initial + 1)),
    ]);
  }
}