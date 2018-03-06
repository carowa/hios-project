//
//  ViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/1/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cryptoRepo = CryptoRepo.shared
    var cryptoList:[Cryptocurrency] = []
    var refresher:UIRefreshControl = UIRefreshControl()
    private var myFavoritesIndex:Int = 0
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(ViewController.populate), for: UIControlEvents.valueChanged)
        favoritesTableView.addSubview(refresher)
        
        // FIXME: Remove example loading when unneeded
        let c = CoinAPIHelper()
        c.update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: populate only favorites and then all other currencies
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewTableCell", for: indexPath) as! MainTableViewCell
        let id = cryptoList[indexPath.row].name //+ " - " + cryptoList[indexPath.row].id
        cell.identifierLabel?.text = id
        cell.priceLabel?.text = String(cryptoList[indexPath.row].priceUSD)
        
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

