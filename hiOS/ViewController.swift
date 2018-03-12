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
    private var myIndex:Int = 0
    private var isFavorite:Bool = false
    
    
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
        refresher.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        favoritesTableView.addSubview(refresher)
        navigationItem.title = "Home"
        
        handleRefresh(refresher)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        CoinAPIHelper().update() {
            self.cryptoList = self.cryptoRepo.getCryptoList()
            // Access the main thread to update UI elements
            DispatchQueue.main.async() {
                self.favoritesTableView.reloadData()
                refreshControl.endRefreshing()
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
        var rowHeight:CGFloat = 62
        if indexPath.section == 1{
            let id = cryptoList[indexPath.row].id
            if favorites.contains(name: id) {
                rowHeight = 0
            }
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewTableCell", for: indexPath) as! MainTableViewCell
        // Add the arrow to the right
        cell.accessoryType = .disclosureIndicator
        var label : String = ""
        var price : String = ""
        switch indexPath.section {
            case 0:
                let list = favorites.getList()
                if (list.count > 0 && cryptoRepo.getCount() > 0) {
                    guard let id = list[indexPath.row].name else {
                        return cell
                    }
                    label = cryptoRepo.getElemById(id: id).name
                    price = String(cryptoRepo.getElemById(id: id).priceUSD)
                } else {
                    // when favorites is empty
                    label = "There's nothing to show here"
                }
            case 1:
                let id = cryptoList[indexPath.row].id
                if !favorites.contains(name: id) {
                    label = cryptoList[indexPath.row].name
                    price = String(cryptoList[indexPath.row].priceUSD)
                } else {
                    cell.isHidden = true
                }
            default:
                break
        }
        cell.identifierLabel?.text = label
        cell.priceLabel?.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == favoritesTableView {
            myIndex = indexPath.row
            isFavorite = indexPath.section == 0 ? true : false
            performSegue(withIdentifier: "showDetailSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailSegue") {
            let detailedController = segue.destination as! DetailedViewController
            if isFavorite {
                let curr = favorites.getElemById(id: favorites.getList()[myIndex].name!)
                detailedController.currency = curr
            } else {
                detailedController.currency = cryptoList[myIndex]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload favorties table view data source after a segue
        favoritesTableView.reloadData()
    }
}

