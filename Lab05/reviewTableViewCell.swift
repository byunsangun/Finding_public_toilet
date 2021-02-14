//
//  reviewTableViewCell.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/24.
//  Copyright © 2020 sangun. All rights reserved.
//

import UIKit

class reviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
  
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var eachToiletRate1: UIButton!
    @IBOutlet weak var eachToiletRate2: UIButton!
    @IBOutlet weak var eachToiletRate3: UIButton!
    @IBOutlet weak var eachToiletRate4: UIButton!
    @IBOutlet weak var eachToiletRate5: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
