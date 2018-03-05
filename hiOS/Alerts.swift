//
//  Alerts.swift
//  hiOS
//
//  Created by Harshitha Akkaraju on 3/3/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation
import UserNotifications

/// Singleton object to store user's Alert preferences
class Alerts: NSObject {
    static let shared = Alerts()
    
    // TODO: Add properties
    
    // TODO: Add functions to edit Alert preferences
}

/// Adds Notification support by adopting the UNUserNotificationCenterDelegate protocol
extension Alerts: UNUserNotificationCenterDelegate {
    
    /**
     Requests authorization for notification permissions
    */
    public func askForNotificationPermissions() {
        // Check Notification authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Guard against Display Error, Handle Error, etc.
            guard error == nil else {
                print("Error requesting notification authorization: \(error.debugDescription)")
                return
            }
        }
    }
    
    /**
     Creates a local notification and adds it to the notification center. Checks for notification permissions first.
     
     - Parameter title: The title text to display in the notification
     - Parameter body: The body text to display in the notification
    */
    public func makeNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        
        // Create a trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: "CryptoPriceAlert", content: content, trigger: trigger)
        
        // Ensure we have permissions
        center.getNotificationSettings() { setting in
            if setting.alertSetting == .enabled {
                // Schedule the request.
                center.add(request) { (error : Error?) in
                    if let theError = error {
                        print(theError.localizedDescription)
                    }
                }
            }
        }
    }
}
