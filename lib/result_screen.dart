import 'package:flutter/material.dart';
import 'ai_service.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;
  const ResultScreen({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    final themeName = (eventData['theme'] as String?)?.trim();
    final displayTitle = themeName != null && themeName.isNotEmpty
        ? themeName
        : 'Your AI Plan';

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text(displayTitle),
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
      body: FutureBuilder(
        future: Future.wait([
          AIService.generatePoster(eventData),
          AIService.getSuggestions(eventData),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Step Indicator - Step 2 loading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStepIndicator(1, false),
                      _buildStepIndicator(2, true),
                      _buildStepIndicator(3, false),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Generating your event plan...',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }

          String posterUrl = snapshot.data![0];
          Map<String, dynamic> suggestions = snapshot.data![1];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator - Step 3 complete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStepIndicator(1, false),
                    _buildStepIndicator(2, false),
                    _buildStepIndicator(3, true),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Poster Section
                Text(
                  'Event Poster',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Event Details Section
                Text(
                  'Event Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                
                // Theme & Catering Cards - Side by Side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            top: BorderSide(
                              color: Colors.purple.shade400,
                              width: 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.palette, color: Colors.purple.shade600, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Theme',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              displayTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Visual Indicators
                            Row(
                              children: _getThemeVisualIndicators(displayTitle)
                                  .map((indicator) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            indicator['color'] as Color,
                                            (indicator['color'] as Color).withValues(alpha: 0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        indicator['icon'] as IconData,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getThemeDescription(displayTitle),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _getThemeAttributes(displayTitle)
                                  .map((attr) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.purple.shade200),
                                    ),
                                    child: Text(
                                      attr,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.purple.shade700,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Catering Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            top: BorderSide(
                              color: Colors.orange.shade400,
                              width: 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.restaurant, color: Colors.orange.shade600, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Catering',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              suggestions['catering'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Meal Options',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _getMealOptions()
                                  .map((meal) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.orange.shade200),
                                    ),
                                    child: Text(
                                      meal,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Dietary Options',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _getDietaryOptions()
                                  .map((diet) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Text(
                                      diet,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Activities Section
                Text(
                  'Planned Activities',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    ...suggestions['activities']
                        .asMap()
                        .entries
                        .map<Widget>(
                          (entry) {
                            String activity = entry.value;
                            int index = entry.key;
                            
                            // Determine emoji based on activity content
                            String emoji = _getActivityEmoji(activity);
                            Color badgeColor = _getActivityColor(index);
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color: badgeColor,
                                      width: 5,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: badgeColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        .toList(),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Pro Tip Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange.shade600, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pro Tip',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              suggestions['pro_tip'] ?? 'Great job planning your event!',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: const Text(
                        'Back to Edit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
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

  String _getActivityEmoji(String activity) {
    String lower = activity.toLowerCase();
    if (lower.contains('registration') || lower.contains('arrive')) return '📝';
    if (lower.contains('opening') || lower.contains('welcome')) return '👋';
    if (lower.contains('keynote') || lower.contains('presentation')) return '🎤';
    if (lower.contains('breakout') || lower.contains('discussion')) return '💬';
    if (lower.contains('wrap') || lower.contains('qa') || lower.contains('q&a')) return '🎯';
    return '⏱️';
  }

  Color _getActivityColor(int index) {
    const colors = [
      Color(0xFF6366f1),  // Indigo
      Color(0xFFf97316),  // Orange
      Color(0xFF8b5cf6),  // Violet
      Color(0xFF06b6d4),  // Cyan
      Color(0xFFec4899),  // Pink
    ];
    return colors[index % colors.length];
  }

  List<Color> _getThemeColors(String theme) {
    final themeLower = theme.toLowerCase();
    
    if (themeLower.contains('midnight')) {
      return [
        const Color(0xFF1a1a2e),
        const Color(0xFF16213e),
        const Color(0xFF0f3460),
        const Color(0xFFe94560),
      ];
    } else if (themeLower.contains('tech')) {
      return [
        const Color(0xFF00d4ff),
        const Color(0xFF0099ff),
        const Color(0xFF9d00ff),
        const Color(0xFF00ff88),
      ];
    } else if (themeLower.contains('nature')) {
      return [
        const Color(0xFF2d5016),
        const Color(0xFF6db83f),
        const Color(0xFF9dcc3f),
        const Color(0xFFe8f5e9),
      ];
    } else if (themeLower.contains('party')) {
      return [
        const Color(0xFFff006e),
        const Color(0xFFfb5607),
        const Color(0xFFffbe0b),
        const Color(0xFF8338ec),
      ];
    } else if (themeLower.contains('wedding')) {
      return [
        const Color(0xFFffffff),
        const Color(0xFFffd700),
        const Color(0xFFffe4e1),
        const Color(0xFFdaa520),
      ];
    } else if (themeLower.contains('corporate')) {
      return [
        const Color(0xFF1f1f1f),
        const Color(0xFF3d3d3d),
        const Color(0xFF0066cc),
        const Color(0xFFcccccc),
      ];
    } else {
      return [
        const Color(0xFFff9500),
        const Color(0xFFff6b00),
        const Color(0xFFffa500),
        const Color(0xFFffb84d),
      ];
    }
  }

  List<Map<String, dynamic>> _getThemeVisualIndicators(String theme) {
    final themeLower = theme.toLowerCase();
    
    if (themeLower.contains('midnight')) {
      return [
        {'icon': Icons.dark_mode, 'color': Colors.indigo},
        {'icon': Icons.star, 'color': Colors.amber},
        {'icon': Icons.nightlife, 'color': Colors.deepPurple},
        {'icon': Icons.language, 'color': Colors.blue},
      ];
    } else if (themeLower.contains('tech')) {
      return [
        {'icon': Icons.flash_on, 'color': Colors.cyan},
        {'icon': Icons.code, 'color': Colors.blue},
        {'icon': Icons.settings, 'color': Colors.purple},
        {'icon': Icons.memory, 'color': Colors.teal},
      ];
    } else if (themeLower.contains('nature')) {
      return [
        {'icon': Icons.eco, 'color': Colors.green},
        {'icon': Icons.landscape, 'color': Colors.lightGreen},
        {'icon': Icons.nature, 'color': Colors.teal},
        {'icon': Icons.park, 'color': Colors.greenAccent},
      ];
    } else if (themeLower.contains('party')) {
      return [
        {'icon': Icons.celebration, 'color': Colors.pink},
        {'icon': Icons.music_note, 'color': Colors.purple},
        {'icon': Icons.emoji_emotions, 'color': Colors.orange},
        {'icon': Icons.local_activity, 'color': Colors.red},
      ];
    } else if (themeLower.contains('wedding')) {
      return [
        {'icon': Icons.favorite, 'color': Colors.red},
        {'icon': Icons.diamond, 'color': Colors.amber},
        {'icon': Icons.psychology, 'color': Colors.pink},
        {'icon': Icons.sentiment_very_satisfied, 'color': Colors.purple},
      ];
    } else if (themeLower.contains('corporate')) {
      return [
        {'icon': Icons.business, 'color': Colors.blueGrey},
        {'icon': Icons.trending_up, 'color': Colors.blue},
        {'icon': Icons.assignment, 'color': Colors.indigo},
        {'icon': Icons.workspace_premium, 'color': Colors.grey},
      ];
    } else {
      return [
        {'icon': Icons.palette, 'color': Colors.orange},
        {'icon': Icons.brush, 'color': Colors.pink},
        {'icon': Icons.lightbulb, 'color': Colors.amber},
        {'icon': Icons.category, 'color': Colors.purple},
      ];
    }
  }

  String _getThemeDescription(String theme) {
    final themeLower = theme.toLowerCase();
    
    if (themeLower.contains('midnight')) {
      return 'A sophisticated evening celebration with luxury and elegance at its core.';
    } else if (themeLower.contains('tech')) {
      return 'A modern tech-forward celebration with innovation and digital excellence.';
    } else if (themeLower.contains('nature')) {
      return 'An organic celebration embracing natural beauty and peaceful atmosphere.';
    } else if (themeLower.contains('party')) {
      return 'A vibrant and energetic celebration filled with fun and entertainment.';
    } else if (themeLower.contains('wedding')) {
      return 'A romantic and intimate celebration of love and commitment.';
    } else if (themeLower.contains('corporate')) {
      return 'A professional and formal celebration with polished excellence.';
    } else {
      return 'A creative and engaging celebration with dynamic energy.';
    }
  }

  List<String> _getThemeAttributes(String theme) {
    final themeLower = theme.toLowerCase();
    
    if (themeLower.contains('midnight')) {
      return ['Elegant', 'Sophisticated', 'Modern'];
    } else if (themeLower.contains('tech')) {
      return ['Innovative', 'Modern', 'Digital'];
    } else if (themeLower.contains('nature')) {
      return ['Organic', 'Fresh', 'Peaceful'];
    } else if (themeLower.contains('party')) {
      return ['Vibrant', 'Fun', 'Energetic'];
    } else if (themeLower.contains('wedding')) {
      return ['Romantic', 'Elegant', 'Intimate'];
    } else if (themeLower.contains('corporate')) {
      return ['Professional', 'Formal', 'Polished'];
    } else {
      return ['Creative', 'Dynamic', 'Engaging'];
    }
  }

  List<String> _getMealOptions() {
    return ['🥗 Appetizers', '🍽️ Main Course', '🍰 Desserts', '🥤 Beverages'];
  }

  List<String> _getDietaryOptions() {
    return ['✓ Vegan', '✓ Vegetarian', '✓ Gluten-Free'];
  }
}
