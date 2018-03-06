//
//  DetailedViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var currency:Cryptocurrency? = nil
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currency?.name
        idLabel.text = currency?.symbol
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showHourPercentChange(_ sender: UIButton) {
        if currency != nil {
            let curr:Cryptocurrency = currency!
            let percentChange:String = String(format:"%.1f", curr.percentChangeHour)
            currentPriceLabel.text = percentChange
        }
    }
    
    @IBAction func showDayPercentChange(_ sender: UIButton) {
        if currency != nil {
            let curr:Cryptocurrency = currency!
            let percentChange:String = String(format:"%.1f", curr.percentChangeDay)
            currentPriceLabel.text = percentChange
        }
    }
    
    @IBAction func showWeekPercentChange(_ sender: UIButton) {
        if currency != nil {
            let curr:Cryptocurrency = currency!
            let percentChange:String = String(format:"%.1f", curr.percentChangeWeek)
            currentPriceLabel.text = percentChange
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
