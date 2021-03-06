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
        valueTextField.keyboardType = UIKeyboardType.decimalPad
        titleLabel.text = "Set New Alert for \(currency?.name ?? "nil")"
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setAlert(_ sender: UIButton) {
        if alertTypeString != "" && inequality != "" && valueTextField.text != "" {
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
            guard let value = Double(valueTextField.text!) else {
                let alert = UIAlertController(title: "Invalid Value", message: "Please enter a valid alert value", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                return
            }
            alerts.addAlert(id: self.id, alertType: alertType, ineq: self.inequality,
                            value: value, price: (currency?.priceUSD)!)
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
        let textFieldString = textField.text! as NSString;
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
        
        let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
        
        return floatExPredicate.evaluate(with: newString)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllAlertsSegue" {
            let allAlertsController = segue.destination as! AlertsViewController
            allAlertsController.currency = currency
            allAlertsController.addedAlert = true
        }
    }

    /// Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the text field to resign the first responder status.
        valueTextField.endEditing(true)
    }
}
