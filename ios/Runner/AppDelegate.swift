import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // 1. 定义Channel
    private let CHANNEL = "com.example/native"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        // 2. 定义钩子方法
        let channel = FlutterMethodChannel(name: CHANNEL,
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getNativeData" {
                self.getNativeData(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getNativeData(result: FlutterResult) {
        // 3. 传递iOS数据给Flutter
        result("Native iOS Data")
      }
}
