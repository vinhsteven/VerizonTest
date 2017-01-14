//
//  DynamicTableViewCell.swift
//  Infodat
//
//  Created by Steven on 12/14/16.
//  Copyright © 2016 Nhuan Quang Company Limited. All rights reserved.
//

import UIKit

/**
 This class provide a custome UITableViewCell.
 
 It has 4 elements:
 - imgView: The UIImageView contains the image we get from RESTful webservices
 - titleLabel: The UILabel contains the name of each data block
 - bodyLabel: The UILabel contains the content of each data block
 - dateLabel: The UILabel contains the date created of each data block
 */

class DynamicTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let avatar_width  = 60.0
    let avatar_height = 60.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = CGFloat(avatar_width) / CGFloat(2.0)
        imgView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
