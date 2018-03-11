//
//  AddFavoritesViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cryptoRepo = CryptoRepo.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive: Bool = false
    var filtered: [String] = []

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        print("cryptorepo count: \(cryptoRepo.getCount())")
        return cryptoRepo.getCount()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cryptoKeys = cryptoRepo.getKeysList()

        filtered = cryptoKeys.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText)
            return range.location != NSNotFound
        })

        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true; //still searching
        }
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cryptoKeys = cryptoRepo.getKeysList()
        print("CryptoKeys: \(cryptoKeys)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Main", for: indexPath) as! FavoriteTableViewCell;
        
//        if(searchActive){
//            cell.currencyLabel.text = filtered[indexPath.row]
//            print(filtered[indexPath.row])
//        } else {
//            cell.currencyLabel.text = cryptoKeys[indexPath.row];
//        }
        print("lets partyyyy")
        cell.currencyLabel.text = cryptoKeys[indexPath.row];
        return cell;
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
