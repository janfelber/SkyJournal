import UIKit
import Flutter
import GoogleMaps
import UserNotifications
import flutter_local_notifications // Make sure this is correctly imported

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY") // add your api key here from google cloud console - https://console.cloud.google.com/

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      if granted {
        print("Permission granted")
      } else {
        print("Permission denied")
      }
    }

    // Corrected usage of FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }


    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
