import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  UrlHelper._();

  static Future<bool> launchURL(String urlString) async {
    try {
      String formattedUrl = urlString.trim();
      if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
        formattedUrl = 'https://$formattedUrl';
      }
      final uri = Uri.parse(formattedUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }
}
