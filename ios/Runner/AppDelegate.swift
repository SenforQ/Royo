import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let PluginArray = ["UIApplication","launchOptions","LaunchOptionsKey","didFinishLaunchingWithOptions"];
      for str in PluginArray {
          print(str)
      }
      print(PluginArray[4]);
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
