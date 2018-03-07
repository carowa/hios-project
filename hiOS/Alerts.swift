//
//  Alerts.swift
//  hiOS
//
//  Created by Harshitha Akkaraju on 3/3/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation
import UserNotifications

class Alert {
    private var id : String
    
    // creates an empty alert object
    init(id : String) {
        self.id = id
    }
    
    // track the alert type
    private var percentVal : Bool = false
    private var currVal : Bool = false

    // default: no alert == ""
    private var inequality : String = ""
    private var value : Int = 0
    
    /*
     Returns the id of the alert object (id property of the cryptocurrency)
     */
    func getId() -> String {
        return id
    }

    /*
     Sets the inequality to keep track of
     
     - Parameter ineq: is a string representing the bound on an alert
    */
    func setInequality(ineq : String) {
        inequality = ineq
    }

    /*
     Returns the inequality setting on the alert
     */
    func getInequality() -> String {
        return inequality
    }
    
    /*
     Sets the alert type on the alert object
     
     - Parameter type: the type of constraint on the alert(either Percent value or Currency value)
    */
    func setAlertType(type: String) {
        if type == "Percent Value" {
            percentVal = true
            currVal = false
        } else if type == "Currency Value" {
            currVal = true
            percentVal = false
        }
    }
    
    /*
     Sets the alert's value
     
     - Parameter input: is the value to which the constraint is applied to
    */
    func setAlertValue(input: Int) {
        value = input
    }
}

/// Singleton object to store user's Alert preferences
class Alerts: NSObject {
    static let shared = Alerts()
    
    private var alertsRepo : [String : Alert] = [:]

    func getAlerts() -> [Alert] {
        return Array(alertsRepo.values)
    }
    
    func addAlert(id: String, alertType: String, ineq: String, value: Int) {
        let alert = Alert(id: id)
        alert.setAlertType(type: alertType)
        alert.setInequality(ineq: ineq)
        alert.setAlertValue(input: value)
        alertsRepo[alert.getId()] = alert
        print("Alert is added to the repo!")
    }
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
