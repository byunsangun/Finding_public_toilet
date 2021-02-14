//
//  toiletTableViewCell.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/22.
//  Copyright © 2020 sangun. All rights reserved.
//

import UIKit

class toiletTableViewCell: UITableViewCell {

    @IBOutlet weak var toiletName: UILabel!
    @IBOutlet weak var toiletType: UILabel!
    @IBOutlet weak var toiletDistance: UILabel!
    @IBOutlet weak var toiletAddress: UILabel!
    @IBOutlet weak var toiletReviewButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
