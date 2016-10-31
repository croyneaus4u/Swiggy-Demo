//
//  SectionView.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 31/10/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class SectionView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var tapHandler: ((Void) -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit () {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        contentView.addSubview(visualEffectView)
        contentView.sendSubviewToBack(visualEffectView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func handleTap () {
        tapHandler?()
    }

}
