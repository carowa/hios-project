//
//  AddAlertsViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AddAlertsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var typeOfAlertPicker: UIPickerView!
    
    @IBOutlet weak var inequalityAlertPicker: UIPickerView!
    
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var setAlertButton: UIButton!
    
    
    var alertTypeArray:[String] = ["Percent Value", "Currency Value"]
    var inequalityArray:[String] = ["<", "=", ">"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOfAlertPicker.delegate = self
        typeOfAlertPicker.dataSource = self
        inequalityAlertPicker.delegate = self
        inequalityAlertPicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    }

}
