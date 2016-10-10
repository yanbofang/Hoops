//
//  GamesTableViewCell.swift
//  Hoops
//
//  Created by Minh Tran on 10/9/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var players: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var gameInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
