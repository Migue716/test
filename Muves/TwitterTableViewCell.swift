//
//  TwitterTableViewCell.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 15/11/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var twitterDescripcionLabel: UILabel!
    @IBOutlet weak var twitterUsuarioLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
