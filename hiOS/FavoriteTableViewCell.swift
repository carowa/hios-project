//
//  FavoriteTableViewCell.swift
//  hiOS
//
//  Created by August Carow on 3/9/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    var favoriteId: String = ""
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    func toggleFavorite() {
        if !favoriteId.isEmpty {
            if !Favorites.shared.contains(name: favoriteId) {
                Favorites.shared.add(name: favoriteId)
            } else {
                Favorites.shared.remove(name: favoriteId)
            }
        }
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
