//
//  FavoriteTableViewCell.swift
//  hiOS
//
//  Created by August Carow on 3/9/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    let favoritesRepo = Favorites.shared
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBAction func toggleFavorite(_ sender: Any) {
        if !favoritesRepo.contains(name: currencyLabel.text!) {
            favoritesRepo.add(name: currencyLabel.text!)
        }
        // Post the notification. Observer in AddFavoritesViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadFavoritesTableView"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
