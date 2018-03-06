//
//  MainTableViewCell.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/5/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
