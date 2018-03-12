//
//  AddFavoritesViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let favoritesRepo = Favorites.shared
    
    let cryptoRepo = CryptoRepo.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive: Bool = false
    var filtered: [Cryptocurrency] = []

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("in searchBarTextDidBeginEditing")
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("in searchBarTextDidEndEditing")
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
        navigationItem.title = "Add Favorites"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cryptoKeys = cryptoRepo.getCryptoList()
        self.tableView.reloadData()

        filtered = cryptoKeys.filter({ (cryptocurrency) -> Bool in
            let tmp: NSString = cryptocurrency.name as NSString
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
        // Get the cryptoList to grab the coin id
        let cryptoKeys = cryptoRepo.getCryptoList()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Main", for: indexPath) as! FavoriteTableViewCell
        // Add the arrow to the right
        cell.accessoryType = .disclosureIndicator
        var id = cryptoKeys[indexPath.row].id
        // If search is active, we need to check the filtered list
        if(searchActive){
            id = filtered[indexPath.row].id
        }
        // Get the display name from the id
        cell.currencyLabel.text = cryptoRepo.getElemById(id: id).name
        // Display or remove the check
        if favoritesRepo.contains(name: id) {
            cell.favoriteLabel.text = "\u{2705}"
        } else {
            cell.favoriteLabel.text = ""
        }
        // Set the cell id
        cell.favoriteId = id
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Get the cryptoList to grab the coin id
        let cryptoKeys = cryptoRepo.getCryptoList()
        var id = cryptoKeys[indexPath.row].id
        // If search is active, we need to check the filtered list
        if(searchActive){
            id = filtered[indexPath.row].id
        }
        // Set alert title and color
        var alertTitle = "Add"
        var color = UIColor.green
        // Adjust the alert title and color to remove if the cryptocurrency is already added
        if favoritesRepo.contains(name: id) {
            alertTitle = "Remove"
            color = UIColor.red
        }
        // Create the action
        let cellAction = UITableViewRowAction(style: .normal, title: alertTitle) { (action, indexPath) in
            let actionCell = tableView.cellForRow(at: indexPath) as! FavoriteTableViewCell
            actionCell.toggleFavorite()
            tableView.reloadData()
        }
        cellAction.backgroundColor = color
        return [cellAction]
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
