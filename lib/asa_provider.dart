import 'package:flutter/services.dart';

class AppleSearchAdsTokenProvider {
  static const platform = MethodChannel('com.example.apple_search_ads/token');

  static Future<String?> getAppleSearchAdsToken() async {
    try {
      final String? token = await platform.invokeMethod('getAttributionToken');
      return token;
    } catch (e) {
      return null;
    }
  }
}
