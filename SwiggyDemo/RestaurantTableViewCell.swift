//
//  RestaurantTableViewCell.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 31/10/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var outletCountLabel: UILabel!
    
    @IBOutlet weak var outletImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var restaurantData: Restaurants? {
        didSet {
            if restaurantData != nil {
                updateData()
            }
        }
    }
    
    func updateData () {
        nameLabel.text = restaurantData?.name
        cuisineLabel.text = restaurantData?.cuisine?.joinWithSeparator(", ")
        //priceLabel.text = restaurantData?.costForTwo
        
        if let price = restaurantData?.costForTwo {
            priceLabel.setAttributedText(price, fullText: "$$$$", attributes: [NSForegroundColorAttributeName: UIColor.greenColor()])
        }
        
        ratingLabel.text = restaurantData?.avg_rating
        
        let text = "\(restaurantData!.deliveryTime) mins"
        timeLabel.setAttributedText("\(restaurantData!.deliveryTime)", fullText: text, attributes: [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size:15)!])
        
        if let count = restaurantData?.chain?.count {
            outletCountLabel.text = "\(count) outlets around you"
        } else {
            outletCountLabel.text = ""
        }
        
        let path = "https://res.cloudinary.com/swiggy/image/upload/\(restaurantData!.cid!)"
        outletImageView.imageWithUrlString(path, placeHolder: nil)
    }
}
