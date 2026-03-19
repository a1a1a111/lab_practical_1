import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String hfKey = '';
  static const String model = 'stabilityai/stable-diffusion-xl-base-1.0';

  // Task 2: Construct prompt and generate Poster
  static Future<String> generatePoster(Map<String, dynamic> data) async {
    try {
      final theme = (data['theme'] as String?)?.toLowerCase().trim() ?? 'event';
      final location = (data['location'] as String?)?.trim() ?? 'venue';
      
      // Expanded theme-specific descriptions with style, mood, composition
      final themeDescriptions = {
        'midnight': {
          'style': 'luxury, elegant, sophisticated, cinema photography',
          'colors': 'midnight blue, deep purple, gold accents, starlight',
          'elements': 'starry night sky, moon, celestial patterns, ornate decorations, luxury venue',
          'mood': 'mysterious, elegant, professional, upscale event atmosphere',
          'composition': 'centered composition, professional event poster layout, balanced lighting',
        },
        'tech': {
          'style': 'futuristic, digital art, cyberpunk, modern design, tech conference aesthetic',
          'colors': 'neon blue, neon purple, electric green, dark background, glowing effects',
          'elements': 'circuit boards, holographic effects, digital waves, tech innovation symbols, sleek surfaces',
          'mood': 'innovative, cutting-edge, modern, dynamic tech atmosphere',
          'composition': 'modern poster design, geometric shapes, tech-inspired layout, high contrast',
        },
        'nature': {
          'style': 'botanical illustration, nature photography, landscape art, eco-friendly design',
          'colors': 'emerald green, forest green, natural earth tones, leaf patterns, garden colors',
          'elements': 'lush green plants, blooming flowers, trees, garden setting, outdoor nature, morning light',
          'mood': 'fresh, peaceful, organic, natural harmony, environmental celebration',
          'composition': 'landscape composition, natural framing with plants, serene outdoor setting',
        },
        'party': {
          'style': 'festive illustration, celebration art, vibrant pop art, party design',
          'colors': 'rainbow colors, bright pink, electric yellow, vibrant orange, confetti colors, neon',
          'elements': 'colorful balloons, streamers, confetti, party lights, celebration symbols, joyful decorations',
          'mood': 'fun, energetic, celebratory, festive, joyful atmosphere, high-energy party',
          'composition': 'dynamic centered design, vibrant poster layout, eye-catching party banner',
        },
        'wedding': {
          'style': 'romantic art, elegant wedding photography, luxury celebration design, sophisticated',
          'colors': 'white, cream, gold, rose gold, blush pink, romantic tones, elegant accents',
          'elements': 'white flowers, floral arrangements, elegant decorations, romantic ambiance, beautiful venue',
          'mood': 'romantic, elegant, intimate, beautiful, celebratory love atmosphere',
          'composition': 'elegant centered design, romantic poster layout, luxury wedding aesthetic',
        },
        'corporate': {
          'style': 'professional photography, corporate design, business conference aesthetic, modern minimal',
          'colors': 'corporate blue, professional gray, white, black, corporate branding colors',
          'elements': 'modern office, conference room, professional setting, corporate branding, sleek design',
          'mood': 'professional, formal, trustworthy, modern business, corporate excellence',
          'composition': 'professional poster layout, clean lines, business-appropriate design, formal presentation',
        },
        'music': {
          'style': 'concert poster art, music festival design, stage production aesthetic, professional concert',
          'colors': 'bold music colors, neon stage lights, concert lighting, vibrant stage colors',
          'elements': 'stage lighting, musical instruments, microphone, concert stage, audience energy, music symbols',
          'mood': 'energetic, musical, concert atmosphere, professional show, live performance vibration',
          'composition': 'concert stage centered, professional concert poster, dynamic music event layout',
        },
        'sports': {
          'style': 'sports photography, athletic event design, sports arena aesthetic, dynamic action',
          'colors': 'sports team colors, power colors, athletic branding, dynamic contrast',
          'elements': 'sports equipment, athletic venue, competition spirit, victory symbols, sports energy',
          'mood': 'energetic, competitive, dynamic, sporty, athletic excellence, victory energy',
          'composition': 'dynamic action composition, sports event poster, energetic athletic layout',
        },
        'art': {
          'style': 'art gallery photography, artistic masterpiece, creative expression, fine art aesthetic',
          'colors': 'artistic colors, creative palette, gallery lighting, artistic accents',
          'elements': 'art gallery setting, creative decorations, artistic atmosphere, cultural ambiance, gallery walls',
          'mood': 'creative, cultured, artistic, expressive, sophisticated artistic celebration',
          'composition': 'gallery-centered design, artistic poster layout, cultural event aesthetic',
        },
        'food': {
          'style': 'food photography, culinary magazine aesthetic, gourmet design, restaurant professional',
          'colors': 'appetizing colors, warm food tones, restaurant ambiance, culinary colors',
          'elements': 'gourmet food display, appetizing dishes, culinary tools, restaurant setting, dining ambiance',
          'mood': 'appetizing, culinary, professional restaurant, food celebration, gastronomic excellence',
          'composition': 'food-centered professional photography, culinary poster design, restaurant event layout',
        }
      };
      
      // Negative prompt - what to exclude
      const negativePrompt = 'no cars, no vehicles, no text, no watermark, no blurry, no distorted, no ugly, no poorly drawn, no bad quality, no low resolution';
      
      final themeData = themeDescriptions[theme] ?? {
        'style': 'professional, elegant event design',
        'colors': 'professional color palette',
        'elements': 'elegant venue decoration, professional setting',
        'mood': 'professional, elegant, sophisticated event atmosphere',
        'composition': 'centered professional poster design',
      };
      
      // Build comprehensive prompt
      final prompt = '''
Professional event poster for $theme event at $location.

Style: ${themeData['style']}
Colors: ${themeData['colors']}
Elements: ${themeData['elements']}
Mood: ${themeData['mood']}
Composition: ${themeData['composition']}

Details: High quality, 4k resolution, detailed, professional event poster, studio quality, perfect lighting, polished, premium design, ready for print.

Negative: $negativePrompt
      '''.replaceAll('\n', ' ').trim();
      
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/$model'),
        headers: {'Authorization': 'Bearer $hfKey', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {
            'width': 1024,
            'height': 576,
            'num_inference_steps': 50,  // Better quality with more steps
            'guidance_scale': 7.5,       // Better prompt adherence
          }
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return 'data:image/png;base64,${base64Encode(response.bodyBytes)}';
      }
      throw "HF API Error";
    } catch (e) {
      print('Image generation error: $e');
      return "https://picsum.photos/seed/${data['theme']}/1024/576";
    }
  }

  // Helper method to generate multiple variants (for future enhancement)
  static Future<List<String>> generatePosterVariants(Map<String, dynamic> data, {int variants = 3}) async {
    try {
      List<String> results = [];
      for (int i = 0; i < variants; i++) {
        final posterUrl = await generatePoster(data);
        results.add(posterUrl);
      }
      return results;
    } catch (e) {
      print('Variant generation error: $e');
      return [await generatePoster(data)];
    }
  }

  // Task 3: Firebase AI Logic Integration
  static Future<Map<String, dynamic>> getSuggestions(Map<String, dynamic> data) async {
    // In a real scenario, this would be a Firebase Vertex AI call
    await Future.delayed(const Duration(seconds: 1));
    
    // Task 3.3: Personalized suggestion in JSON format
    final theme = (data['theme'] as String?)?.trim() ?? 'Event';
    final duration = (data['duration'] is num) ? (data['duration'] as num).toInt() : 2;

    return {
      "catering": "Budget RM${data['budget']} allows for premium ${theme.toLowerCase()}-themed catering.",
      "activities": [
        "Registration & networking (15 min) - Guests arrive, collect badges, and grab refreshments.",
        "Opening & agenda overview (10 min) - Welcome by host and outline of the ${theme.toLowerCase()} schedule.",
        "$theme keynote session (min 60 min) - Main presentation focused on the core topic.",
        "Interactive breakout activity (30 min) - Small group discussions or hands-on exercises.",
        "Wrap-up & Q&A (15 min) - Final thoughts, feedback, and next steps.",
      ],
      "pro_tip": "Assign a point person to handle AV and timing so the event flows smoothly."
    };
  }
}