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
    @IBOutlet weak var favoritesActionButton: UIButton!
    @IBOutlet weak var priceChangeScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var byHour: UIButton!
    @IBOutlet weak var byDay: UIButton!
    @IBOutlet weak var byWeek: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currency?.name
        idLabel.text = currency?.symbol
        currentPriceLabel.text = "$" + String(format:"%.2f", currency!.priceUSD)
        // format highlighted button
        formatSelection(button: byHour)
        if addedAlert {
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(goToMainView))
        }
        navigationItem.title = "Details"
        if favorites.contains(name: (currency?.id)!) {
            saved = true
            favoritesActionButton.setTitle("Remove From Favorites", for: .normal)
        } else {
            saved = false
            favoritesActionButton.setTitle("Add To Favorites", for: .normal)
        }
        
        addDataToScrollView()
        priceChangeScrollView.delegate = self
        pageControl.currentPage = 0
    }
    
    /// Adds text to the scrollview to display the percent changes
    private func addDataToScrollView() {
        let scrollWidth = priceChangeScrollView.frame.width
        let scrollHeight = priceChangeScrollView.frame.height
        let textOne = UILabel(frame: CGRect(x:0, y:0,width:scrollWidth, height:scrollHeight))
        textOne.textColor = currency!.percentChangeHour >= 0.0 ? UIColor.green: UIColor.red
        textOne.text = String(format:"%.1f", currency!.percentChangeHour) + "%"
        textOne.textAlignment = .center
        textOne.font = textOne.font.withSize(35)
        let textTwo = UILabel(frame: CGRect(x:scrollWidth, y:0,width:scrollWidth, height:scrollHeight))
        textTwo.textColor = currency!.percentChangeDay >= 0.0 ? UIColor.green: UIColor.red
        textTwo.text = String(format:"%.1f", currency!.percentChangeDay) + "%"
        textTwo.textAlignment = .center
        textTwo.font = textTwo.font.withSize(35)
        let textThree = UILabel(frame: CGRect(x: scrollWidth * 2, y:0,width:scrollWidth, height:scrollHeight))
        textThree.textColor = currency!.percentChangeWeek >= 0.0 ? UIColor.green: UIColor.red
        textThree.text = String(format:"%.1f", currency!.percentChangeWeek) + "%"
        textThree.textAlignment = .center
        textThree.font = textThree.font.withSize(35)
        
        priceChangeScrollView.addSubview(textOne)
        priceChangeScrollView.addSubview(textTwo)
        priceChangeScrollView.addSubview(textThree)
        
        priceChangeScrollView.contentSize = CGSize(width:self.priceChangeScrollView.frame.width * 3, height:self.priceChangeScrollView.frame.height)
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
        moveTo(pageNumber: 0)
        formatSelection(button: sender)
        removeFormatting(button: byDay)
        removeFormatting(button: byWeek)
    }
    
    @IBAction func showDayPercentChange(_ sender: UIButton) {
        moveTo(pageNumber: 1)
        formatSelection(button: sender)
        removeFormatting(button: byHour)
        removeFormatting(button: byWeek)
    }
    
    @IBAction func showWeekPercentChange(_ sender: UIButton) {
        moveTo(pageNumber: 2)
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

extension DetailedViewController: UIScrollViewDelegate {
    // Called when scrolling is finished
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        switch Int(currentPage) {
        case 0:
            formatSelection(button: byHour)
            removeFormatting(button: byDay)
            removeFormatting(button: byWeek)
        case 1:
            formatSelection(button: byDay)
            removeFormatting(button: byHour)
            removeFormatting(button: byWeek)
        default:
            formatSelection(button: byWeek)
            removeFormatting(button: byHour)
            removeFormatting(button: byDay)
        }
        // Set the page control
        self.pageControl.currentPage = Int(currentPage);
    }
    
    // Call to move to a specific page number (from 0)
    func moveTo(pageNumber: CGFloat){
        let pageWidth:CGFloat = self.priceChangeScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 3
        
        var slideToX = pageNumber * pageWidth
        
        if  slideToX >= maxWidth
        {
            slideToX = 0
        }
        self.priceChangeScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.priceChangeScrollView.frame.height), animated: true)
        self.pageControl.currentPage = Int(pageNumber)
    }
}
