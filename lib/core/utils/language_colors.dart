import 'package:flutter/material.dart';

class LanguageColors {
  LanguageColors._();

  static const Map<String, Color> _colors = {
    'dart': Color(0xFF00B4AB),
    'flutter': Color(0xFF02569B),
    'javascript': Color(0xFFF1E05A),
    'typescript': Color(0xFF3178C6),
    'python': Color(0xFF3572A5),
    'java': Color(0xFFB07219),
    'kotlin': Color(0xFFA97BFF),
    'swift': Color(0xFFF05138),
    'c': Color(0xFF555555),
    'c++': Color(0xFFF34B7D),
    'c#': Color(0xFF178600),
    'go': Color(0xFF00ADD8),
    'rust': Color(0xFFDEA584),
    'ruby': Color(0xFF701516),
    'php': Color(0xFF4F5D95),
    'html': Color(0xFFE34C26),
    'css': Color(0xFF563D7C),
    'scss': Color(0xFFC6538C),
    'vue': Color(0xFF41B883),
    'shell': Color(0xFF89E051),
    'lua': Color(0xFF000080),
    'r': Color(0xFF198CE7),
    'scala': Color(0xFFC22D40),
    'elixir': Color(0xFF6E4A7E),
    'clojure': Color(0xFFDB5855),
    'zig': Color(0xFFEC915C),
  };

  static Color getLanguageColor(String? language) {
    if (language == null || language.trim().isEmpty) {
      return const Color(0xFF8B949E); // Default muted gray
    }
    final key = language.toLowerCase().trim();
    return _colors[key] ?? const Color(0xFF58A6FF);
  }
}
