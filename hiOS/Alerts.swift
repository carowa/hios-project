//
//  Alerts.swift
//  hiOS
//
//  Created by Harshitha Akkaraju on 3/3/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation
import UserNotifications

/// Object to store the different properties of an alert
class Alert {
    private var id: String
    public var alertType: AlertType = .none
    private var currPrice: Double = 0.0
    private var inequality: String = "" // default: no alert == ""
    private var value: Int = 0
    
    /// Defines the types of Alerts available
    public enum AlertType: Int {
        case none = 0
        case percentValue = 1
        case currencyValue = 2
    }
    
    /// Creates an `Alert` with the given parameters
    init(id: String, alertType: AlertType, ineq: String, value: Int, price: Double) {
        self.id = id
        self.alertType = alertType
        self.inequality = ineq
        self.value = value
        self.currPrice = price
    }
    
    /**
     Gets the id of the alert object (id property of the cryptocurrency)
     
     - Returns: a `String` representing the id of the cryptocurrency
     */
    func getId() -> String {
        return self.id
    }

    /**
     Sets the inequality to keep track of
     
     - Parameter ineq: is a `String` representing the bound on an alert
    */
    func setInequality(ineq: String) {
        self.inequality = ineq
    }

    /**
     Gets the inequality setting on the alert
     
     - Returns: a `String` representing the inequality on the alert
     */
    func getInequality() -> String {
        return self.inequality
    }
    
    /**
     Sets the alert type on the alert object
     
     - Parameter type: the type of constraint on the alert(either Percent value or Currency value)
    */
    func setAlertType(type: AlertType) {
        self.alertType = type
    }
    
    /**
     Sets the bound on alert's change
     
     - Parameter input: is the value to which the constraint is applied to
    */
    func setAlertValue(input: Int) {
        self.value = input
    }
    
    /**
     Gets the bound on alert's change
     
     - Returns: an Int representing the bound on alert's change
    */
    func getAlertValue() -> Int {
        return self.value
    }
    
    /**
     Gets the type of the alert on the cryptocurrency
     
     - Returns: An `AlertType` representing the type of alert on the cryptocurrency object
    */
    func getAlertType() -> AlertType {
        return self.alertType
    }
    
    /**
     Sets the price of the cryptocurrency to the given amount
     
     - Parameter input: takes a Double representing the current price of the crypto currency as input
    */
    func setCurrPrice(input : Double) {
        self.currPrice = input
    }
    
    /**
     Gets the price of the cryptocurrency from the time when the alert was set
     
     - Returns: A Double representing the price of the cryptocurrency
    */
    func getCurrPrice() -> Double {
        return self.currPrice
    }
}

/// Singleton object to store user's Alert preferences
class Alerts: NSObject {
    static let shared = Alerts()
    
    let cryptoRepo = CryptoRepo.shared
    
    /**
     Gets and returns the list of alerts
     
     - Returns: An array of `Alert` objects
    */
    func getAlerts() -> [Alert] {
        return []
    }
    
    /**
     Adds a new alert to alerts repo
     
     - Parameter id: id on the cryptocurrency object
     - Parameter alertType: the type of alert (Percent Value or Currency Value)
     - Parameter ineq: the inequality set by user
     - Parameter value: the bound set by user
     - Parameter price: price of the cryptocurrency when the alert was set
    */
    func addAlert(id: String, alertType: Alert.AlertType, ineq: String, value: Int, price : Double) {
        let alert = Alert(id: id, alertType: alertType, ineq: ineq, value: value, price: price)
        StorageManager.shared.insert(alert: alert)
    }
    
    /**
     Checks the status of the alerts and sends notifications accordingly
    */
    func checkStatus() {
        for alertItem in StorageManager.shared.fetchAllAlerts() {
            let change : Int = Int(alertItem.alertValue)
            let price : Double = alertItem.currentPrice
            let ineq : String = alertItem.inequality!
            let type : Alert.AlertType = Alert.AlertType(rawValue: Int(alertItem.alertType))!
            let id : String = alertItem.currencyId!
            
            let updatedVal = cryptoRepo.getElemById(id: id)
            
            if type == .percentValue {
                if pctChange(oldVal: price, newVal: updatedVal.priceUSD, change: change, ineq: ineq) {
                    makeNotification(title: "\(type) for \(id)",
                        body: "Percent change is \(ineq) \(change). New price is \(updatedVal.priceUSD)")
                }
            } else if type == .currencyValue {
                if priceChange(newVal: updatedVal.priceUSD, change: change, ineq: ineq) {
                    makeNotification(title: "\(type) for \(id)",
                        body: "\(id) \(ineq) \(change). New price is \(updatedVal.priceUSD)")
                }
            }
        }
    }
    
    /**
     Computes the if there was a specified amount of price change
     
     - Parameter newVal: the updated value of the cryptocurrency
     - Parameter change: the amount of change specified by the user
     - Parameter ineq: the inequality specified by the user
     - Returns: A boolean indicating whether there was a specified amount of change
    */
    private func priceChange(newVal : Double, change : Int, ineq : String) -> Bool {
        switch (ineq) {
        case "=":
            return abs(newVal - Double(change)) < 1.0
        case "<":
            return newVal < Double(change)
        case ">":
            print("new value: \(newVal)  change: \(change)")
            return newVal > Double(change)
        default:
            return false
        }
    }

    /**
     Computes the percent change between the old and new values of the cryptocurrency
     
     - Parameter oldVal: old value of the cryptocurrency
     - Parameter newVal: updated value of cryptocurrency
     - Parameter change: amount of change specified by user
     - Parameter ineq: inequality specified by the user
     - Returns: A boolean indicating whether there was a specified amount of price change
    */
    private func pctChange(oldVal : Double, newVal : Double, change : Int, ineq : String) -> Bool {
        let pctDecrease : Double = ((oldVal - newVal) / oldVal) * 100
        let pctIncrease : Double = ((newVal - oldVal) / oldVal) * 100
        switch (ineq) {
            case "=":
                return pctIncrease < 1.0 && pctDecrease < 1.0
            case "<":
                return pctDecrease < Double(change)
            case ">":
                return pctIncrease > Double(change)
            default:
                return false
        }
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
