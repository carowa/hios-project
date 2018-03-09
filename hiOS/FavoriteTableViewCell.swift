//
//  FavoriteTableViewCell.swift
//  hiOS
//
//  Created by August Carow on 3/9/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
