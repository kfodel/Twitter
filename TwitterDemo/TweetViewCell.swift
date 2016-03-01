//
//  TweetViewCell.swift
//  TwitterDemo
//
//  Created by Kolton on 2/28/16.
//  Copyright © 2016 Kolton. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var numberRTs: UILabel!
    @IBOutlet weak var numberFavs: UILabel!
    
    var tweetID: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
