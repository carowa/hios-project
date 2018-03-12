//
//  AddFavoritesViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let favoritesRepo = FavoritesRepo.shared
    
    let cryptoRepo = CryptoRepo.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive: Bool = false
    var filtered: [String] = []

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("in searchBarTextDidBeginEditing")
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("in searchBarTextDidEndEditing")
        self.tableView.reloadData()
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("in searchBarCancelButtonClicked")
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("in searchBarSearchButtonClicked")
        searchActive = false;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        //print("cryptorepo count: \(cryptoRepo.getCount())")
        return cryptoRepo.getCount()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Create a notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "reloadFavoritesTableView"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cryptoKeys = cryptoRepo.getKeysList()
        self.tableView.reloadData()

        filtered = cryptoKeys.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Main", for: indexPath) as! FavoriteTableViewCell;
        
        print("this is favorites on 87: \(favoritesRepo.getFavorites())")

        if(searchActive){
            cell.currencyLabel.text = filtered[indexPath.row]
            if favoritesRepo.isInFavorites(name: cell.currencyLabel.text!) {
                cell.favoriteButton.setTitle("\u{2705}", for: .normal)
            } else {
                cell.favoriteButton.setTitle("Add", for: .normal)
            }
        } else {
            cell.currencyLabel.text = cryptoKeys[indexPath.row];
            if favoritesRepo.isInFavorites(name: cell.currencyLabel.text!) {
                cell.favoriteButton.setTitle("\u{2705}", for: .normal)
            } else {
                cell.favoriteButton.setTitle("Add", for: .normal)
            }
        }
        return cell;
    }
    
    /**
     Reloads the TableView. Wrapper for use with a selector
    */
    @objc private func reloadTableView() {
        tableView.reloadData()
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
