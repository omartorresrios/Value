//
//  AdminSideMenuCell.swift
//  Value
//
//  Created by Omar Torres on 12/7/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class AdminSideMenuCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var metric: Metric? {
        didSet {
            nameLabel.text = metric?.name.rawValue
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "metric"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
