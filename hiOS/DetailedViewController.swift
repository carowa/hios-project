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
    @IBOutlet weak var percentChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currency?.name
        idLabel.text = currency?.symbol
        currentPriceLabel.text = "$" + String(format:"%.2f", currency!.priceUSD)
        percentChangeLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showHourPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeHour) + "%"
    }
    
    @IBAction func showDayPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeDay) + "%"
    }
    
    @IBAction func showWeekPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeWeek) + "%"
    }
    
    @IBAction func addCurrencyToFavorites(_ sender: UIButton) {
        // TODO: add currency to favorites array and change appearance of button when pressed
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAddAlertSegue") {
            let addAlertController = segue.destination as! AddAlertsViewController
            addAlertController.currency = currency
        }
    }


}
