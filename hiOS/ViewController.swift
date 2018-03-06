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
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    @IBAction func populateOnClick(_ sender: UIButton) {
        cryptoList = cryptoRepo.getCryptoList()
//        print(cryptoList)
        favoritesTableView.reloadData()
    }
    
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainViewTableCell", for: indexPath) as! MainTableViewCell
        print("table view")
        let id = cryptoList[indexPath.row].name //+ " - " + cryptoList[indexPath.row].id
        cell.identifierLabel?.text = id
        cell.priceLabel?.text = String(cryptoList[indexPath.row].priceUSD)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func populate() {
        
        cryptoList = cryptoRepo.getCryptoList()
        print(cryptoList)
        favoritesTableView.reloadData()
        refresher.endRefreshing()
    }
}

