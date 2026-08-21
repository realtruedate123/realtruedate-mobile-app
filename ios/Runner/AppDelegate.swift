import Flutter
import UIKit
import FirebaseCore
import Firebase
import FirebaseMessaging
import UserNotifications
//import flutter_local_notifications
//FlutterImplicitEngineDelegate
@main
@objc class AppDelegate: FlutterAppDelegate {
    // Store the FlutterViewController reference
//    private let notificationChannelName = "com.truedate/notification"
//    private var notificationChannel: FlutterMethodChannel?
    /// Stores notification received before Flutter is ready.
//    private var initialNotificationPayload: [String: Any]? = nil
    
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Initialize Firebase
      FirebaseApp.configure()

      // Get FlutterViewController from the window

//      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//        GeneratedPluginRegistrant.register(with: registry)
//      }
      
      GeneratedPluginRegistrant.register(with: self)

      
      /*guard let controller = window?.rootViewController as? FlutterViewController
      else {
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
      
      let channel = FlutterMethodChannel(
        name: notificationChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      
      self.notificationChannel = channel
      
      channel.setMethodCallHandler { [weak self] call, result in
          
          print("Flutter called native method: \(call.method)")
          
          switch call.method {
              
          case "getInitialNotification":
              
              print("Initial payload: \(String(describing: self?.initialNotificationPayload))")
              
              result(self?.initialNotificationPayload)
              
              // Clear after Flutter gets it.
              self?.initialNotificationPayload = nil
              
          default:
              
              result(FlutterMethodNotImplemented)
          }
      }*/
      
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
      }
      
      if #available(iOS 10.0, *) {
          let center  = UNUserNotificationCenter.current()
          center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
              if error == nil{
                  UIApplication.shared.registerForRemoteNotifications()
              }
          }
      }else {
          UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
          UIApplication.shared.registerForRemoteNotifications()
      }
      
      
      // App launched from notification.
      /*if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
          
          self.initialNotificationPayload =
          convertPayload(remoteNotification)
          
          print("Initial notification payload:")
          print(self.initialNotificationPayload ?? [:])
      }*/


      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    // Override to handle foreground notifications
    /*override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        let payload = convertPayload(userInfo)
        
        print("FOREGROUND NOTIFICATION:")
        print(payload)
        
//        sendNotificationToFlutter(payload)
        
        // Don't show another notification.
        completionHandler()
    }*/
    
    // This handles notification taps
    /*override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the tap here
        // The FlutterLocalNotificationsPlugin will handle it through the callback
        
        let userInfo = response.notification.request.content.userInfo
        print("userInfo", userInfo);
        
//        let payload = convertPayload(userInfo);
//        sendNotificationToFlutter(payload);
        
        completionHandler()
    }*/
    
    // MARK: - Send To Flutter

    /*private func sendNotificationToFlutter(_ payload: [String: Any]) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let channel =
                    self?.notificationChannel
            else {
                
                self?.initialNotificationPayload =
                payload
                
                return
            }
            
            channel.invokeMethod(
                "onNotification",
                arguments: payload
            )
        }
    }*/
}

/*extension AppDelegate {

    private func convertPayload(
        _ userInfo: [AnyHashable: Any]
    ) -> [String: Any] {

        var payload: [String: Any] = [:]

        for (key, value) in userInfo {

            guard let keyString = key as? String else {
                continue
            }

            if let value = value as? String {
                payload[keyString] = value

            } else if let value = value as? Int {
                payload[keyString] = value

            } else if let value = value as? Double {
                payload[keyString] = value

            } else if let value = value as? Bool {
                payload[keyString] = value

            } else if let value = value as? [String: Any] {
                payload[keyString] = value

            } else if let value = value as? [Any] {
                payload[keyString] = value

            } else {
                payload[keyString] = "\(value)"
            }
        }

        return payload
    }
}
*/
