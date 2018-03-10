//
//  ViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/1/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var addedAlert:Bool = false
    let cryptoRepo = CryptoRepo.shared
    var cryptoList:[Cryptocurrency] = []
    var refresher:UIRefreshControl = UIRefreshControl()
    private var myFavoritesIndex:Int = 0
    
    var favorites = Favorites.shared
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    let sections = ["Favorites", "Popular Cryptocurrencies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addedAlert {
            navigationItem.hidesBackButton = true
        }
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ViewController.populate), for: UIControlEvents.valueChanged)
        favoritesTableView.addSubview(refresher)
        
        // FIXME: Remove example loading when unneeded
        let c = CoinAPIHelper()
        c.update() {
            self.cryptoList = self.cryptoRepo.getCryptoList()
            // Access the main thread to update UI elements
            DispatchQueue.main.async() {
                self.favoritesTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_: UITableView, titleForHeaderInSection: Int) -> String? {
        return self.sections[titleForHeaderInSection]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // return 1 when favorites is empty
            return max(1, favorites.size())
        }
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewTableCell", for: indexPath) as! MainTableViewCell
        var label : String = ""
        var price : String = ""
        switch indexPath.section {
            case 0:
                let list = favorites.getList()
                if (list.count > 0) {
                    let id = list[indexPath.row]
                    label = cryptoRepo.getElemById(id: id).id
                    price = String(cryptoRepo.getElemById(id: id).priceUSD)
                } else {
                    label = "There's nothing to show here"
                }
            case 1:
                label = cryptoList[indexPath.row].name
                price = String(cryptoList[indexPath.row].priceUSD)
            default:
                break
        }
        cell.identifierLabel?.text = label
        cell.priceLabel?.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == favoritesTableView {
            myFavoritesIndex = indexPath.row
            performSegue(withIdentifier: "showDetailSegue", sender: self)
        }
    }
    
    // TODO: Remove populate option from the main table view later
    @IBAction func populate(_ sender: UIButton) {
        cryptoList = cryptoRepo.getCryptoList()
        favoritesTableView.reloadData()
        refresher.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailSegue") {
            let detailedController = segue.destination as! DetailedViewController
            detailedController.currency = cryptoList[myFavoritesIndex]
        }
    }
}

