//
//  DetailedViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    let favorites = Favorites.shared
    var addedAlert:Bool = false
    var currency:Cryptocurrency? = nil
    var saved:Bool = false
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var favoritesActionButton: UIButton!
    
    
    @IBOutlet weak var byHour: UIButton!
    @IBOutlet weak var byDay: UIButton!
    @IBOutlet weak var byWeek: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currency?.name
        idLabel.text = currency?.symbol
        currentPriceLabel.text = "$" + String(format:"%.2f", currency!.priceUSD)
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeHour) + "%"
        // format highlighted button
        formatSelection(button: byHour)
        if addedAlert {
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(goToMainView))
        }
        if favorites.contains(name: (currency?.id)!) {
            saved = true
            favoritesActionButton.setTitle("Remove From Favorites", for: .normal)
        } else {
            saved = false
            favoritesActionButton.setTitle("Add To Favorites", for: .normal)
        }
    }
    
    /**
     Changes the appearence of the 'selected' button by adding a blue border around it
     
     - Parameter button: Reference to the UI button
     */
    private func formatSelection(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
    }
    
    /**
     Removes the formatting (blue border) if the button is not selected
     
     - Parameter button: Reference to the UI button for percent change
     */
    private func removeFormatting(button : UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc private func goToMainView() {
        performSegue(withIdentifier: "showMainSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showHourPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeHour) + "%"
        formatSelection(button: sender)
        removeFormatting(button: byDay)
        removeFormatting(button: byWeek)
    }
    
    @IBAction func showDayPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeDay) + "%"
        formatSelection(button: sender)
        removeFormatting(button: byHour)
        removeFormatting(button: byWeek)
    }
    
    @IBAction func showWeekPercentChange(_ sender: UIButton) {
        percentChangeLabel.text = String(format:"%.1f", currency!.percentChangeWeek) + "%"
        formatSelection(button: sender)
        removeFormatting(button: byHour)
        removeFormatting(button: byDay)
    }
    
    @IBAction func favoritesActionButton(_ sender: UIButton) {
        // TODO: add currency to favorites array and change appearance of button when pressed
        if(saved) {
            saved = false
            favoritesActionButton.setTitle("Add To Favorites", for: .normal)
            favorites.remove(name: (currency?.id)!)
            let alert = UIAlertController(title: "Removed From Favorites", message: "You will no longer see \((currency?.name ?? "this currency")) in your favorites list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            saved = true
            favoritesActionButton.setTitle("Remove From Favorites", for: .normal)
            favorites.add(name: (currency?.id)!)
//            print(currency?.id ?? "id")
            let alert = UIAlertController(title: "Added To Favorites", message: "You will now see \(currency?.name ?? "this currency") in your favorites list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAddAlertSegue") {
            let addAlertController = segue.destination as! AddAlertsViewController
            addAlertController.currency = currency
            addAlertController.id = (currency?.id)!
        } else if(segue.identifier == "showMainSegue") {
            let mainController = segue.destination as! ViewController
            mainController.addedAlert = true
        }
    }
}
