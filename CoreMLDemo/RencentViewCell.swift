//
//  RencentViewCell.swift
//  CoreMLDemo
//
//  Created by Collin on 2017/12/15.
//  Copyright © 2017年 AppCoda. All rights reserved.
//

import UIKit

class RencentViewCell: UITableViewCell {
    @IBOutlet var ans_Label: UILabel! {
        didSet {
            ans_Label.numberOfLines = 0
        }
    }
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.clipsToBounds = true
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
