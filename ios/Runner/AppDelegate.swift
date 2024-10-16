import UIKit
import Flutter
import AdServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let appleSearchAdsChannel = FlutterMethodChannel(name: "com.example.apple_search_ads/token",
                                                    binaryMessenger: controller.binaryMessenger)

    appleSearchAdsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getAttributionToken" {
        if #available(iOS 14.3, *) {
          do {
            let token = try AAAttribution.attributionToken()
            result(token)
          } catch {
            result(FlutterError(code: "UNAVAILABLE", message: "Unable to get Apple Search Ads token", details: nil))
          }
        } else {
          result(FlutterError(code: "UNSUPPORTED_VERSION", message: "iOS version not supported", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
