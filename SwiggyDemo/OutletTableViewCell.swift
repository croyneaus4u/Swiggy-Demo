//
//  OutletTableViewCell.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 31/10/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class OutletTableViewCell: UITableViewCell {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var outletData: Restaurants? {
        didSet {
            if outletData != nil {
                updateData()
            }
        }
    }
    
    func updateData () {
        areaLabel.text = outletData?.area
        ratingLabel.text = outletData?.avg_rating
        
        let text = "\(outletData!.deliveryTime) mins"
        timeLabel.setAttributedText("\(outletData!.deliveryTime)", fullText: text, attributes: [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size:15)!])
    }
    
}
