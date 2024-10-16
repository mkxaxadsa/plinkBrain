// // lib/services/app_initialization_service.dart
// import 'dart:convert';
// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
// import 'package:flutter_asa_attribution/flutter_asa_attribution.dart';
// import 'package:http/http.dart' as http;

// class AppInitializationService {
//   final AppsflyerSdk _appsflyer;
//   DeepLink? _deepLinkResult;
//   Map<String, dynamic> _conversionData = {};
//   Map<String, dynamic> _asaData = {};

//   AppInitializationService(this._appsflyer);

//   Future<void> initialize() async {
//     await _initializeAppsflyer();
//     await _fetchAppleSearchAdsData();
//   }

//   Future<void> _initializeAppsflyer() async {
//     try {
//       await _appsflyer.initSdk(
//         registerConversionDataCallback: true,
//         registerOnAppOpenAttributionCallback: true,
//         registerOnDeepLinkingCallback: true,
//       );

//       _appsflyer.onDeepLinking((DeepLinkResult dp) {
//         if (dp.status == Status.FOUND) {
//           _deepLinkResult = DeepLink(dp.deepLink?.clickEvent ?? {});
//           print("DeepLink found: ${_deepLinkResult.toString()}");
//         }
//       });

//       _appsflyer.onInstallConversionData((data) {
//         _conversionData = data;
//         print("Conversion data received: $_conversionData");
//       });

//       await Future.delayed(Duration(seconds: 5));
//     } catch (e) {
//       print("Error initializing AppsFlyer: $e");
//     }
//   }

//   Future<void> _fetchAppleSearchAdsData() async {
//     try {
//       final String? appleSearchAdsToken = await FlutterAsaAttribution.instance.attributionToken();
//       if (appleSearchAdsToken != null) {
//         const url = 'https://api-adservices.apple.com/api/v1/';
//         final headers = {'Content-Type': 'text/plain'};
//         final response = await http.post(Uri.parse(url), headers: headers, body: appleSearchAdsToken);

//         if (response.statusCode == 200) {
//           _asaData = json.decode(response.body);
//           print("Apple Search Ads data received: $_asaData");
//         }
//       }
//     } catch (e) {
//       print("Error fetching Apple Search Ads data: $e");
//     }
//   }

//   Map<String, String> buildUrlParams(String appsFlyerUID) {
//     Map<String, String> params = {
//       'appsflyer_id': appsFlyerUID,
//       'app_id': "com.jeclkpdk",
//       'dev_key': "78mcqfm5CyTxuGW9xHLe95",
//       'apple_id': "id6736759537",
//     };

//     if (_asaData['attribution'] == true) {
//       params.addAll({
//         'utm_medium': _asaData['adId']?.toString() ?? '',
//         'utm_content': _asaData['conversionType'] ?? '',
//         'utm_term': _asaData['keywordId']?.toString() ?? '',
//         'utm_source': _asaData['adGroupId']?.toString() ?? '',
//         'utm_campaign': _asaData['campaignId']?.toString() ?? '',
//       });
//     } else if (_deepLinkResult != null) {
//       params.addAll({
//         'utm_medium': _deepLinkResult?.af_sub1 ?? '',
//         'utm_content': _deepLinkResult?.af_sub2 ?? _deepLinkResult?.campaign ?? '',
//         'utm_term': _deepLinkResult?.af_sub3 ?? '',
//         'utm_source': _deepLinkResult?.af_sub4 ?? _deepLinkResult?.mediaSource ?? '',
//         'utm_campaign': _deepLinkResult?.af_sub5 ?? _deepLinkResult?.campaignId ?? '',
//         'deep_link_value': _deepLinkResult?.deepLinkValue ?? '',
//       });
//     } else if (_conversionData.isNotEmpty) {
//       params.addAll({
//         'utm_medium': _conversionData['af_sub1'] ?? '',
//         'utm_content': _conversionData['af_sub2'] ?? _conversionData['campaign'] ?? '',
//         'utm_term': _conversionData['af_sub3'] ?? '',
//         'utm_source': _conversionData['af_sub4'] ?? _conversionData['media_source'] ?? '',
//         'utm_campaign': _conversionData['af_sub5'] ?? _conversionData['af_adset'] ?? '',
//       });
//     } else {
//       params.addAll({
//         'utm_medium': 'organic',
//         'utm_content': 'organic',
//         'utm_term': 'organic',
//         'utm_source': 'organic',
//         'utm_campaign': 'organic',
//       });
//     }

//     return params;
//   }
// }
