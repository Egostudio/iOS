//
//  messageTableViewCell.swift
//  egostudio.com
//
//  Created by Kogen on 10/1/17.
//  Copyright © 2017 Egostudio. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 20.0/255.0, green: 2.0/255.0, blue: 16.0/255.0, alpha: 0.5)
        self.selectedBackgroundView = bgColorView
        
        //self.priceLabel.backgroundColor = UIColor(red: 50.0/255.0, green: 23.0/255.0, blue: 79.0/255.0, alpha: 1.0) as! CGColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
