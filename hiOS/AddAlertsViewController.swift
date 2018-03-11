//
//  AddAlertsViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AddAlertsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    let alerts = Alerts.shared
    var currency:Cryptocurrency? = nil
    var id : String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeOfAlertPicker: UIPickerView!
    @IBOutlet weak var inequalityAlertPicker: UIPickerView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var setAlertButton: UIButton!
    
    var alertTypeString:String = ""
    var inequality:String = ""
    
    var alertTypeArray:[String] = ["", "Percent Value", "Currency Value"]
    var inequalityArray:[String] = ["", "<", "=", ">"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOfAlertPicker.delegate = self
        typeOfAlertPicker.dataSource = self
        inequalityAlertPicker.delegate = self
        inequalityAlertPicker.dataSource = self
        valueTextField.delegate = self
        valueTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
        titleLabel.text = "Set New Alert for \(currency?.name ?? "nil")"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setAlert(_ sender: UIButton) {
        if alertTypeString != "" && inequality != "" && valueTextField.text != "" {
            // delete this
            alertLabel.text = alertTypeString + inequality + valueTextField.text!
            /* TODO: add alert object to array
            
            */

            // Get index value inside of alertType
            guard let alertIndex = self.alertTypeArray.index(of: alertTypeString) else {
                print("Something went wrong grabbing ArrayIndex in AddAlertsViewController")
                return
            }
            // Get actual Alert.AlertType. AlertType(0) = .none, AlertType(1) = .percentValue, AlertType(2) = .currencyValue
            guard let alertType = Alert.AlertType(rawValue: alertIndex) else {
                print("Something went wrong creating Alert.AlertType AddAlertsViewController")
                return
            }
            alerts.addAlert(id: self.id, alertType: alertType, ineq: self.inequality,
                            value: Int(valueTextField.text!)!, price: (currency?.priceUSD)!)
            performSegue(withIdentifier: "showAllAlertsSegue", sender: self)
        }
    }
    

    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typeOfAlertPicker {
            return alertTypeArray.count
        } else if pickerView == inequalityAlertPicker {
            return inequalityArray.count
        }
        return 0 
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typeOfAlertPicker {
            return alertTypeArray[row]
        } else if pickerView == inequalityAlertPicker {
            return inequalityArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == typeOfAlertPicker) {
            alertTypeString = alertTypeArray[row]
        } else {
            inequality = inequalityArray[row]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllAlertsSegue" {
            let allAlertsController = segue.destination as! AlertsViewController
            allAlertsController.currency = currency
            allAlertsController.addedAlert = true
        }
    }

}
