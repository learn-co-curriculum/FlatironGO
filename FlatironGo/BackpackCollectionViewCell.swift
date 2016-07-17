//
//  BackpackCollectionViewCell.swift
//  FlatironGo
//
//  Created by Haaris Muneer on 7/16/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import SnapKit

class BackpackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var treasureImageView: UIImageView!
    @IBOutlet weak var treasureNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("BackpackCollectionViewCell", owner: self, options: nil)
        
        treasureImageView.translatesAutoresizingMaskIntoConstraints = false
        treasureNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        treasureImageView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10.0)
            make.width.equalTo(contentView).multipliedBy(0.65)
            make.centerX.equalTo(contentView)
            make.height.equalTo(treasureImageView.snp_width)
        }
        treasureNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(treasureImageView.snp_bottom).offset(5.0)
            make.height.equalTo(30.0)
            make.width.equalTo(contentView).offset(-30.0)
            make.centerX.equalTo(contentView)
        }
        
        
    }

}
